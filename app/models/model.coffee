Database = require('../db/database')
_ = require('lodash')

SampleModelDao = Database.getInstance().define('sample', {},
  {
    instanceMethods: {
      toJSON: () ->
        attributes = _.extend(this.dataValues, {})
        _.each(attributes, (key, value) ->
          if _.has(value, 'toJSON')
            attributes[key] = value.toJSON()
        )

        return attributes
    }
  }
)

class Sample

Sample = _.extend(SampleModelDao, Sample)
module.exports = Sample
