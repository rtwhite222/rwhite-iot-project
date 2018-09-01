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
trace(usersession.addNewUser)
if tonumber(usersession.addCompanyUsers)==1 then ?>
<html>
    <head>
        <meta charset="UTF-8"/>
        <meta name="viewport" content="width=device-width, height=device-height, initial-scale=1">
        <title>Login Page</title>
        
            <link rel="stylesheet" href="cssfiles/inputForms.css?version=22">

    </head>
    <style>
        .content-container{
  top: 0;
  right: 0;
  bottom: 0;
  left: 0;
  width: 60%;
  background-color: White;
  border-radius: 5px;
  text-align: left;
  padding-left: 5%;
  padding-top: 30px;
  box-shadow: 5px 5px 5px grey;
  margin: auto;
  font-size: 17px;
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
br {
   margin: 5px;
}
    </style>

    <body><script src="//code.jquery.com/jquery-1.11.1.min.js"></script>
        <div id="new-header">
            <script>
                $("#new-header").load("header.lsp?version=2", function() {
                    $('#header-addNewUser').addClass('active');
                });
            </script>
        </div>
        
        
        <div class="container"><div class="content-container">
<form method="post">
Name:<br> <input type="text" name="username" required><br>
Password:<br> <input type="password" name="password" pattern="(?=.*\d)(?=.*[a-z])(?=.*[A-Z]).{8,}" title="at least one number and one uppercase and lowercase letter, and at least 8 or more characters" required>
<br>Confirn Password:<br><input type="password" name="passwordCheck" required>
<input type="hidden" name ="PasswordExpiry" value = "0">
<br>Company:<br> <select name="CompanyName" required>

<?lsp if tonumber(usersession.addNewNonCompanyUsers)==1 then
        local su=require"sqlutil"
        local sql=string.format("companyName FROM company")
        
        local function execute(cur)
            local company = cur:fetch()
            while company do
               response:write("<option value='"..company.."'>"..company.."</option>")
               company = cur:fetch()
            end
            return true
        end
        
        local function opendb() 
            return su.open"file" 
        end
        
        local ok,err=su.select(opendb,string.format(sql), execute)
        
    else
        response:write("<option value='"..usersession.company.."'>"..usersession.company.."</option>")
    end
    
        ?>
</select><br>


<br>Phone Number:<br> <input type="tel" name="ContactNumber" title="Please input a valid phone number"><br>
Email:<br> <input type="email" name="Email" title="Please input a valid email address" required><br>
Permission Level:<br> <select name="permissionlevel" required><br>
<option value=""></option>

<?lsp 

usersession = request:session()
if not usersession then response:forward"login.lsp" end
        local su=require"sqlutil"
        local sql=string.format("PermissionLevel FROM permissions")
        

        local function execute(cur)
        local permissions = cur:fetch()
        while permissions do
           print("<option value='"..permissions.."'>"..permissions.."</option>")
           permissions = cur:fetch()
        end
        return true
     end
        
        local function opendb() 
            return su.open"file" 
        end
        
        local ok,err=su.select(opendb,string.format(sql), execute)
        
        ?></select><br>
<!-- <button type = "button" onClick = optionsPage() >Login</button> -->
<input type="submit" value = "Create new user">
</form>


    
<?lsp -- START SERVER SIDE CODE


if request:method() == "POST"  then
    local userTable = request:data()
    
   -- -- -- --
    if userTable.password == userTable.passwordCheck then
        local su=require"sqlutil"
        local env,conn = su.open"file"
        local sql= "INSERT INTO users(username,password,PasswordExpiry,CompanyName,ContactNumber,Email,permissionlevel) VALUES("
        sql = string.format(sql .. "'" .. userTable.username .. "',")
        sql = string.format(sql .. "'" .. userTable.password .. "',")
        --local expirytime = os.time()+60*60*24*180
        --DATEADD(MONTH,6,GETDATE())
        sql = string.format(sql .. '0' .. ",")
        sql = string.format(sql .. "'" .. userTable.CompanyName .. "',")
        sql = string.format(sql .. "'" .. userTable.ContactNumber .. "',")
        sql = string.format(sql .. "'" .. userTable.Email .. "',")
        sql = string.format(sql .. "'" .. userTable.permissionlevel .. "');")
        --print(sql)
        ok, err = conn:execute(sql)
        if ok then 
            print("New user created")
             local sql= "INSERT INTO userlogs VALUES('"..usersession.loggedinas.."','"..os.time().."','Created new user - ".. userTable.username .."');"
            local env,conn = su.open"file"
            local ok,err=conn:execute(sql)
            su.close(env,conn)
        
        if not ok then 
            response:write("DB err: "..err) 
        end
        else
            print("New user create failed ",err)
        end
        
        su.close(env,conn)
    else if userTable.password ~= userTable.passwordCheck then 
        print("Password mismach. Try again")
    end
    end
end

?>
</div></div></body></html>
<?lsp
else
print"ACCESS DENIED"
end
?>