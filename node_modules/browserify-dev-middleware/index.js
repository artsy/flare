const PrettyError = require('pretty-error')
const _ = require('underscore')
const beep = require('beepbeep')
const browserify = require('browserify')
const errorify = require('errorify')
const debug = require('debug')('browserify-dev-middleware')
const extname = require('path').extname
const fs = require('fs')
const notifier = require('node-notifier')
const watchify = require('watchify')

const pe = new PrettyError()
const watchers = {}
const cached = {}

const bundleAndCache = (w, path) => {
  w.bundle((err, src) => {
    if (err) {
      console.log(pe.render(new Error(err.message)))

      // Send error to browser console
      cached[path] = `
        if (typeof window !== 'undefined') {
          console.warn('Error bundling file: ${path}')
          console.error('${err.message}')
        }
      `

      notifier.notify({
        'title': 'Browserify compile error!',
        'message': 'Check terminal console for more info.'
      })

      beep(2)
      w.emit('error')
    } else {
      cached[path] = src.toString()
      console.log('[Bundled] ' + path)
    }
  })
}

module.exports = (options) => (req, res, next) => {
  if (extname(req.url) === '.js') {
    debug('Bundling ' + req.url)

    // Make sure the source file exists
    let path = options.src + req.url
    fs.exists(path, (exists) => {
      if (!exists) path = options.src + req.url.replace('.js', '.coffee')
      fs.exists(path, (exists) => {
        if (!exists) return next()

        let w

        // Create a new bundle & watcher if we haven't done so. Then start
        // and initial bundling.
        if (!watchers[path]) {
          const b = browserify(_.extend(_.omit(options,
            'transforms', 'globalTransforms', 'src'
          ), watchify.args))

          b.add(path)

          const transforms = options.transforms || []
          transforms.forEach((t) => {
            b.transform(t)
          })

          const globalTransforms = options.globalTransforms || []
          globalTransforms.forEach((t) => {
            b.transform({ global: true }, t)
          })

          if (options.intercept) options.intercept(b)
          w = watchers[path] = watchify(b)
          bundleAndCache(w, path)
          // Re-bundle & cache the output on file change
          w.on('update', () => {
            cached[path] = null
            bundleAndCache(w, path)
          })
        } else {
          w = watchers[path]
        }

        // Serve cached asset if it hasn't change
        if (cached[path]) {
          debug('Finished bundling ' + req.url)
          res.send(cached[path])
        } else {
          const end = _.once(() => {
            setTimeout(() => {
              debug('Finished bundling ' + req.url)
              res.send(cached[path])
            })
          })
          w.once('time', end) // .once('error', end);

          // Don't exit process on error so that we can fix and continue
          w.on('error', debug)
        }
      })
    })
  } else {
    return next()
  }
}
