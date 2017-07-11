#!/bin/bash
set -o nounset -o errexit -o pipefail -o errtrace

if [ -f .sshcontrol ]
then
   echo ".sshcontrol exists, run exit to logout"
   exit 1
else
   ssh -M -S .sshcontrol -fnNT -o ExitOnForwardFailure=yes -L 8200:10.11.0.1:8200 -L 4646:10.11.0.1:4646 bastion 
   echo "connected!"
fi
