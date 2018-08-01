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
import './FileApi/FileAPI.min';
import './FileApi/FileAPI.id3';
import './FileApi/FileAPI.exif';

$(document).ready(function() {
  $('.home-users').owlCarousel({
    naw: true,
    loop: false,
    margin: 20,
    items: 1,
    responsiveClass: true,
    lazyLoad: true,
    responsive: {
      0: {
        items: 1,
        nav: true,
      },
      600: {
        items: 1,
        nav: true,
      },
      768: {
        items: 1,
        nav: true,
      },
      1024: {
        items: 1,
        nav: true,
      },
    },
    navText: [
      '',
      '',
    ],
  });

  $('.gen-partner-media-gallery-owl').owlCarousel({
    naw: false,
    loop: true,
    margin: 0,
    items: 1,
    responsiveClass: true,
    lazyLoad: true,
    dots: true,
    autoplay: false,
    center: true,
    responsive: {
      0: {
        items: 1,
        nav: true,
      },
      600: {
        items: 1,
        nav: true,
      },
      768: {
        items: 1,
        nav: true,
      },
      1024: {
        items: 1,
        nav: true,
      },
    },
    navText: [
      '',
      '',
    ],
  });

  $('.usersGrid-gallery-owl').owlCarousel({
    naw: false,
    loop: true,
    margin: 0,
    items: 1,
    responsiveClass: true,
    lazyLoad: true,
    dots: true,
    autoplay: true,
    center: true,
    responsive: {
      0: {
        items: 1,
        nav: true,
      },
      600: {
        items: 1,
        nav: true,
      },
      768: {
        items: 1,
        nav: true,
      },
      1024: {
        items: 1,
        nav: true,
      },
    },
    navText: [
      '',
      '',
    ],
  });

  $('a[data-remote]').on('ajax:success', function(e, data, status, xhr) {
    console.log(e);
    console.log(data);
  });

});

jQuery(function($) {
  if (!(FileAPI.support.cors || FileAPI.support.flash)) {
    $('#oooops').show();
    $('#buttons-panel').hide();
  }
  $(document).on('mouseenter mouseleave', '.b-button', function(evt) {
    $(evt.currentTarget).toggleClass('b-button_hover', evt.type == 'mouseenter');
  });
  if (FileAPI.support.dnd) {
    $('#drag-n-drop').show();
    $(document).dnd(function(over) {
      $('#drop-zone').toggle(over);
    }, function(files) {
      onFiles(files);
    });
  }
  $('input[type="file"]').on('change', function(evt) {
    var files = FileAPI.getFiles(evt);
    onFiles(files);
    FileAPI.reset(evt.currentTarget);
  });
  var FU = {
    icon: {
      def: '//cdn1.iconfinder.com/data/icons/CrystalClear/32x32/mimetypes/unknown.png'
      , image: '//cdn1.iconfinder.com/data/icons/humano2/32x32/apps/synfig_icon.png'
      , audio: '//cdn1.iconfinder.com/data/icons/august/PNG/Music.png'
      , video: '//cdn1.iconfinder.com/data/icons/df_On_Stage_Icon_Set/128/Video.png',
    },
    files: [],
    index: 0,
    active: false,
    add: function(file) {
      FU.files.push(file);
      if (/^image/.test(file.type)) {
        FileAPI.Image(file).preview(35).rotate('auto').get(function(err, img) {
          if (!err) {
            FU._getEl(file, '.js-left')
                .addClass('b-file__left_border')
                .html(img)
            ;
          }
        });
      }
    },
    getFileById: function(id) {
      var i = FU.files.length;
      while (i--) {
        if (FileAPI.uid(FU.files[i]) == id) {
          return FU.files[i];
        }
      }
    },
    start: function() {
      if (!FU.active && (FU.active = FU.files.length > FU.index)) {
        FU._upload(FU.files[FU.index]);
      }
    },
    abort: function(id) {
      var file = this.getFileById(id);
      if (file.xhr) {
        file.xhr.abort();
      }
    },
    _getEl: function(file, sel) {
      var $el = $('#file-' + FileAPI.uid(file));
      return sel ? $el.find(sel) : $el;
    },
    _upload: function(file) {
      if (file) {
        file.xhr = FileAPI.upload({
          url: $('#buttons-panel').data('url'),
          headers: {
            'Accept': 'text/javascript, application/javascript, application/ecmascript, application/x-ecmascript, */*',
          },
          files: { photo_src: file },
          upload: function() {
            FU._getEl(file).addClass('b-file_upload');
            FU._getEl(file, '.js-progress')
                .css({ opacity: 0 }).show()
                .animate({ opacity: 1 }, 100)
            ;
          },
          progress: function(evt) {
            FU._getEl(file, '.js-bar').css('width', evt.loaded / evt.total * 100 + '%');
          },
          complete: function(err, xhr) {
            // console.log(xhr.response);
            eval(xhr.response);
            var state = err ? 'error' : 'done';
            FU._getEl(file).removeClass('b-file_upload');
            FU._getEl(file, '.js-progress').animate({ opacity: 0 }, 200, function() { $(this).hide(); });
            FU._getEl(file, '.js-info').append(', <b class="b-file__' + state + '">' + (err ? (xhr.statusText || err) : state) + '</b>');
            FU.index++;
            FU.active = false;
            FU.start();
          },
        });
      }
    },
  };

  function onFiles(files) {
    var $Queue = $('<div/>').prependTo('#preview');
    FileAPI.each(files, function(file) {
      if (file.size >= 25 * FileAPI.MB) {
        alert('Sorrow.\nMax size 25MB');
      }
      else if (file.size === void 0) {
        $('#oooops').show();
        $('#buttons-panel').hide();
      }
      else {
        $Queue.append(tmpl($('#b-file-ejs').html(), { file: file, icon: FU.icon }));
        FU.add(file);
        FU.start();
      }
    });
  }

  $(document)
      .on('click', '.js-abort', function(evt) {
        FU.abort($(evt.target).closest('.js-file').attr('id').split('-')[1]);
        evt.preventDefault();
      })
  ;
}); // ready

