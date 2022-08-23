QUICKEMU_VMS=${QUICKEMU_VMS:-"${HOME}/quickemu"}
QMU_DISPLAY=${QMU_DISPLAY:-none}

cd ${QUICKEMU_VMS}

qvmports=($(grep -A1 qvm ~/.ssh/config|grep -v '^#'|cut -d\  -f2))




i=${#qvmports[@]}
x=0;y=1

while [[ $y -lt $i ]];do
    #echo ${qvmports[$x]}
    vm=$(ls *$(echo ${qvmports[$x]}|cut -d\- -f2)*conf | sort -n|tail -1 ) > /dev/null 2>&1 ;
    #echo ${vm} ;
    sshport=${qvmports[$y]}
    if [ ! -z ${vm} ]; then
        quickemu --vm  "${vm}"  --ssh-port  "${sshport}" --display "${QMU_DISPLAY}"
    else
        echo " WARN: ${qvmports[$x]} not present in ${QUICKEMU_VMS}"
        echo "         Presumed disabled"
    fi
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