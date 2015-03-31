Application = require('./app/application')
Index = require('./app/controllers/index')
ApiController = require('./app/controllers/api/v1/api_controller')

_application = new Application({
  viewEngine: 'jade',
  title: 'Full Stack Node',
  domain: 'your-domain.com'
})

# website
_application.addRoute '/', new Index()

# api/v1
_application.addRoute '/api/v1', new ApiController()

_application.configureErrorHandlers()
_application.start()
