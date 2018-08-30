<!DOCTYPE html>
    <html>
        <head>
            <meta charset="UTF-8"/>
            <meta name="viewport" content="width=device-width, height=device-height, initial-scale=1">
            <title>Login Page</title>

            <style>
body{
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
  height: 500px;
  background-color: White;
  border-radius: 5px;
  text-align: center;
  box-shadow: 5px 5px 5px grey;
  overflow: hide;
}
input[type=text] {
    width: 50%;
    border: 2px solid;
    border-color:red;
    font-size: 17px;
    padding: 12px 20px;
    margin: 8px 0;
    display: inline-block;
    border-radius: 4px;
    box-sizing: border-box;
}
input[type=password] {
    width: 50%;
    border: 2px solid;
    border-color:red;
    font-size: 17px;
    padding: 12px 20px;
    margin: 8px 0;
    display: inline-block;
    border-radius: 4px;
    box-sizing: border-box;
}
input[type=submit] {
    width:100px;
    font-size: 25px;
    box-shadow: 1px 1px 5px grey;
    
    background-color: red;
    color: white;
    padding: 14px 20px;
    margin: 8px 0;
    border: none;
    border-radius: 4px;
    cursor: pointer;
}
body {
    background: linear-gradient(to right, rgba(128,128,128,1), rgba(128,128,128,0));
}
h2 {
    font-family: Tahoma, Geneva, sans-serif;
}
h3 {
    font-family: Tahoma, Geneva, sans-serif;
    font-size: 15px;
    color: black;
}




</style>
        </head>


<div class="center-div">
    <form method="post">
        <br>
<h2 align = "center">Email:</h2>
<input type="text" name="Email" placeholder="Enter Email" autocomplete="nope" autofocus required><br>
<h2 align = "center">Password:</h2>
<input type="password" name="password" placeholder="Enter password"  required><br><br><br>
<!-- <button type = "button" onClick = optionsPage() >Login</button> -->
<input type="submit" value = "Login">
</form>

    
<?lsp -- START SERVER SIDE CODE

usersession = request:session(true) -- Creates user session (persistent 
--if not usersession.loggedin then 
--usersession.lockoutuntil = 0
    usersession.loggedin = false
    usersession:maxinactiveinterval(300)
--end
--if usersession.loggedin == true then response:forward"options.lsp" end
if not usersession.lockoutuntil then usersession.lockoutuntil = 0 end
if request:method() == "POST" and (os.time()>(usersession.lockoutuntil or 0)) then
    
    local luaTable = request:data() -- grabs data from posted form
    local su=require("sqlutil") -- sql utility that allows access to database commands
    --local sqlQueries = require("ProjectApplication.lua.sqlQuery") -- loads custom select query builder function list
    local sql = selectQueryWhere({"password"},"users","Email",luaTable.Email); -- builds select query

    
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
        
       if (luaTable.password == password) then
            --loginattempt:terminate()
            usersession.loggedin = true;
            usersession.loggedinas = luaTable.Email;
            trace(usersession.loggedinas)
            usersession.loginattempts = 0;
            local sql = selectQueryWhere({"CompanyName,PermissionLevel"},"users","Email",luaTable.Email);
            local function execute(cur)
                company,permissionlevel = cur:fetch();
                return true;
            end
            
            local function opendb() 
                return su.open("file");
            end
            
            local ok,err=su.select(opendb,string.format(sql), execute);
            usersession.company=company;
            if not ok then 
                response:write("DB err: "..err) 
            end
            
            local sql = selectQueryWhere({"viewAllDevices","viewAllUsers","changeUserSettings","viewCompanyUsers"
                ,"addNewNonCompanyUsers","addCompanyUsers","addNewCompany","addNewDevice",
                "changeDeviceSettings","isManufacturerEmployee","isRoot"},"permissions","PermissionLevel",permissionlevel)
            trace(sql)
            local function execute(cur)
                usersession.viewAllDevices, usersession.viewAllUsers,usersession.changeUserSettings,usersession.viewCompanyUsers
                ,usersession.addNewNonCompanyUsers,usersession.addCompanyUsers,usersession.addNewCompany,usersession.addNewDevice,
                usersession.changeDeviceSettings,usersession.isManufacturerEmployee,usersession.isRoot = cur:fetch();
                return true;
            end
            local ok,err=su.select(opendb,string.format(sql), execute);
            trace(usersession.viewAllDevices)
             local sql= "INSERT INTO userlogs VALUES('"..luaTable.Email.."','"..os.time().."','User Login');"
            local env,conn = su.open"file"
            local ok,err=conn:execute(sql)
            su.close(env,conn)
        
        if not ok then 
            response:write("DB err: "..err) 
        end
        --if ok then
        ?>
           <script>location.href = "devicelist.lsp"</script>
        <?lsp    
            
            --loginattempt.counter = 999
           
        else
            
            usersession.loginattempts = (usersession.loginattempts or 0) + 1
            
            if(usersession.loginattempts >= 3) then
                usersession.loginattempts = 0
                usersession.lockoutuntil =  os.time() + 60*5-1
            else
                print("<h3>Wrong username or password. Please try again</h3>")
            end
            
    end
    
end
    if usersession.lockoutuntil > os.time() then print("<h3>Please wait another "..(usersession.lockoutuntil-os.time())//60+1 .. " minute(s)"-- and " 
        .. --[[(usersession.lockoutuntil-os.time())%60 .. " seconds--]] " before trying to log in again</h3>") end
    
    --response:write('</pre>')

?>
</div>
</body></html>