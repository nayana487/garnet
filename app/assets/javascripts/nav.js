$(function() {

  var timer; //helps to slightly throttle the scroll event
  var aArray = []; //empty array for getNavHrefs
  var navHeight = 40;

  function getNavHrefs() {
    var aChildren = $(".page-nav li").children();
    for (var i=0; i < aChildren.length; i++) {
      var aChild = aChildren[i];
      var ahref = $(aChild).attr('href');
      aArray.push(ahref);
    }
  };
  getNavHrefs();

  $(window).scroll(function () {
    var scrollPos = $(window).scrollTop(); // get current vertical position
    var winHeight = $(window).height(); // get window height
    var docHeight = $(document).height(); // get doc height for last child
    var contentStart = $('main').position().top;

    // starts new timeout if new scroll triggered before first timeout finishes
    if (timer) {
      window.clearTimeout(timer);
    }

    timer = window.setTimeout(function() {

      function scrollNav() {
        if ($(window).scrollTop() > (contentStart)) {
          $('.page-nav').addClass('navbar-fixed');
          $('.page-nav').removeClass('navbar-relative');
        }
        if ($(window).scrollTop() < (contentStart - 1)) {
          $('.page-nav').removeClass('navbar-fixed');
          $('.page-nav').addClass('navbar-relative');
        }
      };
      scrollNav();

    }, 15); //delay of 10 ms
  });

  // Smooth scroll
  $('a').click(function(){
    if (this.innerHTML == 'Top') {
      $("html, body").animate({
        scrollTop: 0
      }, 500);
    } else if ( $( $(this).attr('href') ) ) {
      $('html, body').animate({
        scrollTop: $( $(this).attr('href') ).offset().top - navHeight
      }, 500);
    }
    return false;
});

});
