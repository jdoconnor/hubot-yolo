# Description:
#   Presents the user with a random image of living only once when the word 'yolo' is used
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   saying yolo triggers an image of only living once.
#
# Notes
#   none
#
# Author:
#   Brian Boyle github bboyle87

module.exports = (robot) ->
  robot.hear /yolo/i, (msg) ->
    msg.send msg.random images

images = [
  'http://grossify.com/wp-content/uploads/2013/04/Say-Yolo-Again.png',
  'http://teeninja.com/wp-content/uploads/2013/11/yolo-2.jpg',
  'http://thegrumpygiraffe.files.wordpress.com/2013/06/yolo.jpg',
  'http://1.bp.blogspot.com/-58AWwFPtu7I/UFdcYHAzOtI/AAAAAAAAB9s/bp5_dw4ghUk/s1600/Yolo.png',
  'http://thelavisshow.files.wordpress.com/2012/06/yolo7-300x300.jpg',
  'http://2.bp.blogspot.com/-T3fKpto_I_k/UDVhAgTlAMI/AAAAAAAAAbY/B6N046fN7gM/s1600/yolo-t-shirts.jpeg',
  'http://www.costaricantimes.com/wp-content/uploads/2012/12/yolo-2.jpg',
  'http://www.monkeyfrolic.com/show-image/?img=/wp-content/uploads/2014/05/jeopardy-yolo-is-actually-short-for-this.jpg'
]
