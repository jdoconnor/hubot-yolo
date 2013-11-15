# Description:
#  Setting your mood & viewing other users' current moods on the LED board.
#
#  Commands: 
#    hubot mood me <query>   - Assign your [r,g,b] mood color on the LED board
#    hubot my mood           - Get your current mood
#    hubot <query>'s mood    - Get another user's current mood
#    hubot how's it hangin?  - Get every user's current mood
#
#  Examples: 
#    hubot mood me [255,0,0]
#    hubot Kevin's mood
module.exports = (robot) ->

  # Converts an array in string form to an array
  string_to_array = (string) ->
    string = string.replace(/\[|\]/gi, "")
    string.split(",")

  # Converts an array string with rgb values to a hex (ie. "[r,g,b]" -> #ff0000) 
  rgb_to_hex = (rgb) ->
    # Parse out RGB since array is returned as a string from the cache service
    rgb_array = string_to_array(rgb)
    "#" + component_to_hex(parseInt(rgb_array[0])) + component_to_hex(parseInt(rgb_array[1])) + component_to_hex(parseInt(rgb_array[2]))

  # Converts r / g / or b component to hex value
  component_to_hex = (component) ->
    hex = component.toString(16)
    if hex.length is 1
      "0" + hex
    else
      hex

  snake_case = (string) ->
    string.replace('\'', "").toLowerCase().split(' ').join('_')

  getAmbiguousUserText = (users) ->
    "Be more specific, I know #{users.length} people named like that: #{(user.name for user in users).join(", ")}"

  get_user_mood = (user, current_user, msg) ->

    robot.http("https://api.bellycard.com/api/data/get")
      .query({
        key: "mood_ring_#{user}"
        password: process.env.CACHE_SERVICE_PASSWORD
      })
      .get() (err, res, body) ->
        if err
          msg.send "An error ocurred."
        else
          prefix = ""
          if current_user
            prefix = "You are"
          else
            prefix = "#{user} is" 
          msg.send "#{prefix} feeling: #{rgb_to_hex(body)}"
    
  robot.respond /(mood|md)( me)? (.*)/i, (msg) ->
    rgb = msg.match[3]
    user = snake_case(msg.message.user.name)
    params = 
      key: "mood_ring_#{user}"
      password: process.env.CACHE_SERVICE_PASSWORD
      data: "#{rgb}"

    data = JSON.stringify(params)

    robot.http("https://api.bellycard.com/api/data/set")
      .headers({'content-type': 'application/json'})
      .post(data) (err, res, body) ->
        if err
          msg.send "An error ocurred."
        else
          msg.send "Mood successfully updated to #{rgb_to_hex(rgb)}"

  robot.respond /(my)( mood)/i, (msg) ->
    user = snake_case(msg.message.user.name)
    get_user_mood(user, true, msg)

  robot.respond /(.*)(\'s)( mood)/i, (msg) ->
    name = msg.match[1]
    users = robot.brain.usersForFuzzyName(name)
    if users.length is 1
      user = users[0]
      get_user_mood(snake_case(user.name), false, msg)
    else if users.length > 1
      msg.send getAmbiguousUserText(users)
    else
      msg.send "#{name}? Who the hell is that?"

  robot.respond /(how\'s it hangin?)(.*)/i, (msg) ->
    users = robot.brain.users()
    for key, value of users
      get_user_mood(snake_case(value.name), false, msg)
       
