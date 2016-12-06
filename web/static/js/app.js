import "phoenix_html"

require('turbolinks').start()

global.$ = global.jQuery = require('jquery')
global.Tether = require('tether')
require('bootstrap')

import Timer from "./timer"
const pageTimers = new Timer({listener: 'turbolinks:load'});

// Page Load Event Handler
$(document).on("turbolinks:load", function() {
  $('.alert').on('click', function() {
    $(this).alert('close');
  });
});

// import socket from "./socket"
