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
    <link rel="stylesheet" href="cssfiles/button.css?version=8">
    <link rel="stylesheet" href="cssfiles/textheadings.css?version=1">
    <!--<link rel="stylesheet" href="cssfiles/header.css?version=1">-->
      <style>body{
      html{height:100%}
  color:white;
   font-weight:bold;
background: rgb(0,0,0); /* Old browsers */
background: -moz-linear-gradient(top,  rgba(0,0,0,1) 0%, rgba(69,72,77,1) 110%); /* FF3.6+ */
background: -webkit-gradient(linear, left top, left bottom, color-stop(0%,rgba(0,0,0,1)), color-stop(100%,rgba(69,72,77,1))); /* Chrome,Safari4+ */
background: -webkit-linear-gradient(top,  rgba(0,0,0,1) 0%,rgba(69,72,77,1) 100%); /* Chrome10+,Safari5.1+ */
background: -o-linear-gradient(top,  rgba(0,0,0,1) 0%,rgba(69,72,77,1) 100%); /* Opera 11.10+ */
background: -ms-linear-gradient(top,  rgba(0,0,0,1) 0%,rgba(69,72,77,1) 100%); /* IE10+ */
background: linear-gradient(to bottom,  rgba(0,0,0,1) 0%,rgba(69,72,77,1) 100%); /* W3C */
filter: progid:DXImageTransform.Microsoft.gradient( startColorstr='#000000', endColorstr='#45484d',GradientType=0 ); /* IE6-9 */
}
}   </style>
  </head>

  <body>
      <h1 align = "center">Options</h1>
        <script>
            var buttonlist  = new Array("adddevice.lsp","adduser.lsp","addcompany.lsp","usersettings.lsp","userlist.lsp","devicelist.lsp","userlogs.lsp", "login.lsp");
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
