<!DOCTYPE html>
 <nav class="navbar navbar-inverse">
  <div class="container-fluid">
    <div class="navbar-header">
      <a class="navbar-brand" href="#">Othername</a>
    </div>
    <ul class="nav navbar-nav">
      <li class="active"><a href="#">Devices</a></li>
      <li><a href="#">Page 1</a></li>
      <li><a href="#">Page 2</a></li><li><a href="#">Page 2</a></li><li><a href="#">Page 2</a></li>
    </ul>
    <ul class="nav navbar-nav navbar-right">
      <li><a href="#"><span class="glyphicon glyphicon-user"></span> My Profile</a></li>
      <li><a href="#"><span class="glyphicon glyphicon-log-in"></span> Log Out</a></li>
    </ul>
  </div>
</nav> 
<?lsp

usersession = request:session()
if not usersession then response:forward"login.lsp" end
function checkLogin()
    if not usersession.loggedin then
        print "not logged in"
        response:forward"login.lsp"
    end
end
checkLogin()

?>

<html>
<head>
    <link href="//maxcdn.bootstrapcdn.com/bootstrap/3.3.0/css/bootstrap.min.css" rel="stylesheet" id="bootstrap-css">
<script src="//maxcdn.bootstrapcdn.com/bootstrap/3.3.0/js/bootstrap.min.js"></script>
<script src="//code.jquery.com/jquery-1.11.1.min.js"></script>
<!------ Include the above in your HEAD tag ---------->

<script src="https://use.fontawesome.com/1e803d693b.js"></script>
<style>form {
    display: inline-block; //Or display: inline; 
}
tr:hover{
    background-color: #ddd;
    color: black;
}
input[type=text] {
    float: right;
    border: none;
    margin-top: 8px;
    margin-right: 16px;
    font-size: 17px;
    
}
.search-container {
  float: right;
}

.search-container input[type=submit] {
  float: right;
  margin-top: 8px;
  margin-right: 16px;
  background: #ddd;
  font-size: 17px;
  border: none;
  cursor: pointer;
}

body {
    background: linear-gradient(to right, rgba(128,128,128,1), rgba(128,128,128,0));
}

</style>
<meta charset="UTF-8" />
<title>Devices Page</title>
<meta name=viewport content="width=device-width, initial-scale=1" />


<script src="/rtl/smq.js"></script>
<script src="/rtl/jquery.js"></script>
<script>

function escapeHtml(unsafe) {
    return unsafe
        .replace(/&/g, "&amp;")
        .replace(/</g, "&lt;")
        .replace(/>/g, "&gt;")
        .replace(/"/g, "&quot;")
        .replace(/'/g, "&#039;");
};
function getCompany(){
    var company = "<?lsp=usersession.company?>"
return company
};

function mkLedName(name) {
    return '<td>'+name+'</td>';
}

function mkLed(ptid,ledId,color,on) {
    return '<td><div id="led-'+ptid+ledId+'" class="led-'+
        color+(on ? '' : ' led-off')+'"></div></td>';
}

function mkLedSwitch(ptid,ledId,on) {
    var x ="0"

        
    return x;
}

function temp2html(temp) {
    temp /= 10;
    return "Temperature: " + temp + "  &#x2103; <span>(" + 
        Math.round(temp*9/5+32) + " &#x2109;)</span>";
}

function printNoDevs() {
    $("#nodev").html('<h2 align="center">There are currently no devices connected</h2><br><h3 align="center">Please make sure that the device you wish to register has an internet connection</h3>').show();
};




$(function() {
    var connectedDevs=0;
    if(window.location.search.search("nointro") == 1) {
        $("#dev-0").hide();
        $("#nav-0").hide();
    }

    if(! SMQ.websocket() ) {
        $('#nodev').html('<h2>Please update your browser or install one which supports websockets</h2>');
        return; /* Stop: no support */
    }

    var smq = SMQ.Client(SMQ.wsURL("/Server-Broker-Test8/"));

    smq.onmsg=function(data,ptid,tid,subtid) {
        console.log("Received unexpected data:", data,", from",ptid,", tid=",tid,
                    ", subtid=",subtid);
        console.log("  data string:",SMQ.utf8.decode(data))
    };

    smq.onclose=function(message,canreconnect) {
        connectedDevs=0;
        $("#nav").empty();
        $("#devices").empty();
        $('#nodev').html('<h2>Disconnected!</h2><p>'+(message ? message : '')+'</p>').show();
        if(canreconnect) return 3000;
    };

    smq.onconnect=printNoDevs();

    smq.onreconnect=function() {
        printNoDevs(); // State "not connected" to "no devices"
        smq.publish("Hello", "nocompany");
    };
    

    function devInfo(info, ptid) {
        var html=        
        ("<tr class='clickable-row' id = 'dev-"+ptid+"' data-href='usersettings.lsp'>"+
            "<td width='10' align='center'>"+
                "<i class='fa fa-2x fa-user fw'></i>"+
            "</td>"+
            "<td>"+
                escapeHtml(info.devname)+"<br>"+
            "</td>"+
            "<td>"+
                escapeHtml(info.ipaddr)+
            "</td>"+
            "<td align='center'>"+
                "Product code<br><small class='text-muted'>a23.f43.2342o</small>"+
            "</td>"+
        "</tr> ");
        $("#devicesList").append(html);
        $(".clickable-row").click(function(ev) {
            var message = '#dev-'+ptid;
            smq.publish(getCompany()+"\0",ptid);
            smq.publish(message,"deviceremove")
            $.post("test2.lsp", {deviceModel: info.devname,companyName: getCompany(),deviceIP:info.ipaddr})
            if(--connectedDevs == 0)
                printNoDevs();
        });
        smq.observe(ptid, function() {
            $('#dev-'+ptid).remove();

            if(--connectedDevs == 0)
                printNoDevs();
        });
        if(++connectedDevs == 1) {
            $("#nodev").hide(); 
        }
    } //devInfo
    
    
    function removeDevice(ptid){
        $('#dev-'+ptid).remove();
    };
    
    
    smq.subscribe("nocompany", {"datatype":"json", "onmsg":devInfo});
    smq.subscribe("self", {"datatype":"json", "onmsg":devInfo});
    smq.subscribe("deviceremove", {"datatype":"text","onmsg":function(message,ptid) { 
            $(message).remove()
        }
    });

    smq.publish("Hello", "discovery");

});

</script>
</head>

<body>
  <div class="container">
	<div class="row">
        <div class="panel panel-default user_panel">
            <div class="panel-heading">
                <h3 class="panel-title">Devices list</h3>
            </div>
            <div id="nodev">
                <h2>Connecting....</h2>
            </div>
            <div class="panel-body">
				<div class="table-container" >
                    <table class="table-users table"   border="0">
                        <tbody id = "devicesList" >
                        </tbody>
                    </table>
                </div>
            </div>
        </div>

	</div>
</div>
</body>
</html>