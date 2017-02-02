#! /usr/bin/env bash
#
# Author: Bert Van Vreckem <bert.vanvreckem@gmail.com>
#
# Runs tests for this Ansible role on a Docker container
# Environment variables DISTRIBUTION and VERSION must be set
# outside of the script, e.g.
#
# $ DISTRIBUTION=centos VERSION=7 docker-tests.sh

#{{{ Bash settings
# abort on nonzero exitstatus
set -o errexit
# abort on unbound variable
set -o nounset
# don't hide errors within pipes
set -o pipefail
#}}}
#{{{ Variables
readonly script_name=$(basename "${0}")
readonly script_dir=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
IFS=$'\t\n'   # Split on newlines and tabs (but not on spaces)

readonly container_id="$(mktemp)"
readonly role_dir='/etc/ansible/roles/role_under_test'
readonly test_playbook="${role_dir}/docker-tests/test.yml"

# geerlingguy
#readonly docker_image="geerlingguy/docker"
#readonly image_tag="${docker_image}-${DISTRIBUTION}${VERSION}-ansible"
# bertvv
readonly docker_image="bertvv/ansible-testing"
readonly image_tag="${docker_image}:${DISTRIBUTION}_${VERSION}"

# Distribution specific settings
init="/sbin/init"
run_opts=("--privileged")
#}}}

main() {
  configure_environment

  start_container

  run_syntax_check
  run_test_playbook
  run_idempotence_test

  # Uncomment the following line if you want to clean up the
  # container(s) after running the tests. *Not* cleaning up may be
  # useful for troubleshooting

  # cleanup
}

#{{{ Helper functions

# Usage: configure_environment.
#
# This function defines run options for Docker, depending on the
# Linux $DISTRIBUTION and $VERSION.
configure_environment() {

  case "${DISTRIBUTION}_${VERSION}" in
    'centos_6')
      run_opts+=('--volume=/sys/fs/cgroup:/sys/fs/cgroup:ro')
      ;;
    'centos_7'|'fedora_25')
      init=/usr/lib/systemd/systemd
      run_opts+=('--volume=/sys/fs/cgroup:/sys/fs/cgroup:ro')
      ;;
    'ubuntu_14.04')
      #run_opts+=('--volume=/sys/fs/cgroup:/sys/fs/cgroup:ro')
      # Workaround for issue when the host operating system has SELinux
      if [ -x '/usr/sbin/getenforce' ]; then
        run_opts+=('--volume=/sys/fs/selinux:/sys/fs/selinux:ro')
      fi
      ;;
    'ubuntu_16.04')
      run_opts=('--volume=/run' '--volume=/run/lock' '--volume=/tmp' '--volume=/sys/fs/cgroup:/sys/fs/cgroup:ro' '--cap-add=SYS_ADMIN' '--cap-add=SYS_RESOURCE')

      if [ -x '/usr/sbin/getenforce' ]; then
        run_opts+=('--volume=/sys/fs/selinux:/sys/fs/selinux:ro')
      fi
      ;;
    *)
      log "Warning: no run options added for ${DISTRIBUTION} ${VERSION}"
      ;;
  esac
}

# Usage: build_container
build_container() {
  log "Building container for ${DISTRIBUTION} ${VERSION}"
  set -x
  docker build --tag="${image_tag}" .
  set +x
}

start_container() {
  log "Starting container"
  set -x
  docker run --detach \
    "${run_opts[@]}" \
    --volume="${PWD}:${role_dir}:ro" \
    "${image_tag}" \
    "${init}" \
    > "${container_id}"
  set +x
}

get_container_id() {
  cat "${container_id}"
}

# Usage: get_container_ip CONTAINER_ID
#
# Prints the IP address of the specified container.
get_container_ip() {
  local id
  id="$(get_docker_id)"

  docker inspect \
    --format '{{ .NetworkSettings.IPAddress }}' \
    "${id}"
}

# Usage: exec_container COMMAND
#
# Run COMMAND on the Docker container
exec_container() {
  local id
  id="$(get_container_id)"

  set -x
  docker exec --tty \
    "${id}" \
    env TERM=xterm \
    "${@}"
  set +x
}

run_syntax_check() {
  log 'Running syntax check on playbook'
  exec_container ansible-playbook "${test_playbook}" --syntax-check
  log 'Syntax check finished'
}

run_test_playbook() {
  log 'Running playbook'
  exec_container ansible-playbook "${test_playbook}"
  log 'Run finished'
}

run_idempotence_test() {
  log 'Running idempotence test'
  local output
  output="$(mktemp)"

  exec_container ansible-playbook "${test_playbook}" 2>&1 | tee "${output}"

  if grep -q 'changed=0.*failed=0' "${output}"; then
    result='pass'
    return_status=0
  else
    result='fail'
    return_status=1
  fi
  rm "${output}"

  log "Result: ${result}"
  return "${return_status}"
}

cleanup() {
  log 'Cleaning up'
  local id
  id="$(get_container_id)"

  docker stop "${id}"
  docker rm "${id}"
  rm "${container_id}"
}

log() {
  local yellow='\e[0;33m'
  local reset='\e[0m'

  printf "${yellow}>>> %s${reset}\n" "${*}"
}

#}}}

main "${@}"

