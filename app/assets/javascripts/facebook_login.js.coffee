exports = @
exports.FacebookLogin =
  checkLoginState: ->
    FB.getLoginStatus (response) ->
      if response.status is 'connected'
        location.reload()

window.fbAsyncInit = ->
  FB.init
    appId: '677690115647841'
    cookie: true
    xfbml: true
    version: 'v2.0'

  FacebookLogin.checkLoginState()

((d, s, id) ->
  js = undefined
  fjs = d.getElementsByTagName(s)[0]
  return  if d.getElementById(id)
  js = d.createElement(s)
  js.id = id
  js.src = "//connect.facebook.net/en_US/sdk.js"
  fjs.parentNode.insertBefore js, fjs
  return
) document, "script", "facebook-jssdk"