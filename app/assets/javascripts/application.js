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
//= require jquery.stickytableheaders.min

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

(function(){
  var mantra = $("#mantra");
  var speed = 200;
  loadMantra();
  mantra.on("dblclick", function(){
    mantra.animate({opacity:0}, speed, function(){
      loadMantra().then(function(){
        mantra.animate({opacity:1}, speed);
      });
    });
  });
  function loadMantra(){
    return $.getJSON("/mantras/random", function(response){
      mantra.html(response.message);
    });
  }
}());


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
  document.querySelector("h1").style.color = "green";
  document.querySelector("h1 a").innerHTML = "<span>GA</span>rnett: Anything is possible";
});

$("[data-autosave] input, [data-autosave] textarea, [data-autosave] select").on("change", autoSave);

function autoSave(evt){
  evt.preventDefault();
  var trigger = $(this);
  var form    = trigger.closest("form");
  var data    = form.serializeArray();
  var url     = form.attr("action");
  trigger.addClass("waiting");
  $.ajax({
    url:      url,
    type:     "post",
    dataType: "json",
    data:     data
  }).fail(function(response){
    console.log("That didn't work.");
  }).always(function(response){
    trigger.removeClass("waiting");
  });
}

$(".js-sticky-table-header").stickyTableHeaders();
