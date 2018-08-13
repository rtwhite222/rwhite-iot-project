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

if (tonumber(usersession.addNewDevice) == 0) then
    print("ACCESS DENIED") 
    else
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

}
tr:hover{
    background-color: #ddd;
    color: black;
}

.submit-btn {
  float: right;
  margin-right: 16px;
  background: #ddd;
  font-size: 17px;
  border: none;
  cursor: pointer;
}

select {
    border: none;
    margin-top: 8px;
    margin-right: 16px;
    font-size: 17px;
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
function getCompanyName(){
html = ""

<?lsp
 if tonumber(usersession.viewAllDevices) == 1 then
 local su=require"sqlutil"
        local sql=string.format("companyName FROM company")
        
        local function execute(cur)
            local company = cur:fetch()
            while company do 
            ?>
               html+="<option value=<?lsp=company ?>><?lsp=company?></option>"
               <?lsp 
               company = cur:fetch()
            end
            return true
        end
        
        local function opendb() 
            return su.open"file" 
        end
        
        local ok,err=su.select(opendb,string.format(sql), execute)
        
        
else ?>
 html+="<option value=<?lsp=usersession.company?>><?lsp=usersession.company?></option>"        
<?lsp end ?>

return html
}
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
                "Register to company:   <select id='companyInput"+ptid+"'>"+getCompanyName()+"</select>"+
                "<button class='submit-btn' type = 'submit' id = 'submit"+ptid+"'>Register Device</button>"+
            "</td>"+
        "</tr> ");
        $("#devicesList").append(html);
        
        $("#submit"+ptid).click(function(ev) {
            var message = '#dev-'+ptid;
            smq.publish($("#companyInput"+ptid).val()+"\0",ptid);
            smq.publish(message,"deviceremove")
            $.ajax({
              type: "POST",
              url: "deviceaddservercode.lsp",
              data: {deviceModel: info.devname,companyName: $("#companyInput"+ptid).val(),deviceIP:info.ipaddr},
            success: function(output) {
                  alert(output);
                  if(--connectedDevs == 0)
                printNoDevs();
              }
            });
            
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
    
    
    /*function removeDevice(ptid){
        $('#dev-'+ptid).remove();
    };*/
    
    
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
<div id="new-header">
    <script>
    $("#new-header").load("header.lsp?version=9", function() {
        $('#header-addDevices').addClass('active');
    });
    </script>
</div>


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
<?lsp end ?>