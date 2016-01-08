Express = require("express.io")
Path = require("path")
Favicon = require("serve-favicon")
Logger = require("morgan")
CookieParser = require("cookie-parser")
BodyParser = require("body-parser")
Sass = require('node-sass-middleware')
Https = require('https')
Compression = require('compression')
FileSystem = require('fs')

class Application
  _app = null
  _options = null

  constructor:(options) ->
    _app = new Express()
    _app.http().io()
    _options = options

    this.configure()

  configure: () ->
    console.log("Options: ")
    console.log(_options)

    if !_options.port
      _options.port = process.env.PORT || 8000

    this._setupViewEngine()

  _setupViewEngine: () ->
    # view engine setup
    _app.set "views", Path.join(__dirname, _options.viewDirectory ||= "views")
    _app.set "view engine", _options.viewEngine ||= "jade"
    _app.set "json spaces", 0

    _app.use new Favicon(__dirname + (_options.favicon ||= '/public/images/favicon.ico'))
    _app.use new Logger(_options.environment ||= "dev")
    _app.use new BodyParser.json()
    _app.use new BodyParser.urlencoded( { extended: true } )
    _app.use new CookieParser()
    _app.use new Compression()

    _app.use Express.session({ secret: '47ffe4924a549793cd4915353d454f95ec2d19cfceb199c90c36ef76e77a8b6964d632bd29d24c2829fe6b368b615db21f7f490872ae53cdfd64f0c09eaab844' })
    _app.use Express.csrf()

    _app.use Sass {
      src: __dirname + '/assets',
      dest: __dirname + '/public',
      outputStyle: 'compressed'
    }
    _app.use Express.static(Path.join(__dirname, (_options.public ||= "public")))
    _app.locals _options

  configureErrorHandlers: () ->
    #/ catch 404 and forward to error handler
    _app.use (req, res, next) ->
      err = new Error("Not Found")
      err.status = 404
      next err
      return

    # development error handler
    # will print stacktrace
    if _app.get("env") is "development"
      _app.use (err, req, res, next) ->
        res.status err.status or 500
        res.render "common/error",
          message: err.message
          error: err
        return

    # production error handler
    # no stacktraces leaked to user
    _app.use (err, req, res, next) ->
      res.status err.status or 500
      res.render "common/error",
        message: err.message
        error: {}
      return

  start: () ->
    options = {
    }
    @server = Https.createServer(options, _app)

    port = process.env.PORT || _options.port 
    console.log "Running application on port #{port}"
    _app.listen port

  addRoute: (route, module) ->
    _app.use route, module.router

module.exports = Application
