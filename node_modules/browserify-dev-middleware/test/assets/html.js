module.exports = () => `
  <html>
    <head>
      <script src="/html.js"></script>
    </head>

    <body>
      Hey there!
    </body>
  </html>
`

if (typeof window !== 'undefined') {
  console.log('Howdy mister!!!')
}
