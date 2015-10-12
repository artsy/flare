module.exports = function xFrameOptions(value) {
  value = value || 'Deny'

  return function (req, res, next) {
    res.setHeader('X-Frame-Options', value)
    next()
  }
}
