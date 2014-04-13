#
# .DESCRIPTION
# Download vagrant image from github and set it up.
#

$here = Split-Path $MyInvocation.MyCommand.Path

Push-Location $here
try
{
	git clone https://github.com/c-owens/Vagrant-LAMP-Stack.git ./
}
finally
{
	Pop-Location
}
