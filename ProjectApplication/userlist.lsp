<link href="//maxcdn.bootstrapcdn.com/bootstrap/3.3.0/css/bootstrap.min.css" rel="stylesheet" id="bootstrap-css">
<script src="//maxcdn.bootstrapcdn.com/bootstrap/3.3.0/js/bootstrap.min.js"></script>
<script src="//code.jquery.com/jquery-1.11.1.min.js"></script>
<!------ Include the above in your HEAD tag ---------->

<script src="https://use.fontawesome.com/1e803d693b.js"></script>
<style>form {
    display: inline-block; //Or display: inline; 
}
tr:hover{
    background-color: #ddd;
    color: black;
}
input[type=text] {
    float: right;
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
    $("#new-header").load("repeatfiles/header.html?version=9", function() {
        $('#header-userList').addClass('active');
    });
    </script>
</div>
<div class="container">
<div class="search-container">
    <form action="/action_page.php">
        <input type="text" name="name" placeholder = "Search for user">
        <input type="submit" value = "Search"></button>
    </form>
    <form action="/action_page.php">
        <input type="text" name="name" placeholder = "Search by Company">
        <input type="submit" value = "Search"></button>
    </form>
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
                        local sql = selectQuery({"username","companyname","permissionlevel"},"users");
                            
                        local function opendb() 
                            return su.open"file" 
                        end
                            
                        local function exec(cur)
                            local user,company,permissions = cur:fetch()
                            while user do
                                ?>
                            <tr class='clickable-row' data-href='usersettings.lsp?name='<?lsp=user?>>
                                <td width='10' align='center'>
                                    <i class='fa fa-2x fa-user fw'></i>
                                </td>
                                <td>
                                    <?lsp=user?> <br><i class='fa fa-envelope'></i>
                                </td>
                                <td>
                                    <?lsp=permissions?> 
                                </td>
                                <td align='center'>
                                    Last Login:  6/14/2017<br><small class='text-muted'>2 days ago</small>
                                </td>
                            </tr> 
                                <?lsp
                               user,company,permissions = cur:fetch()
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