<!DOCTYPE html>

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
<!--<link rel="stylesheet" type="text/css" href="style.css"/>-->

<style>
form {
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


.tab {
    overflow: hidden;
    border: 1px solid #ccc;
    background-color: #f1f1f1;
    margin:auto;
    border-radius: 5px;
}

/* Style the buttons that are used to open the tab content */
.tab button {
    background-color: inherit;
    float: left;
    border: none;
    outline: none;
    cursor: pointer;
    padding: 14px 16px;
    transition: 0.3s;
}

/* Change background color of buttons on hover */
.tab button:hover {
    background-color: #ddd;
}

/* Create an active/current tablink class */
.tab button.active {
    background-color: #ccc;
}

/* Style the tab content */
.tabcontent {
    display: none;
    padding: 6px 12px;
    border: 1px solid #ccc;
    border-top: none;
    margin:auto;
    background:white;
    border-radius: 5px;
    height: 70%;
    overflow-y: auto;
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
    var x =
        '<td>'+
        '<div class="onoffswitch">'+
        '<input type="checkbox" name="onoffswitch" class="onoffswitch-checkbox" id="switch-'+
        ptid+'-'+ledId+'" '+(on ? "checked" : "")+'/>'+
        '<label class="onoffswitch-label" for="switch-'+ptid+'-'+ledId+'">'+
        '<span class="onoffswitch-inner"></span>'+
        '<span class="onoffswitch-switch"></span>'+
        '</label>'+
        '</div>'+
        '</td>';
        
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
        smq.publish("Hello", getCompany());
    };
    

    function devInfo(info, ptid) {
     var html='<div id="dev-'+ptid+'"><span>'+(escapeHtml(info.devname))+'</span><div>';
        if(typeof info.temp != 'undefined') {
            html+='<div class="temperature" id="temp-'+ptid+'">'+temp2html(info.temp)+'</div>'
        }
        html += '</div><table>'
        //Loop over all LEDS and create a TR element for each LED (Ref-TR)
        var leds=info.leds;
        for(var i=0 ; i < leds.length; i++) {
            // TR contains: TD for name + TD for LED + TD for LED on/off switch
            html += ('<tr>' +
                     mkLedName(leds[i].name) +
                     mkLed(ptid, leds[i].id, leds[i].color,leds[i].on) +
                     mkLedSwitch(ptid, leds[i].id, leds[i].on) +
                     '</tr>');
        }
       html += '<form method = "post" action = "test2.lsp"><input type="hidden" name="ptid" value =';
        html += ptid;
        html +='><input type="text" name="companyname" value = "chameleon"><input type="submit" name = "test" value = "Remove this device"></form>';
        html += '</table></div>';
         //Add the complete HTML for this device to the "devices" DIV element

        $("#DeviceInfo").append(html);
        
        
                
            $('#dev-'+ptid+' :checkbox').click(function(ev) {
                var id = $(this).prop('id').match(/(\d+)-(\d+)/);
                var ptid = parseInt(id[1]);
                var ledId = parseInt(id[2]);
                var data = new Uint8Array(2);
                data[0] = ledId;
                data[1] = this.checked ? 1 : 0;
                smq.publish(data,ptid);
            });
    
    
        html=        
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
            $('#devicesSection').hide();
            $("#deviceSettings").show();
            $("#defaultOpen").click();
            
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
    
    
    
    
    function onLED(data, ptid) {
        var ledId='#switch-'+ptid+'-'+data[0];
        var checked = data[1] ? true : false;
        $(ledId).prop('checked',checked);
        ledId ='#led-'+ptid+data[0];
        if(checked)
            $(ledId).removeClass('led-off')
            //$('#nav-'+ptid).addClass("selected");
        else
            $(ledId).addClass('led-off');
            //$('#nav-'+ptid).removeClass("selected");
    };
    
    


    
    
    
    
    
    
    

    function onTemp(data, ptid) {
        var b = new Uint8Array(data,0,2);
        var temp = (new DataView(b.buffer)).getInt16(0);
        var tempId='#temp-'+ptid;
        $("#addDataPoint").on("message", temp );
        $(tempId).html(temp2html(temp));
    };
    
    
    smq.subscribe(getCompany(), "devinfo", {"datatype":"json", "onmsg":devInfo});
    smq.subscribe("self", {"datatype":"json", "onmsg":devInfo});
    smq.subscribe(getCompany(), {"onmsg":onLED});
    smq.subscribe("/m2m/temp", {"onmsg":onTemp});
    smq.publish("Hello", "/m2m/led/display/"+getCompany());

});

</script>
</head>
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

<body>
    <div class="container" >
    	<div class="row" >
    	    <!-- DEVICE LIST SECTION -->
            <div class="panel panel-default user_panel" id = "devicesSection">
                <div class="panel-heading" >
                    <h3 class="panel-title">Devices list</h3>
                </div>
                <div id="nodev">
                    <h2>Connecting....</h2>
                </div>
                <div class="panel-body" >
                    <div class="table-container" >
                        <table class="table-users table"   border="0">
                            <tbody id = "devicesList" >
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
            <!-- DEVICE LIST SECTION -->
            <div id ="deviceSettingInjection">
                <div class="tab" id = "deviceSettings">
                <button class="tablinks" id="defaultOpen">Device Info</button>
                <button class="tablinks">Edit Device Settings</button>
                <button class="tablinks">User Logs</button>
            </div>
            <div id="DeviceInfo" class="tabcontent">
                <h3>hi</h3>
            </div>
            <div id="ChangeSettings" class="tabcontent">
            </div>
           </div>
        </div>
    </div>
    

</body>


<script>
function openInfo(evt, tabName) {
    // Declare all variables
    var i, tabcontent, tablinks;

    // Get all elements with class="tabcontent" and hide them
    tabcontent = document.getElementsByClassName("tabcontent");
    for (i = 0; i < tabcontent.length; i++) {
        tabcontent[i].style.display = "none";
    }


    // Get all elements with class="tablinks" and remove the class "active"
    tablinks = document.getElementsByClassName("tablinks");
    for (i = 0; i < tablinks.length; i++) {
        tablinks[i].className = tablinks[i].className.replace(" active", "");
    }

    // Show the current tab, and add an "active" class to the button that opened the tab
    document.getElementById(tabName).style.display = "block";
    evt.currentTarget.className += " active";
    
    } 
    //document.getElementById("defaultOpen").click();
    $(document).ready(function() {
    $("#deviceSettings").hide();
});/*



</script>
<script src="https://canvasjs.com/assets/script/canvasjs.min.js"></script>

</html>