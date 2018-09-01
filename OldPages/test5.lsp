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
        /*var html='<div id="dev-'+ptid+'"><span>'+(escapeHtml(info.devname))+'</span><div>';
        html += (mkSubmitBtn(ptid))
        */
        var html = "<tr class='clickable-row' data-href='options.lsp'>" +
                                "<td width='10' align='center'>" +
                                    "<i class='fa fa-2x fa-user fw'></i>" +
                                "</td>" +
                                "<td>" +
                                    "56780 <br><i class='fa fa-envelope'></i>" +
                                "</td>" +
                                "<td>" +
                                   "56780" +
                                "</td>" +
                                "<td align='center'>" +
                                    "Last Login:  6/14/2017<br><small class='text-muted'>2 days ago</small>" +
                                "</td>" +
                           "</tr>";
        $("#devices").append(html);
    
        
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

<link href="//maxcdn.bootstrapcdn.com/bootstrap/3.3.0/css/bootstrap.min.css" rel="stylesheet" id="bootstrap-css">
<script src="//maxcdn.bootstrapcdn.com/bootstrap/3.3.0/js/bootstrap.min.js"></script>
<script src="//code.jquery.com/jquery-1.11.1.min.js"></script>
<!------ Include the above in your HEAD tag ---------->

<script src="https://use.fontawesome.com/1e803d693b.js"></script>
<script src="/rtl/smq.js"></script>
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

</style>
 <nav class="navbar navbar-inverse">
  <div class="container-fluid">
    <div class="navbar-header">
      <a class="navbar-brand" href="#">Devices</a>
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
<div class="container">
    <div class="search-container">
    <form action="/action_page.php">
        <input type="text" name="name" placeholder = "Search for user">
        <input type="submit" value = "Search"></button>
    </form>
    <form action="/action_page.php">
        <input type="text" name="name" placeholder = "Search by Company">
        <input type="submit" value = "Search"></button>
    </form>
</div>
	<div class="row">
        <div class="panel panel-default user_panel">
            <div class="panel-heading">
                <h3 class="panel-title">User List</h3>
            </div>
            <div class="panel-body">
				<div class="table-container">
                    <table class="table-users table" border="0">
                        <tbody id="devices">
                            <tr class='clickable-row' data-href='options.lsp'>
                                <td width='10' align='center'>
                                    <i class='fa fa-2x fa-user fw'></i>
                                </td>
                                <td>
                                    5678 <br><i class='fa fa-envelope'></i>
                                </td>
                                <td>
                                   5678
                                </td>
                                <td align='center'>
                                    Last Login:  6/14/2017<br><small class='text-muted'>2 days ago</small>
                                </td>
                            </tr> 

                        </tbody>
                    </table>
                </div>
            </div>
        </div>

	</div>
</div>
<script>
jQuery(document).ready(function($) {
    $(".clickable-row").click(function() {
        window.location = $(this).data("href");
    });
});</script>