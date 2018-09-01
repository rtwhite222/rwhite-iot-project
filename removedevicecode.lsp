<?lsp 
    local su=require"sqlutil"
    local sql = deleteQueryWhere("device","deviceIP","172.20.20.107")
    local env,conn = su.open"file"
    trace(sql)
    local ok,err=conn:execute(sql)
    if ok then print"The device has been removed. Restart it for the changes to take effect" end
    su.close(env,conn)
?>