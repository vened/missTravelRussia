// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require rails-ujs
//= require jquery
//= require bootstrap-sprockets
//= require bootstrap/tooltip
//= require ./lightgallery/lightgallery/dist/js/lightgallery.min.js
//= require ./lightgallery/lg-thumbnail/dist/lg-thumbnail.min.js
//= require ./lightgallery/lg-fullscreen/dist/lg-fullscreen.min.js
//= require ./lightgallery/lg-zoom/dist/lg-zoom.min.js
//= require ./lightgallery/lg-share/dist/lg-share.min.js

// bootstrap-sass
// require_tree .

$(document).ready(function() {
  $('[data-toggle="tooltip"]').tooltip();

  $('#profile-gallery').lightGallery({
    selector: '.profile-gallery-item',
    subHtmlSelectorRelative: true,
  });

  $('.gallery').lightGallery({
    selector: '.gallery-item',
    subHtmlSelectorRelative: true,
  });

  if (window.localStorage.getItem('isPaymentModalOpen') != '0') {
    $('#payment').modal('show');
  }

  $('.social-group-btn').on('click', function() {
    $('#payment').modal('hide');
    window.localStorage.setItem('isPaymentModalOpen', 0);
  });

});
