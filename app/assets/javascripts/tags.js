$('.js-select2').select2();
$('.js-select2.tag_select').select2({tags: true});

$('.js-remove-tagging').click(removeTag);

$('.js-tag').on("click", filterByTag)
var membershipsDataTable = $(".js-dataTable.memberships").DataTable({
    paging: false,
    "aoColumnDefs" : [
      {
        "bSearchable": true,
        "aTargets": [0,1]
      }
    ]
});

function removeTag(event) {
  event.preventDefault();
  var el = $(this);
  $.ajax({
    method: "delete",
    url: el.data("remove-tagging-path")
  })
    .then(function() {
      el.closest("li").fadeOut();
    });
}

function filterByTag(event){
  if(event.target.classList.contains("js-tag")){
    membershipsDataTable.search(event.target.innerText).draw()
  }
}
