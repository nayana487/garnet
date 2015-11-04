function KonamiListener(element, callback){
  var instance = this;
  instance.element = element;
  instance.callback = callback;
  instance.sequence = []
  instance.oninput = KonamiListener.oninput.bind(instance);
  element.addEventListener("keyup", instance.oninput);
}
KonamiListener.masterSequence = [38, 38, 40, 40, 37, 39, 37, 39, 66, 65]
KonamiListener.oninput = function(e){
  var instance = this, keyCode = e.keyCode, sequence, master;
  if(instance.sequence.indexOf(keyCode) < -1) return;
  instance.sequence.push(e.keyCode);
  sequence = instance.sequence.join("");
  masterSequence = KonamiListener.masterSequence.join("");
  if(masterSequence.indexOf(sequence) < 0) return instance.sequence = [];
  if(masterSequence === sequence){
    instance.sequence = [];
    instance.callback();
  }
}
