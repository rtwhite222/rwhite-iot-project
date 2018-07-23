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
            

            
            
            
            smq.subscribe("BasicChatMsg", {onmsg:onChatMsg, datatype:"text"});
            smq.subscribe("BasicChatMsg2", {onmsg:onChatMsg2, datatype:"text"});
        });
      </script>
  </head>
  <body>
    <table class="BasicChat">
      <tr>
      <td>
        <div id="messages">
          <div><ul></ul></div> <!-- Messages will be injected here -->
        </div>
        </td>
      </tr>
    </table>
  </body>
</html>