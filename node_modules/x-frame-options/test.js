var xFrameOptionsHeader = require('./')
  , request = require('supertest')
  , express = require('express')

describe('X-Frame-Options header middleware', function () {

  it('should add the header to all responses', function (done) {
    var app = express()
    app.use(xFrameOptionsHeader())

    request(app)
      .get('/')
      .expect('X-Frame-Options', 'Deny')
      .end(function (err) {
        if (err) throw err
        done()
      })
  })

  it('should allow the value to be overridden', function (done) {
    var app = express()
    app.use(xFrameOptionsHeader('Sameorigin'))

    request(app)
      .get('/')
      .expect('X-Frame-Options', 'Sameorigin')
      .end(function (err) {
        if (err) throw err
        done()
      })
  })

})
