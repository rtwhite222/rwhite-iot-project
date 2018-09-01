<!DOCTYPE html>
<html>
<head> 
<script type="text/javascript" src="https://canvasjs.com/assets/script/jquery-1.11.1.min.js"></script>
<script type="text/javascript" src="https://canvasjs.com/assets/script/canvasjs.min.js"></script> 
<script type="text/javascript">
window.onload = function () {
	var chart = new CanvasJS.Chart("chartContainer", { 
		title: {
			text: "Adding & Updating dataPoints"
		},
		data: [
		{
			type: "spline",
			dataPoints: [
			]
		}
		]
	});
	chart.render();	

	$("#addDataPoint").click(function () {

	var length = chart.options.data[0].dataPoints.length;
	chart.options.title.text = "New DataPoint Added at the end";
	chart.options.data[0].dataPoints.push({ y: 25 - Math.random() * 10});
	chart.render();

	});

	$("#updateDataPoint").click(function () {

	var length = chart.options.data[0].dataPoints.length;
	chart.options.title.text = "Last DataPoint Updated";
	chart.options.data[0].dataPoints[length-1].y = 15 - Math.random() * 10;
	chart.render();

	});
}



</script>
</head>  
<body>  
<div id="chartContainer" style="width:100%; height:280px"></div>  
<button id="addDataPoint">Add Data Point</button>  
<button id="updateDataPoint">Update Data Point</button>  
</body>
</html>