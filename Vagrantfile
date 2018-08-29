# vi: ft=ruby

require 'rbconfig'

VAGRANTFILE_API_VERSION = '2'
ROLE_NAME = 'httpd'
BOX_AUTHOR = 'bento'
SUBNET = '192.168.56.'

distros = [
  { distro: 'centos', version: '7.5',   ip: '22'},
  { distro: 'fedora', version: '28',    ip: '23'}
]

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  distros.each do |host|
    host_name = ROLE_NAME + host[:distro]

    config.vm.define host_name do |node|
      node.vm.box = "#{BOX_AUTHOR}/#{host[:distro]}-#{host[:version]}"
      node.vm.hostname = host_name
      node.vm.network 'private_network', ip: "192.168.56.#{host[:ip]}"

    end
  end

  config.vm.provision 'ansible' do |ansible|
    ansible.playbook = 'test.yml'
    ansible.host_vars = {
      # bento/fedora-26 does not have Python 2.7 installed
      ROLE_NAME + 'fedora' => { ansible_python_interpreter: '/usr/bin/python3' }
    }
  end
end

