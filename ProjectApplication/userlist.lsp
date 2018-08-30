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

.search-container select {
    float: left;
    border: none;
    margin-top: 8px;
    margin-right: 16px;
    font-size: 17px;
}

.search-container {
  float: right;
}

.search-container input[type=submit] {
  float: right;
  margin-top: 8px;
  margin-right: 16px;
  background: #ddd;
  font-size: 17px;
  border: none;
  cursor: pointer;
}

body {
    background: linear-gradient(to right, rgba(128,128,128,.8), rgba(128,128,128,.3));
}

</style>



 <div id="new-header">
    <script>
    $("#new-header").load("header.lsp", function() {
        $('#header-userList').addClass('active');
    });
    </script>
</div>

<div class="container">
<div class="search-container">
    <?lsp 
    usersession = request:session()
    trace(request:method())
    if not usersession then response:forward"login.lsp" end
        function checkLogin()
            if not usersession.loggedin then
                print "not logged in"
                request:session(false)
                response:forward"login.lsp"
            end
        end
checkLogin()
    if tonumber(usersession.viewAllUsers) == 1 then ?>

    <form method = "post">
        <select name="companyName" >  <option value=""></option>
<?lsp 
        local su=require"sqlutil"
        local sql=string.format("companyName FROM company")
        
        local function execute(cur)
            local company = cur:fetch()
            while company do
               response:write("<option value='"..company.."'>"..company.."</option>")
               company = cur:fetch()
            end
            return true
        end
        
        local function opendb() 
            return su.open"file" 
        end
        
        local ok,err=su.select(opendb,string.format(sql), execute)
        
        
        ?>
        <input type="submit" value = "Search by Company"></button>
    </form>
    <?lsp end ?>
    </div>
	<div class="row">
        <div class="panel panel-default user_panel">
            <div class="panel-heading">
                <h3 class="panel-title">User List</h3>
            </div>
            <div class="panel-body">
				<div class="table-container">
                    <table class="table-users table" border="0">
                        <tbody>
                        <?lsp 
                        
                        local su=require"sqlutil"
                        local sql
                        
                        
                        if (tonumber(usersession.viewAllUsers) == 1) then
                            sql = selectQuery({"username","companyname","Email","permissionlevel"},"users")
                        trace(sql)
                            if request:method() == "POST" and request:data().companyName ~= "" then
                                sql = selectQueryWhere({"username","companyname","Email","permissionlevel"},"users","CompanyName", request:data().companyName)
                            trace(sql)
                            end
                        else 
                            sql = selectQueryWhere({"username","companyname","Email","permissionlevel"},"users","CompanyName", usersession.company)
                        end
                        
                        
                        
                        local function opendb() 
                            return su.open"file" 
                        end
                            
                        local function exec(cur)
                            local user,company,Email,permissions = cur:fetch()
                            while Email do
                                ?>
                            <tr class='clickable-row' data-href='usersettings.lsp?from=list&userSelect=<?lsp=Email?>'>
                                <td width='10' align='center'>
                                    <i class='fa fa-2x fa-user fw'></i>
                                </td>
                                <td>
                                    <?lsp=user?> <br><!--<i class='fa fa-envelope'></i>-->
                                </td>
                                <td>
                                    <?lsp=permissions?> 
                                </td>
                                <td align='center'>
                                    Company<br><small class='text-muted'><?lsp=company ?></small>
                                </td>
                            </tr> 
                                <?lsp
                               user,company,Email,permissions = cur:fetch()
                            end
                            return true
                        end
                        
                        local ok,err=su.select(opendb,string.format(sql), exec)
                        ?>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>

	</div>
</div>
<script>
jQuery(document).ready(function($) {
    $(".clickable-row").click(function() {
        window.location = $(this).data("href");
    });
});</script>