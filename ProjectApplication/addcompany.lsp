<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8"/>
        <meta name="viewport" content="width=device-width, height=device-height, initial-scale=1">
        <title>Login Page</title>
        <link rel="stylesheet" href="cssfiles/button.css?version=3">
        
    </head>
    
    <body>
        
        <form method="post">
            
            Company Name: <br><input type="text" name="name"><br>
            Street: <br><input type="text" name="street"><br>
            City: <br><input type="text" name="city"><br>
            Postcode: <br><input type="text" name="postcode"><br>
            Company Email: <br><input type="text" name="emailAddress"><br>
            Company Phone: <br><input type="text" name="contactNumber"><br> 
            <button type="submit">Create Company Profile</button>
        </form>

<pre style="background:red">
    
<?lsp -- START SERVER SIDE CODE
usersession = request:session()
if not usersession then response:forward"login.lsp" end

--local sql = selectQueryWhere({"password"},"users","username","a");
function checkLogin()
    if not usersession.loggedin then
        print "not logged in"
        response:forward"login.lsp"
    end
end
checkLogin()

if request:method() == "POST" then
    local companyTable = request:data()
   -- -- -- --
    local su=require"sqlutil"
    local env,conn = su.open"file"
    --local sql= "INSERT INTO company VALUES("
    --sql = string.format(sql .. "'" .. companyTable.name .. "',")
    --sql = string.format(sql .. "'" .. companyTable.street .. "',")
    --sql = string.format(sql .. "'" .. companyTable.city .. "',")
    --sql = string.format(sql .. "'" .. companyTable.postcode .. "',")
    --sql = string.format(sql .. "'" .. companyTable.emailAddress .. "',")
    --sql = string.format(sql .. "'" .. companyTable.contactNumber .. "');")
    local sql = insertQuery(companyTable,"company")
    
    ok, err = conn:execute(sql)
    if ok then 
        print("New company created")
    else
        print("New company create failed. Make sure that the company is not already in the system. "
            .."Otherwise, please try again.")
    end
    
    su.close(env,conn)
   
end
?>
</pre>

<a href="options.lsp">Go back</a>
</body></html>