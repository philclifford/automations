#!/bin/bash
QUICKEMU_VMS=${QUICKEMU_VMS:-"${HOME}/quickemu"}
# set QMU_DISPLAY=spice in your env if you want to fire up
# all the gui joy on $DISPLAY
QMU_DISPLAY=${QMU_DISPLAY:-none}
if [ -n "$DEBUG" ] ;then
echo DEBUG set to "${DEBUG}" so machines may not run
else echo no; fi

cd ${QUICKEMU_VMS}

# get array of Host and port setting for
# test vms to make ssh access less tiresome

qvmports=($(grep -A1 qvm ~/.ssh/config|grep -v '^#'|cut -d\  -f2))

# Now may need to add port-forwarding to the ssh configs as
# spice will be bound to localhost and so remote access will
# need a remote display/gui setting up  or port-forwarding

# On the VM host it is very helpful to have quickgui around but for monitoring and
# running these test scenarios ssh is handy
# TODO: confugure a tmux/screen/terminator/.. session with tiled access
# to all the running VMs

# We have found this many qvm- entries
i=${#qvmports[@]}
# two-part harmony required, starting from a 0 index
x=0;y=1

while [[ $y -lt $i ]];do
    #echo ${qvmports[$x]}
    #
    vm=$(ls ./*$(echo ${qvmports[$x]}|cut -d\- -f2)*conf | sort -n|tail -1 ) > /dev/null 2>&1 ;
    #echo ${vm} ;
    sshport=${qvmports[$y]}
    if [ ! -z "${vm}" ]; then
        $DEBUG quickemu --vm  "${vm}"  --ssh-port  "${sshport}" --display "${QMU_DISPLAY}"
    else
        # if you dont want to be filling with ssh configs all the time
        # leave them be and omit <vm>.conf files/symlinks from the QUICKEMU_VMS directory

        #
        echo " WARN: ${qvmports[$x]} not present in ${QUICKEMU_VMS}"
        echo "         Presumed disabled"
    fi
    # skip to next pair of host and port values
    x=$((x + 2 )); y=$((y +  2))
done



# test if systemd host
# if so maybe run runsvc once to re-register
# otherwice sudo svc.sh with start and status

#for r in 0 1 2 3 ;do  ssh localhost -p 2222${r}  "hostname ; cat /etc/os-release;echo on port 2222${r};cd actions-runner && sudo ./svc.sh status;  ";done
#for r in 0 1 2 3 ;do  ssh localhost -p 2222${r}  "hostname ; cat /etc/os-release;echo on port 2222${r};cd actions-runner && sudo ./svc.sh status;  ";done

#when shutting down first close/deregister the listener then shutdown/pause the vm
#maybe using the monitor now it is enabled

# NOTES

# presumes a number of Host entries called `qvm-<something-appropriate>` in `~/.ssh/config` mapping ports and users etc
# requires a bunch of Quickemu ,machines under $QUICKEMU_VMS with matching .confs
# export QUICKEMU_VMS=/path/to/VMs/
#     NB works fine with a directory full of symlinks to the main VM collection
#        and you can disable a runner VM by commenting out the ssh Host and/or renaming or removing the .conf
# TODO
#
# Install / update / re-register the runner
# Install/use CM tooling
#  - cloud-init ?
#  - Ansible
#  - Puppet
#  - Chef
#  - Foreman
#
#  Use snapshots for a clean baseline config
#  Use docker for a cleaner and tighter CI setup
#  slim all the things