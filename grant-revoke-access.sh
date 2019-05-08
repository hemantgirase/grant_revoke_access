#!/bin/bash

if [[ -z "$1" ]];then
       echo "Please enter one of the below actions...
             - grant
             - revoke"
elif [[ $1 == "help" || $1 == "-help" || $1 == "--help" || $1 == "h" || $1 == "-h" || $1 == "--h" ]];then
       echo "Usage: 
             This script is used to Grant or Revoke access to the users.
                       ./grant-revoke-access.sh [action]
             Below are the valid actions
             - grant
             - revoke "
fi

USER_NAMES=`cat user_list_file.txt`
HOST_NAMES=`cat host_list_file.txt`

for USER_NAME in ${USER_NAMES}
	do		
		for HOST_NAME in ${HOST_NAMES}
			do
				if [[ $1 == "grant" ]]; then
					useradd ${USER_NAME}
					sudo -u ${USER_NAME} mkdir /home/${USER_NAME}/.ssh
					sudo -u ${USER_NAME} chmod 700 /home/${USER_NAME}/.ssh
					sudo -u ${USER_NAME} ssh-keygen -f /home/${USER_NAME}/.ssh/id_rsa -t rsa -N ''
					ssh -o StrictHostKeyChecking=no root@${HOST_NAME} "useradd ${USER_NAME}"
					ssh -o StrictHostKeyChecking=no root@${HOST_NAME} "mkdir /home/${USER_NAME}/.ssh"
					ssh -o StrictHostKeyChecking=no root@${HOST_NAME} "chmod 700 /home/${USER_NAME}/.ssh"
					ssh -o StrictHostKeyChecking=no root@${HOST_NAME} "touch /home/${USER_NAME}/.ssh/authorized_keys"
					ssh -o StrictHostKeyChecking=no root@${HOST_NAME} "chmod 600 /home/${USER_NAME}/.ssh/authorized_keys"
					#ssh-copy-id -i /home/${USER_NAME}/.ssh/id_rsa.pub ${USER_NAME}@${HOST_NAME}
					echo `cat /home/${USER_NAME}/.ssh/id_rsa.pub` | ssh -o StrictHostKeyChecking=no root@${HOST_NAME} "cat >> /home/${USER_NAME}/.ssh/authorized_keys"
				elif [[ $1 == "revoke" ]]; then
					userdel -r ${USER_NAME}
					ssh -o StrictHostKeyChecking=no root@${HOST_NAME} "userdel -r ${USER_NAME}"
				fi
			done
	done
