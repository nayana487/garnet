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
    console.log(self)
    var url = $(this).attr("data-github-pr-submitted")
    console.log(url)
    getIssues(url, [], function(issues){
      console.log("got all issues")
      console.log(issues)
    })
  }
})