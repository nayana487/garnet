$('.js-select2').select2();
$('.js-select2.tag_select').select2({tags: true});

$('.js-remove-tagging').click(removeTag);

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
