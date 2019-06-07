---
layout: default-nav
title: Distribution-Table-Test
description: mlpack | fast, flexible machine learning library in C++
order: 2
---

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Test</title>

<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>

<style type="text/css">
.seltable {
  border-collapse: collapse;
  width: 100%;
  background-color: white;
}
.seltable-head {
  border: 1px solid black;
  margin-bottom: 0;
  padding-bottom: 0;
}
.seltable-head td {
  border: 1px solid black;
}
.seltable-body {
  border: 1px solid black;
  border-top: 0;
  margin-top: 0;
  padding-top: 0;
  margin-bottom: 0;
  padding-bottom: 0;
}
.seltable-body td {
  border: 1px solid black;
  border-top: 0;
}
.seltable-footer {
  border: 1px solid black;
  border-top: 0;
  margin-top: 0;
  padding-top: 0;
}
.seltable-footer td {
  border: 1px solid black;
  border-top: 0;
}
 </style>

</head>

<body>

<table class="seltable seltable-head">
<tr id="sel-build">
  <td width="20%">Build</td>
</tr>
</table>

<table id="tbl-os" class="seltable seltable-body" >
<tr id="sel-os">
  <td width="20%">OS</td>
</tr>
</table>

<table id="tbl-package" class="seltable seltable-body" >
<tr id="sel-package">
  <td width="20%">Package</td>
</tr>
</table>

<table id="tbl-language" class="seltable seltable-body" >
<tr id="sel-language">
  <td width="20%">Language</td>
</tr>
</table>

<table id="tbl-command" class="seltable seltable-body" >
<tr id="sel-command">
  <td width="20%">Command</td>
  <td id="sel-cmd" width="80%">Command</td>
</tr>
</table>

</body>

<script type="text/javascript">

var data = null;
var iddentifier = 0;

var build = "stable";
var os = "mac";
var distribution = "debian";
var package = "homebrew";
var language = "python";

function select(id)
{
	var sel = document.getElementById(id);

	if (sel.parentNode.id.includes("build"))
		build = sel.innerHTML.toLowerCase();
	else if (sel.parentNode.id.includes("os"))
		os = sel.innerHTML.toLowerCase();
	else if (sel.parentNode.id.includes("package"))
		package = sel.innerHTML.toLowerCase();
	else if (sel.parentNode.id.includes("language"))
		language = sel.innerHTML.toLowerCase();

	console.log(build)
	console.log(os)
	console.log(package)
	console.log(language)

	var command = getCommand(build, os, package, language)
	if (command == null)
	{
		return;
	}

	var command = getCommand(build, os, package, language)["cmd"];
	var command_text = ""
	for (var i = 0; i < command.length; i++)
		command_text += command[i] + "<br>"
	document.getElementById("sel-cmd").innerHTML = command_text;
}

function TdEntry(id, value, size)
{
	var entry = document.createElement('td');
	entry.setAttribute('id', id);
	entry.setAttribute('width', size);
	entry.innerHTML = value
	entry.onclick = function() { select(id) };
	return entry
}

function getCommand(build, os, package, language)
{
	if (os != "linux")
	{
		for (var i = 0; i < data[os].length; i++)
		{
			if (data[os][i]["package"].toLowerCase() == package && data[os][i]["language"].toLowerCase() == language)
				return data[os][i];
		}
	}
	else
	{

	}
	return null
}

function ShowSolution(solutions)
{
	var parent_sel_package = document.getElementById("sel-package");
	var parent_sel_language = document.getElementById("sel-language");

	var tbl_package = document.getElementById("tbl-package");
	var tbl_language = document.getElementById("tbl-language");

	// Delete old packages.
	for (var i = 0; i < tbl_package.rows.length - 1; i++)
	{
		tbl_package.rows[i].deleteCell(1 + i)
	}

	// Filter data.
	var language = [];
	var package = [];
	for (var i = 0; i < solutions.length; i++)
	{
		if (!language.includes(solutions[i]["language"]))
			language.push(solutions[i]["language"])

		if (!package.includes(solutions[i]["package"]))
			package.push(solutions[i]["package"])
	}
	// Add the first 4 packages.
	var package_num = package.length > 4 ? 4 : package.length;
	var package_width = package_num < package.length ? 80 / (package_num + 1) + "%" : 80 / package_num + "%";
	for (var i = 0; i < package_num; i++)
		parent_sel_package.appendChild(TdEntry(iddentifier++, package[i], package_width));

	// Are there any packages left?
	if (package.length > package_num)
		parent_sel_package.appendChild(TdEntry(iddentifier++, ">", package_width));

	// Add the first 3 languages.
	var language_num = language.length > 3 ? 3 : language.length;
	var language_width = language_num < package.length ? 80 / (language_num + 1) + "%" : 80 / language_num + "%";
	for (var i = 0; i < language_num; i++)
		parent_sel_language.appendChild(TdEntry(iddentifier++, language[i], language_width));

	// Are there any languages left?
	if (package.length > language_num)
		parent_sel_language.appendChild(TdEntry(iddentifier++, ">", language_width));

	var command = getCommand("stable", "mac", "homebrew", "python")["cmd"];
	var command_text = ""
	for (var i = 0; i < command.length; i++)
		command_text += command[i] + "<br>"
	document.getElementById("sel-cmd").innerHTML = command_text;
}

$.getJSON("install.json", function(json)
{
	data = json["stable"]
	var parent_sel_build = document.getElementById("sel-build");
	parent_sel_build.appendChild(TdEntry(iddentifier++, "Stable", "40%"));
	parent_sel_build.appendChild(TdEntry(iddentifier++, "Nightly", "40%"));

	var parent_sel_os = document.getElementById("sel-os");
	parent_sel_os.appendChild(TdEntry(iddentifier++, "Linux", "26.6%"));
	parent_sel_os.appendChild(TdEntry(iddentifier++, "Mac", "26.6%"));
	parent_sel_os.appendChild(TdEntry(iddentifier++, "Windows", "26.6%"));


	ShowSolution(json["stable"]["mac"])

});

</script>
</html>

