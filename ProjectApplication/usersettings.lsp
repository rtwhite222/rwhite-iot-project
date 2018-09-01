 <link href="//maxcdn.bootstrapcdn.com/bootstrap/3.3.0/css/bootstrap.min.css" rel="stylesheet" id="bootstrap-css">
<script src="//maxcdn.bootstrapcdn.com/bootstrap/3.3.0/js/bootstrap.min.js"></script>
<script src="//code.jquery.com/jquery-1.11.1.min.js"></script>
<!------ Include the above in your HEAD tag ---------->

<script src="https://use.fontawesome.com/1e803d693b.js"></script>
 <nav class="navbar navbar-inverse">
  <div class="container-fluid">
    <div class="navbar-header">
      <a class="navbar-brand" href="#">Othername</a>
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
<style>
    .tab {
    margin:auto;
    border-radius: 5px;
}
.tabcontent {

margin:auto;
background:white;
border-radius: 5px;
}
body {
    background: linear-gradient(to right, rgba(128,128,128,1), rgba(128,128,128,0));
}

</style>
<div class="container" >
    <div class="tab">
        <button class="tablinks" onclick="openInfo(event, 'UserInfo')" id="defaultOpen">User Info</button>
        <button class="tablinks" onclick="openInfo(event, 'ChangeSettings')">Edit User Settings</button>
        <button class="tablinks" onclick="openInfo(event, 'UserLogs')">User Logs</button>
    </div>

<!-- Tab content -->
<?lsp 
        local su=require"sqlutil"
        --local sql=string.format("username,companyname,PasswordExpiry,CompanyName,ContactNumber,Email,permissionlevel FROM users")
        usersession = request:session()
        if not usersession then response:forward"login.lsp" end
        function checkLogin()
            if not usersession.loggedin then
                print "not logged in"
                response:forward"login.lsp"
            end
        end
checkLogin()
        local value = request:data().name
        if value then
        else
            value = usersession.loggedinas
        end
        
        local sql = selectQueryWhere({"username","companyname","passwordexpiry","contactnumber","email","permissionlevel"},"users","username",value);
        local function opendb() 
            return su.open"file" 
        end

        local function execute(cur)
            local username,companyname,passwordexpiry,contactnumber,email,permissionlevel = cur:fetch()?>
            
            <div id="UserInfo" class="tabcontent">
                <h3>
                    Username: <?lsp=username?> <br><br>
                    Password Expiry Date: <?lsp=passwordexpiry?> <br><br>
                    Related Company: <?lsp=companyname?><br><br>
                    Contact Number: <?lsp=contactnumber?><br><br>
                    Email Address: <?lsp=email?><br><br>
                    Granted Permission Level: <?lsp=permissionlevel?><br>
                    <br></h3></div>
                    <?lsp
            return true
     end
        
        
        
        local ok,err=su.select(opendb,string.format(sql), execute)
        
        
        ?>

<div id="ChangeSettings" class="tabcontent">
<form method="post">
Name: <input type="text" name="username"><br>
Password: <input type="password" name="password"><br>
Confirm Password: <input type="password" name="passwordCheck"><br>
Company: <select name="companyName">
<option value=""></option>

<?lsp 
        local su=require"sqlutil"
        local sql=string.format("companyName FROM company")
        

        local function execute(cur)
        local company = cur:fetch()
        
        while company do
           response:write("<option value="..company..">"..company.."</option>")
           company = cur:fetch()
        end
        return true
     end
        
        local function opendb() 
            return su.open"file" 
        end
        
        local ok,err=su.select(opendb,string.format(sql), execute)
        
        
        ?>
</select><br>


Phone Number: <input type="text" name="ContactNumber"><br>
Email: <input type="text" name="email"><br>
Permission Level: <input type="text" name="permissionLevel"><br>
<!-- <button type = "button" onClick = optionsPage() >Login</button> -->
<button type="submit">Update User Settings</button>
</form>
</div>

<div id="UserLogs" class="tabcontent">
  <?lsp
  local su=require"sqlutil"
        --local sql=string.format("username,companyname,PasswordExpiry,CompanyName,ContactNumber,Email,permissionlevel FROM users")
        local sql = selectQueryWhere({"*"},"userlogs","username",usersession.loggedinas);
        local function opendb() 
            return su.open"file" 
        end ?>
        
        <table>
            <th>
                user
            </th>
            <th>
                time
            </th>
            <th>
                action
            </th>
            
        <?lsp
        local function exec(cur)
            local user,activitytime,action = cur:fetch()
            while user do ?>
                
                <tr>
                    <td> 
                    <?lsp=user?>
                    </td>
                    <td> 
                    <?lsp=(os.date("%c", activitytime))?> 
                    </td>
                    <td> <?lsp=action ?></td>
                </tr>
           
            <?lsp
               user,activitytime,action = cur:fetch()
            end
            --write("</div>")
            return true
        end

     local ok,err=su.select(opendb,string.format(sql), exec)


?>
</table></div>
</div> </div>
<style>
.tab {
    overflow: hidden;
    border: 1px solid #ccc;
    background-color: #f1f1f1;
}

/* Style the buttons that are used to open the tab content */
.tab button {
    background-color: inherit;
    float: left;
    border: none;
    outline: none;
    cursor: pointer;
    padding: 14px 16px;
    transition: 0.3s;
}

/* Change background color of buttons on hover */
.tab button:hover {
    background-color: #ddd;
}

/* Create an active/current tablink class */
.tab button.active {
    background-color: #ccc;
}

/* Style the tab content */
.tabcontent {
    display: none;
    padding: 6px 12px;
    border: 1px solid #ccc;
    border-top: none;
height: 70%;
overflow-y: auto;
}</style>

<script>
    function openInfo(evt, tabName) {
    // Declare all variables
    var i, tabcontent, tablinks;

    // Get all elements with class="tabcontent" and hide them
    tabcontent = document.getElementsByClassName("tabcontent");
    for (i = 0; i < tabcontent.length; i++) {
        tabcontent[i].style.display = "none";
    }


    // Get all elements with class="tablinks" and remove the class "active"
    tablinks = document.getElementsByClassName("tablinks");
    for (i = 0; i < tablinks.length; i++) {
        tablinks[i].className = tablinks[i].className.replace(" active", "");
    }

    // Show the current tab, and add an "active" class to the button that opened the tab
    document.getElementById(tabName).style.display = "block";
    evt.currentTarget.className += " active";
    
    } 
    document.getElementById("defaultOpen").click();
</script>


<?lsp -- START SERVER SIDE CODE


if request:method() == "POST" then
    local userTable = request:data()
    
   -- -- -- --
  
    local su=require"sqlutil"
    local env,conn = su.open"file"
    
    local sql = updateQueryWhere(userTable,'users', 'username', usersession.loggedinas)
    
    print(sql)
    ok, err = conn:execute(sql)
    if ok then 
        print("User settings updated")
    else
        print("SQL update failed ",err)
    end
    
    --su.close(env,conn)
    --trace(value)
end
?>