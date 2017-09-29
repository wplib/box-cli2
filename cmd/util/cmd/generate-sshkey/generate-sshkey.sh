#
# Command: box util generate-sshkey
#
emailAddress="$1"
cd ~/.ssh
ssh-keygen -t rsa -b 4096 -C "${emailAddress}"
statusMsg "SSH Key generated in ~/.ssh"