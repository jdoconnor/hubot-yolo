# Description:
#   Get a list of food trucks at 600 W Chicago Ave
#
# Commands:
#   food trucks - show food trucks at 600 W Chicago Ave

jsdom = require "jsdom" 
request = require "request"
_ = require "underscore"

module.exports = (robot) ->
  robot.respond /food trucks/i, (msg) ->
    console.log "Finding the food trucks..."
    request uri: "http://www.chicagofoodtruckfinder.com/locations/56007", (error, response, body) ->
      msg.send "Error when trying to find food trucks =("  if error and response.statusCode isnt 200
      jsdom.env html: body, scripts: ["http://code.jquery.com/jquery-1.5.min.js"], done: (err, window) ->
        $ = window.jQuery
        trucks = $(".media-body")
        result = ""
        _.each trucks, (truck, iterator) ->
          result+=trucks.eq(iterator).text()
        msg.send result


