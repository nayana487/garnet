$(".js-dataTable.memberships").DataTable({
    paging: false,
    "aoColumnDefs" : [
      {
        "bSearchable": true,
        "aTargets": [0,1]
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
