$(function() {

  var timer; //helps to slightly debounce/throttle the scroll event
  var navHeight     = $('.page-nav').outerHeight();
  var marginOfMain  = parseInt($('main').css('margin-top'));
  var contentStart  = $('main').position().top + marginOfMain;
  var scrollCurrent = 0;
  var scrollBefore  = 0;
  var scrollDiff    = 0;
  var delta         = 5;

  scrollNav() // call function once on page load

  function scrollNav() {
    scrollCurrent = window.pageYOffset;

    // Make sure they scroll more than delta
    if (Math.abs(scrollBefore - scrollCurrent) <= delta) {
      return;
    }

    // scrollCurrent > scrollBefore -> scrolling down

    // scolled above the default navbar position (top of page)
    if (scrollCurrent <= contentStart) {
      $('.page-nav')
        .addClass('navbar-relative')
        .removeClass('navbar-fixed')
        .removeClass('navbar-fixed-hide');
      $('.nav-spacer').hide();
    }
    // scrolled past the start of the navbar & scrolling up
    else if (scrollCurrent > contentStart && scrollCurrent < scrollBefore) {
      $('.page-nav')
      .addClass('navbar-fixed-hide')
      .removeClass('navbar-relative')
      .removeClass('navbar-fixed');
      $('.nav-spacer').show();
    }
    // scrolled past the start of the navbar & scrolling down
    else if (scrollCurrent > contentStart && scrollCurrent > scrollBefore) {
      $('.page-nav')
        .addClass('navbar-fixed')
        .removeClass('navbar-relative')
        .removeClass('navbar-fixed-hide');
      $('.nav-spacer').show();
    }

      // if (scrollCurrent > scrollBefore) {
      //   console.log("scrolling down");
      //   $('.page-nav').addClass('navbar-fixed').removeClass('navbar-fixed-hide');
      // } // scrolling up
      // else {
      //   console.log("scrolling up");
      //   $('.page-nav').removeClass('navbar-fixed').addClass('navbar-fixed-hide');
      // }

    scrollBefore = scrollCurrent;

    // // scolled above the default navbar position (top of page)
    // if (scrollCurrent <= (contentStart)) {
    //   $('.page-nav').removeClass('navbar-fixed').addClass('navbar-relative');
    //   $('.nav-spacer').hide();
    // }
    // // scrolled past the start of the navbar
    // else (scrollCurrent > contentStart) {
    //   $('.page-nav').addClass('navbar-fixed').removeClass('navbar-relative');
    //   $('.nav-spacer').show();
    // }
  };

  $(window).scroll(function () {

    // starts new timeout if new scroll triggered before first timeout finishes
    if (timer) {
      window.clearTimeout(timer);
    }

    timer = window.setTimeout(scrollNav(), 1500); //delay of 15 ms
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
