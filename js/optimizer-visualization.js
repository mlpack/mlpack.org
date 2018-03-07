/**
 * @file optimizer-visualization.js
 * @author Marcus Edel
 */

function httpGetAsync(theUrl, callback)
{
  if (xmlHttp!=null) xmlHttp.abort()

  xmlHttp = new XMLHttpRequest();
  xmlHttp.onreadystatechange = function()
  {
    if (xmlHttp.readyState == 4 && xmlHttp.status == 200)
      callback(xmlHttp.responseText);
  }
  xmlHttp.open("GET", theUrl, true);
  xmlHttp.send(null);
}

function getFunctionOptions()
{
  var options = {
    width:  '500px',
    height: '500px',
    style: 'surface',
    showPerspective: true,
    showGrid: true,
    showShadow: false,
    keepAspectRatio: true,
    showXAxis: true,
    showYAxis: true,
    showZAxis: true,
    xMin: -10,
    xMax: 10,
    yMin: -10,
    yMax: 10,
    zMax: 2500,
    zMin: 0,
  };

  return options;
}

function getOptimizerOptions()
{
  var options = {
    width:  '500px',
    height: '500px',
    style: 'dot-color',
    showPerspective: true,
    showGrid: false,
    showShadow: false,
    keepAspectRatio: true,
    showLegend: false,
    showXAxis: false,
    showYAxis: false,
    showZAxis: false,
    xMin: -10,
    xMax: 10,
    yMin: -10,
    yMax: 10,
    zMax: 2500,
    zMin: 0,
    dotSizeRatio: 0.005,
    dataColor:
    {
      fill: '#FF00FF',
      stroke: '#FF00FF',
      strokeWidth: 4,
    },
  };

  return options;
}

function getFunction()
{
  var options = getFunctionOptions();
  var ret = null;

  if (functionID == 0)
  {
    ret = BoothFunction();
  }
  else if (functionID == 1)
  {
    ret = BukinFunction();
  }
  else if (functionID == 2)
  {
    ret = DropWaveFunction();
  }
  else if (functionID == 3)
  {
    ret = SphereFunction();
  }
  else if (functionID == 4)
  {
    ret = RastriginFunction();
  }
  else if (functionID == 5)
  {
    ret = McCormickFunction();
  }
  else if (functionID == 6)
  {
    ret = EasomFunction();
  }
  else if (functionID == 7)
  {
    ret = StyblinskiTangFunction();
  }
  else if (functionID == 8)
  {
    ret = EggholderFunction();
  }

  options.xMin = ret.xMin;
  options.yMin = ret.yMin;
  options.xMax = ret.xMax;
  options.yMax = ret.yMax;
  options.zMin = ret.zMin;
  options.zMax = ret.zMax;

 return {data: ret.data, options: options};
}

var xmlHttp = null;
var functionGraph = null;
var optimizerGraph = null;
var costGraph = null;
var functionID = 0;
var intervalID = null;
var lines = null;
var optimizerData = null;
var stepSize = 0.01;
var iterations = 4000;
var functionOptions = null;
var optimizerOptions = null;
var ic = 0;
var cc = 0;
var valueZ = 0;
var done = true;
var currentData = null;
var combine = true;
var evaluations = null;
var initPos = {horizontal: -3.8, vertical: 0.56, distance: 1.7};

var optimizerParameter0 = 0.9;
var optimizerParameter1 = 0.999;
var optimizerParameter2 = 0;
var optimizerParameter3 = 0;
var optimizerStyle = "line";
var optimizerName = "Adam";
var optimizerID = 0;

var colors = ['#00dc6e', '#0098c3', '#5f7c2a', '#8ebcbd', '#ffd328',
             '#ffcaca', '#620000', '#61bfbe', '#fffae3', '#fae4d9',
             '#ffb5ba', '#baddd6', '#8af3e7', '#dfadd4', '#800800',
             '#ceff05', '#016531', '#36c7ff', '#bf74ff', '#9c9c9c',
             '#ff78f9', '#663e90', '#ff0066', '#ff663f', '#ffeb00'];

var costGraphLength = [];
(costGraphLength = []).length = 40;
costGraphLength.fill(0);

