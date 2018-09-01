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
<!--<script src="//maxcdn.bootstrapcdn.com/bootstrap/3.3.0/js/bootstrap.min.js"></script>
<script src="//code.jquery.com/jquery-1.11.1.min.js"></script>
<!------ Include the above in your HEAD tag --------

<script src="https://use.fontawesome.com/1e803d693b.js"></script>-->
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
.tablinks {
    background-color: inherit;
    float: left;
    border: none;
    outline: none;
    cursor: pointer;
    padding: 14px 16px;
    transition: 0.3s;
}

.backtab {
    background-color: black;
    float: right;
    color:white;
    font-size: 15px;
}

/* Change background color of buttons on hover */
.tablinks:hover {
    background-color: #ddd;
}

/* Create an active/current tablink class */
.tablinks.active {
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
    max-height: 70vh;
    overflow-y:auto;
    position:relative;
}
.device-reading-container {position: absolute; right: 0; @media (max-width: 480px){float:left;}}
.device-gpio-container{float:left}

.onoffswitch {
    position: relative; width: 72px;
    -webkit-user-select:none; -moz-user-select:none; -ms-user-select: none;
}
.onoffswitch-checkbox {
    display: none;
}
.onoffswitch-label {
    display: block; overflow: hidden; cursor: pointer;
    border: 2px solid #999999; border-radius: 23px;
}
.onoffswitch-inner {
    display: block; width: 200%; margin-left: -100%;
    -moz-transition: margin 0.3s ease-in 0s; -webkit-transition: margin 0.3s ease-in 0s;
    -o-transition: margin 0.3s ease-in 0s; transition: margin 0.3s ease-in 0s;
}
.onoffswitch-inner:before, .onoffswitch-inner:after {
    display: block; float: left; width: 50%; height: 23px; padding: 0; line-height: 23px;
    font-size: 14px; color: white; font-family: Trebuchet, Arial, sans-serif; font-weight: bold;
    -moz-box-sizing: border-box; -webkit-box-sizing: border-box; box-sizing: border-box;
    border-radius: 23px;
    box-shadow: 0px 11.5px 0px rgba(0,0,0,0.08) inset;
}
.onoffswitch-inner:before {
    content: "ON";
    padding-left: 10px;
    background-color: #933C00; color: #FFFFFF;
    border-radius: 23px 0 0 23px;
}
.onoffswitch-inner:after {
    content: "OFF";
    padding-right: 10px;
    background-color: #000000; color: #FFFFFF;
    text-align: right;
    border-radius: 0 23px 23px 0;
}
.onoffswitch-switch {
    display: block; width: 23px; margin: 0px;
    background: #FFFFFF;
    border: 2px solid #999999; border-radius: 23px;
    position: absolute; top: 0; bottom: 0; right: 45px;
    -moz-transition: all 0.3s ease-in 0s; -webkit-transition: all 0.3s ease-in 0s;
    -o-transition: all 0.3s ease-in 0s; transition: all 0.3s ease-in 0s; 
    background-image: -moz-linear-gradient(center top, rgba(0,0,0,0.1) 0%, rgba(0,0,0,0) 80%); 
    background-image: -webkit-linear-gradient(center top, rgba(0,0,0,0.1) 0%, rgba(0,0,0,0) 80%); 
    background-image: -o-linear-gradient(center top, rgba(0,0,0,0.1) 0%, rgba(0,0,0,0) 80%); 
    background-image: linear-gradient(center top, rgba(0,0,0,0.1) 0%, rgba(0,0,0,0) 80%);
    box-shadow: 0 1px 1px white inset;
}
.onoffswitch-checkbox:checked + .onoffswitch-label .onoffswitch-inner {
    margin-left: 0;
}
.onoffswitch-checkbox:checked + .onoffswitch-label .onoffswitch-switch {
    right: 0px; 
}
.led-red, .led-yellow, .led-green, .led-blue, .led-off {
margin:20px;
    width: 25px;
    height: 25px;
    border-radius: 50%;
}

.led-red {
    background-color: #940;
    box-shadow: #000 0 -1px 7px 1px, inset #600 0 -1px 9px, #F00 0 2px 12px;
}

