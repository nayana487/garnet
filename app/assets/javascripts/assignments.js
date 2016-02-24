$(".js-count-assignment-issues").on("click", function(e){
  var button = $(this)
  var buttonHTML = button.html()
  var url = button.attr("data-issues-url")
  button.addClass("waiting");
  loadIssues(url, function(){
    button.removeClass("waiting");
  })
})

$(".js-toggle-notes").on("click", toggleNotes);
toggleNotes(); // notes are shown in the HTML, but hidden by default using JS

function loadIssues(url, callback){
  var els = $("[data-gh-issues]");
  var summaries = {};
  $.ajax({
    url: url
  }).done(function(response){
    for(index in response){
      parseIssue(response[index]);
    }
    els.each(function(index, el){
      var userID = el.getAttribute("data-gh-issues");
      el.textContent = issueSummaryToString(userID)
    });
    if(typeof callback == "function"){
      callback()
    }
  });

  function parseIssue(issue){
    var userID, state;
    userID = issue[9][1][1][1];
    state = issue[11][1];
    if(!summaries[userID]) summaries[userID] = {}
    if(!summaries[userID][state]) summaries[userID][state] = 0;
    summaries[userID][state]++
  }

  function issueSummaryToString(id){
    var state;
    var output = []
    if(id){
      var summary = summaries[id];
      for(state in summary){
        output.push(state + ": " + summary[state])
      }
    }
    if(!id || output.length < 1){
      output = ["?"]
    }
    return "(" + output.join(", ") + ")";
  }
}

function toggleNotes() {
  // when called globally, use the default of js-toggle-notes
  // when called in a callback, use the button that triggered the event
  var button = this === window ? $(".js-toggle-notes") : this

  $(button).text() === "Show Notes" ? $(button).text("Hide Notes") : $(button).text("Show Notes");
  $(".submission-note").toggle("fast");
}
