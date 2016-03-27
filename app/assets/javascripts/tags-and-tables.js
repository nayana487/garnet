(function(){
  $('.js-select2').select2();
  $('.js-select2.tag_select').select2({tags: true});
  $(".js-sticky-table-header").stickyTableHeaders({fixedOffset: 40});
  $('[data-remove-tagging-path]').click(removeTag);

  $("[data-sortable]").each(function(index, el){
    new Sortable(el).activate();
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
})();
