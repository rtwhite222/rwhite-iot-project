<!DOCTYPE HTML>
<html>
<head>  
  <script type="text/javascript">
      
      
      <?lsp
      deviceData=request:data()
       local su=require("sqlutil")
        local sql = selectQueryWhereMult({"readings"},"devicereadings",{"deviceIP","readingstarttime"},{deviceData.deviceIP,deviceData.timeofrun})
          trace(sql)
        local graphinput={}
        local function execute(cur)
            local count = 0
            readingValue = cur:fetch()
            while readingValue do
                count = count + 1
                table.insert(graphinput, readingValue)
                readingValue = cur:fetch()
            end
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
  function renderchart() {
    var chart = new CanvasJS.Chart("chartContainer",
    {      
      title:{
        text: "Device readings"
      },
      axisY :{
        title: "Torque ( N \u22C5 m )",
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
      
    <div id="chartContainer" style="height: 300px; width: 100%;">
        <script>renderchart()</script>
    </div>
  </body>
  </html>
