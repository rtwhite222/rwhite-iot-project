<!DOCTYPE html><link href="//maxcdn.bootstrapcdn.com/bootstrap/3.3.0/css/bootstrap.min.css" rel="stylesheet" id="bootstrap-css"><script src="https://use.fontawesome.com/1e803d693b.js"></script>

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

local su=require"sqlutil"
        --local sql=string.format("username,companyname,PasswordExpiry,CompanyName,ContactNumber,Email,permissionlevel FROM users")
        local sql = selectQuery({"*"},"userlogs");
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
<html><body><a href="options.lsp">Go back</a></body></html>