<?lsp
local smq = require("smqbroker").create()

local function smqEntry(_ENV)
   trace("New SMQ client")
   smq.connect(request)
end
local smqDir = ba.create.dir("My-SMQ-Broker")
smqDir:setfunc(smqEntry)
smqDir:insert()
print("Installing broker entry at:",smqDir:baseuri())

if app.mySmqBrokerDir then
   print"Removing old broker"
   app.mySmqBrokerDir:unlink()
end
app.mySmqBrokerDir = smqDir

-- Lua code acting as SMQ client below

local function send5Messages(notUsed,ptid,number)
   trace"Sending 5 messages"
   local function timeout()
      for count = 1,5 do
         local msg  = string.format("hello %d",count)
         trace('',msg)
         smq.publish(msg, ptid)
         coroutine.yield(true)
      end
      trace("Done")
   end
   ba.timer(timeout):set(1000,true,true)
end


smq.subscribe("hello",
              {onmsg=send5Messages})
?>

<html>
  <head>
    <script src="/rtl/jquery.js"></script>
    <script src="/rtl/smq.js"></script>
    <script>
$(function() {
    function print(txt) {
        $("#console").append(txt+"\n");
    };
    var smq = SMQ.Client(SMQ.wsURL("/My-SMQ-Broker/"));
    function serverMessage(msg) {
        print('Server: ' + msg);
    };
    smq.subscribe("self", {onmsg:serverMessage, datatype:"text"});
    smq.subscribe("hello", {onmsg:serverMessage, datatype:"text"});
    smq.publish("","hello");
});
    </script>
  </head>
  <body>
  <p><b>Console Window:</b></p>
  <pre id="console"></pre>
  </body>
  <body>
    <table class="BasicChat">
      <tr>
      <td>
        <div id="messages">
          <div><ul></ul></div> <!-- Messages will be injected here -->
          <form>
            <input id="hello" />
          </form>
        </div>
        </td>
      </tr>
    </table>
  </body>
</html>


