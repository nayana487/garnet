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
