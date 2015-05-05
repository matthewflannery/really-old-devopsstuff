#!/usr/bin/python
 
import fcntl, socket, struct
import json
import urllib2
import os
 
webhost = "genesis.lab.local"
webhost_ip = "192.168.168.77"
master_name = "ubuntu-puppet01"
myfile = "/usr/bin/autoconf.py"
# Check to see if you're running this as root.
if not os.geteuid()==0:
    sys.exit("\nOnly root can run this script\n")
 
oldHostname = socket.gethostname()
 
f = open("/etc/hosts", "r")
hosts_content = f.read()
f.close()
 
# If the /etc/hosts file doesn't have an entry for genesis.lab.local
if hosts_content.find(webhost) == -1:
    # Open the file again.
    f = open("/etc/hosts", "a")
    # Add the webhost to the file with the ip address
    f.write(webhost_ip + "\t" + webhost + "\n")
    f.close()
 
# Note that the web host is whatever server is running the thing that delegates
# host names dynamically.
url =  "http://" + webhost + ":3000"
print url
 
print oldHostname
# data= {"hostname": "PUPPET-AGENT-001", "puppetmaster": "10.10.10.10"}
# Do HTTP request and get JSON result && parse it.
data = json.load(urllib2.urlopen(url))
 
newHostname = data['hostname']
master_ip = data['puppetmaster']
 
#newHostname = "PUPPET-AGENT-001"
#master_ip = "192.168.168.106"
 
if newHostname != oldHostname:
    print "Hostname needs to be updated"
 
    print "[+] Updating the /etc/hosts file"
    f = open("/etc/hosts", "r")     #open file for reading
    contents = f.read()             #read contents
    f.close()                       #close file
 
    newContent = contents.replace(oldHostname, newHostname)      #replace
    f = open("/etc/hosts", "w")     #open file for writing
    f.write(newContent)               #write the altered contents
    f.close()
 
    print "[+] Updating the hostname file"
    f_hostname = open("/etc/hostname", "w")
    f_hostname.write(newHostname + "\n")
    f_hostname.close()
 
    print "[+] Updating the puppet server IP address"
    f_puppet = open("/etc/hosts", "a")
    # puppet - whatever you call your puppet master.
    # data['PuppetMaster']
    f_puppet.write(master_ip + "\t" +  master_name + "\n")
    f_puppet.close()
 
    print "[+] Restarting the server and removing script"
    os.remove(myfile)
    os.system("shutdown -r now")