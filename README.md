# Ansible role `httpd`

A simple Ansible role for installing and configuring the Apache web server for RHEL/CentOS 7. Specifically, the responsibilities of this role are to:

- Install the necessary packages;
- Maintain the main configuration file;
- Maintain the configuration file for `mod_ssl`.

HTTPS/TLS is enabled, by default using the standard self-signed certificate. You can provide your own certificate.

Currently, no virtual hosts or other features are provided

## Requirements

- The firewall settings are not managed by this role.
- If you want to use custom certificates, you have to make sure that they are installed on the system before applying this role.

## Role Variables

If no variables are set, applying this role will result in a configuration equivalent to the default install. Consequently, no variables are required.

| Variable                        | Default                            | Comments (type) |
| :---                            | :---                               | :---            |
| `httpd_AccessLog_ssl`           | logs/ssl_access_log                |                 |
| `httpd_DocumentRoot`            | '/var/www/html'                    |                 |
| `httpd_ErrorLog`                | logs/error_log                     |                 |
| `httpd_ErrorLog_ssl`            | logs/ssl_error_log                 |                 |
| `httpd_Listen`                  | 80                                 |                 |
| `httpd_Listen_ssl`              | 443                                |                 |
| `httpd_LogLevel_ssl`            | warn                               |                 |
| `httpd_LogLevel`                | warn                               |                 |
| `httpd_ServerAdmin`             | root@localhost                     |                 |
| `httpd_ServerRoot`              | '/etc/httpd'                       |                 |
| `httpd_SSLCACertificateFile`    | -                                  |                 |
| `httpd_SSLCertificateChainFile` | -                                  |                 |
| `httpd_SSLCertificateFile`      | /etc/pki/tls/certs/localhost.crt   |                 |
| `httpd_SSLCertificateKeyFile`   | /etc/pki/tls/private/localhost.key |                 |

## Dependencies

No dependencies.

## Example Playbook

See the [test playbook](tests/test.yml)

## Testing

The `tests` directory contains acceptance tests for this role in the form of a Vagrant environment. The directory `tests/roles/httpd` is a symbolic link that should point to the root of this project in order to work. To create it, do

```ShellSession
$ cd tests/
$ ln -frs ../../bertvv.httpd roles/httpd
```

You may want to change the base box into one that you like. The current one is based on Box-Cutter's [CentOS Packer template](https://github.com/boxcutter/centos).

The playbook [`test.yml`](tests/test.yml) applies the role to a VM, setting role variables.

## Contributing

Issues, feature requests, ideas are appreciated and can be posted in the Issues section. Pull requests are also very welcome. Preferably, create a topic branch and when submitting, squash your commits into one (with a descriptive message).

## License

BSD

## Author Information

Bert Van Vreckem (bert.vanvreckem@gmail.com)

