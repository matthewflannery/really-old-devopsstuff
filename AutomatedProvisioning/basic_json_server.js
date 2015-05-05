var http = require('http');
 
var currentIndex = 1
 
var app = http.createServer(function(req,res){
    
    res.setHeader('Content-Type', 'application/json');
    
    var agentHostname = "PUPPET-AGENT-" + currentIndex;
    var puppetMasterIP = "192.168.168.106";
 
    var responseData = {
    	hostname: agentHostname,
    	puppetmaster: puppetMasterIP
    };
 
    res.end(JSON.stringify(responseData));
 
    currentIndex++;
});
app.listen(3000);