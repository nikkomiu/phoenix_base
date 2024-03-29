import "phoenix_html"

require('turbolinks').start()

global.$ = global.jQuery = require('jquery')
global.Tether = require('tether')
require('jquery.ns-autogrow')
require('bootstrap')

// Page Load Event Handler
$(document).on("turbolinks:load", function() {
  $('.alert').on('click', function() {
    $(this).alert('close');
  });

  $('textarea.form-control').autogrow({
    vertical: true,
    horizontal: false,
    flickering: false
  });
});

// import Timer from "./timer"
// const pageTimers = new Timer({listener: 'turbolinks:load'});

// import socket from "./socket"
