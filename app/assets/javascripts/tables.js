$(".js-dataTable.memberships").DataTable({
    paging: false,
    "aoColumnDefs" : [
      {
        "bSearchable": false,
        "aTargets": [3, 4, 5, 6, 7]
      }
    ]
});

$(".js-dataTable.submissions, .js-dataTable.attendances").DataTable({
    paging: false,
    "aoColumnDefs" : [
      {
        "bSortable" : false,
        "aTargets" : [ "no-sort" ]
      }
    ]
});
