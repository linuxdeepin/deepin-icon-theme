import { app, BrowserWindow } from 'electron'
import {flow} from 'lodash'
import yargs from 'yargs'
/**
 * Set `__static` path to static files in production
 * https://simulatedgreg.gitbooks.io/electron-vue/content/en/using-static-assets.html
 */
if (process.env.NODE_ENV !== 'development') {
  global.__static = require('path').join(__dirname, '/static').replace(/\\/g, '\\\\')
}

let mainWindow
const winURL = process.env.NODE_ENV === 'development'
  ? `http://localhost:9080`
  : `file://${__dirname}/index.html`

const argv = yargs(process.argv)
  .usage('Usage: $0 -i=[path]')
  .help('h')
  .describe('i', '输入你想检查的 svg 路径')
  .alias('i', 'input')
  .alias('h', 'help')
  .example('$0 -i=/home/feng/fail.svg', 'check the /home/feng/fail.svg')
  .argv

if (argv.help) {
  process.exit(0)
}

function createWindow () {
  /**
   * Initial window options
   */
  mainWindow = new BrowserWindow({
    height: 540,
    useContentSize: true,
    width: 680,
    resizable: false,
    webPreferences: {
      webSecurity: false
    }
  })

  mainWindow.loadURL(winURL)

  mainWindow.on('closed', () => {
    mainWindow = null
  })
}

function svgPathFromCmd () {
  mainWindow.webContents.on('did-finish-load', () => {
    mainWindow.webContents.send('path', argv.i)
  })
}

app.on('ready', flow([
  createWindow, svgPathFromCmd
]))

app.on('window-all-closed', () => {
  if (process.platform !== 'darwin') {
    app.quit()
  }
})

app.on('activate', () => {
  if (mainWindow === null) {
    createWindow()
  }
})

/**
 * Auto Updater
 *
 * Uncomment the following code below and install `electron-updater` to
 * support auto updating. Code Signing with a valid certificate is required.
 * https://simulatedgreg.gitbooks.io/electron-vue/content/en/using-electron-builder.html#auto-updating
 */

/*
import { autoUpdater } from 'electron-updater'

autoUpdater.on('update-downloaded', () => {
  autoUpdater.quitAndInstall()
})

app.on('ready', () => {
  if (process.env.NODE_ENV === 'production') autoUpdater.checkForUpdates()
})
 */
