<html>
  <head>
    <title>SMQ Basic Chat Demo</title>
    <link rel="stylesheet" type="text/css" href="style.css"/> 
      <script src="/rtl/jquery.js"></script>
      <script src="/rtl/smq.js"></script>
      <script>
          
        $(function() {
        // SMQ function
        
            var smq = SMQ.Client(SMQ.wsURL("/smq.lsp"));
            //smq client
            
            function onChatMsg(msg,ftid) {
                $('#messages ul').append("<li>"+msg+"</li>");
            };
            function onChatMsg2(msg2,ftid) {
                $('#messages ').append("<li>"+msg2+"</li>");
            };
            
            
            function sendChatMsg2() {
                smq.publish($('#msg2').val(), "BasicChatMsg2"); //publishes msg (user input form)
                $('#msg2').val(""); // sets input value to 'empty'
                $('#msg2').focus(); //focuses on text box
                return false;
                
            };
            function sendChatMsg() {
                //smq.publish($('#msg').val(), "BasicChatMsg"); //publishes msg (user input form)
                $('#msg').val(), "BasicChatMsg");
                $('#msg').val("");
                $('#msg').focus();
                return false;
                }
            
            
            
            smq.subscribe("BasicChatMsg", {onmsg:onChatMsg, datatype:"text"});
            smq.subscribe("BasicChatMsg2", {onmsg:onChatMsg2, datatype:"text"});
            $('form').submit(sendChatMsg2);
            $('form').submit(sendChatMsg);
            $('#msg').focus();
        });
      </script>
  </head>
  <body>
    <table class="BasicChat">
      <tr>
      <td>
        <div id="messages">
          <div><ul></ul></div> <!-- Messages will be injected here -->
          Inputs
          <form>
            <input id="msg" />
          </form>
          <form>
            <input id="msg2" />
          </form>
        </div>
        </td>
      </tr>
    </table>
  </body>
</html>