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
        <!--<style> 
        div.collapse {
            border: 5px solid;
            border-radius: 15px 50px;
            border-color:black;
            padding-left: 2em;
            background:black;
            color:white;
        }
        ."btn btn-info" {
            background:black
            
        }
        </style>
    -->
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
        <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
        <title>User List</title>
    </head>
  
    <body>

<?lsp 
        local su=require"sqlutil"
        --local sql=string.format("username,companyname,PasswordExpiry,CompanyName,ContactNumber,Email,permissionlevel FROM users")
        usersession = request:session()
        local value = request:data().name
        if value then
        else
            value = usersession.loggedinas
        end
        
        local sql = selectQueryWhere({"username","companyname","passwordexpiry","contactnumber","email","permissionlevel"},"users","username",value);
        local function opendb() 
            return su.open"file" 
        end

        local function exec(cur)
            local username,companyname,passwordexpiry,contactnumber,email,permissionlevel = cur:fetch()?>
            <div id="userinfo">
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
        
        
        
        local ok,err=su.select(opendb,string.format(sql), exec)
        
        
        ?>
        
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

<pre style="background:red">
    
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
<a href="options.lsp">Go back</a>
        </body>
</html>
        