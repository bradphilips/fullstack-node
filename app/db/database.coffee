Sequelize = require('sequelize')

class Database
  instance = null

  @getInstance: () ->
    instance ?= new Sequelize(process.env.DATABASE_URL || 'postgres://localhost:5432/database')

module.exports = Database
