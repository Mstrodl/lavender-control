# Lavender Puppet

## First off, what's Puppet!

Puppet is a cool piece of software! It lets you declare the desired state of your
infrastructure with code and uses a pull configuration to bring your infrastructure
from it's current state to the desired state described in your puppet files.

This guide will help you get set up with [Foreman](https://theforeman.org),
[r10k](https://github.com/puppetlabs/r10k), and
[hiera](https://puppet.com/docs/puppet/7/hiera_intro.html) to make a flexible
puppet master!

## Foreman setup

We'll use foreman to manage our infrastructure. Foreman is just a pretty
web console where you can get a quick idea of the state of your infrastructure
and also makes changing parameters for testing or whatever super painless.

To setup foreman, I mostly just followed the
[quickstart installation guide](https://www.theforeman.org/manuals/2.5/index.html#2.1Installation)
from the foreman manual. I'll be using Foreman 2.5 with a Debian 10 master.

Foreman is cool, because it actually puppetizes the master as well as any clients.

We should have a working puppet server, let's try this out!
To test, let's try and do a puppet run on the master:

```bash
puppet agent -t
```

If everything went well, you should see a `Notice: Applied catalog in X.XX seconds`
message in the output!

Now, foreman should be accessible at `https://puppet-master.example.org`.
If it's not, make sure the `apache2` configs got applied:

```bash
systemctl restart apache2
```

## Control setup

Let's make a repo to store our code! R10K uses branch names as puppet environments,
so we'll need to name our branch to match the default puppet environment:

```bash
git init -b production # production is default environment for puppet
```

Now, copy the files from this repo into yours. Most of it's just boilerplate.

Alternatively, you can follow
[the quickstart steps](https://github.com/puppetlabs/r10k/blob/29204764d7aa824801690ea388d7065a2b32e391/doc/dynamic-environments/quickstart.mkd#configure-puppet-code-repository)
provided by r10k, although I had very little luck with getting them working...

## R10K setup

This repo is nice and all, but what if we could automagically pull in our changes?

I only really found these resources:

* https://puppet.com/docs/pe/2019.8/set-up-r10k.html
* https://github.com/puppetlabs/r10k

I created a `configure_r10k.pp` file in this repository to install r10k and
set up a webhook to pull down new changes automatically.
To run it, use the `configure_r10k.sh` helper script.

To verify it works, let's try and pull down the environment with r10k:

```bash
r10k deploy environment -p
```

Now that this is done, you can set up a git webhook which POSTs to
`http://your-puppet-master.example.org:8088/payload`
for your control repo. Now every time you push changes to git, r10k
will automatically be deployed!

## Tell foreman!

Hopefully that worked. Head to your foreman site and click:
`Import environments from ...`

Click 'All' and submit the form. This will pull down our new environment
changes so foreman can see them in the UI. This isn't always necessary, it
should only be needed when you create a new environment you want to manually
assign to a host in the foreman web UI or if you need to assign new classes to a group.
Puppet itself can always see the stuff tracked in git.

Now, we should have a production environment, so we can make a host group!

1. Head to the Foreman web console
2. Go to Configure > Host Groups
3. Click create
4. Name your group 'Common' and set Environment to 'production'
5. Click submit!

Now that we have the group, let's assign it some classes.

1. Click "Common" in the host group list
1. Click "Puppet Classes".
Here we can see a list of puppet classes in the control repo.
Typically, we add "role" classes which pass off responsibility to a number of "profiles"
These can be seen in `site/profile/manifests` and `site/role/manifests`.
1. Add the `role::server` class to `Common` and click submit!

## Registering an agent

Now that we have a host group and environment, let's try and make a new host!

1. Grab the repos
```bash
wget https://apt.puppetlabs.com/puppet6-release-bullseye.deb
dpkg -i puppet6-release-bullseye.deb
```
2. Install the agent
```bash
apt update
apt install puppet-agent
```
3. Tell puppet where to look for catalogs.
Add the following to `/etc/puppetlabs/puppet/puppet.conf`:
```ini
[agent]
    server = your-puppet-master.example.org
```
4. Run the agent
```bash
puppet agent -t
```
5. You'll probably get an error message from the puppet agent because the certificate
isn't signed by the Puppet CA. To fix this, we need to sign the certificate on
the puppet master to show the host is authorized to pull configurations:
```bash
puppetserver ca sign --certname puppet-node01.example.org
```
6. Run the agent again, this time it should succeed!
```bash
puppet agent -t
```

## Now what? Setting up SSH keys

I've already gone through much of the setup here, but if you check
`data/ssh_keys.yaml` you can see how useful puppet can be, particularly
with a larger team like opcomm!

## Troubleshooting

### Puppet executable not found :(

You probably need to restart your shell or `source /etc/profile`!

That failing, you can manually add `/opt/puppetlabs/bin` to your `PATH`!

### I messed up and now there's two certificates for my agent!

Easy. Nuke it!
On the server run:
```bash
puppetserver ca clean --certname puppet-node01.example.org
```

On the agent run:
```bash
find /etc/puppetlabs/puppet/ssl -name puppet-node01.example.org.pem -delete
find /var/lib/puppet/ssl -name puppet-node01.example.org.pem -delete
```
