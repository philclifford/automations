# Automations
A learning area where I try out automations and integrations and learn their benefits and limits (or more likely mine)

Feel free to try these out but this all comes with the standard warranty: it _will_ break stuff and you get to keep the bits.


First a [shonky shell script](quickemu/runtestvms.sh) to spin up a bunch of pre-created QuickEmu VMs to host :

 * github action_runners
 * gitlab runners
 * ....

 for handling automated testing via Github workflows

Next we'll have a look at containerizing some or all of our test runners (because: disosable, repeatable, portable, denser and more lightweight, slimable) using docker (maybe k8s, maybe lxd)

Later on we'll have a play with

* Ansible
* Puppet
* Chef
* Foreman

and maybe some other Configuration Management magic to provision, control and manage those VMS (or at least some aspects thereof for our test runner use-case)

Along the way we'll try and keep a few [lessons-learned](lessons.md) notes and tips handy.