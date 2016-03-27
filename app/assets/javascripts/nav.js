$(function() {

  var timer; //helps to slightly debounce/throttle the scroll event
  var navHeight = 40;
  var marginOfMain = 10;
  var contentStart = $('main').position().top + marginOfMain;

  scrollNav()

  function scrollNav() {
    if ($(window).scrollTop() > (contentStart)) {
      $('.page-nav').addClass('navbar-fixed');
      $('.page-nav').removeClass('navbar-relative');
      $('.nav-spacer').show();
    }
    if ($(window).scrollTop() < (contentStart - 1)) {
      $('.page-nav').removeClass('navbar-fixed');
      $('.page-nav').addClass('navbar-relative');
      $('.nav-spacer').hide();
    }
  };

  $(window).scroll(function () {

    // starts new timeout if new scroll triggered before first timeout finishes
    if (timer) {
      window.clearTimeout(timer);
    }

    timer = window.setTimeout(scrollNav(), 15); //delay of 15 ms
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
