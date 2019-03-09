function changeVersion()
{
  // Get the current URL, and redirect accordingly.
  var currentLocation = window.location.href;
  // Get selection.
  version = document.getElementById("version-select").value;

  window.location.href =
      currentLocation.replace(/\/mlpack-[^\/]*/, '/mlpack-' + version);
}
