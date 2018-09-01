
<?lsp usersession = request:session()

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
<link href="//maxcdn.bootstrapcdn.com/bootstrap/3.3.0/css/bootstrap.min.css" rel="stylesheet" id="bootstrap-css">
<script src="https://use.fontawesome.com/1e803d693b.js"></script>
<style>
    .navbar-clickable{
    display:none;
    }
    
    @media (max-width: 1000px) {
    .navbar-widthcheck {
    display:none;
  }
  .navbar-clickable{
  display:block;
  }
  }
@media (max-width: 767px) {
  .navbar-inverse {
    visibility:hidden;
  }
  .navbar-right {
    float: none;
  }
}
</style>
<nav class="navbar navbar-inverse">
    <div class="navbar-clickable">
        hello there
    </div>
  <div class="container-fluid">
    <div class="navbar-header">
      <a class="navbar-brand" href="#">Chameleon</a>
    </div>
    <ul class="nav navbar-nav navbar-widthcheck">      
        <li id="header-deviceList"><a href="devicelist.lsp">Connected Devices</a></li>
        <?lsp trace(usersession.addNewDevice) ?>
        <?lsp if tonumber(usersession.addNewDevice) == 1 then ?><li id="header-addDevices"><a href="adddevice.lsp"> Device Discovery</a></li><?lsp end ?>
        <li id="header-userList"><a href="userlist.lsp">User List</a></li>
        <li id="header-addNewUser"><a href="adduser.lsp"><!--<span class="glyphicon glyphicon-search"></span>--> Add New User</a></li>
        <?lsp if tonumber(usersession.addNewCompany) == 1 then ?><li id="header-addNewCompany"><a href="addcompany.lsp">Add New Company</a></li><?lsp end ?>
    </ul>
    <ul class="nav navbar-nav navbar-right">
      <li id="header-userProfile"><a href="usersettings.lsp?from=profile&userSelect=<?lsp=usersession.loggedinas ?>"><span class="glyphicon glyphicon-user"></span> My Profile</a></li>
      <li><a href="login.lsp"><span class="glyphicon glyphicon-log-in"></span> Log Out</a></li>
    </ul>
  </div>
</nav> 