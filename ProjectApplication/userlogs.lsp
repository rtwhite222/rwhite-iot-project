<!DOCTYPE html>
<?lsp

local su=require"sqlutil"
        --local sql=string.format("username,companyname,PasswordExpiry,CompanyName,ContactNumber,Email,permissionlevel FROM users")
        local sql = selectQuery({"*"},"userlogs");
    trace(sql)
        local function opendb() 
            return su.open"file" 
        end
        
        local function exec(cur)
            local user,activitytime,action = cur:fetch()
            trace(user)
            while user do
                
                --local function execute(c2)
                --    local = c2:fetch() 
                    
                --end
                --local ok,err=su.select(opendb,string.format(sqlSelectUser), execute(c2))
                
                response:write("<div ><h3>"
                    .."user: ".. user .." <br>activity time: "..activitytime .." <br>action: "..action.."<br><br>"
                    .."<br></h3>")
                
               user,activitytime,action = cur:fetch()
               trace(user)
            end
            --write("</div>")
            return true
        end
        response:write"</div>"
     local ok,err=su.select(opendb,string.format(sql), exec)


?>
<html><body><a href="options.lsp">Go back</a></body></html>