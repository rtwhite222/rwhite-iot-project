<!DOCTYPE HTML>
<html>
<head>  
<link href="//maxcdn.bootstrapcdn.com/bootstrap/3.3.0/css/bootstrap.min.css" rel="stylesheet" id="bootstrap-css">
<script src="//maxcdn.bootstrapcdn.com/bootstrap/3.3.0/js/bootstrap.min.js"></script>
<script src="//code.jquery.com/jquery-1.11.1.min.js"></script>
<!------ Include the above in your HEAD tag ---------->

<script src="https://use.fontawesome.com/1e803d693b.js"></script>
<style>
    form {
    display: inline-block;
}
tr:hover{
    background-color: #ddd;
    color: black;
}



body {
    background: linear-gradient(to right, rgba(128,128,128,.8), rgba(128,128,128,.3));
}

</style>

  <body>
            <?lsp
        -------------------------------------------------------------------------------------------------------------------------
        local su=require("sqlutil")
        --local sql = selectQueryWhereMult({"error","errortime"},"devicereadings",{"deviceIP","resolved"},{deviceData.deviceIP,0})
        local sql = selectQueryWhereMult({"COUNT(*)"},"deviceerrors",{"deviceIP","resolved"},{"172.20.20.107",0})

        local function execute(cur)
            errorCount = cur:fetch()
            trace(errorCount)
            return true
        end
        
        local function opendb() 
            return su.open("file")
        end
        local ok,err=su.select(opendb,string.format(sql), execute)
        
        if not ok then 
            response:write("DB err: "..err) 
        end

      ?>

<div class="table-container">
    <table class="table-users table" border="0">
        <tbody>
            <?lsp 
                deviceData=request:data()
                --deviceData.deviceIP = "172.20.20.107"
                local su=require"sqlutil"
                local sql = selectQueryWhereMult({"error","errortime"},"deviceerrors",{"deviceIP","resolved"},{deviceData.deviceIP,0})
                
                local function opendb() 
                    return su.open"file" 
                end
                
                local function execute(cur)
                    local errorType, errorTime,ptid = cur:fetch()
                    if not errorType then ?>
                    This device has no unresolved errors
                    <?lsp 
                    end
                    while errorType do
                    ?>
                    <tr class='clickable-row' id="row-<?lsp=errorTime?><?lsp=deviceData.ptid?>">
                        <td width='10' align='center'>
                            <i class='fa fa-2x fa-user fw'></i>
                        </td>
                        <td>
                            <?lsp=errorType?> <br><!--<i class='fa fa-envelope'></i>-->
                        </td>
                        <td>
                            <?lsp=errorTime?> 
                        </td>
                        <td align='center'>
                            <input type="checkbox" onclick="errorResolve('<?lsp=deviceData.deviceIP?>','<?lsp=errorTime?>','<?lsp=deviceData.ptid?>')">
                            checkbox<?lsp=errorTime?>
                            </td>
                        </tr> 

                    <?lsp
                        errorType, errorTime = cur:fetch()
                    end
                    return true
                end
                        
                local ok,err=su.select(opendb,string.format(sql), execute)
                        ?>
                        </tbody>
                    </table>
                </div>

  </body>

    
  </html>