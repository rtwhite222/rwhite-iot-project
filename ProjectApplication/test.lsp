<?lsp 
sql="INSERT INTO deviceerrors VALUES('172.20.20.107','Test Error',39,0);"
su=require"sqlutil" 
   local env,conn = su.open"file"
  ok, err = conn:execute(sql)
    if ok then 
        print("Error created")
    else
        trace("Permission Settings create failed")
    end
    
    su.close(env,conn)
    ?>