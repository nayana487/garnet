$(".submission-score").on("keydown", function(evt){
  if(evt.keyCode == 13){
    var self = $(this);
    var submissionId = $(this).attr("submission-id");
    var url = "../submissions/" + submissionId + "/update_score";
    $.ajax({
      url: url,
      dataType: 'json',
      type: "put",
      data: {
        score: self.val()
      }
    }).done(function(res){
      self.parent().parent().append($("<td>Score Update</td>"))
    }).fail(function(res){
      console.log("this failed");
    });
  }
});