function drawFunction()
{
  var functionInfo = getFunction();
  functionOptions = functionInfo.options;
  var data = functionInfo.data;

  // Update the optimizer options.
  optimizerOptions = getOptimizerOptions();
  optimizerOptions.xMin = functionOptions.xMin;
  optimizerOptions.yMin = functionOptions.yMin;
  optimizerOptions.xMax = functionOptions.xMax;
  optimizerOptions.yMax = functionOptions.yMax;
  optimizerOptions.zMin = functionOptions.zMin;
  optimizerOptions.zMax = functionOptions.zMax;

  // Instantiate our function graph object.
  var container = document.getElementById('function');
  functionGraph = new vis.Graph3d(container, data, functionOptions);
  functionGraph.setCameraPosition(initPos);

  drawOptimizerAnimation();
}

function onCameraPositionChange(event)
{
  var pos = {
    horizontal: event.horizontal,
    vertical: event.vertical,
    distance: event.distance
  };

  functionGraph.setCameraPosition(pos);
}

function optimizerSettings(obj)
{
  if (obj.id == "parameterASlider")
  {
    optimizerParameter0 = parseFloat(obj.value).toFixed(4);
    document.getElementById("parameterAValue").innerHTML = optimizerParameter0;
  }
  else if (obj.id == "parameterBSlider")
  {
    optimizerParameter1 = parseFloat(obj.value).toFixed(4);
    document.getElementById("parameterBValue").innerHTML = optimizerParameter1;
  }
  else if (obj.id == "parameterCSlider")
  {
    optimizerParameter2 = parseFloat(obj.value).toFixed(4);
    document.getElementById("parameterCValue").innerHTML = optimizerParameter2;
  }
  else if (obj.id == "parameterDSlider")
  {
    optimizerParameter3 = parseFloat(obj.value).toFixed(4);
    document.getElementById("parameterDValue").innerHTML = optimizerParameter3;
  }

  drawOptimizerAnimation();
}

function stepsizeSliderChanged(value)
{
  stepSize = value;
  document.getElementById("stepsizeValue").innerHTML = stepSize;
  drawOptimizerAnimation();
}

function evaluationsSliderChanged(value)
{
  evaluations = value;
  document.getElementById("evaluationValue").innerHTML = evaluations;
  document.getElementById("restrict").checked = true;

  addCostGraph(currentData);
}

function restricttSettings(obj)
{
  if (obj.checked)
  {
    evaluations = 4000;
    document.getElementById("evaluationValue").innerHTML = 4000;
  }
  else
  {
    evaluations = null;
    document.getElementById("evaluationValue").innerHTML = "Dynamic";
  }

  addCostGraph(currentData);
}

function combineSettings(obj)
{
  combine = obj.checked;
  addCostGraph(currentData);
}

function iterationsSliderChanged(value)
{
  iterations = value;
  document.getElementById("iterationsValue").innerHTML = iterations;
  drawOptimizerAnimation();
}

function clearOptimizer()
{
  if (intervalID != null)
  {
    clearInterval(intervalID);
    intervalID = null;
  }
}

function clearCostGraph()
{
  costGraph.data.datasets = [];

  (costGraphLength = []).length = 40;
  costGraphLength.fill(0);
}

function addCostGraph(data)
{
  var dataset = {
    label: "",
    fill: false,
    backgroundColor: '',
    borderColor: '',
    borderWidth: 1,
    data: [],
    lineTension: 0,
    hiddenLegend: true,
  };

  dataset.label = optimizerName;
  dataset.backgroundColor = colors[optimizerID];
  dataset.borderColor = colors[optimizerID];

  for(var i = 0; i < lines.length - 1; i++)
  {
    var d = lines[i].split(' ');
    dataset.data.push(parseFloat(d[3]))
  }

  costGraphLength[optimizerID] = lines.length;

  var costLength = Math.max.apply(null, costGraphLength);
  if (evaluations != null)
  {
    costLength = evaluations;
  }

  if (combine)
  {
    costGraph.options.legend.display = true;
  }
  else
  {
    costGraph.options.legend.display = false;
  }

  costGraph.data.labels = [];
  for(var i = 0; i < costLength; i++)
    costGraph.data.labels.push(i);

  if (combine)
  {
    for(var i = 0; i < costGraph.data.datasets.length; i++)
    {
      if (costGraph.data.datasets[i].label == optimizerName)
      {
        costGraph.data.datasets.splice(i, 1);
        i--;
      }
    }
  }

  costGraph.data.datasets.push(dataset);
  costGraph.update();
}

