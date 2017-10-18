<template>
  <div id="app">
    <router-view></router-view>
  </div>
</template>

<script>
import {remote, ipcRenderer} from 'electron'
import {accessSync} from 'fs'

const preventEventList = [
  'drop', 'dragover'
]

function preventEvent (eventName) {
  document.body.addEventListener(eventName, event => {
    event.stopPropagation()
    event.preventDefault()
  })
}
const droTragetList = [
  document.body
]
function svgCheckFromPathList (file, {$store, $router}) {
  $store.commit('setSvgList', file)
  $router.push('/check')
  $store.dispatch('checkSvg')
}

export default {
  name: 'svgcheck',
  mounted () {
    let cmdFilePath
    ipcRenderer.on('path', (event, path) => {
      if (path) {
        try {
          cmdFilePath = remote.process.cwd() + '/' + path
          accessSync(cmdFilePath)
        } catch (error) {
          try {
            cmdFilePath = path
            accessSync(cmdFilePath)
          } catch (error) {
            cmdFilePath = ''
            remote.getGlobal('console').log('error path')
          }
        }
      }
      console.log(cmdFilePath)
      cmdFilePath && svgCheckFromPathList([cmdFilePath], this)
    })

    preventEventList.forEach(preventEvent)
    droTragetList.forEach(e => e.addEventListener('drop', event => {
      if (!event.dataTransfer.files.length) {
        return false
      }
      svgCheckFromPathList(Array.from(event.dataTransfer.files.map(x => x.path)), this)
    }))
  }
}
</script>

<style>

body {
  width: 100vw;
  height: 100vh;
  margin: 0;
  overflow: hidden;
}
#app {
  width: 100vw;
  height: 100vh;
  margin: 0;
}
</style>
