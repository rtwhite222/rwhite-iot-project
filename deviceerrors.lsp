<?lsp 
    local su=require"sqlutil"
        local sql = selectQueryWhereMult({"COUNT(*)"},"deviceerrors",{"deviceIP","resolved"},{"asdf","0"})
        print(sql)  
        local function opendb() 
            return su.open"file" 
        end
                            
        local function exec(cur)
            local errcount = cur:fetch()
            return true
        end
                        
    local ok,err=su.select(opendb,string.format(sql), exec)
    ?>