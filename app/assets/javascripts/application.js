// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require foundation
//= require_tree .
// $(function () {
//   $(document).foundation();
// });

pageTitleResize = function () {
  if ($("#page-title").length > 0) {
    var fontSize = 300;
    var maxHeight = $("#page-title-container").height() - 40;
    var maxWidth = $("#page-title-container").width() - 25;
    do {
      $("#page-title h1").css('font-size', fontSize + "px");
      fontSize -= 3;
      titleHeight = $("#page-title h1").height();
      titleWidth = $("#page-title h1 span").width();
      bottom = (maxHeight - titleHeight) / 2;
      $("#page-title").css('bottom', bottom + "px");
    } while (titleHeight > maxHeight || titleWidth > maxWidth);
  }
};

$(window).resize(pageTitleResize);
$(document).ready(pageTitleResize);
$(document).on('page:load', pageTitleResize);
