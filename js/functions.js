/**
 * @file functions.js
 * @author Marcus Edel
 */

function BoothFunction()
{
  // Create and populate a data table with the Booth function.
  var data = new vis.DataSet();

  var counter = 0;

  var axisStep = 1;
  var xStart = -10;
  var yStart = -10;
  var axisMax = 10;

  for (var x = xStart; x < axisMax; x += axisStep)
  {
      for (var y = yStart; y < axisMax; y += axisStep)
      {
          var value = Math.pow(x + 2 * y - 7, 2) + Math.pow(2 * x + y - 5, 2)
          data.add({id:counter++, x:x, y:y, z:value, style:value});
      }
  }

  return {data:data, xMin:xStart, yMin:yStart, xMax:axisMax, yMax:axisMax, zMin:0, zMax:2500}
}

function BukinFunction()
{
  // Create and populate a data table with the Bukin function.
  var data = new vis.DataSet();

  var counter = 0;

  var axisStep = 0.18;
  var xStart = -15;
  var yStart = -3;
  var xAxisMax = -5;
  var yAxisMax = 3;

  for (var x = xStart; x < xAxisMax; x += axisStep)
  {
      for (var y = yStart; y < yAxisMax; y += axisStep)
      {
          var value = 100 * Math.sqrt(Math.abs(y - 0.01 * Math.pow(x, 2))) +
              0.01 * Math.abs(x + 10);
          data.add({id:counter++, x:x, y:y, z:value, style:value});
      }
  }

  return {data:data, xMin:xStart, yMin:yStart, xMax:xAxisMax, yMax:yAxisMax, zMin:0, zMax:250}
}

function DropWaveFunction()
{
  // Create and populate a data table with the Drop-Wave function.
  var data = new vis.DataSet();

  var counter = 0;

  var axisStep = 0.25;
  var xStart = -5.12;
  var yStart = -5.12;
  var xAxisMax = 5.12;
  var yAxisMax = 5.12;

  for (var x = xStart; x < xAxisMax; x += axisStep)
  {
      for (var y = yStart; y < yAxisMax; y += axisStep)
      {
          var frac0 = 1 + Math.cos(12 * Math.sqrt(Math.pow(x, 2) +
              Math.pow(y, 2)));
          var frac1 =  0.5 * (Math.pow(x, 2) + Math.pow(y, 2)) + 2;
          var value = -frac0 / frac1;
          data.add({id:counter++, x:x, y:y, z:value, style:value});
      }
  }

  return {data:data, xMin:xStart, yMin:yStart, xMax:xAxisMax, yMax:yAxisMax, zMin:-1, zMax:0}
}

function SphereFunction()
{
  // Create and populate a data table with the Sphere function.
  var data = new vis.DataSet();

  var counter = 0;

  var axisStep = 0.3;
  var xStart = -5.12;
  var yStart = -5.12;
  var xAxisMax = 5.12;
  var yAxisMax = 5.12;

  for (var x = xStart; x < xAxisMax; x += axisStep)
  {
      for (var y = yStart; y < yAxisMax; y += axisStep)
      {
          var value = Math.pow(x, 2) + Math.pow(y, 2);
          data.add({id:counter++, x:x, y:y, z:value, style:value});
      }
  }

  return {data:data, xMin:xStart, yMin:yStart, xMax:xAxisMax, yMax:yAxisMax, zMin:0, zMax:60}
}

function RastriginFunction()
{
  // Create and populate a data table with the Rastrigin function.
  var data = new vis.DataSet();

  var counter = 0;

  var axisStep = 0.19;
  var xStart = -5.12;
  var yStart = -5.12;
  var xAxisMax = 5.12;
  var yAxisMax = 5.12;

  for (var x = xStart; x < xAxisMax; x += axisStep)
  {
      for (var y = yStart; y < yAxisMax; y += axisStep)
      {
          var value = 10 * 2.0 + ((Math.pow(x, 2) - 10 * Math.cos(2 * Math.PI * x)) +
              (Math.pow(y, 2) - 10 * Math.cos(2 * Math.PI * y)));
          data.add({id:counter++, x:x, y:y, z:value, style:value});
      }
  }

  return {data:data, xMin:xStart, yMin:yStart, xMax:xAxisMax, yMax:yAxisMax, zMin:0, zMax:80}
}