.led-yellow {
    background-color: #A90;
    box-shadow: #000 0 -1px 7px 1px, inset #660 0 -1px 9px, #DD0 0 2px 12px;
}

.led-green {
    background-color: #690;
    box-shadow: #000 0 -1px 7px 1px, inset #460 0 -1px 9px, #7D0 0 2px 12px;
}

.led-blue {
    background-color: #4AB;
    box-shadow: #000 0 -1px 7px 1px, inset #006 0 -1px 9px, #06F 0 2px 14px;
}

.led-off {
    background-color: gray;
    box-shadow: #000 0 -1px 7px 1px, inset #4B4B4B 0 -1px 9px, #878787 0 2px 14px;
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

/////////////////////////////////////////////MAKE LEDS ////////////////////////////////
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
    $("#nodev").html('<h2 align="center">There are currently no devices connected</h2>').show();
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
        ("<tr class='clickable-row' id = 'device-"+ptid+"' data-href='usersettings.lsp'>"+
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
                "Product registered to:<br><small class='text-muted'>"+getCompany()+"</small>"+
            "</td>"+
        "</tr> ");
        $("#devicesList").append(html);
        
                var tablisthtml=        
            ('<div class="tab" id = "deviceContents-'+ptid+'">'+
                '<button class="tablinks" id ="deviceInfoTab-'+ptid+'">Device Info</button>'+
                '<button class="tablinks" id ="deviceSettingsTab-'+ptid+'">Edit Device Settings</button>'+
                '<button class="tablinks" id ="deviceLogsTab-'+ptid+'">User Logs</button>'+
                '<button class="tablinks backtab" id ="backtab-'+ptid+'">Go back</button>'+
            '</div>'+
            '<div id="deviceInfo-'+ptid+'" class="tabcontent">'+
            '</div>'+
            '<div id="deviceSettings-'+ptid+'" class="tabcontent">'+
            '</div>'+
            '<div id="deviceLogs-'+ptid+'" class="tabcontent">'+
            '</div>')
        $("#deviceSettingInjection").append(tablisthtml);
        $("#deviceContents-"+ptid).hide();
        
        $("#deviceInfoTab-"+ptid).click(function(ev) {
            $("#deviceInfo-"+ptid).show();
            $("#deviceSettings-"+ptid).hide();
            $("#deviceLogs-"+ptid).hide();
        });
        
        $("#deviceSettingsTab-"+ptid).click(function(ev) {
        
                $.ajax({
              type: "POST",
              url: "userlogs.lsp",
              data: {deviceModel: info.devname,companyName: getCompany(),deviceIP:info.ipaddr},
            success: function(output) {
                  $("#deviceSettings-"+ptid).html(output);
              }
            });
        
        
        
            $("#deviceInfo-"+ptid).hide();
            $("#deviceSettings-"+ptid).show();
            $("#deviceLogs-"+ptid).hide();
        });
        
        $("#deviceLogsTab-"+ptid).click(function(ev) {
            $("#deviceInfo-"+ptid).hide();
            $("#deviceSettings-"+ptid).hide();
            $("#deviceLogs-"+ptid).show();
        });
        
        $("#device-"+ptid).click(function(ev) {
            $("#devicesListContainer").hide();
            $("#deviceContents-"+ptid).show();
            $("#deviceInfo-"+ptid).show();
        });
        
        $("#backtab-"+ptid).click(function(ev) {
            $("#devicesListContainer").show();
            $("#deviceContents-"+ptid).hide();
            $("#deviceInfo-"+ptid).hide();
            $("#deviceSettings-"+ptid).hide();
            $("#deviceLogs-"+ptid).hide();
        });
        
        
        var devicetabhtml='<div id="dev-'+ptid+'">'; 
        devicetabhtml+='<div><span class="left-align-span">'+(escapeHtml(info.devname))+'</span><span class ="center-align-span">IP address: '+escapeHtml(info.ipaddr)+'<span></div>'
        devicetabhtml += '<div class ="device-gpio-container"><table>';
        //Loop over all LEDS and create a TR element for each LED (Ref-TR)
        var leds=info.leds;
        for(var i=0 ; i < leds.length; i++) {
            // TR contains: TD for name + TD for LED + TD for LED on/off switch
            devicetabhtml += 
                            ('<tr>' + mkLedName(leds[i].name) + 
                                mkLed(ptid, leds[i].id, leds[i].color,leds[i].on) +
                                mkLedSwitch(ptid, leds[i].id, leds[i].on) +
                            '</tr>');
        }
       devicetabhtml += '</table></div>';
         //Add the complete HTML for this device to the "devices" DIV element
        devicetabhtml += ('<div class="device-reading-container"><form method = "post" action = "test2.lsp"><input type="hidden" name="ptid" value ='+
        ptid+'>');
        devicetabhtml +='<input type="text" name="companyname" value = "chameleon"><input type="submit" name = "test" value = "Remove this device"></form>';
        if(typeof info.temp != 'undefined') {
            devicetabhtml+='<div class="device-reading" id="temp-'+ptid+'">'+temp2html(info.temp)+'</div><br>'
            devicetabhtml+='<div class="device-reading" id="temp-'+ptid+'">'+temp2html(info.temp)+'</div><br>'
            devicetabhtml+='<div class="device-reading" id="temp-'+ptid+'">'+temp2html(info.temp)+'</div><br>'
            devicetabhtml+='<div class="device-reading" id="temp-'+ptid+'">'+temp2html(info.temp)+'</div><br>'
        }
        devicetabhtml+= '</div>';
        $("#deviceInfo-"+ptid).append(devicetabhtml);
        
        $('#dev-'+ptid+' :checkbox').click(function(ev) {
            var id = $(this).prop('id').match(/(\d+)-(\d+)/);
            var ptid = parseInt(id[1]);
            var ledId = parseInt(id[2]);
            var data = new Uint8Array(2);
            data[0] = ledId;
            data[1] = this.checked ? 1 : 0;
            smq.publish(data,ptid);
            
        });
        
        
        
        smq.observe(ptid, function() {
            $('#dev-'+ptid).remove();
            $('#device-'+ptid).remove();
            $('#deviceContents-'+ptid).html("<h2>The device has disconnected</h2>");
            $("#deviceInfo-"+ptid).remove();
            $("#deviceSettings-"+ptid).remove();;
            $("#deviceLogs-"+ptid).remove();

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
        $(tempId).html(temp2html(temp));
    };
    
    /*function removeDevice(ptid){
        $('#dev-'+ptid).remove();
    };*/
    
    
 //When a new device broadcasts to all connected "display" units.
    smq.subscribe(getCompany(), "devinfo", {"datatype":"json", "onmsg":devInfo});
    //smq.subscribe("/m2m/led/device", {"datatype":"json", "onmsg":devInfo});

    //When a device responds to our "/m2m/led/display" published message.
    //smq.subscribe("self", "devinfo", {"datatype":"json", "onmsg":devInfo});
    smq.subscribe("self", {"datatype":"json", "onmsg":devInfo});

    //When a device publishes LED state change.
    //smq.subscribe("/m2m/led/device", "led", {"onmsg":onLED});
    smq.subscribe(getCompany(), {"onmsg":onLED});

    //When a device publishes a new temperature.
    <?lsp --[[if true then]] ?> smq.subscribe("/m2m/temp", {"onmsg":onTemp}); <?lsp --[[ end ]] ?>
 
    //Broadcast to all connected devices.
    //Device will then send 'info' to our ptid ("self"), sub-tid: "devinfo".
    
    smq.publish("Hello", "/m2m/led/display/"+getCompany());

});

</script>

</head>
<body>
<div id="new-header">
    <script>
    $("#new-header").load("repeatfiles/header.html?version=9", function() {
        $('#header-deviceList').addClass('active');
    });
    </script>
</div>


  <div class="container">
	<div class="row">
        <div class="panel panel-default user_panel" id = "devicesListContainer">
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
        
        <div id ="deviceSettingInjection">
                
           </div>
        
        
	</div>
</div>
</body>
</html>