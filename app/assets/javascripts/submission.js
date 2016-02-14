$(".js-score-update-form").on("submit", function(evt){
  evt.preventDefault();
  var inputEl = $(this).children(".submission-score").eq(0);
  var submissionId = inputEl.attr("submission-id");
  var url = "../submissions/" + submissionId;
  $(inputEl).addClass("waiting");
  $.ajax({
    url: url,
    dataType: 'json',
    type: "put",
    data: {
      score: inputEl.val()
    }
  }).fail(function(res){
    console.log("this failed");
  }).always(function(){
    $(inputEl).removeClass("waiting");
  });
});
