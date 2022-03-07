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
