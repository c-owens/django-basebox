#
# .DESCRIPTION
# Install all of the necessary prereqs for vagrant. After pulling down the
# repository this will install everything you need to be able to do 
# "vagrant up" and start a development machine.
#

$here = Split-Path $MyInvocation.MyCommand.Path
$installDir = Join-Path $here "installs"

function verify-installed( [string] $url, [scriptblock] $checkInstalled, [scriptblock] $runInstall, [bool] $git = $false )
{
	$fileName = Split-Path $url -Leaf
	$installed = & $checkInstalled
	if( $installed )
	{
		Write-Host -ForegroundColor Green "$fileName already installed, skipping..."
		return
	}

	if( !$git )
	{
		$localFileName = Join-Path $installDir $fileName
		if( !(Test-Path $localFileName) )
		{
			"downloading $($fileName)..."
			(New-Object System.Net.WebClient).DownloadFile( $url, $localFileName )
		}
	}
	else
	{
		Push-Location $installDir
		"cloning $($url)..."
		git clone $url
		Pop-Location
	}

	"installing $($fileName)..."
	& $runInstall
}

if( !(Test-Path $installDir) )
{
	New-Item -ItemType Directory -Path $installDir | Out-Null
}

### URLs for prerequisite files. ###
$urlVirtualBox = "http://download.virtualbox.org/virtualbox/4.3.10/VirtualBox-4.3.10-93012-Win.exe"

# Vagrant 1.4.3 because vagrant-berkshelf only supports this one.
$urlVagrant = "https://dl.bintray.com/mitchellh/vagrant/Vagrant_1.4.3.msi"
$urlRuby = "http://dl.bintray.com/oneclick/rubyinstaller/rubyinstaller-1.9.3-p545.exe"
$urlRubyDevkit = "https://github.com/downloads/oneclick/rubyinstaller/DevKit-tdm-32-4.5.2-20111229-1559-sfx.exe"

Push-Location $here
try
{

	## Virtual box ##

	$vboxPath = "C:\Program Files\Oracle\VirtualBox"
	$vboxFile = Split-Path $urlVirtualBox -Leaf
	$vboxInstaller = Join-Path $installDir $vboxFile
	$testVbox = { Test-Path $vboxPath }
	$installVbox = {
		Write-Host "Please use the interactive installer and install to the default path ($vboxPath)..." -ForegroundColor -Yellow
		Invoke-Expression "& '$vboxInstaller'"
	}

	verify-installed -url $urlVirtualBox -checkInstalled $testVbox -runInstall $installVbox

	## Vagrant ##

	$vagrantPath = "C:\HashiCorp\Vagrant\bin\vagrant.bat"
	$vagrantFile = Split-Path $urlVagrant -Leaf
	$vargantInstaller = Join-Path $installDir $vagrantFile
	$testVagrant = { Test-Path $vagrantPath }
	$installVagrant = {
		Invoke-Expression "& '$vagrantInstaller' /passive /norestart /log '$installDir\vagrant_install.log'  "
	}

	verify-installed -url $urlVagrant -checkInstalled $testVagrant -runInstall $installVagrant

	## Ruby ##

	$rubyPath = "C:\Ruby193"
	$rubyFile = Split-Path $urlRuby -Leaf
	$rubyExe = Join-Path $rubyPath "bin\ruby.exe"
	$rubyInstaller = Join-Path $installDir $rubyFile
	$testRuby = { (Test-Path $rubyExe) -or ((Get-Command ruby -ErrorAction SilentlyContinue) -ne $null) }
	$installRuby = {
		Invoke-Expression "& '$rubyInstaller' /VERYSILENT /LOG=`"$installDir\ruby_install.log`" /DIR=`"$rubyPath`""
		Start-Sleep -Seconds 20
		if( $env:path -NotMatch "Ruby193" )
		{
			$rbBin = Join-Path $rubyPath "bin"
			[Environment]::SetEnvironmentVariable( "Path", "$env:Path;$rbBin", "Machine" )
		}
		
		$installed = & $testRuby
		if( $installed )
		{
			Write-Host -ForegroundColor Green "Ruby installed successfully."
		}
	}

	verify-installed -url $urlRuby -checkInstalled $testRuby -runInstall $installRuby

	## Ruby devkit ##

	$devkitPath = Join-Path $rubyPath "devkit"
	$devkitFile = split-Path $urlRubyDevkit -Leaf
	$devkitInstaller = Join-Path $installDir $devkitFile
	$testDevkit = {
		$installedPath = Join-Path $rubyPath "lib\ruby\site_ruby\devkit.rb"
		Test-Path $installedPath
	}
	$installDevkit = {
		if( !(Test-Path $devkitPath) )
		{
			New-Item -ItemType Directory -Path $devKitPath | Out-Null
		}

		Copy-Item $devkitInstaller $devkitPath -Force
		$devkitInstaller = Join-Path $devkitPath $devkitFile
		Invoke-Expression "& '$devkitInstaller' -o -y"
		Start-Sleep -Seconds 20
		$dkrb = Join-Path $devkitPath "dk.rb"
		Invoke-Expression "& $rubyExe `"$dkrb`" init"
		Start-Sleep 5
		Invoke-Expression "& $rubyExe `"$dkrb`" install"
	}

	verify-installed -url $urlRubyDevkit -checkInstalled $testDevkit -runInstall $installDevkit

	# git clone https://github.com/c-owens/Vagrant-LAMP-Stack.git ./
}
finally
{
	Pop-Location
}