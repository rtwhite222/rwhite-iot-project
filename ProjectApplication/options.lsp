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
    <!--<div class="header">
        <a href="#default" class="logo">CompanyLogo</a>
        <div class="header-right">
            <a class="active" href="#home">Home</a>
            <a href="#contact">Contact</a>
            <a href="#about">About</a>
        </div>
    </div> -->
  <head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, height=device-height, initial-scale=1">
    <title>Options Page</title>
    <link rel="stylesheet" href="cssfiles/button.css?version=9">
    <link rel="stylesheet" href="cssfiles/textheadings.css?version=1">
    <!--<link rel="stylesheet" href="cssfiles/header.css?version=1">-->

  </head>

  <body>
      <h1 align = "center">Options</h1>
        <script>
            var buttonlist  = new Array("adddevice.lsp","adduser.lsp","addcompany.lsp","usersettings.lsp","test4.lsp","devicelist.lsp","userlogs.lsp", "login.lsp");
            var buttonnames = new Array("Add Device", "Add New User","Add Company", "User Settings", "User List", "Device List","User Logs","Log out");
            var buttonheight = Math.floor(90/buttonlist.length);
            for(var i=0; i<buttonlist.length; i++){
                var btn = document.createElement("BUTTON");
                document.body.appendChild(btn);
                btn.id = buttonnames[i];
                btn.innerHTML = buttonnames[i];
                btn.setAttribute("onclick", "location.href= '" + buttonlist[i] +"'");
                btn.className="buttonTypeA";
                btn.style.height = buttonheight + "vh";
                
                if(i == buttonlist.length-1) {
                    btn.style.width = "20vw"
                    //btn.style.borderRadius: '1em';
                }
                else{
                    document.write("<br>");
                }
            }
        </script>
  </body>
</html>
