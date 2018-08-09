<?lsp 
    local su=require"sqlutil"
    local sql = deleteQueryWhere("device","deviceIP","172.20.20.101")
    local env,conn = su.open"file"
    trace(sql)
    local ok,err=conn:execute(sql)
    if ok then trace"device removed from list" end
    su.close(env,conn)
?>