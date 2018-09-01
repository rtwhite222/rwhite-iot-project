 <link href="//maxcdn.bootstrapcdn.com/bootstrap/3.3.0/css/bootstrap.min.css" rel="stylesheet" id="bootstrap-css">
<script src="//maxcdn.bootstrapcdn.com/bootstrap/3.3.0/js/bootstrap.min.js"></script>
<script src="//code.jquery.com/jquery-1.11.1.min.js"></script>
<!------ Include the above in your HEAD tag ---------->

<script src="https://use.fontawesome.com/1e803d693b.js"></script>
            <link rel="stylesheet" href="cssfiles/inputForms.css?version=22">
<style>
    .tab {
    margin:auto;
    border-radius: 5px;
}
body {
    background: linear-gradient(to right, rgba(128,128,128,1), rgba(128,128,128,0));
}
img{
max-width:100%;
max-height:100%;
}
.userImageContainer{
max-width:30%;
padding-top: 20px;
padding-left: 20px;
float:left
}

.usernameContainer {
    border-style:solid;
    padding-left: 30px;
    -webkit-border-image: 
           -webkit-linear-gradient(left, rgba(255,255,255,1) 1%,rgba(0,0,0,1) 50%,rgba(255,255,255,1) 100%) 0 0 100% 0/0 0 5px 0 stretch;
}
.companyContainer {
    float:right;
    padding-right:10px;

}
.textContainer{
    width:70%;
    display: inline-block;
    padding-left: 50px;
    padding-top:20px;

}
.setting-modal
{
    display: none;
    z-index: 1;
    position: absolute; /* Stay in place */
    left: 0;
    top: 0;
    padding-top: 100px;
    border-radius: 5px;
    width: 100%; /* Full width */
    height: 100%; /* Full height */
    overflow: auto;
        background-color: rgb(0,0,0); /* Fallback color */
    background-color: rgba(0,0,0,0.4); /* Black w/ opacity */
}
        input[type=text], input[type=password], input[type=email], input[type=tel], select {
  width: 90%;
  padding: 15px;
  margin: 0 0 22px 0;
  display: inline-block;
  border: none;
  background: #f1f1f1;
}
        input[type=submit] {
  width: 90%;
  padding: 10px;
  margin: 22px 0 22px 0;
  display: inline-block;
  border: none;
}
.modal-interior{
    background-color: #fefefe;
    margin: auto;
    padding: 20px;
    border: 1px solid #888;
    width: 50%;
    text-align: center;
    font-size: 17px;
}

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
    max-height: 70vh;
    overflow-y: auto;
    min-height: 10vh;
    margin:auto;
    background:white;
    border-radius: 5px;
}
.settings-btn{
width:100%;
height:5%;
margin:5px;
background-color: #f1f1f1;

}
.settings-btn:hover {
    background-color: #ddd;
}
</style>
<?lsp 
        --local sql=string.format("username,companyname,PasswordExpiry,CompanyName,ContactNumber,Email,permissionlevel FROM users")
        usersession = request:session()
        trace(usersession.loggedinas)
        if not usersession then response:forward"login.lsp" end
        function checkLogin()
            if not usersession.loggedin then
                print "not logged in"
                response:forward"login.lsp"
            end
        end
checkLogin()
local userInfo=request:data().userSelect
local tabHighlight = request:data().from
--local userInfo="root"
--local tabHighlight="list"
?>

<div id="new-header">
    <script>
    function getActiveTab(){
    return <?lsp if tabHighlight == "list" then print("'#header-userList'") else print("'#header-userProfile'") end?>
    }
    $("#new-header").load("header.lsp", function() {
        $(getActiveTab()).addClass('active');
    });
    </script>
</div>
<div class="container" >
    <div class="tab">
        <button class="tablinks" onclick="openInfo(event, 'UserInfo')" id="defaultOpen">User Info</button>
        <?lsp if tonumber(usersession.changeUserSettings) == 1 or userInfo == usersession.loggedinas then ?> 
        <button class="tablinks" onclick="openInfo(event, 'ChangeSettings')">Edit User Settings</button> 
        <?lsp end ?>
        
        <button class="tablinks" onclick="openInfo(event, 'UserLogs')">User Logs</button>
    </div>

