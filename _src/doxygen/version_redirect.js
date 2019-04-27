function changeVersion()
{
  // Get the current URL, and redirect accordingly.
  var currentLocation = window.location.href;
  // Get selection.
  version = document.getElementById("version-select").value;

  window.location.href =
      currentLocation.replace(/\/mlpack-[^\/]*/, '/' + version);
}

// Set to the correct version on load.
window.onload = function()
{
  // Extract the version from the URL and select it.
  lang = window.location.href.replace(/.*\/(mlpack-[^\/]*)\/.*/, "$1");
  if (lang == window.location.href)
  {
    lang2 = window.location.href.replace(/.*\/(stable)\/.*/, "$1");
    if (lang2 == "stable")
    {
      // Extract the newest version.
      document.getElementById("version-select").value =
          document.getElementById("version-select").options[1].text;
      return;
    }
  }
  document.getElementById("version-select").value = lang;
}
