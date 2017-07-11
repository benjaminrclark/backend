#!/bin/bash
set -o nounset -o errexit -o pipefail -o errtrace

if [ -S .sshcontrol ]
then
   echo ".sshcontrol exists, exiting ..."
   ssh -S .sshcontrol -O exit bastion 	
fi
