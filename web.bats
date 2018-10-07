#! /usr/bin/env bats
#
# Functional tests for an Apache webserver set up with bertvv.httpd
#
# Variable SUT_IP should be set outside this script and should contain the IP
# address of the System Under Test.

content='hello world'
http_port=8080
https_port=8443
status_page=status
cert_info='.*O=Acme.*CN=www\.acme-inc\.com'

@test 'HTTP access should work' {
  run curl --silent "http://${SUT_IP}:${http_port}/"

  [ "${status}" -eq '0' ]
  [ "${output}" = "${content}" ]
}

@test 'HTTPS access should work' {
  run curl --silent --insecure "https://${SUT_IP}:${https_port}/"

  [ "${status}" -eq '0' ]
  [ "${output}" = "${content}" ]
}

@test 'Server should use custom certificate' {
  run curl --verbose --insecure "https://${SUT_IP}:${https_port}/" 2>&1

  [ "${status}" -eq '0' ]
  echo "${output}" | grep "subject.*${cert_info}"
  echo "${output}" | grep "issuer.*${cert_info}"
}

@test 'Server status should be accessible' {
  curl --silent "http://${SUT_IP}:${http_port}/${status_page}" | \
    fgrep "<title>Apache Status</title>"
}
