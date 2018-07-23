<!DOCTYPE html>
<style>table, th, td {
    border: 1px solid black;
}</style>
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
        response:write("<table><th>user</th><th>time</th><th>action</th>")
        local function exec(cur)
            local user,activitytime,action = cur:fetch()
            while user do
                
                --local function execute(c2)
                --    local = c2:fetch() 
                    
                --end
                --local ok,err=su.select(opendb,string.format(sqlSelectUser), execute(c2))
                

                
                response:write("<tr>"
                    .."<td>".. user .." </td><td>"..(os.date("%c", activitytime)) .." </td><td>"..action.."</td>"
                    .."</tr>")
                
               user,activitytime,action = cur:fetch()
            end
            response:write("</table>")
            --write("</div>")
            return true
        end
        response:write"</div>"
     local ok,err=su.select(opendb,string.format(sql), exec)


?>
<html><body><a href="options.lsp">Go back</a></body></html>