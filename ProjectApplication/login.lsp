<!DOCTYPE html>
    <html>
        <head>
            <meta charset="UTF-8"/>
            <meta name="viewport" content="width=device-width, height=device-height, initial-scale=1">
            <title>Login Page</title>
            <link rel="stylesheet" href="cssfiles/button.css?version=3">
            <link rel="stylesheet" href="cssfiles/inputForms.css?version=3">
            
        </head>
    <body>
        
        <style>
            input{
                width: 90%;
                padding:2px 2px;
            }

        </style>

<form method="post">
Name:
<br><input type="text" name="name" autofocus required><br>
Password: 
<br><input type="password" name="password" required><br>
<!-- <button type = "button" onClick = optionsPage() >Login</button> -->
<input type="submit" value = "Login">
</form>

    
<?lsp -- START SERVER SIDE CODE
response:write('<pre style="background:red">')
usersession = request:session(true) -- Creates user session (persistent 
usersession.loggedin = false
if not usersession.lockoutuntil then usersession.lockoutuntil = 0 end
if request:method() == "POST" and (os.time()>(usersession.lockoutuntil or 0)) then
    
    local luaTable = request:data() -- grabs data from posted form
    local su=require("sqlutil") -- sql utility that allows access to database commands
    local sqlQueries = require("ProjectApplication.lua.sqlQuery") -- loads custom select query builder function list
    local sql = selectQueryWhere({"password"},"users","username",luaTable.name); -- builds select query
    --local sql=string.format("password FROM users WHERE username = '%s'",luaTable.name)
    
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
        
        --su.close(env,conn)
        
       if (--luaTable.name == "root" and 
           luaTable.password == password) then
            print("working")
            trace"Logging in"
            --loginattempt:terminate()
            usersession.loggedin = true
            usersession.loggedinas = luaTable.name
            usersession.loginattempts = 0
            
             local sql= "INSERT INTO userlogs VALUES('"..luaTable.name.."','"..os.time().."','User Login');"
             trace(sql)
            local env,conn = su.open"file"
            local ok,err=conn:execute(sql)
            su.close(env,conn)
        
        if not ok then 
            response:write("DB err: "..err) 
        end
        --if ok then
        --    response:write("login is a go") end
           response:forward"options.lsp"
            
            
            --loginattempt.counter = 999
           
        else
            print("Wrong username or password. Please try again")
            usersession.loginattempts = (usersession.loginattempts or 0) + 1
            
            if(usersession.loginattempts >= 3) then
                print("you have exceeded 3 login attempts")
                usersession.loginattempts = 0
                usersession.lockoutuntil =  os.time() + 60*5
            end
            
    end
    
end
    if usersession.lockoutuntil > os.time() then print("Please wait another "..(usersession.lockoutuntil-os.time())//60 .. " minute(s) and " 
        .. (usersession.lockoutuntil-os.time())%60 .. " seconds before trying to log in again") end
    
    response:write('</pre>')

?>

</body></html>