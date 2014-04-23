# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

  project_name = "django"

  config.vm.box = "opscode-ubuntu-12.04_chef-11.4.0"
  config.vm.box_url = "https://opscode-vm-bento.s3.amazonaws.com/vagrant/opscode_ubuntu-12.04_chef-11.4.0.box"
  config.ssh.forward_agent = true

  config.vm.network :forwarded_port, guest: 80, host: 8080
  config.vm.network :forwarded_port, guest: 8000, host: 8000
  config.vm.network :forwarded_port, guest: 3306, host: 3306
  config.vm.network "private_network", ip: "192.168.33.10"

  config.vm.synced_folder "./app", "/home/vagrant/app"
  config.vm.synced_folder "./www", "/var/www"

  config.vm.provision :chef_solo do |chef|
    chef.cookbooks_path = ["cookbooks"]

    chef.add_recipe :apt
    chef.add_recipe 'build-essential'
    #chef.add_recipe 'git'
    chef.add_recipe 'apache2'
    chef.add_recipe "apache2::mod_wsgi"
    chef.add_recipe 'python'
    chef.add_recipe 'mysql::server'

    chef.json = {
      :apache => {
        :default_site_enabled => "true",
        :dir                  => "/etc/apache2",
        :log_dir              => "/var/log/apache2",
        :error_log            => "error.log",
        :user                 => "www-data",
        :group                => "www-data",
        :binary               => "/usr/sbin/apache2",
        :cache_dir            => "/var/cache/apache2",
        :pid_file             => "/var/run/apache2.pid",
        :lib_dir              => "/usr/lib/apache2",
        :listen_ports         => [
          "80"
        ],
        :contact              => "dick@butt.com",
        :timeout              => "300",
        :keepalive            => "On",
        :keepaliverequests    => "100",
        :keepalivetimeout     => "5"
      },
      :mysql  => {
        :server_root_password   => "password",
        :server_repl_password   => "password",
        :server_debian_password => "password",
        :service_name           => "mysql",
        :basedir                => "/usr",
        :data_dir               => "/var/lib/mysql",
        :root_group             => "root",
        :mysqladmin_bin         => "/usr/bin/mysqladmin",
        :mysql_bin              => "/usr/bin/mysql",
        :conf_dir               => "/etc/mysql",
        :confd_dir              => "/etc/mysql/conf.d",
        :socket                 => "/var/run/mysqld/mysqld.sock",
        :pid_file               => "/var/run/mysqld/mysqld.pid",
        :grants_path            => "/etc/mysql/grants.sql"
      }
    }

      # Application provision
      config.vm.provision :shell, :inline => "pip install -r ./app/requirements.txt"
  end
end
