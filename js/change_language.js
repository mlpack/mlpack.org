/**
 * A utility function to change the language displayed on the page.  This
 * function should be called whenever the language is changed from the
 * drop-down.
 */
function changeLanguage()
{
  // Use current version.
  lang = document.getElementById("language-select").value;
  // Assemble a new URL and redirect there.
  currentLocation = window.location.href;
  window.location.href = currentLocation.replace(/\/[^\/_]*_documentation.html/,
      '/' + lang + "_documentation.html");
}

/**
 * A utility function to change the version displayed on the page.  This
 * function should be called whenever the version is changed from the
 * drop-down.
 */
function changeVersion()
{
  version = document.getElementById("version-select").value;
  // Assemble a new URL and redirect there.
  currentLocation = window.location.href;
  window.location.href = currentLocation.replace(/\/mlpack-[^\/]*/,
      '/' + version);
}

window.onload = function()
{
  // Extract the language from the URL and select it.
  lang = window.location.href.replace(/.*\/([^\/_]*)_documentation.html.*/,
      "$1");
  document.getElementById("language-select").value = lang;
}
