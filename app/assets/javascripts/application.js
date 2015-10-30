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
//= require_tree .

$("[data-record-url]").on("click", function(){
  var el = $(this);
  el.addClass("waiting");
  $.ajax({
    url: el.attr("data-record-url"),
    dataType: "json",
    method: "PATCH",
    data: {status: el.val()}
  }).success(function(data){
    el.removeClass("waiting");
    console.log(data);
  });
});

$(document).ready(function(){
  (function openFirstFoldingSection(){
    var folderID = $(".fold").eq(0).attr("id");
    if(folderID && !window.location.hash) window.location = "#" + folderID;
  }())
})
