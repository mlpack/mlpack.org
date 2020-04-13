function ScrollTo(name) {
  ScrollToResolver(document.getElementById(name));
}

function ScrollToResolver(elem) {
  var jump = parseInt(elem.getBoundingClientRect().top * 0.2 - 13);
  document.body.scrollTop += jump;
  document.documentElement.scrollTop += jump;
  if (!elem.lastjump || elem.lastjump > Math.abs(jump)) {
    elem.lastjump = Math.abs(jump);
    setTimeout(function() {
      ScrollToResolver(elem);
    }, "20");
  } else {
    elem.lastjump = null;
  }
}

function navResize() {
  var subnav = document.getElementById("sub-nav");
  console.log(document.documentElement.clientWidth);
  if (document.documentElement.clientWidth > 1110) {
    var element = document.getElementById("helper");
    var rect = element.getBoundingClientRect();

    subnav.style.top = rect.top - 10 + "px";
    subnav.style.left = rect.left - 180 + "px";
    subnav.style.display = "block";
  } else {
    subnav.style.display = "none";
  }
}

window.addEventListener("resize", function(event) {
  navResize();
});

navResize();
