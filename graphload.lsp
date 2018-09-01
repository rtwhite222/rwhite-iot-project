<!DOCTYPE HTML>
<html>
<head>  
  <script type="text/javascript">
      
      
      <?lsp
      local t = { 1352 ,1514 ,1321 ,1163 ,1950 ,1201 ,1186 ,1281 ,1438 ,1305 ,1480 ,1991       }
      local v=ba.json.encode(t);
      local t12 = { 1652 ,1614 ,1621 ,1663 ,1650 ,1601 ,1686 ,1681 ,1638 ,1605 ,-60 ,6}   
      
      local v2 = ba.json.encode(t12);
      t2 = ba.json.decode(v);
      t22 = ba.json.decode(v2);
      local graphinput = 0;
      trace(request:data().graphinfo)
      if request:data().graphinfo=="2" then graphinput = t else graphinput = t22 end
      ?>
  function renderchart() {
    var chart = new CanvasJS.Chart("chartContainer",
    {      
      title:{
        text: "Device readings"
      },
      axisY :{
        title: "Torque ( N &#183; m)",
        includeZero: false
       
      },
      axisX: { 
      title: "Time (s)",
        interval: 1,includeZero: false
      },
      data: [
      {        
        type: "spline",  
        indexLabelFontColor: "orangered",      
        dataPoints: [
        <?lsp for value, graphinput in ipairs(graphinput) do ?>
        <?lsp trace(t2) ?>
        { x: <?lsp=value?>, y: <?lsp=graphinput?> },
        <?lsp end ?>
        ]
      }
      ]
    });

    chart.render();
  }
  //window.onload = renderchart;
  </script>
  <script type="text/javascript" src="https://canvasjs.com/assets/script/canvasjs.min.js"></script></head>
  <body>
      <div><input type = </div>
    <div id="chartContainer" style="height: 300px; width: 100%;">
        <script>renderchart()</script>
    </div>
  </body>
  </html>
