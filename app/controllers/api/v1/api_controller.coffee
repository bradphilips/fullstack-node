Controller = require("../../controller")
_ = require('lodash')
Rx = require('Rx')

class ApiController extends Controller

  constructor: ->
    super()
    this.router.get '/', this.index

  index: (req, res) ->
    res.json { apiresponse: "your data here.  make some models" }

module.exports = ApiController
