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
    <script type="text/javascript" src="https://canvasjs.com/assets/script/canvasjs.min.js"></script>
    <link href="//maxcdn.bootstrapcdn.com/bootstrap/3.3.0/css/bootstrap.min.css" rel="stylesheet" id="bootstrap-css">
<!--<script src="//maxcdn.bootstrapcdn.com/bootstrap/3.3.0/js/bootstrap.min.js"></script>
<script src="//code.jquery.com/jquery-1.11.1.min.js"></script>
- - - - - Include the above in your HEAD tag - - - - - - - -

<script src="https://use.fontawesome.com/1e803d693b.js"></script>-->
<style>
form {
    display: inline-block; //Or display: inline; 
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


form {
    display: inline-block; //Or display: inline; 
}

.clickable-row:hover{
    background-color: #ddd;
    color: black;
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

.header-div{
position: absolute;
    float:left;
    display:inline;
     margin-left: 10px;
     margin-top: 8px;
     font-size: 25px;
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
    display:inline-block;
    background-color: black;
    float: right;
    color:white;
    font-size: 15px;
    
}

/* Change background color of buttons on hover */
.tablinks:hover {
    background-color: #ddd;
    color:black;
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
.device-reading-container {
    border-style:solid;
    padding-left: 30px;
    padding-bottom: 10px;
    -webkit-border-image: 
        -webkit-linear-gradient(left, rgba(255,255,255,1) 1%,rgba(0,0,0,1) 50%,rgba(255,255,255,1) 100%) 0 0 100% 0/0 0 5px 0 stretch;
           @media (max-width: 480px){float:left;}
}
.readout-container {
    padding-left: 50px;
    padding-top: 20px;
    float:left;
}
.device-reading {
padding-top:10px;
padding-bottom:15px;
}
.device-gpio-container{
    float:left;
    display: inline-block;
    padding-left: 30px;
    padding-top: 10px;
    padding-right:30px;
}

.right-align-span{
    float:right;
    padding-right:10px;
}


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
.led, .led-off {
margin:20px;
    width: 25px;
    height: 25px;
    border-radius: 50%;
}


.led {
    background-color: #690;
    box-shadow: #000 0 -1px 7px 1px, inset #460 0 -1px 9px, #7D0 0 2px 12px;
}


.led-off {
    background-color: gray;
    box-shadow: #000 0 -1px 7px 1px, inset #4B4B4B 0 -1px 9px, #878787 0 2px 14px;
}

.red-warning {
color:red;
}
.white-warning {
color:white;
}
.setting-inputs{
background-color:black;
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
    return '<td><div id="led-'+ptid+ledId+'" class="led'+
        (on ? '' : ' led-off')+'"></div></td>';
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
        Math.round(temp*9/5+32) + " &#x2109; )</span>";
}
function torque2html(torque) {
    return "Torque: " + torque + " N \u22C5 m "
}
function runtime2html(runtime) {
    return "Run time left: " + runtime
}
function size2html(size) {
    return "Paint tin size: " + size;
}

function printNoDevs() {
    $("#nodev").html('<h2 align="center">There are currently no devices connected</h2>').show();
};




function errorResolve(ipaddr, errorTimes,ptid) {
$.ajax({
        type: "POST",
        url: "deviceerrorupdate.lsp",
        data: {deviceIP: escapeHtml(ipaddr), errorTime: errorTimes},
        success: function(output) {
            $("#row-"+errorTimes+ptid).remove();
            errorCount(ipaddr,ptid)
        }
    });
} 

function errorCount(ipaddr,ptid){

    $.ajax({
        
        type: "POST",
        url: "deviceerrorcount.lsp",
        data: {deviceIP: escapeHtml(ipaddr)},
        success: function(output) {
            if(output > 0){
                $('#device-warning-'+ptid).removeClass("white-warning").addClass("red-warning");
            }
            else{
                $('#device-warning-'+ptid).removeClass("red-warning").addClass("white-warning");
                $("#deviceLogs-"+ptid).html("This device has no unresolved errors");
            }
        }
    });

}
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
        smq.publish("Hello", "nocompany");////////////////////////////////////////////////////////////////////////////////
    };
    

    function devInfo(info, ptid) {
    info.company = "nil"
        var html=        
        ("<tr class='clickable-row' id = 'device-"+ptid+"' data-href='usersettings.lsp'>"+
            "<td width='10' align='center'>"+
                "<i class='fa fa-2x fa-warning fw white-warning' id='device-warning-"+ptid+"'></i>"+   
            "</td>"+
            "<td>"+
                escapeHtml(info.devname)+"<br>"+
            "</td>"+
            "<td>"+
                escapeHtml(info.ipaddr)+
            "</td>"+
            "<td align='center'>"+
                "Product registered to:<br><small class='text-muted'>"+escapeHtml(info.company)+"</small>"+

        "</tr> ");
        
        $("#devicesList").append(html);
        
        errorCount(info.ipaddr,ptid)
        
                var tablisthtml=        
            ('<div class="tab" id = "deviceContents-'+ptid+'">'+
                '<button class="tablinks active" id ="deviceInfoTab-'+ptid+'">Device Info</button>'+
                '<button class="tablinks" id ="deviceStatisticsTab-'+ptid+'">Device Statistics</button>'+
                '<button class="tablinks" id ="deviceRunParamsTab-'+ptid+'">Device Parameters</button>'+
                '<button class="tablinks" id ="deviceLogsTab-'+ptid+'">Error Logs</button>'+
                '<button class="tablinks backtab" id ="backtab-'+ptid+'">Go back</button>'+
            '</div>'+
            '<div id="deviceInfo-'+ptid+'" class="tabcontent">'+
            '</div>'+
            '<div id="deviceStatistics-'+ptid+'" class="tabcontent">'+
            '</div>'+
            '<div id="deviceRunParams-'+ptid+'" class="tabcontent">'+
            '</div>'+
            '<div id="deviceLogs-'+ptid+'" class="tabcontent">'+
            '</div>')
        $("#deviceSettingInjection").append(tablisthtml);
        
        
        
        $("#deviceContents-"+ptid).hide();
        
        $("#deviceInfoTab-"+ptid).click(function(ev) {
            $("#deviceInfo-"+ptid).show();
            $("#deviceStatistics-"+ptid).hide();
            $("#deviceRunParams-"+ptid).hide();
            $("#deviceLogs-"+ptid).hide();
            $("#deviceInfoTab-"+ptid).removeClass("").addClass("active");
            $("#deviceStatisticsTab-"+ptid).removeClass("active").addClass("");
            $("#deviceRunParamsTab-"+ptid).removeClass("active").addClass("");
            $("#deviceLogsTab-"+ptid).removeClass("active").addClass("");
            
        });
        
        $("#deviceStatisticsTab-"+ptid).click(function(ev) {

        
            $("#deviceInfo-"+ptid).hide();
            $("#deviceStatistics-"+ptid).show();
            $("#deviceRunParams-"+ptid).hide();            
            $("#deviceLogs-"+ptid).hide();
            $("#deviceInfoTab-"+ptid).removeClass("active").addClass("");
            $("#deviceStatisticsTab-"+ptid).removeClass("").addClass("active");
            $("#deviceRunParamsTab-"+ptid).removeClass("active").addClass("");
            $("#deviceLogsTab-"+ptid).removeClass("active").addClass("");
        });
        
        $("#deviceLogsTab-"+ptid).click(function(ev) {
            $("#deviceInfo-"+ptid).hide();
            $("#deviceStatistics-"+ptid).hide();
            $("#deviceRunParams-"+ptid).hide();
            $("#deviceLogs-"+ptid).show();
            $("#deviceInfoTab-"+ptid).removeClass("active").addClass("");
            $("#deviceStatisticsTab-"+ptid).removeClass("active").addClass("");
            $("#deviceRunParamsTab-"+ptid).removeClass("active").addClass("");
            $("#deviceLogsTab-"+ptid).removeClass("").addClass("active");
            

                $.ajax({
              type: "POST",
              url: "deviceerrors.lsp",
              data: {deviceIP: escapeHtml(info.ipaddr), ptid: ptid},
              //data: {graphinfo: "2"},
            success: function(output) {
                  $("#deviceLogs-"+ptid).html(output);
                  //renderchart();
              }
            });
            
        $('#deviceLogs-'+ptid+' :checkbox').click(function(ev) {

            alert("#smallRunTime"+ptid)
        });

        });
        
        $("#deviceRunParamsTab-"+ptid).click(function(ev) {
            $("#deviceInfo-"+ptid).hide();
            $("#deviceStatistics-"+ptid).hide();
            $("#deviceRunParams-"+ptid).show();
            $("#deviceLogs-"+ptid).hide();
            $("#deviceInfoTab-"+ptid).removeClass("active").addClass("");
            $("#deviceStatisticsTab-"+ptid).removeClass("active").addClass("");
            $("#deviceRunParamsTab-"+ptid).removeClass("").addClass("active");
            $("#deviceLogsTab-"+ptid).removeClass("active").addClass("");
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
            $("#deviceStatistics-"+ptid).hide();
            $("#deviceRunParams-"+ptid).hide();
            $("#deviceLogs-"+ptid).hide();
            
        });
        
        
        var devicetabhtml='<div id="dev-'+ptid+'">'; 
        devicetabhtml+='<div class="device-reading-container"><h1>'+(escapeHtml(info.devname))+'<span class ="right-align-span">'+escapeHtml(info.ipaddr)+'<span></h1></div>'
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
         info.torque = 0;
         info.runtime = 0;
         info.size = "None";
        

        devicetabhtml+= '<div class = "readout-container" >'
            devicetabhtml+='<div class="device-reading" id="temp-'+ptid+'">'+temp2html(info.temp)+'</div><br>'
            devicetabhtml+='<div class="device-reading" id="torque-'+ptid+'">'+torque2html(info.torque)+'</div><br>'
            devicetabhtml+='<div class="device-reading" id="runtime-'+ptid+'">'+runtime2html(info.runtime)+'</div><br>'
            devicetabhtml+='<div class="device-reading" id="size-'+ptid+'">'+size2html(info.size)+'</div><br>'
        devicetabhtml+= '</div>'
        devicetabhtml+= '</div>';
        $("#deviceInfo-"+ptid).append(devicetabhtml);
        
        devicetabhtml = '<div class = "setting-inputs">';
        devicetabhtml +='<div><input type="text" value="test" id = "smallRunTime'+ptid+'">';
        devicetabhtml +='<button class="submit-btn" type = "submit" id = "smallRunTimeSub'+ptid+'">Set Run Duration</button>';
        
        devicetabhtml += '<input type="text" value="test" id = "smallRunSpeed'+ptid+'">';
        devicetabhtml +='<button class="submit-btn" type = "submit" id = "smallRunSpeedSub'+ptid+'">Set Run Speed</button></div>';
        
        devicetabhtml +='<div><input type="text" value="test" id = "medRunTime'+ptid+'">';
        devicetabhtml +='<button class="submit-btn" type = "submit" id = "medRunTimeSub'+ptid+'">Set Run Duration</button>';
        
        devicetabhtml += '<input type="text" value="test" id = "medRunSpeed'+ptid+'">';
        devicetabhtml +='<button class="submit-btn" type = "submit" id = "medRunSpeedSub'+ptid+'">Set Run Speed</button></div>';
        
        devicetabhtml +='<div><input type="text" value="test" id = "largeRunTime'+ptid+'">';
        devicetabhtml +='<button class="submit-btn" type = "submit" id = "largeRunTimeSub'+ptid+'">Set Run Duration</button>';
        
        devicetabhtml += '<input type="text" value="test" id = "largeRunSpeed'+ptid+'">';
        devicetabhtml +='<button class="submit-btn" type = "submit" id = "largeRunSpeedSub'+ptid+'">Set Run Speed</button></div>';
        
        devicetabhtml +='<button class="submit-btn" type = "submit" id = "removeDevice'+ptid+'">Remove Device</button>';
        devicetabhtml +='</div>';
        $("#deviceRunParams-"+ptid).append(devicetabhtml);
        
        $("#smallRunSpeedSub"+ptid).click(function(ev) {
            smq.publish($("#smallRunSpeed"+ptid).val()+"\0",ptid,"smallSpeed");
            alert($("#smallRunSpeed"+ptid).val())
        });
        $("#smallRunTimeSub"+ptid).click(function(ev) {
            smq.publish($("#smallRunTime"+ptid).val()+"\0",ptid,"smallTime");
            alert($("#smallRunTime"+ptid).val())
        });
        $("#medRunSpeedSub"+ptid).click(function(ev) {
            smq.publish($("#medRunSpeed"+ptid).val()+"\0",ptid,"medSpeed");
            alert($("#medRunSpeed"+ptid).val())
        });
        $("#medRunTimeSub"+ptid).click(function(ev) {
            smq.publish($("#medRunTime"+ptid).val()+"\0",ptid,"medTime");
            alert($("#medRunTime"+ptid).val())
        });
        $("#largeRunSpeedSub"+ptid).click(function(ev) {
            smq.publish($("#largeRunSpeed"+ptid).val()+"\0",ptid,"largeSpeed");
            alert($("#largeRunSpeed"+ptid).val())
        });
        $("#largeRunTimeSub"+ptid).click(function(ev) {
            smq.publish($("#largeRunTime"+ptid).val()+"\0",ptid,"largeTime");
            alert($("#largeRunTime"+ptid).val())
        });
        $('#dev-'+ptid+' :checkbox').click(function(ev) {
            var id = $(this).prop('id').match(/(\d+)-(\d+)/);
            var ptid = parseInt(id[1]);
            var ledId = parseInt(id[2]);
            var data = new Uint8Array(2);
            data[0] = ledId;
            data[1] = this.checked ? 1 : 0;
            smq.publish(data,ptid);
            alert("#smallRunTime"+ptid)
        });
        
        $("#removeDevice"+ptid).click(function(ev) {
            $.ajax({
              type: "POST",
              url: "removedevicecode.lsp",
              data: {deviceIP:info.ipaddr},
            success: function(output) {
                  alert(output);
                  if(--connectedDevs == 0)
                printNoDevs();
              }
            });
            
        });
        
        devicetabhtml ='<div><input type="text" value="test" id = "deviceRunSelect'+ptid+'">';
        devicetabhtml +='<button class="submit-btn" type = "submit" id = "deviceRunSelectbtn'+ptid+'">View Readings</button></div>';
        devicetabhtml+= '<div id = "deviceStatisticsGraph-'+ptid+'">NO GRAPH DISPLAYED</div>';
        $("#deviceStatistics-"+ptid).html(devicetabhtml);
        $("#deviceRunSelectbtn"+ptid).click(function(ev) {
                    //////////////////////////////////////////
                $.ajax({
              type: "POST",
              url: "graphload.lsp",
              data: {deviceIP: escapeHtml(info.ipaddr), timeofrun: $("#deviceRunSelect"+ptid).val()},
              //data: {graphinfo: "2"},
            success: function(output) {
                  $("#deviceStatisticsGraph-"+ptid).html(output);
                  //renderchart();
              }
            });
        ///////////////////////////////////////////
        });
        
        smq.observe(ptid, function() {
            $('#dev-'+ptid).remove();
            $('#device-'+ptid).remove();
            $('#deviceContents-'+ptid).html('<div class="header-div">The device has disconnected</div><button class="tablinks backtab" id ="backtabdelete-'+ptid+'">Go back</button>');
            $("#deviceInfo-"+ptid).remove();
            $("#deviceStatistics-"+ptid).remove();
            $("#deviceRunParams-"+ptid)
            $("#deviceLogs-"+ptid).remove();
            $("#backtabdelete-"+ptid).click(function(ev) {
                $("#devicesListContainer").show();
                $("#deviceContents-"+ptid).hide();
            });
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
    
    function onTorque(data, ptid) {
        var b = new Uint8Array(data,0,2);
        var torque = (new DataView(b.buffer)).getInt16(0);
        var torqueId='#torque-'+ptid;
        $(torqueId).html(torque2html(torque));
    };
    
    function onTimeLeft(data, ptid) {
        var b = new Uint8Array(data,0,2);
        var time = (new DataView(b.buffer)).getInt16(0);
        var timeId='#runtime-'+ptid;
        $(timeId).html(time2html(time));
    };
    
    function onPaintSize(data, ptid) {
        var b = new Uint8Array(data,0,2);
        var size = (new DataView(b.buffer)).getInt16(0);
        var sizeId='#size-'+ptid;
        $(sizeId).html(size2html(size));
    };
    

    
    /*function removeDevice(ptid){
        $('#dev-'+ptid).remove();
    };*/
        <?lsp --[[if true then]] ?> smq.subscribe("/m2m/temp", {"onmsg":onTemp}); <?lsp --[[ end ]] ?>
        smq.subscribe("/m2m/torque", {"onmsg":onTorque});
        smq.subscribe("/m2m/time", {"onmsg":onTimeLeft});
        smq.subscribe("/m2m/size", {"onmsg":onPaintSize});
        smq.subscribe("self", {"datatype":"json", "onmsg":devInfo});
    <?lsp
    if tonumber(usersession.viewAllDevices)== 1 then 
        local su=require"sqlutil"
        local sql=string.format("companyName FROM company")

        local function execute(cur)
            local company = cur:fetch()
            while company do  trace(company)?>
                smq.subscribe("<?lsp=company?>", "devinfo", {"datatype":"json", "onmsg":devInfo}); //Devices that connect after browser has already connected-
                smq.subscribe("<?lsp=company?>", {"onmsg":onLED});
                smq.publish("Hello", "/m2m/led/display/"+"<?lsp=company?>");
               <?lsp company = cur:fetch()
            end
            return true
        end
        
        local function opendb() 
            return su.open"file" 
        end
        
        local ok,err=su.select(opendb,string.format(sql), execute)
    else
        ?>
        smq.subscribe(getCompany(), "devinfo", {"datatype":"json", "onmsg":devInfo});
                smq.subscribe(getCompany(), {"onmsg":onLED});
                smq.publish("Hello", "/m2m/led/display/"+getCompany());
        <?lsp
        
    end ?>



    
 //When a new device broadcasts to all connected "display" units.
    //smq.subscribe(getCompany(), "devinfo", {"datatype":"json", "onmsg":devInfo});
    //smq.subscribe("/m2m/led/device", {"datatype":"json", "onmsg":devInfo});

    //When a device responds to our "/m2m/led/display" published message.
    //smq.subscribe("self", "devinfo", {"datatype":"json", "onmsg":devInfo});
    //smq.subscribe("self", {"datatype":"json", "onmsg":devInfo});

    //When a device publishes LED state change.
    //smq.subscribe("/m2m/led/device", "led", {"onmsg":onLED});
    //smq.subscribe(getCompany(), {"onmsg":onLED});

    //When a device publishes a new temperature.

 
    //Broadcast to all connected devices.
    //Device will then send 'info' to our ptid ("self"), sub-tid: "devinfo".
    
    //smq.publish("Hello", "/m2m/led/display/"+getCompany());
});

</script>

</head>
<body>
<div id="new-header">
    <script>
    $("#new-header").load("header.lsp", function() {
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