#
# Command: box circleci ssh <port> <address>
#

port="$1"
address="$2"
ip_address="${address#*@}"

sudo touch "${HOME}/.ssh/known_hosts"

sudo sed -i.bak "/${ip_address}/d" "${HOME}/.ssh/known_hosts"

ssh -oStrictHostKeyChecking=no \
    -p "${port}" \
    "${address}" \
    -L 8080:localhost:8080



