<template>
  <div id="app">
    <router-view></router-view>
  </div>
</template>

<script>
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

export default {
  name: 'svgcheck',
  mounted () {
    preventEventList.forEach(preventEvent)
    droTragetList.forEach(e => e.addEventListener('drop', event => {
      if (!event.dataTransfer.files.length) {
        return false
      }
      this.$store.commit('setSvgList', Array.from(event.dataTransfer.files).map(x => x.path))
      this.$router.push('/check')
      this.$store.dispatch('checkSvg')
    }))
  }
}
</script>

<style>
.fade-enter-active, .fade-leave-active {
  transition: opacity .3s
}
.fade-enter, .fade-leave-to /* .fade-leave-active in below version 2.1.8 */ {
  opacity: 0
}

body {
  font-family: "Noto Sans CJK SC";
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
