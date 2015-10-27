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
