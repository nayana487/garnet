"use strict";

(function(){

  function KonamiListener(element, callback){
    var instance = this;
    instance.element  = element;
    instance.callback = callback;
    instance.sequence = "";
    element.addEventListener("keyup", KonamiListener.oninput.bind(instance));
  }
  KonamiListener.sequence = "-38-38-40-40-37-39-37-39-66-65";
  KonamiListener.oninput = function(evt){
    var master = KonamiListener, instance = this;
    instance.sequence += "-" + evt.keyCode;
    if(master.sequence.indexOf(instance.sequence) < 0){
      instance.sequence = "";
    }else if(master.sequence === instance.sequence){
      instance.sequence = "";
      instance.callback();
    }
  }

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

})();
