(function(){
  $('.js-select2').select2();
  $('.js-select2.tag_select').select2({tags: true});
  $('.js-remove-tagging').click(removeTag);
  $('.js-tag').on("click", filterByTag);
  $(".js-sticky-table-header").stickyTableHeaders();

  var membershipsDataTable = $(".js-dataTable.memberships").DataTable({
      paging: false,
      "aoColumnDefs" : [
        {
          "bSearchable": true,
          "aTargets": [0,1]
        }
      ]
  });

  var todosDataTable = $(".js-dataTable.submissions, .js-dataTable.attendances").DataTable({
      paging: false,
      "aoColumnDefs" : [
        {
          "bSortable" : false,
          "aTargets" : [ "no-sort" ]
        }
      ]
  });

  function removeTag(event) {
    event.preventDefault();
    var el = $(this);
    $.ajax({
      method: "delete",
      url: el.data("remove-tagging-path")
    }).then(function() {
      el.closest("li").fadeOut();
    });
  }

  function filterByTag(event){
    var target = $(event.target)
    if(target.hasClass("js-tag")){
      membershipsDataTable.search(event.target.firstChild.textContent).draw();
    }
  }
})();
