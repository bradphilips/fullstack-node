Controller = require("./controller")

class Index extends Controller

  constructor: ->
    super()
    this.router.get '/', this.index

  index: (req, res) ->
    res.render "index"
    return

module.exports = Index