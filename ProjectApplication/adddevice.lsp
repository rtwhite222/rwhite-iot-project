<!DOCTYPE html>
<?lsp usersession = request:session()
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
<meta charset="UTF-8" />
<title>Devices Page</title>
<meta name=viewport content="width=device-width, initial-scale=1" />
<link rel="stylesheet" type="text/css" href="style.css"/>

<script src="/rtl/jquery.js"></script>
<script src="/rtl/smq.js"></script>
<script src="txt2link.js"></script>
<script>

function escapeHtml(unsafe) {
    return unsafe
        .replace(/&/g, "&amp;")
        .replace(/</g, "&lt;")
        .replace(/>/g, "&gt;")
        .replace(/"/g, "&quot;")
        .replace(/'/g, "&#039;");
};


/* Each LED is wrapped in a Table Row (TR) element (Ref-TR). Each TR
   element contains 3 TD elements and the 3 'mk..' (for make) functions
   below create the HTML that goes into these 3 TD elements.
*/

/* TD 1: the LED name */
function mkLedName(name) {
    <?lsp print"var x = 'hi'"?>
    return '<td>'+name+'</td>';
}

/* TD 2: the LED is simply a DIV element styled by using the CSS from
   the following page: http://cssdeck.com/labs/css-leds
*/
function mkLed(ptid,ledId,color,on) {
    return '<td><div id="led-'+ptid+ledId+'" class="led-'+
        color+(on ? '' : ' led-off')+'"></div></td>';
}


/* TD 3: the LED on/off switch is a standard HTML checkbox that is
   styled using CSS3 and by using CSS3 transformation. We used the
   on/off FlipSwitch generator on the following page for generating
   the CSS: https://proto.io/freebies/onoff/
*/
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

/* temp is in celcius x 10 */
function temp2html(temp) {
    temp /= 10;
    return "Temperature: " + temp + "  &#x2103; <span>(" + 
        Math.round(temp*9/5+32) + " &#x2109;)</span>";
}


/* The div with ID 'nodev' is used for displaying information when no
   devices are connected.
*/
function printNoDevs() {
    $("#nodev").html('<h2>There are currently no devices connected</p>').show();
}


/* The complete LED manager is created in this function when JQuery
   calls our anonymous function at startup.
*/
$(function() {
    var connectedDevs=0;
    if(window.location.search.search("nointro") == 1) {
        $("#dev-0").hide();
        $("#nav-0").hide();
    }

    /* Check if the browser supports WebSockets */
    if(! SMQ.websocket() ) {
        $('#nodev').html('<h2>Please update your browser or install one which supports websockets</h2>');
        return; /* Stop: no support */
    }

    // Create a SimpleMQ instance and connect to the broker.
    var smq = SMQ.Client(SMQ.wsURL("/Server-Broker-Test8/"));

    /* We use the onmsg as a "catch all" for non managed messages we
       receive. This function should not be called since we install
       callbacks for all subscribed events. The onmsg is typically
       used for error checking during development.
    */
    smq.onmsg=function(data,ptid,tid,subtid) {
        console.log("Received unexpected data:", data,", from",ptid,", tid=",tid,
                    ", subtid=",subtid);
        console.log("  data string:",SMQ.utf8.decode(data))
    };

    /* The disconnect callback function removes all devices and
       LEDS. A disconnect message is shown. The function instructs the
       SimpleMQ client stack to attempt to reconnect after 3
       seconds. This function will be called repeatedly if the
       SimpleMQ client stack is unable to reconnect.
     */
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
        smq.publish("Hello", "/m2m/led/display");
    };

    /* Function devInfo is installed as a SimpleMQ callback for the
       events we receive on the [topic "self" and sub topic "devinfo"]
       and on the [topic "/m2m/led/display" and sub topic
       "devinfo"]. The function creates the HTML for the device based
       on the capabilities presented in the info object. The info
       object is the parsed JSON received from the device.
    */
    function devInfo(info, ptid) {
        /* HTML for device information (displayed at top). We give the
         DIV the ID "dev-'+ptid+'". The ID is used when we install
         click event callbacks for the on/off switches (Ref-switch).
        */
        
        var html='<div id="dev-'+ptid+'"><span>'+(escapeHtml(info.devname))+'</span><div>';
        html += '<form method="post"><input type="submit" value = "Add this device to company device list"></form>';html += '</table></div>';
        //Add the complete HTML for this device to the "devices" DIV element

        $("#devices").append(html);
        
        smq.observe(ptid, function() {
            $('#dev-'+ptid).remove(); /* Remove HTML for this device */
            $('#nav-'+ptid).remove(); /* Remove the tab in the left pane */
            if(--connectedDevs == 0)
                printNoDevs();
        });

        $('#nav').append('<li><a id="nav-'+ ptid+'" href="#">'+escapeHtml(info.ipaddr)+'<span>'+
                         escapeHtml(info.devname)+'</a></span></li>');

        if(++connectedDevs == 1) { // State change: no devices to at least one device.
            $("#nodev").hide(); // Hide message: no devices connected ...
            $('#nav-0').hide(); // hides the tab indicating that there are currently no devices in the add queue
            $("#dev-"+ptid).show(); // Show our new HTML
            $("#nav-"+ptid).addClass("selected"); // Make the tab in the left pane "selected"
        }
    } // End function devInfo
    
    function devcheck(info,ptid){
    if(true){
    devInfo(info,ptid)
    }
    }


    //When a new device broadcasts to all connected "display" units.
    smq.subscribe("/m2m/led/device", "devinfo", {"datatype":"json", "onmsg":devcheck});

    //When a device responds to our "/m2m/led/display" published message.
    smq.subscribe("self", "devinfo", {"datatype":"json", "onmsg":devcheck});

    //When a device publishes LED state change.

    //When a device publishes a new temperature.

 
    //Broadcast to all connected devices.
    //Device will then send 'info' to our ptid ("self"), sub-tid: "devinfo".
    smq.publish("Hello", "/m2m/led/display");

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
          <li><a id="nav-0" href="#">No Devices<span>SMQ LED Demo Introduction</span></a></li>
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
</body>
<a href="options.lsp">Go back</a>
</html>
