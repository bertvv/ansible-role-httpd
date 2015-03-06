#! /usr/bin/bash
#
# Author:   Bert Van Vreckem <bert.vanvreckem@gmail.com>
#
# Run Ansible manually on a host managed by Vagrant. Fix the path to the Vagrant
# private key before use!

set -o errexit # abort on nonzero exitstatus
set -o nounset # abort on unbound variable

#{{{ Variables
host="$(vagrant status --machine-readable | grep ',state,running' | cut -d',' -f2)"
inventory_file=".vagrant/provisioners/ansible/inventory/vagrant_ansible_inventory"
ssh_user=vagrant
private_key_path=".vagrant/machines/${host}/virtualbox/private_key"
#}}}
#{{{  Functions

usage() {
cat << _EOF_
Usage: ${0} PLAYBOOK [ARGS]
Runs Ansible-playbook manually on a host controlled by Vagrant. Run this script
from the same directory as the Vagrantfile.

  PLAYBOOK  the playbook to be run
  ARGS      other options that are passed on to ansible-playbook verbatim
_EOF_
}

 #}}}
#  {{{ Command line parsing

if [[ "$#" -lt "1" ]]; then
    echo "Expected at least 1 arguments, got $#" >&2
    usage
    exit 2
fi

if [[ -f "${1}" ]]; then
  playbook="${1}"
  shift
else
  echo "Not a file: ${1}" >&2
  usage
  exit 1
fi


# }}}
# Script proper

ansible-playbook \
  ${playbook} \
  --inventory="${inventory_file}" \
  --connection=ssh \
  --user="${ssh_user}" \
  --private-key="${private_key_path}" \
  "$@"

