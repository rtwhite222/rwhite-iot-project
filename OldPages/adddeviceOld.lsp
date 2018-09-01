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
trace"helllooooo"
checkLogin()
local searchValue = "none"
if request:method() == "POST" then
    deviceInfo = request:data();
    searchValue = deviceInfo.deviceDiscovery
end


?>

<html>
<head>
<meta charset="UTF-8" />
<title>Devices Page</title>
<meta name=viewport content="width=device-width, initial-scale=1" />
<link rel="stylesheet" type="text/css" href="style.css"/>

<script src="/rtl/jquery.js"></script>
<script src="/rtl/smq.js"></script>
<script>
function escapeHtml(unsafe) {
    return unsafe
        .replace(/&/g, "&amp;")
        .replace(/</g, "&lt;")
        .replace(/>/g, "&gt;")
        .replace(/"/g, "&quot;")
        .replace(/'/g, "&#039;");
};

/* The div with ID 'nodev' is used for displaying information when no
   devices are connected.
*/
function printNoDevs() {
    $("#nodev").html('<h2>No devices found</h2>').show();
}

function mkSubmitBtn(ptid,ledId,on) {
    var ledID = 0;
    var on = 0;
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

function getCompany(){
    var company = "<?lsp=usersession.company?>"
return company
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


    /* We redirect the onconnect event to our function for printing
       "no devices connected". The function replaces the initial
       "Connecting..." message.
     */
    smq.onconnect=printNoDevs();

    /* Called after a disconnect (smq.onclose) and after a re-connect
       attempt succeeded.
       Re-discover all devices by publishing a "hello" message to the
       "/m2m/led/display" topic. The devices will then respond by
       publishing the devices capabilities to our ephemeral topic ID.
    */
    smq.onreconnect=function() {
        //Broadcast to all connected devices.
        //Device will then send info to our ptid ("self"), sub-tid: "devinfo".
        printNoDevs(); // State "not connected" to "no devices"
        smq.publish("Hello", "nocompany");
    };

    /* Function devInfo is installed as a SimpleMQ callback for the
       events we receive on the [topic "self" and sub topic "devinfo"]
       and on the [topic "/m2m/led/display" and sub topic
       "devinfo"]. The function creates the HTML for the device based
       on the capabilities presented in the info object. The info
       object is the parsed JSON received from the device.
    */
    
    /*function submitDevice(data){
        //var companyname = document.getElementById("company-"+ptid).value;
        //var html = "hi";
        $("#devices").append(html);
        smq.publish(data.companyname+"\0",data.ptid);
    }*/

    
    function devInfo(info, ptid) {
        var html='<div id="dev-'+ptid+'"><span>'+(escapeHtml(info.devname))+'</span><div>';
        html += (mkSubmitBtn(ptid))
        
        $("#devices").append(html);
        
        $('#dev-'+ptid+' :checkbox').click(function(ev) {
            smq.publish(getCompany()+"\0",ptid);
            //$.post("test2.lsp", {deviceModel: info.devname,companyName: getCompany(),deviceIP:info.ipaddr})
            $.ajax({
              type: "POST",
              url: "deviceaddservercode.lsp",
              data: {deviceModel: info.devname,companyName: getCompany(),deviceIP:info.ipaddr},
            success: function(output) {
                  alert(output);
              }
            });
            
        });

        smq.observe(ptid, function() {
            $('#dev-'+ptid).remove(); 
            $('#nav-'+ptid).remove(); 
            if(--connectedDevs == 0)
                printNoDevs();
        });

        $('#nav').append('<li><a id="nav-'+ ptid+'" href="#">'+escapeHtml(info.ipaddr)+'<span>'+
                         escapeHtml(info.devname)+'</a></span></li>');

        if(++connectedDevs == 1) { // State change: no devices to at least one device.
            $("#nodev").hide(); // Hide message: no devices connected ...
            $("#dev-"+ptid).show(); // Show our new HTML
            $("#nav-"+ptid).addClass("selected"); // Make the tabe in the left pane "selected"
        }
    } // End function devInfo

    /* Function 'led' is installed as a SimpleMQ callback for the
       events we receive on [topic "/m2m/led/device" and sub topic
       "led"].  The device publishes to this topic/sub-topic when
       either the device internally switches an LED or when it
       receives a command from a browser.

       Argument 'data' is a binary array of length two, where byte 1
       contains the LED ID and byte two contains the on/off state.

       * The LED's on/off switch is toggled by setting the checkbox's
         "checked" attribute.
       * The LED on/off state is changed by either adding or
         removing the CSS class led-off.
*/


    //When a new device broadcasts to all connected "display" units.
    smq.subscribe("nocompany", {"datatype":"json", "onmsg":devInfo});
    //smq.subscribe("/m2m/led/device", {"datatype":"json", "onmsg":devInfo});

    //When a device responds to our "/m2m/led/display" published message.
    //smq.subscribe("self", "devinfo", {"datatype":"json", "onmsg":devInfo});
    smq.subscribe("self", {"datatype":"json", "onmsg":devInfo});


    smq.publish("Hello", "discovery");
    
    
    /*function check(data, ptid) {
        <?--lsp trace"checkingchecking123123" ?>
    };
    
    
    smq.subscribe("/m2m/temp/ss", {"onmsg":check});
    
    smq.publish("hello","/m2m/temp/ss");*/
    
    

    /* Click event for managing the tabs in the left pane when we have
       multiple devices connected. Clicking on a tab hides all
       devices and then shows the HTML for the device we clicked on.
       See the following for a 'tab' tutorial:
       http://htmldog.com/articles/tabs/
    */
    $("#nav").on("click", "a", function() {
        var ptid = $(this).prop('id').match(/(\d+)/)[0]; // Extract ptid from HTML ID element
        $("#nav a").removeClass("selected"); // Remove 'selected' from all tabs
        $(this).addClass("selected"); // Set 'selected' for the tab we clicked on
        $("#devices > div").hide(); // Hide all devices
        $("#dev-"+ptid).show(); //Show the device associated with the 'tab' we clicked on
        
        return false;
    });

});

</script>
</head>

<body>
    
  <table>
    <tr>
      <td valign="top">
        <ul id="nav">
          <li><a id="nav-0" href="#">No devices<span>There are currently no devices connected.</span></a></li>
        </ul>
      </td>
      <td valign="top" id="devices">
        <div id="dev-0" style="max-width:600px">
            If this is the only tab you see, it means that no devices are currently connected. Please go into the connect device
            tab if you believe this to be in error.



        </div>
      </td>
    </tr>
  </table>
  <div id="nodev">
    <h2>Connecting....</h2>
  </div>
  <a href="options.lsp">Go back</a>
</body>
</html>
