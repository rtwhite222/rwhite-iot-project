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
        <div class="container">
     <?lsp 
        local su=require"sqlutil"
        --local sql=string.format("username,companyname,PasswordExpiry,CompanyName,ContactNumber,Email,permissionlevel FROM users")
        local sql = selectQuery({"username","companyname","passwordexpiry","companyname","contactnumber","email","permissionlevel"},"users");
        local function opendb() 
            return su.open"file" 
        end

        local function exec(cur)
            local user,company,passwordexpiry,company,number,email,permissions = cur:fetch()
            while user do

                --local function execute(c2)
                --    local = c2:fetch() 
                    
                --end
                --local ok,err=su.select(opendb,string.format(sqlSelectUser), execute(c2))
                
                response:write("<button type='button' class='btn btn-info' data-toggle='collapse' data-target='#"..user.."'>"..user.." | "..company.."</button><br>")
                response:write("<div id='"..user.."' class='collapse'>"
                    .."<h3>"
                    .."Username: "..user.. "<br><br>"
                    .."Password Expiry Date: "..passwordexpiry.."<br><br>"
                    .."Related Company: "..company.."<br><br>"
                    .."Contact Number: "..number.."<br><br>"
                    .."Email Address: "..email.."<br><br>"
                    .."Granted Permission Level: "..permissions.."<br>"
                    .."<br></h3></div>")
                
               user,company,passwordexpiry,company,number,email,permissions = cur:fetch()
            end
            return true
     end
        
        
        
        local ok,err=su.select(opendb,string.format(sql), exec)
        
        
        ?>
  

  
</div>
</select><br>
<a href="options.lsp">Go back</a>
  </body>
</html>
