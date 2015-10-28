$(function(){
  var prsSubmitted = 0
  $("[data-github-pr-submitted]").each(isPrSubmitted)
  function getIssues(url, issues, callback){
    issues = issues || []
    $.getJSON( url, function( res, textStatus, req ){
      res.forEach( function( issue ){
	       issues.push( issue )
      });
      nextUrl = req.getAllResponseHeaders().match(/<(.*)>; rel="next"/);
      if( nextUrl ){
	       getIssues(nextUrl[1], issues, callback);
      } else {
	       callback(issues);
      }
    });
  }
  function isPrSubmitted(){
    var self = $(this)
    var url = $(this).attr("data-github-pr-submitted")
    var id = $(this).attr("data-github-user-id")
    getIssues(url, [], function(issues){
      for( var i=0; i < issues.length; i++ ){
        console.log(issues[i].user.id, id)
        if( issues[i].user.id == id ){
          var a = $( "<a href='" + issues[i].html_url + "'>View Pull Request</a>" )
          if( issues[i].state != "closed" ){
            a.append( " <small>(Open)</small>")
          }
          self.html( a );
          return
        }
      }
      self.html("Missing")
    })
  }
})

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
      var id = el.getAttribute("data-gh-issues");
      el.textContent = summaryToString(id)
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

  function summaryToString(id){
    var state;
    var output = []
    if(id){
      var summary = summaries[id];
      for(state in summary){
        output.push(state + ": " + summary[state])
      }
    }else{
      output = ["missing"]
    }
    return output.join(", ");
  }
}
