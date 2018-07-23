<!DOCTYPE html>
<html>
  <head>
     <meta charset="UTF-8"/>
         <link href="https://fonts.googleapis.com/css?family=Noto+Sans:400,700|Roboto:300" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css?family=Roboto+Mono:500&text=0123456789:." rel="stylesheet">
    
    
    <link href="//lichess1.org/assets/stylesheets/common.css?v=2072" type="text/css" rel="stylesheet"/>

    <title>MY LSP</title>
  </head>
  <body>
     <div id="topmenu" class="hover">
  <section>
    <a href="/">Play</a>
    <div>
      <a href="/?any#hook">Create a game</a>
      <a href="/tournament">Tournament</a>
      <a href="/simul">Simultaneous exhibitions</a>
    </div>
  </section>
  <section>
    <a href="/training">Learn</a>
    <div>
      <a href="/learn">Chess basics</a>
      <a href="/training">Puzzles</a>
      <a href="/practice">Practice</a>
      <a href="/training/coordinate">Coordinates</a>
      <a href="/study">Study</a>
      <a href="/coach">Coaches</a>
    </div>
  </section>
  <section>
    <a href="/tv">Watch</a>
    <div>
      <a href="/tv">Lichess TV</a>
      <a href="/games">Current games</a>
      <a href="/streamer">Streamers</a>
      <a href="/broadcast">Broadcasts (beta)</a>
      <a href="/video">Video library</a>
    </div>
  </section>
  <section>
    <a href="/player">Community</a>
    <div>
      <a href="/player">Players</a>
      
      <a href="/team">Teams</a>
      <a href="/forum">Forum</a>
      
      <a href="/qa">Questions &amp; Answers</a>
    </div>
  </section>
  <section>
    <a href="/analysis">Tools</a>
    <div>
      <a href="/analysis">Analysis board</a>
      <a href="/analysis#explorer">Opening explorer &amp; tablebase</a>
      <a href="/editor">Board editor</a>
      <a href="/paste">Import game</a>
      <a href="/games/search">Advanced search</a>
    </div>
  </section>
</div>
<?lsp 
local     sql ="CREATE TABLE UserPermissions(PermissionLevel varchar(255) PRIMARY KEY,"
 .."viewAllDevices        int NOT NULL,"
 .."viewAllUsers          int NOT NULL,"
 .."viewCompanyUsers      int NOT NULL,"
 .."addNewNonCompanyUsers int NOT NULL,"
 .."addCompanyUsers       int NOT NULL,"
 .."addNewCompany         int NOT NULL,"
 .."addNewDevice          int NOT NULL,"
 .."changeDeviceSettings  int NOT NULL,"
 .."CONSTRAINT c2 PRIMARY KEY(PermissionLevel));"
 print(sql)

?>
  </body>
</html>
