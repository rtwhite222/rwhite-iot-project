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
    <head>
        <meta charset="UTF-8"/>
        <meta name="viewport" content="width=device-width, height=device-height, initial-scale=1">
        <title>Login Page</title>
        
        <link rel="stylesheet" href="cssfiles/button.css?version=4">
            <link rel="stylesheet" href="cssfiles/inputForms.css?version=3">
                <style>body{
    color: white;
}</style>
    </head>
    
    
    <body>
        
        

<form method="post">
Name:<br> <input type="text" name="name" required><br>
Password:<br> <input type="password" name="password" required><br>
Confirm Password:<br> <input type="password" name="passwordCheck" required><br>
Company:<br> <select name="companyName" required>
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


Phone Number:<br> <input type="text" name="phoneNumber"><br>
Email:<br> <input type="text" name="emailAddress" required><br>
Permission Level:<br> <select name="permissionLevel" required><br>
<option value=""></option>

<?lsp 

usersession = request:session()
if not usersession then response:forward"login.lsp" end
        local su=require"sqlutil"
        local sql=string.format("PermissionLevel FROM permissions")
        

        local function execute(cur)
        local permissions = cur:fetch()
        while permissions do
           print("<option value="..permissions..">"..permissions.."</option>")
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
<input type="submit" value = "Create new user"></button>
</form>

<pre style="background:red">
    
<?lsp -- START SERVER SIDE CODE


if request:method() == "POST"  then
    local userTable = request:data()
    
   -- -- -- --
  if userTable.password == userTable.passwordCheck then
        local su=require"sqlutil"
        local env,conn = su.open"file"
        local sql= "INSERT INTO users(username,password,PasswordExpiry,CompanyName,ContactNumber,Email,permissionlevel) VALUES("
        sql = string.format(sql .. "'" .. userTable.name .. "',")
        sql = string.format(sql .. "'" .. userTable.password .. "',")
        --local expirytime = os.time()+60*60*24*180
        --DATEADD(MONTH,6,GETDATE())
        sql = string.format(sql .. '0' .. ",")
        sql = string.format(sql .. "'" .. userTable.companyName .. "',")
        sql = string.format(sql .. "'" .. userTable.phoneNumber .. "',")
        sql = string.format(sql .. "'" .. userTable.emailAddress .. "',")
        sql = string.format(sql .. "'" .. userTable.permissionLevel .. "');")
        --print(sql)
        
        ok, err = conn:execute(sql)
        if ok then 
            print("New user created")
        else
            print("New user create failed ",err)
        end
        
        su.close(env,conn)
        trace(value)
    else if userTable.password ~= userTable.passwordCheck then 
        print("Password mismach. Try again")
    end
    end
end

?>
</pre>

<a href="options.lsp">Go back</a>
</body></html>
