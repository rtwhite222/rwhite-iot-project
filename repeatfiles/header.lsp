<link rel="stylesheet" href="//ProjectApplication/cssfiles/inputForms.css?version=3">
<?lsp         usersession = request:session()

        if not usersession then response:forward"login.lsp" end
        function checkLogin()
            if not usersession.loggedin then
                print "not logged in"
                request:session(false)
                response:forward"login.lsp"
            end
        end
checkLogin()
?>

<link href="//maxcdn.bootstrapcdn.com/bootstrap/3.3.0/css/bootstrap.min.css" rel="stylesheet" id="bootstrap-css"><script src="https://use.fontawesome.com/1e803d693b.js"></script>
<nav class="navbar navbar-inverse">
  <div class="container-fluid">
    <div class="navbar-header">
      <a class="navbar-brand" href="#">Chameleon</a>
    </div>
    <ul class="nav navbar-nav">      
        <li id="header-deviceList"><a href="devicelist.lsp">Connected Devices</a></li>
        <li id="header-addDevices"><a href="adddevice.lsp"><!--<span class="glyphicon glyphicon-search"></span>--> Device Discovery</a></li>
        <li id="header-userList"><a href="userlist.lsp">User List</a></li>
        <?lsp if usersession.addNewDevice == 1 then ?><li id="header-addDevices"><a href="adduser.lsp"><!--<span class="glyphicon glyphicon-search"></span>--> Add New User</a></li><?lsp end ?>
        <li id="header-addDevices"><a href="addcompany.lsp"><!--<span class="glyphicon glyphicon-search"></span>--> Add New Company</a></li>
    </ul>
    <ul class="nav navbar-nav navbar-right">
      <li><a href="usersettings.lsp?name="<?lsp=usersession.loggedinas?>'><span class="glyphicon glyphicon-user"></span> My Profile</a></li>
      <li><a href="login.lsp"><span class="glyphicon glyphicon-log-in"></span> Log Out</a></li>
    </ul>
  </div>
</nav> 