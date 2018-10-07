# Change log

This file contains al notable changes to the bertvv.httpd Ansible role.

This file adheres to the guidelines of [http://keepachangelog.com/](http://keepachangelog.com/). Versioning follows [Semantic Versioning](http://semver.org/).

## 2.0.0 - 2018-10-07

This release has several breaking changes (see below), so check your playbooks/variable files before upgrading from an earlier version!

### Added

- Support for [Certificate Status Request](https://tools.ietf.org/html/rfc6066.html) extension of the [Online Certificate Status Protocol (OCSP)](https://tools.ietf.org/html/rfc2560) ([SSLUseStapling](https://httpd.apache.org/docs/2.4/mod/mod_ssl.html#sslusestapling))
- Copy custom server certificate/key file to the server. **This is a breaking change!** In previous versions, the complete path of the certificate files had to be specified, and the user had to put the files in place before applying this role. Now, only the file names should be given. The role will copy the specified files from the `files/` subdirectory (relative to the playbook location) to the appropriate directory on the server.

### Changed

- Updated TLS/SSL settings as recommended by Mozilla SSL Configuration Generator
- Replace CamelCase in role variable names with underscore/lowercase naming. This is consistent with naming conventions in other Ansible roles. **This is a breaking change!**
- Ensures the default self-signed certificate files are created on platforms where they are missing after installing `mod_ssl`. See [Fedora issue #1585533](https://bugzilla.redhat.com/show_bug.cgi?id=1585533).

### Removed

- Installation of packages enabling support for scripting languages. Only PHP was supported, and there were no plans (nor requests) to add other languages. Furthermore, this is actually not a concern of this role. A role installing a web application on this server should take care of all dependencies, including the appropriate scripting language support. **This is a breaking change!**

## 1.3.0 - 2018-08-29

### Added

- (GH-5) Support for `mod_status` (credit: [Lander Van den Bulcke](https://github.com/landervdb))

### Changed

- Removed test code from master branch and added Vagrant and Docker test branches. Tests can now be performed on Travis CI

## 1.2.1 - 2015-05-10

### Added

- tests for supported platforms

### Changed

- Installing scripting support is better generalized.
- Moved platform specific values to `vars/RedHat.yml`.

## 1.2.0 - 2015-03-15

### Added

- Fedora support (credit [Richard Marko](https://github.com/sorki))
- more SSL configuration options (credit [Richard Marko](https://github.com/sorki)
- `httpd_ServerTokens` variable (credit [Richard Marko](https://github.com/sorki)

## 1.1.0 - 2015-03-06

### Added

- Optional support for PHP

## 1.0.0 - 2015-03-06

First release!

### Added

- Install `httpd` and `mod_ssl` packages
- Configure Apache with template for `httpd.conf`
- Configure `mode_ssl` with template for `ssl.conf`
- Basic settings like port number, log file locations, and certificates can be customized


