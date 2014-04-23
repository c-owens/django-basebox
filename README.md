#### A django development box provisioned with vagrant and chef.

Prereqs
-------------------------
* Virtualbox
* Vagrant

Installation (Windows)
-------------------------

#### Install either cygwin or OpenSSH for Windows:

Cygwin (bash shell for windows):

    http://www.cygwin.com/install.html

OpenSSH for Windows:
 
    http://sshwindows.sourceforge.net/

If using OpenSSH for Windows, make sure "ssh" is in your path.

#### Install the latest version of virtualbox:
    https://www.virtualbox.org/wiki/Downloads

#### Install the latest version of vagrant:
    http://www.vagrantup.com/downloads.html

- Make sure vagrant is in the path.
- cd to the root of the git repository (../ from here).
- Run "vagrant up" to begin installing a virtual machine.

How to use the virtual machine
-------------------------------

- "vagrant up" will start a new virtual machine in virtualbox matching a template in this repository.
- This will download an ubuntu image once and then it'll be saved on your hard drive.
- "vagrant ssh" will drop you into a shell on the virtual machine, but this usually isn't necessary.
- "vagrant destroy" will shutdown and remove the virtual machine.

- The template has the following pre-installed:
    -   apache2
    -   python
    -   mysql
    -   django
