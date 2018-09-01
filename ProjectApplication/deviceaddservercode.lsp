<?lsp 
    devinfo = request:data()
    local su=require"sqlutil"
    local env,conn = su.open"file"
    local sql = insertQuery(devinfo,"device")
    trace(sql)
    ok, err = conn:execute(sql)
    if ok then 
        print("Device registered")
        usersession = request:session()
        local sql= "INSERT INTO userlogs VALUES('"..usersession.loggedinas.."','"..os.time().."','Registered device - <br> - Model:"..devinfo.deviceModel.." <br> - IP: "..devinfo.deviceIP.." <br> - Company : "..devinfo.companyName.."');"
        local env,conn = su.open"file"
        local ok,err=conn:execute(sql)
        su.close(env,conn)
    else
        print("Device registration failed ",err)
    end
?>

