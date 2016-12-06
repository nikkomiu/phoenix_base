import "phoenix_html"

global.$ = global.jQuery = require('jquery')
global.Tether = require('tether')
require('turbolinks').start()

require('bootstrap')

// Page Load
document.addEventListener("turbolinks:load", function() {
  $('.alert').on('click', function() {
    $(this).alert('close');
  });
});

// import socket from "./socket"