function initData(data)
{
  while(!done) { }

  currentData = data;

  ic = 0;
  done = true;

  optimizerData = new vis.DataSet();

  if (currentData.indexOf("WARN") !== -1)
  {
    if (functionID == 1)
    {
      optimizerData.add({id:0, x:-10, y:0, z:0, style:"#FF00FF"})
    }
    else
    {
      optimizerData.add({id:0, x:0, y:0, z:0, style:"#FF00FF"})
    }

    optimizerOptions.style = "line"
    optimizerGraph = new vis.Graph3d(
        document.getElementById('optimizer'), optimizerData,
        optimizerOptions);
    optimizerGraph.on('cameraPositionChange', onCameraPositionChange);

    optimizerGraph.setCameraPosition(initPos);
    functionGraph.setCameraPosition(initPos);
    return;
  }

  optimizerOptions.style = optimizerStyle;
  lines = data.split('\n');
  lines.shift();

  addCostGraph(data);

  var d = lines[0].split(' ');
  optimizerData.add({id:parseInt(d[0]), x:parseFloat(d[1]),
      y:parseFloat(d[2]), z:parseFloat(d[3]), style:"#FF00FF"})

  optimizerGraph = new vis.Graph3d(
      document.getElementById('optimizer'), optimizerData,
      optimizerOptions);
  optimizerGraph.on('cameraPositionChange', onCameraPositionChange);

  optimizerGraph.setCameraPosition(initPos);
  functionGraph.setCameraPosition(initPos);

  intervalID = setInterval(optimizerAnimation, 200);
}

function drawOptimizer()
{
  optimizerData = new vis.DataSet();
  for(var i = 0; i < lines.length - 1; i++)
  {
    var d = lines[i].split(' ');
    var x=parseFloat(d[1]);
    var y=parseFloat(d[2]);
    var z=parseFloat(d[3]);

    if (x >= optimizerOptions.xMin && x <= optimizerOptions.xMax &&
        y >= optimizerOptions.yMin && y <= optimizerOptions.yMax &&
        z >= optimizerOptions.zMin && z <= optimizerOptions.zMax)
    {
      optimizerData.add({x:x, y:y, z:z, style:"#FF00FF"})
    }
  }

  if (optimizerData.length > 0)
    optimizerGraph.setData(optimizerData);
}

function optimizerAnimation()
{
  var currentFunction = functionID;
  if (done == false)
     return;

  done = false;

  var offset = 20;
  var end = ic + 60;

  if (lines.length < 2000)
  {
    offset = 1;
    end = ic + 2;
  }

  if (end > lines.length - 1)
     end = lines.length - 1;

  for(; ic < end; )
  {
    var d = lines[ic].split(' ');

    if (Math.abs(valueZ) - Math.abs(parseFloat(d[3])) < 3)
    {
      valueZ = parseFloat(d[3]);
      ic++;
     continue;
    }

    if (currentFunction == functionID)
    {
      try
      {
        var x=parseFloat(d[1]);
        var y=parseFloat(d[2]);
        var z=parseFloat(d[3]);

        if (x >= optimizerOptions.xMin && x <= optimizerOptions.xMax &&
            y >= optimizerOptions.yMin && y <= optimizerOptions.yMax &&
            z >= optimizerOptions.zMin && z <= optimizerOptions.zMax)
        {
          optimizerData.add({id:parseInt(d[0])+1, x:x,y:y,z:z,style:"#FF00FF"})
        }
      }
      catch(err)
      {
        done = true;
        return;
      }
    }
    else
    {
      done = true;
      return;
    }

    cc++;
    ic += offset;
  }

  optimizerGraph.setData(optimizerData);

  if (ic >= lines.length - 1)
  {
    clearInterval(intervalID);
    drawOptimizer();
  }

  done = true;
}

