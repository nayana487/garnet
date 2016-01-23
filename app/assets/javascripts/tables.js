$(".js-dataTable.memberships").DataTable({
    paging: false
});

$(".js-dataTable.submissions, .js-dataTable.attendances").DataTable({
    paging: false,
    "aoColumnDefs" : [
      { "bSortable" : false,
        "aTargets" : [ "no-sort" ]
      }
    ]
});
