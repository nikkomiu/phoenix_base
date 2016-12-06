import "phoenix_html"

import Timer from "./timer"
const pageTimers = new Timer({listener: 'turbolinks:load'});

// Start Turbolinks
require('turbolinks').start()

global.$ = global.jQuery = require('jquery')
global.Tether = require('tether')
require('bootstrap')

// Page Load Event Handler
document.addEventListener("turbolinks:load", function() {
  $('.alert').on('click', function() {
    $(this).alert('close');
  });
});

// import socket from "./socket"
