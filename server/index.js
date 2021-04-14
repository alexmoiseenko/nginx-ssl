webSocketServer = require('ws')

const wss = new webSocketServer.Server({ port: 4000 })

wss.on('connection', ws => {
  ws.on('message', message => {
    console.log(`Received message => ${message}`)
  })
  ws.send('ho!')
})