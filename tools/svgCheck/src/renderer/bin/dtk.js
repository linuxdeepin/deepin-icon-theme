const childProcess = require('child_process')
const path = require('path')
const {TMPDIR} = require('./conf')

function dtkSvgToPng (filePath) {
  return new Promise(function (resolve, reject) {
    let pathObj = path.parse(filePath)
    let pngPath = `${TMPDIR}/${pathObj.name}.png`
    childProcess.execFile('/usr/lib/dtk2/dtk-svgc', [filePath, pngPath, '-s 200x200'],
      (error, result) => {
        error ? reject(error) : resolve(pngPath)
      })
  })
}

export default dtkSvgToPng
