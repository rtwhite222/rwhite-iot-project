<!DOCTYPE html>
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
                    $('#header-addNewCompany').addClass('active');
                });
            </script>
        </div>
        
        <div class="container"><div class="content-container">
        
        <form method="post">
            
            Company Name: <br><input type="text" name="CompanyName"><br>
            Street: <br><input type="text" name="street"><br>
            City: <br><input type="text" name="city"><br>
            Postcode: <br><input type="text" name="postc"><br>
            Company Email: <br><input type="text" name="email"><br>
            Company Phone: <br><input type="text" name="ContactNumber"><br> 
            <input type="submit" value="Create Company Profile">
        </form>


    
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
    trace(sql)
    ok, err = conn:execute(sql)
    if ok then 
        print("New company created")
         local sql= "INSERT INTO userlogs VALUES('"..usersession.loggedinas.."','"..os.time().."','Created new company - ".. companyTable.CompanyName .."');"
            local env,conn = su.open"file"
            local ok,err=conn:execute(sql)
            su.close(env,conn)
        
            if not ok then 
                response:write("DB err: "..err) 
            end
    else
        print("New company create failed. Make sure that the company is not already in the system. "
            .."Otherwise, please try again.")
    end
    
    su.close(env,conn)
   
end
?>
</div></div></body></html>