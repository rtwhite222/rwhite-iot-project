<!DOCTYPE html>
    <html>
        <head>
            <meta charset="UTF-8"/>
            <meta name="viewport" content="width=device-width, height=device-height, initial-scale=1">
            <title>Login Page</title>

            <link rel="stylesheet" href="cssfiles/inputForms.css?version=3">
            
        </head>
<style>body{
    display: block;
    color: lightgrey;
}
.center-div
{
  position: absolute;
  margin: auto;
  top: 0;
  right: 0;
  bottom: 0;
  left: 0;
  width: 60%;
  height: 450px;
  background-color: White;
  border-radius: 5px;
  text-align: center;
  box-shadow: 5px 5px 5px grey;
}
input[type=text] {
    width: 50%;
    border: 2px solid;
    border-color:red;
    font-size: 17px;
}
input[type=password] {
    width: 50%;
    border: 2px solid;
    border-color:red;
    font-size: 17px;
}
input[type=submit] {
    width:100px;
    font-size: 25px;
    box-shadow: 1px 1px 5px grey;
}
body {
    background: linear-gradient(to right, rgba(128,128,128,1), rgba(128,128,128,0));
}
h2 {
    font-family: Tahoma, Geneva, sans-serif;
}

</style>

<div class="center-div">
    <form method="post">
        <br>
<h2 align = "center">Name:</h2>
<input type="text" name="name" placeholder="Enter username" autocomplete="nope" autofocus required><br>
<h2 align = "center">Password:</h2>
<input type="password" name="password" placeholder="Enter password"  required><br><br><br>
<!-- <button type = "button" onClick = optionsPage() >Login</button> -->
<input type="submit" value = "Login">
</form>
</div>
    
<?lsp -- START SERVER SIDE CODE

usersession = request:session(true) -- Creates user session (persistent 
if not usersession.loggedin then 
    usersession.loggedin = false
    usersession:maxinactiveinterval(300)
end
--if usersession.loggedin == true then response:forward"options.lsp" end
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
            --loginattempt:terminate()
            usersession.loggedin = true;
            usersession.loggedinas = luaTable.name;
            usersession.loginattempts = 0;
            local sql = selectQueryWhere({"CompanyName"},"users","username",luaTable.name);
        
            local function execute(cur)
                company = cur:fetch();
                return true;
            end
            
            local function opendb() 
                return su.open("file");
            end
            
            local ok,err=su.select(opendb,string.format(sql), execute);
            usersession.company=company;
            trace(usersession.company)
            if not ok then 
                response:write("DB err: "..err) 
            end
            
             local sql= "INSERT INTO userlogs VALUES('"..luaTable.name.."','"..os.time().."','User Login');"
            local env,conn = su.open"file"
            local ok,err=conn:execute(sql)
            su.close(env,conn)
        
        if not ok then 
            response:write("DB err: "..err) 
        end
        --if ok then
           response:forward"devicelist.lsp"
            
            
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