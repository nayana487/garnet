$(".js-score-update-form").on("submit", submitScore);
$(".js-score-update-form input").on("focusout", submitScore);

function submitScore(evt){
  evt.preventDefault();

  var form = $(this).closest("form");
  var inputEl = form.find(".submission-score").eq(0);
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
}