function drawOptimizerAnimation()
{
  if (xmlHttp != null)
    xmlHttp.abort();

  if (optimizerGraph != null)
    clearOptimizer();
  var mainURI = "http://mlpack.org";
  if (window.location.href.indexOf("www.mlpack") != -1)
  mainURI = "http://www.mlpack.org"

  var optimizerURI = mainURI + "/cgi-bin/a.cgi?" +
      "optimizer=" + optimizerName.toLowerCase() +
      "&function=" + functionID +
      "&iterations=" + iterations +
      "&stepSize=" + stepSize +
      "&paramA=" + optimizerParameter0 +
      "&paramB=" + optimizerParameter1 +
      "&paramC=" + optimizerParameter2 +
      "&paramD=" + optimizerParameter3;
  httpGetAsync(optimizerURI, initData)
}

function functionSelection(obj)
{
  clearCostGraph();

  var functionElements = document.getElementById("functionWrapper").children;
  for(var i = 0; i < functionElements.length; i++)
  {
    functionElements[i].childNodes[0].style.border = "3px solid #333333";
  }

  obj.style.border = "3px solid #CC9900";
  functionID = parseInt(obj.id.substring(1));

  drawFunction();
}

function optimizerSelection(obj)
{
  optimizerNames =
      ["Adam", "RmsProp", "AdaDelta", "AdaGrad", "CNE", "SMORMS", "IQN",
      "CMAES", "AdaMax", "AMSGrad", "Nadam", "SGD", "SGDMomentum",
      "LBFGS", "GradientDescent", "SimulatedAnnealing", "SPALeRASGD",
      "SVRG", "SVRGBB", "Katyusha", "KatyushaProximal", "SARAH",
      "SARAHPlus"];

  optimizerID = obj.value - 1;
  optimizerName = optimizerNames[optimizerID];

  document.getElementById("stepsizeSlider").min = 0;
  document.getElementById("stepsizeSlider").max = 1;
  document.getElementById("stepsizeSlider").step = 0.001;

  document.getElementById("parameterASlider").min = 0;
  document.getElementById("parameterASlider").max = 1;
  document.getElementById("parameterASlider").step = 0.001;

  document.getElementById("parameterBSlider").min = 0;
  document.getElementById("parameterBSlider").max = 1;
  document.getElementById("parameterBSlider").step = 0.01;

  document.getElementById("parameterCSlider").min = 0;
  document.getElementById("parameterCSlider").max = 1;
  document.getElementById("parameterCSlider").step = 0.01;

  document.getElementById("parameterDSlider").min = 0;
  document.getElementById("parameterDSlider").max = 1;
  document.getElementById("parameterDSlider").step = 0.01;

  iterations = 4000;
  stepSize = 0.001;
  optimizerStyle = "line";

  if (optimizerName.toLowerCase() == "adam" ||
      optimizerName.toLowerCase() == "adamax" ||
      optimizerName.toLowerCase() == "amsgrad" ||
      optimizerName.toLowerCase() == "nadam")
  {
    $(".parameterContainerA").show();
    $(".parameterContainerB").show();
    $(".parameterContainerC").hide();
    $(".parameterContainerD").hide();

    document.getElementById("parameterADesc").innerHTML = "First moment coefficient: ";
    document.getElementById("parameterBDesc").innerHTML = "Second moment coefficient: ";
    document.getElementById("stepSizeDesc").innerHTML = "Step-size: ";

    stepSize = 0.01;
    optimizerParameter0 = 0.9;
    optimizerParameter1 = 0.999;
  }
  else if (optimizerName.toLowerCase() == "rmsprop")
  {
    $(".parameterContainerA").show();
    $(".parameterContainerB").hide();
    $(".parameterContainerC").hide();
    $(".parameterContainerD").hide();

    document.getElementById("parameterADesc").innerHTML = "Smoothing constant: ";
    document.getElementById("stepSizeDesc").innerHTML = "Step-size: ";

    stepSize = 0.01;
    optimizerParameter0 = 0.99;
  }
  else if (optimizerName.toLowerCase() == "adadelta")
  {
    $(".parameterContainerA").show();
    $(".parameterContainerB").hide();
    $(".parameterContainerC").hide();
    $(".parameterContainerD").hide();

    document.getElementById("parameterADesc").innerHTML = "Smoothing constant: ";
    document.getElementById("stepSizeDesc").innerHTML = "Step-size: ";

    stepSize = 1.0;
    optimizerParameter0 = 0.99;
  }
  else if (optimizerName.toLowerCase() == "adagrad")
  {
    $(".parameterContainerA").hide();
    $(".parameterContainerB").hide();
    $(".parameterContainerC").hide();
    $(".parameterContainerD").hide();

    document.getElementById("stepSizeDesc").innerHTML = "Step-size: ";

    stepSize = 0.1;
  }
  else if (optimizerName.toLowerCase() == "cne")
  {
    $(".parameterContainerA").show();
    $(".parameterContainerB").show();
    $(".parameterContainerC").show();
    $(".parameterContainerD").hide();

    document.getElementById("parameterASlider").min = 10;
    document.getElementById("parameterASlider").max = 1000;
    document.getElementById("parameterASlider").step = 1;
    document.getElementById("parameterASlider").value = 500;

    document.getElementById("parameterADesc").innerHTML = "Population-Size: ";
    document.getElementById("parameterBDesc").innerHTML = "Mutation-Size: ";
    document.getElementById("stepSizeDesc").innerHTML = "Mutation-Probability: ";
    document.getElementById("parameterCDesc").innerHTML = "Select-percentage: ";

    stepSize = 0.1;
    optimizerParameter0 = 500;
    optimizerParameter1 = 0.02;
    optimizerParameter2 = 0.2;
    optimizerStyle = "dot-color";
  }
  else if (optimizerName.toLowerCase() == "smorms")
  {
    $(".parameterContainerA").hide();
    $(".parameterContainerB").hide();
    $(".parameterContainerC").hide();
    $(".parameterContainerD").hide();

    document.getElementById("stepSizeDesc").innerHTML = "Step-size: ";

    stepSize = 0.01;
  }
  else if (optimizerName.toLowerCase() == "iqn")
  {
    $(".parameterContainerA").hide();
    $(".parameterContainerB").hide();
    $(".parameterContainerC").hide();
    $(".parameterContainerD").hide();

    document.getElementById("stepSizeDesc").innerHTML = "Step-size: ";

    stepSize = 0.01;
  }
  else if (optimizerName.toLowerCase() == "cmaes")
  {
    $(".parameterContainerA").show();
    $(".parameterContainerB").show();
    $(".parameterContainerC").hide();
    $(".parameterContainerD").hide();

    document.getElementById("stepsizeSlider").min = 0;
    document.getElementById("stepsizeSlider").max = 2000;
    document.getElementById("stepsizeSlider").step = 1;

    document.getElementById("stepSizeDesc").innerHTML = "Population-size (0 Default): ";

    document.getElementById("parameterADesc").innerHTML = "Lower-bound: ";
    document.getElementById("parameterBDesc").innerHTML = "Upper-bound: ";

    optimizerParameter0 = -1;
    optimizerParameter1 = 1;
    stepSize = 0;
    optimizerStyle = "dot-color";

    document.getElementById("parameterASlider").min = -10;
    document.getElementById("parameterASlider").max = 10;
    document.getElementById("parameterASlider").step = 1;

    document.getElementById("parameterBSlider").min = -10;
    document.getElementById("parameterBSlider").max = 10;
    document.getElementById("parameterBSlider").step = 1;
  }
  else if (optimizerName.toLowerCase() == "sgd" ||
           optimizerName.toLowerCase() == "spalerasgd")
  {
    $(".parameterContainerA").hide();
    $(".parameterContainerB").hide();
    $(".parameterContainerC").hide();
    $(".parameterContainerD").hide();

    document.getElementById("stepSizeDesc").innerHTML = "Step-size: ";

    stepSize = 0.01;
  }
  else if (optimizerName.toLowerCase() == "sgdmomentum")
  {
    $(".parameterContainerA").show();
    $(".parameterContainerB").hide();
    $(".parameterContainerC").hide();
    $(".parameterContainerD").hide();

    document.getElementById("stepSizeDesc").innerHTML = "Step-size: ";
    document.getElementById("parameterADesc").innerHTML = "Momentum: ";

    stepSize = 0.01;
    optimizerParameter0 = 0.5;
  }
  else if (optimizerName.toLowerCase() == "lbfgs")
  {
    $(".parameterContainerA").show();
    $(".parameterContainerB").show();
    $(".parameterContainerC").hide();
    $(".parameterContainerD").hide();

    document.getElementById("stepSizeDesc").innerHTML = "Memory-points: ";
    document.getElementById("parameterADesc").innerHTML = "Armijo-Constant: ";
    document.getElementById("parameterBDesc").innerHTML = "Wolfe-Constant: ";

    document.getElementById("stepsizeSlider").min = 1;
    document.getElementById("stepsizeSlider").max = 50;
    document.getElementById("stepsizeSlider").step = 1;

    stepSize = 10;
    optimizerParameter0 = 0.0001;
    optimizerParameter1 = 0.9;
  }
  else if (optimizerName.toLowerCase() == "gradientdescent")
  {
    $(".parameterContainerA").hide();
    $(".parameterContainerB").hide();
    $(".parameterContainerC").hide();
    $(".parameterContainerD").hide();

    document.getElementById("stepSizeDesc").innerHTML = "Step-size: ";

    stepSize = 0.01;
  }
  else if (optimizerName.toLowerCase() == "simulatedannealing")
  {
    $(".parameterContainerA").show();
    $(".parameterContainerB").show();
    $(".parameterContainerC").show();
    $(".parameterContainerD").show();

    document.getElementById("stepSizeDesc").innerHTML = "Initial-temperature: ";
    document.getElementById("parameterADesc").innerHTML = "Initial-iterations: ";
    document.getElementById("parameterBDesc").innerHTML = "Sweeps-feedback: ";
    document.getElementById("parameterCDesc").innerHTML = "Maximum-move-size: ";
    document.getElementById("parameterDDesc").innerHTML = "Initial-move-size: ";

    document.getElementById("stepsizeSlider").min = 1;
    document.getElementById("stepsizeSlider").max = 50000;
    document.getElementById("stepsizeSlider").step = 1;

    document.getElementById("parameterASlider").min = 1;
    document.getElementById("parameterASlider").max = 10000;
    document.getElementById("parameterASlider").step = 1;

    document.getElementById("parameterBSlider").min = 1;
    document.getElementById("parameterBSlider").max = 1000;
    document.getElementById("parameterBSlider").step = 0.1;

    document.getElementById("parameterCSlider").min = 1;
    document.getElementById("parameterCSlider").max = 1000;
    document.getElementById("parameterCSlider").step = 0.1;

    document.getElementById("parameterDSlider").min = 0;
    document.getElementById("parameterDSlider").max = 1;
    document.getElementById("parameterDSlider").step = 0.05;

    stepSize = 10000;
    optimizerParameter0 = 1000;
    optimizerParameter1 = 100;
    optimizerParameter2 = 1.5;
    optimizerParameter3 = 0.3;
    optimizerStyle = "dot-color";
  }
  else if (optimizerName.toLowerCase() == "katyusha")
  {
    $(".parameterContainerA").show();
    $(".parameterContainerB").show();
    $(".parameterContainerC").hide();
    $(".parameterContainerD").hide();

    document.getElementById("stepSizeDesc").innerHTML = "Convexity: ";
    document.getElementById("parameterADesc").innerHTML = "Lipschitz constant: ";
    document.getElementById("parameterBDesc").innerHTML = "Inner-iterations:";

    document.getElementById("parameterASlider").min = 0;
    document.getElementById("parameterASlider").max = 100;
    document.getElementById("parameterASlider").step = 1;

    document.getElementById("parameterBSlider").min = 0;
    document.getElementById("parameterBSlider").max = 1000;
    document.getElementById("parameterBSlider").step = 1;

    stepSize = 1.0;
    optimizerParameter0 = 10;
    optimizerParameter1 = 0;
  }
  else if (optimizerName.toLowerCase() == "katyushaproximal")
  {
    $(".parameterContainerA").show();
    $(".parameterContainerB").show();
    $(".parameterContainerC").hide();
    $(".parameterContainerD").hide();

    document.getElementById("stepSizeDesc").innerHTML = "Convexity: ";
    document.getElementById("parameterADesc").innerHTML = "Lipschitz constant: ";
    document.getElementById("parameterBDesc").innerHTML = "Inner-iterations: ";

    document.getElementById("parameterASlider").min = 0;
    document.getElementById("parameterASlider").max = 100;
    document.getElementById("parameterASlider").step = 1;

    document.getElementById("parameterBSlider").min = 0;
    document.getElementById("parameterBSlider").max = 100;
    document.getElementById("parameterBSlider").step = 1;

    stepSize = 1.0;
    optimizerParameter0 = 10;
    optimizerParameter1 = 0;
  }
  else if (optimizerName.toLowerCase() == "svrg" ||
           optimizerName.toLowerCase() == "sarah" ||
           optimizerName.toLowerCase() == "sarahplus")
  {
    $(".parameterContainerA").show();
    $(".parameterContainerB").hide();
    $(".parameterContainerC").hide();
    $(".parameterContainerD").hide();

    document.getElementById("parameterADesc").innerHTML = "Inner-iterations: ";

    document.getElementById("parameterASlider").min = 0;
    document.getElementById("parameterASlider").max = 100;
    document.getElementById("parameterASlider").step = 1;

    stepSize = 0.01;
    optimizerParameter0 = 0;
  }
  else if (optimizerName.toLowerCase() == "svrgbb")
  {
    $(".parameterContainerA").show();
    $(".parameterContainerB").show();
    $(".parameterContainerC").hide();
    $(".parameterContainerD").hide();

    document.getElementById("parameterADesc").innerHTML = "Inner-iterations: ";
    document.getElementById("parameterBDesc").innerHTML = "Decay: ";

    document.getElementById("parameterASlider").min = 0;
    document.getElementById("parameterASlider").max = 1;
    document.getElementById("parameterASlider").step = 0.01;

    stepSize = 0.01;
    optimizerParameter0 = 0;
    optimizerParameter1 = 0.1;
  }

  document.getElementById("stepsizeValue").innerHTML = stepSize;
  document.getElementById("iterationsValue").innerHTML = iterations;
  document.getElementById("parameterAValue").innerHTML = optimizerParameter0;
  document.getElementById("parameterBValue").innerHTML = optimizerParameter1;
  document.getElementById("parameterCValue").innerHTML = optimizerParameter2;
  document.getElementById("parameterDValue").innerHTML = optimizerParameter3;

  document.getElementById("stepsizeSlider").value = stepSize;
  document.getElementById("iterationsSlider").value = iterations;
  document.getElementById("parameterASlider").value = optimizerParameter0;
  document.getElementById("parameterBSlider").value = optimizerParameter1;
  document.getElementById("parameterCSlider").value = optimizerParameter2;
  document.getElementById("parameterDSlider").value = optimizerParameter3;

  drawOptimizerAnimation();
}

