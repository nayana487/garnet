// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require select2
//= require jquery.dataTables.min
//= require_tree .

$("[data-record-url]").on("change", function(){
  var el = $(this);
  var key = el.attr("data-record-attribute");
  var value = el.val();
  var url = el.attr("data-record-url");
  var params = {};

  if(!key) key = "status";
  params[key] = value;
  el.addClass("waiting");
  $.ajax({
    url: url,
    dataType: "json",
    method: "PATCH",
    data: params
  }).success(function(data){
    el.removeClass("waiting");
  });
});

$(".fold").on("click", function(e){
  // toggles url anchor
  // Actual "fold"ing is performed by CSS
  var hash = window.location.hash;
  if(hash == e.target.getAttribute('href')){
    e.preventDefault();
    window.location.hash = '#';
  }
});

new KonamiListener(window, function(){
  var img = document.createElement("IMG");
  img.title = "Garnett. Get it?";
  img.src = "http://i.imgur.com/dfb04ls.png";
  img.style.display = "block";
  img.style.position = "fixed";
  img.style.zIndex = 9000;
  img.style.right = "0px";
  img.style.bottom = "0px";
  img.style.cursor = "help";
  document.body.appendChild(img);
  document.querySelector("h1 a").innerHTML = "<span style='color:green;'>GA</span>rnett: Anything is possible";
});
