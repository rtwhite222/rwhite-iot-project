<?lsp require "socket.mail" -- Load mail lib
 
local mail=socket.mail{
   shark=ba.create.sharkssl(), -- Use TLS
   server="smtp.gmail.com",
   user="projectservertestemail@gmail.com",
   password="X3hLkB0063",
}
 
-- Send one email
local ok,err=mail:send{
   subject="Auto response message",
   from='Project Application Server <projectservertestemail1@gmail.com>',
   to='Richard <rtwhite222@gmail.com>',
   body=[[
     This is a test message to make sure that the email send feature is working
   ]]
}
if not ok then
    print("Not able to be sent ",err)
end