function functionOver(obj)
{
  if (!obj.style.border.includes("#CC9900") && !obj.style.border.includes("rgb(204, 153, 0)"))
    obj.style.border = "3px solid #707070";
}

function functionOut(obj)
{
 if (!obj.style.border.includes("#333333") && !obj.style.border.includes("rgb(204, 153, 0)"))
   obj.style.border = "3px solid #333333";
}

function OptimizerSettingsOpen()
{
  $(".expanded").toggle();
}

document.addEventListener('DOMContentLoaded', function()
{
  drawFunction();
}, false);

$(document).ready(function()
{
  $(".expanded").hide();

  $(".parameterContainerC").hide();
  $(".parameterContainerD").hide();

  var ctx = document.getElementById("canvas").getContext("2d");
  costGraph = new Chart(ctx, config);
  });

  var config = {
  type: 'line',
  data: {
      labels: [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12],
  },
  options: {
      responsive: true,
      animation : false,
      tooltips: {
        enabled: false
      },
      legend: {
        position: 'top',
        fullWidth:true,
        labels: {
            boxWidth: 10,
        },
      },
      elements: {
      point: {
        radius: 0,
        hitRadius: 0,
        hoverRadius: 0,
      }
    },
      scales: {
    yAxes: [{
      scaleLabel: {
        display: true,
        labelString: 'Cost'
      }
    }],
    xAxes: [{
      scaleLabel: {
        display: true,
        labelString: 'Number of gradient evaluations'
      }
    }]
  },} };