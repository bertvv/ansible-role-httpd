#! /usr/bin/env bats
#
# Functional tests for an Apache webserver set up with bertvv.httpd
#
# Variable SUT_IP should be set outside this script and should contain the IP
# address of the System Under Test.

content='hello world'

@test 'HTTP access should work' {
  run curl --silent "http://${SUT_IP}/"

  [ "${status}" -eq '0' ]
  [ "${output}" = "${content}" ]
}

@test 'HTTPS access should work' {
  run curl --silent --insecure "https://${SUT_IP}/"

  [ "${status}" -eq '0' ]
  [ "${output}" = "${content}" ]
}
