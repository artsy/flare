# x-frame-options express middleware

Express middleware to add an X-Frame-Options response header

[![build status](https://secure.travis-ci.org/domharrington/x-frame-options.png)](http://travis-ci.org/domharrington/x-frame-options)

The X-Frame-Options header can be used to to indicate whether a browser is allowed to render a page within an `<iframe>` element or not.
This is helpful to prevent clickjacking attacks by ensuring your content is not embedded within other sites.
See more here: [https://developer.mozilla.org/en-US/docs/HTTP/X-Frame-Options](https://developer.mozilla.org/en-US/docs/HTTP/X-Frame-Options).

## Example
``` js
  var express = require('express')
  var app = express()
  var xFrameOptions = require('x-frame-options')

  app.use(xFrameOptions())

  app.get('/', function (req, res) {
    res.get('X-Frame-Options') // === 'Deny'
  })

  app.listen(3000)
```

## Usage
``` js
  var xFrameOptions = require('x-frame-options')
```

### var middleware = xFrameOptions(headerValue = 'Deny')

Returns an express middleware function. Allows you to specify the value of the header, defaults to 'Deny' for the strongest protection.

## Installation

    npm install x-frame-options --save

## Credits
[Dom Harrington](https://github.com/domharrington/)

## License
Licensed under the [New BSD License](http://opensource.org/licenses/bsd-license.php)