<!-- Tab content -->
<?lsp 
         
local su=require"sqlutil"
        
        local sql = selectQueryWhere({"username","companyname","passwordexpiry","contactnumber","email","permissionlevel"},"users","Email",userInfo);
        local function opendb() 
            return su.open"file" 
        end

        local function execute(cur)
            local name,companyname,passwordexpiry,contactnumber,email,permissionlevel = cur:fetch()?>
            
            <div id="UserInfo" class="tabcontent">
                <div class="usernameContainer">
                    <h1><?lsp=name?>
                    <span class="companyContainer"> <?lsp=companyname?> </span></h1>
                    </div>
                <div class="userImageContainer">
                    <img src="stickpingimage.png" />
                </div>
                <div class="textContainer">
                    <h2><i class="fa fa-phone">   </i> <?lsp if contactnumber == "" then print"None given" else print(contactnumber) end?></h2><br>
                    <h2><i class="fa fa-envelope"></i> <?lsp=email?></h2><br>
                    <h2><i class='fa fa-lock'> </i> <?lsp=permissionlevel?></h2>
                    </div></div>
                    <?lsp
            return true
     end
        
        
        
        local ok,err=su.select(opendb,string.format(sql), execute)
        
        
        ?>

<div id="ChangeSettings" class="tabcontent">
    <!-- THREE BUTTONS HERERERERERERERERERE-->
    <button class="settings-btn" id="pass-popup">Change password</button>
    <button class="settings-btn btn-right" id="name-popup">Change name</button><br>
    <button class="settings-btn" id="phone-popup">Change phone number</button>
    <button class="settings-btn btn-right" id="email-popup">Change Email</button>
    
 
</div>
<div id="UserLogs" class="tabcontent">
  <?lsp
  local su=require"sqlutil"
        --local sql=string.format("username,companyname,PasswordExpiry,CompanyName,ContactNumber,Email,permissionlevel FROM users")
        local sql = selectQueryWhere({"*"},"userlogs","Email",userInfo);
        local function opendb() 
            return su.open"file" 
        end
        ?>
        <table class="table table-striped" ><thead><th scope="col">user</th><th scope="col">time</th><th scope="col">action</th></thead><tbody>
        <?lsp
        local function exec(cur)
            local user,activitytime,action = cur:fetch()
            while user do
                
                --local function execute(c2)
                --    local = c2:fetch() 
                    
                --end
                --local ok,err=su.select(opendb,string.format(sqlSelectUser), execute(c2))
                

                ?>
                <tr>
                    <th> <?lsp=user?> </th><th> <?lsp=(os.date("%c", activitytime))?> </th><th> <?lsp=action ?></th>
                </tr>
            <?lsp
               user,activitytime,action = cur:fetch()
            end
            response:write("</tbody></table>")
            --write("</div>")
            return true
        end
        response:write"</div>"
     local ok,err=su.select(opendb,string.format(sql), exec)


