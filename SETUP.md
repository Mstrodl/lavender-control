# Lavender Puppet

## Control setup

Let's make a repo to store our code!

R10K uses branch names as puppet environments, so we'll need to rename
our branch to match the default puppet environment:

```bash
git branch -m master production # Rename master to production
```

Now, you can follow
[the quickstart steps](https://github.com/puppetlabs/r10k/blob/29204764d7aa824801690ea388d7065a2b32e391/doc/dynamic-environments/quickstart.mkd#configure-puppet-code-repository)
provided by r10k!

## R10K setup

This repo is nice and all, but what if we could automagically pull in our changes?

I only really found these resources:
* https://puppet.com/docs/pe/2019.8/set-up-r10k.html
* https://github.com/puppetlabs/r10k

The latter was useful, though!

I ran:

```bash
/opt/puppetlabs/puppet/bin/gem install r10k
```

to get a copy of r10k for our use

Now, we can configure the r10k stuff to know where our repository is stored:

```yaml
# /etc/puppetlabs/r10k/r10k.yaml
---
:cachedir: /opt/puppetlabs/puppet/cache/r10k
:sources:
  puppet:
    basedir: /etc/puppetlabs/code/environments
    remote: https://github.com/mstrodl/lavender-control.git
```

To verify it works, let's try and pull down the environment with r10k:

```bash
/opt/puppetlabs/puppet/bin/r10k deploy environment -p
```

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

Now that we have a host group and environment, let's try and make a new host!

1. Grab the repos
```
wget https://apt.puppetlabs.com/puppet6-release-bullseye.deb
dpkg -i puppet6-release-bullseye.deb
```
2. Install the agent
```
apt update
apt install puppet-agent
```
3. Run the agent
```
/opt/puppetlabs/puppet/bin/puppet agent -t
```
4. Sign the certificate (from the puppet master)
```
/opt/puppetlabs/bin/puppetserver ca sign --certname puppet-node01.csh.rit.edu
```
5. Run the agent again
```
/opt/puppetlabs/puppet/bin/puppet agent -t
```
