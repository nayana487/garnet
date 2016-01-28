$(".js-score-update-form").on("submit", function(evt){
  evt.preventDefault();
  var inputEl = $(this).children(".submission-score").eq(0);
  var submissionId = inputEl.attr("submission-id");
  var url = "../submissions/" + submissionId;
  $.ajax({
    url: url,
    dataType: 'json',
    type: "put",
    data: {
      score: inputEl.val()
    }
  }).done(function(res){
    var parentTr = inputEl.parents("tr")
    parentTr.animate({backgroundColor: "#DCFFDC" }, 0)
    parentTr.animate({backgroundColor: "#eeeeee" }, 500)
  }).fail(function(res){
    console.log("this failed");
  });
});
