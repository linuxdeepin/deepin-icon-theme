<template>
  <div> <img class="ai" src="../assets/ai.png" alt="">
    <p class="drop">拖拽svg文件到此进行检查</p>
    <button class="select" @click="select">选择文件</button>
  </div>
</template>

<script>
// const fse = require('fs-extra')
// const { TMPDIR } = require('./bin/conf')
// const {curry} = require('lodash')
const {dialog} = require('electron').remote

export default {
  methods: {
    async select () {
      let svgList = await dialog.showOpenDialog({
        title: 'svgCheck',
        properties: [
          'multiSelections'
        ],
        filters: [
          {name: 'Images', extensions: ['svg']}
        ]
      })
      this.$store.commit('setSvgList', Array.from(svgList))
      this.$router.push('/check')
      this.$store.dispatch('checkSvg')
    }
  }
}
</script>

<style>
body {
  width: 100vw;
  height: 100vh;
  margin: 0;
}
#app {
  width: 100vw;
  height: 100vh;
   margin: 0;
}
img.ai {
  width: 84px;
  height: 104px;
  position: absolute;
  top: 170px;
  left: 298px;
}

p.drop {
  position: absolute;
  top: 310px;
  left: 270.5px;
  font-size: 12px;
  line-height: 1.25;
  text-align: center;
  color: #6a6a6a;
}

button.select {
  cursor: pointer;
  position: absolute;
  left: 306px;
  bottom: 151px;
  width: 60px;
  height: 18px;
  font-size: 12px;
  text-align: right;
  color: #0066ed;
  background: transparent;
  border: none;
}
button.select:focus {
    outline-color: white;
}
</style>
