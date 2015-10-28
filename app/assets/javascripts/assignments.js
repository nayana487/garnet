function loadIssues(url){
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
  });

  function parseIssue(issue){
    var userID, state;
    userID = issue[8][1][1][1];
    state = issue[10][1];
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
      output = ["missing"]
    }
    return output.join(", ");
  }
}
