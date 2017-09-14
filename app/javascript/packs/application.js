/* eslint no-console:0 */
// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.
//
// To reference this file, add <%= javascript_pack_tag 'application' %> to the appropriate
// layout file, like app/views/layouts/application_old.html.erb
// import $ from 'jquery';
// import "jquery";
// import 'bootstrap-sass';
import './owl/owl.carousel';

$(document).ready(function() {
  $('.home-users').owlCarousel({
    naw: true,
    loop: true,
    margin: 20,
    items: 5,
    responsiveClass: true,
    responsive: {
      0: {
        items: 1,
        nav: true,
      },
      600: {
        items: 3,
        nav: true,
      },
      1024: {
        items: 5,
        nav: true,
      },
    },
    navText: [
      '',
      '',
    ],
  });

  $("a[data-remote]").on("ajax:success", function(e, data, status, xhr) {
    console.log(e)
    console.log(data);
  });


});

