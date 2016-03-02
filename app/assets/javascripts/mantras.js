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
