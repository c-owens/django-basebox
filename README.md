#### A django development box provisioned with vagrant and chef.

Prereqs
-------------------------
* Virtualbox
* Vagrant

Installation (Windows)
-------------------------

#### Install either cygwin or OpenSSH for Windows:

Cygwin:

    http://www.cygwin.com/install.html

OpenSSH for Windows:
 
    http://sshwindows.sourceforge.net/

If using OpenSSH for Windows, make sure "ssh" is in your path.

#### Install the latest version of virtualbox:

    https://www.virtualbox.org/wiki/Downloads

#### Install the latest version of vagrant:

    http://www.vagrantup.com/downloads.html

Basic development VM use
-------------------------------

* Open a terminal and cd to this directory.
* `vagrant up` will start the development virtual machine in virtualbox, matching a template in this repository.
* `vagrant ssh` will drop you into a shell on the virtual machine.
* `vagrant destroy` will shutdown and remove the virtual machine.

Default Environment
-------------------------------

#### Once started with `vagrant up`, the following default setup will occur:
* The `app` directory will be mirrored between your local computer and /home/vagrant/app on the virtual machine.
    * You can start the django development server by SSHing into the server using `vagrant ssh`, CDing to `/home/vagrant/app`, and running `python manage.py runserver`.
    * This will expose the server at `http://localhost:8000`.
* The `www` directory will be mirrored between your local computer and /var/www on the virtual machine.
    * This site is hosted by apache and can be accessed at `http://localhost:8080`.
    * Apache is not hosting django in the default setup, only a default html.
* You can develop using tools on your computer and the changes are reflected in the virtual machine.

#### The template has the following pre-installed:
* apache2
* python
* mysql
* django
