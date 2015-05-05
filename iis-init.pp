## Deploy and Configure IIS on Windows Server 2008, 2012
## Dependant on the following modules: puppet-windowsfeature, puppet-iis, dism, and on the fly written modules also 

## Windows Firewall Configuration
class windows-base::firewall { 

	exec { 'remotedesktop': # Allows for RDP
			command => 'C:\Windows\System32\netsh.exe advfirewall firewall set rule group="remote desktop" new enable=Yes',
				refreshonly => true,
	}

	exec { 'remotedesktop': # Allows Load Balancer
			command => 'C:\Windows\System32\netsh.exe advfirewall firewall add rule name="load balancer" dir=in action=allow protocol=TCP localport=8000 profile=any',
				refreshonly => true,
	}


}

## Adds Windows Features using puppet-windowsfeature https://github.com/puppet-community/puppet-windowsfeature#defined-windowsfeature
windowsfeature { 'IIS':
	feature_name => [
	'Web-Server',
	'Web-Asp',
	'Web-Net-Ext',
	'Web-Health',
	'Web-Security',
	'Web-Performance',
	'Web-Mgmt-Console',
	'Web-Scripting-Tools',
	'Web-Mgmt-Service',
	'smtp-server',
	'Web-WMI',
	'Web-Lgcy-Scripting',
	'Web-Static-Content',
	'Web-Default-Doc',
	'Web-Dir-Browsing',
	'Web-Http-Errors',
	'Web-Http-Redirect',
	'Web-Asp-Net',
	'Web-Log-Libraries',
	'Web-Custom-Logging',
	'Web-Basic-Auth',
	'Web-Windows-Auth',
	'Web-IP-Security',
	'Web-Url-Auth',
	'Web-Dyn-Compression',
	'NET-WCF-HTTP-Activation45'
	]
}
# IF WINDOWS FEATURE DOES NOT WORK, try dism module: 

#class windows-iis {
#	include windows-iis::firewall
#	include windows-iis::files
#
#	dism { 'IIS-WebServerRole': ensure => present, # Add each feature individually
#	}
#	dism { $mods ['IISWebServerRole', 'IIS-WebServer', 'Web-Server',] ensure => present, #Add features using an array
#	}

## Manage IIS Configuration using puppet-iis module ( https://github.com/puppet-community/puppet-iis )
node 'iis1' {
	include 'insight'
}

class insight {
  iis::manage_app_pool {'InsightAU': # Creates application pool 'InsightAU'
    enable_32_bit           => true,
    managed_runtime_version => 'v4.0',
  }
   iis::manage_site {'www.mysite.com': # Management of site
    site_path     => 'C:\inetpub\wwwroot\mysite',
    port          => '80',
    ip_address    => '*',
    host_header   => 'www.mysite.com',
    app_pool      => 'InsightAU'
  }
   iis::manage_virtual_application {'application1': ## WebApp 
    site_name   => 'www.mysite.com',
    site_path   => 'C:\inetpub\wwwroot\application1',
    app_pool    => 'InsightAU'
  }
   iis::manage_virtual_application {'application2':
    site_name   => 'www.mysite.com',
    site_path   => 'C:\inetpub\wwwroot\application2',
    app_pool    => 'InsightAU'
  }
#iis::manage_binding { 'www.mysite.com-port-8080': # Additional Binding
#  site_name => 'www.mysite.com',
#  protocol  => 'http',
#  port      => '8080',
 }
}

## Install WSE

## Enable .NET v4 

## Move Log Directory

## Remove redundant AppPools 

## Configure IIS Premier AppPool  

node 'iis1' {
	include 'insight'
}

class insight {
  iis::manage_app_pool {'InsightAU': # Creates application pool 'InsightAU'
    enable_32_bit           => true,
    managed_runtime_version => 'v4.0',
  }
   iis::manage_site {'www.mysite.com': # Management of site
    site_path     => 'C:\inetpub\wwwroot\mysite',
    port          => '80',
    ip_address    => '*',
    host_header   => 'www.mysite.com',
    app_pool      => 'InsightAU'
  }
   iis::manage_virtual_application {'application1': ## WebApp 
    site_name   => 'www.mysite.com',
    site_path   => 'C:\inetpub\wwwroot\application1',
    app_pool    => 'InsightAU'
  }
   iis::manage_virtual_application {'application2':
    site_name   => 'www.mysite.com',
    site_path   => 'C:\inetpub\wwwroot\application2',
    app_pool    => 'InsightAU'
  }