function McCormickFunction()
{
  // Create and populate a data table with the Mc-Cormick function.
  var data = new vis.DataSet();

  var counter = 0;

  var axisStep = 0.2;
  var xStart = -2;
  var yStart = -4;
  var xAxisMax = 4;
  var yAxisMax = 4;

  for (var x = xStart; x < xAxisMax; x += axisStep)
  {
      for (var y = yStart; y < yAxisMax; y += axisStep)
      {
          var value = Math.sin(x + y) + Math.pow(x - y, 2) - 1.5 * x + 2.5 * y + 1;
          data.add({id:counter++, x:x, y:y, z:value, style:value});
      }
  }

  return {data:data, xMin:xStart, yMin:yStart, xMax:xAxisMax, yMax:yAxisMax, zMin:0, zMax:45}
}

function EasomFunction()
{
  // Create and populate a data table with the Easom function.
  var data = new vis.DataSet();

  var counter = 0;

  var axisStep = 1.3;
  var xStart = -50;
  var yStart = -50;
  var xAxisMax = 50;
  var yAxisMax = 50;

  for (var x = xStart; x < xAxisMax; x += axisStep)
  {
      for (var y = yStart; y < yAxisMax; y += axisStep)
      {
          var fact0 = -Math.cos(x) * Math.cos(y);
          var fact1 = Math.exp(-Math.pow(x - Math.PI, 2) - Math.pow(y - Math.PI, 2));
          var value = fact0 * fact1;
          data.add({id:counter++, x:x, y:y, z:value, style:value});
      }
  }

  return {data:data, xMin:xStart, yMin:yStart, xMax:xAxisMax, yMax:yAxisMax, zMin:-1, zMax:0.3}
}

function StyblinskiTangFunction()
{
  // Create and populate a data table with the Styblinski-Tang function.
  var data = new vis.DataSet();

  var counter = 0;

  var axisStep = 0.2;
  var xStart = -5;
  var yStart = -5;
  var xAxisMax = 5;
  var yAxisMax = 5;

  for (var x = xStart; x < xAxisMax; x += axisStep)
  {
      for (var y = yStart; y < yAxisMax; y += axisStep)
      {
          var value = 0.5 * ((Math.pow(x, 4) - 16 * Math.pow(x, 2) + 6 * x) +
              (Math.pow(y, 4) - 16 * Math.pow(y, 2) + 6 * y));
          data.add({id:counter++, x:x, y:y, z:value, style:value});
      }
  }

  return {data:data, xMin:xStart, yMin:yStart, xMax:xAxisMax, yMax:yAxisMax, zMin:-100, zMax:240}
}

function EggholderFunction()
{
  // Create and populate a data table with the Eggholder function.
  var data = new vis.DataSet();

  var counter = 0;

  var axisStep = 20;
  var xStart = -512;
  var yStart = -512;
  var xAxisMax = 512;
  var yAxisMax = 512;

  for (var x = xStart; x < xAxisMax; x += axisStep)
  {
      for (var y = yStart; y < yAxisMax; y += axisStep)
      {
          var term0 = -(y + 47) * Math.sin(Math.sqrt(Math.abs(y + x / 2 + 47)));
          var term1 = -x * Math.sin(Math.sqrt(Math.abs(x - (y + 47))));
          var value = term0 + term1;
          data.add({id:counter++, x:x, y:y, z:value, style:value});
      }
  }

  return {data:data, xMin:xStart, yMin:yStart, xMax:xAxisMax, yMax:yAxisMax, zMin:-1000, zMax:1000}
}