?>
</table></div>
</div> </div>
    <div class = "setting-modal" id = "change-password">
        <div class="modal-interior">
            <form method="post">
                Password: <br><input type="password" name="passwordCheck" placeholder = "Please enter your password" required><br>
                New Password: <br><input type="password" name="password" placeholder = "Enter account&#39;s new password" pattern="(?=.*\d)(?=.*[a-z])(?=.*[A-Z]).{8,}" autocomplete="off" title="at least one number and one uppercase and lowercase letter, and at least 8 or more characters" required><br>
                Confirm New Password: <br><input type="password" name="passwordConfirm" placeholder = "Confirm password" required><br>
                <input type="submit" value="Change password">
            </form>
        </div>
    </div>
    <div class = "setting-modal" id ="edit-name">
        <div class="modal-interior">

        <form method="post">
            Password: <br><input type="password" name="passwordCheck" placeholder = "Please enter your password" required><br>
            Name: <br><input type="text" name="username" placeholder = "Enter new name" required><br>
            <input type="submit" value="Update Name">
        </form></div>
    </div>
    <div class = "setting-modal" id="edit-contact-number">
        <div class="modal-interior">

        <form method="post">
            Password: <br><input type="password" name="passwordCheck" placeholder = "Please enter your password" required><br>
            Phone Number: <br><input type="text" name="ContactNumber" placeholder = "Enter new contact number" required><br>
            <input type="submit" value="Update Contact Number">
        </form></div>
    </div>
    <div class = "setting-modal" id ="edit-email">
        <div class="modal-interior">

        <form method="post">
            Password: <br><input type="password" name="passwordCheck" placeholder = "Please enter your password" required><br>
            Email: <br><input type="text" name="Email" placeholder = "Enter new email address"><br>
            <input type="submit" value="Update Email">
            <br> Keep in mind that this new value will be used to sign you in
        </form></div>
    </div>

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
    

    document.getElementById("pass-popup").onclick = function() {
        document.getElementById('change-password').style.display = "block";
    }
    document.getElementById("name-popup").onclick = function() {
        document.getElementById('edit-name').style.display = "block";
    }   
    document.getElementById("phone-popup").onclick = function() {
        document.getElementById('edit-contact-number').style.display = "block";
    } 
    document.getElementById("email-popup").onclick = function() {
        document.getElementById('edit-email').style.display = "block";
    } 
    
    
    window.onclick = function(event) {
        if (event.target == document.getElementById('change-password')) {
            document.getElementById('change-password').style.display = "none";
        } 
        if (event.target == document.getElementById('edit-name')) {
            document.getElementById('edit-name').style.display = "none";
        }
        if (event.target == document.getElementById('edit-contact-number')) {
            document.getElementById('edit-contact-number').style.display = "none";
        }
        if (event.target == document.getElementById('edit-email')) {
            document.getElementById('edit-email').style.display = "none";
        }
    }

</script>


<?lsp -- START SERVER SIDE CODE


if request:method() == "POST" then
    local updateValues = request:data()
    trace(usersession.loggedinas)
   local sql = selectQueryWhere({"password"},"users","Email",usersession.loggedinas); -- builds select query

    
        local function execute(cur)
            password = cur:fetch()
            return true
        end
        
        local function opendb() 
            return su.open("file")
        end
        
        local ok,err=su.select(opendb,string.format(sql), execute)
        
        if not ok then 
            response:write("DB err: "..err) 
        end
        if updateValues.passwordCheck == password then 
            if updateValues.passwordConfirm == nil or updateValues.passwordConfirm == updateValues.password then 
                local logincheck = updateValues.userSelect
                updateValues.userSelect = nil
                local fromPage = updateValues.from
                updateValues.from = nil
                updateValues.passwordCheck = nil
                updateValues.passwordConfirm = nil
                -- setting all unneeded inputs to nil so the 
                local su=require"sqlutil"
                local env,conn = su.open"file"
                
                local sql = updateQueryWhere(updateValues,'users', 'Email', userInfo)
                
                print(sql)
                ok, err = conn:execute(string.format(sql))
                if ok then 
                    print("User settings updated")
                else
                    print("SQL update failed ",err)
                end
                if updateValues.Email ~= nil then 
                    trace("here")
                    if logincheck == usersession.loggedinas then
                        usersession.loggedinas = updateValues.Email
                    end
                    ?>
                    <script>
                    location.href = "usersettings.lsp?from=<?lsp=fromPage ?>&userSelect=<?lsp=updateValues.Email?>";
                    </script> 
                
                <?lsp 
                else
                    ?>
                    <script>
                    location.href = "usersettings.lsp?from=<?lsp=fromPage?>&userSelect=<?lsp=logincheck?>";
                    </script>
                       
                <?lsp 
                end 
            else ?>
                <script>alert("Password mismatch")</script> 
                <?lsp
            end    
           
        else ?>
            <script>alert("Incorrect password entered")</script> 
            <?lsp
        end
    end
    
    --su.close(env,conn)
    --trace(value)

?>