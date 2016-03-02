(function(){
  $("[data-autosave] input, [data-autosave] textarea, [data-autosave] select").on("change", autoSave);

  function autoSave(evt){
    evt.preventDefault();
    var trigger = $(this);
    var form    = trigger.closest("form");
    var data    = form.serializeArray();
    var url     = form.attr("action");
    trigger.removeClass("dirty");
    trigger.addClass("waiting");
    $.ajax({
      url:      url,
      type:     "post",
      dataType: "json",
      data:     data
    }).fail(function(){
      console.log("That didn't work.");
    }).always(function(response){
      console.log(response);
    }).success(function(){
      trigger.removeClass("waiting");
      trigger.addClass("dirty");
    });
  }
})();
