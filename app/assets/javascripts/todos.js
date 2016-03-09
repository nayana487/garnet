if(typeof todoData != "undefined" ){
  todoData.sort(function(a,b){
    return a.ungraded - b.ungraded;
  })
  var max = d3.max(todoData, function(d){
    return d.ungraded
  })
  var scale = d3.scale.linear()
                .domain([0,max])
                .range([0,100]);
  d3.select(".chart")
    .selectAll("div")
    .data(todoData)
    .enter()
    .append("div")
    .style("width", function(d){
      return scale(d.ungraded) + "%"
    })
    .text(function(d){
      return d.user + ": " + d.ungraded
    })
}
