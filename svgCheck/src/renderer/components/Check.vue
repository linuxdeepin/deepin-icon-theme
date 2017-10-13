<template>
  <div>
    <img v-show="list.length" class="state-img" :src="currentState ? '/src/renderer/assets/ok.svg': '/src/renderer/assets/error.svg'" alt="">
    <div class="canvas-container">
      <canvas id="dtkCanvas" width="200" height="200"></canvas>
      <canvas id="jsCanvas" width="200" height="200"></canvas>
    </div>
    <p class="tip1">正在检查，请稍候...</p>
    <p class="tip2">已检查 {{resultList.length}}/{{list.length}} 个</p>
    <p class="tip3">发现有问题svg文件： {{badSvgList.length}}个</p>
  </div>
</template>
<script>
import {mapState} from 'vuex'
export default {
  computed: {
    ...mapState({
      list: state => state.svgList.list,
      currentState: state => state.svgList.currentState,
      resultList: state => state.svgList.resultList,
      badSvgList: state => state.svgList.badSvgList
    }),
    currentState () {
      this.resultList.length === this.list.length && this.$router.push('/result')
      let last = this.$store.state.svgList.resultList.slice(-1)[0] || {}
      return last.rate > 0.9
    }
  }
}
</script>

<style>
.state-img {
  width: 24px;
  height: 24px;
  position: relative;
  top: 70px;
  left: 328px;
  object-fit: contain;
}
div.canvas-container{ 
  width: 100%;
  position: relative;
   margin-left: 97px;
  top: 120px;
}
div.canvas-container > canvas {
  margin-left: 30px;
}
p.tip1{
  position: relative;
  top: 156px;
  font-family: SourceHanSansSC;
  font-size: 14px;
  text-align: center;
}
p.tip2{
  position: relative;
  top: 146px;
  font-family: SourceHanSansSC;
  font-size: 12px;
  line-height: 1.67;
  text-align: center;
  color: #424242;
}
p.tip3 {
  position: relative;
  top: 140px;
  font-family: SourceHanSansSC;
  font-size: 12px;
  line-height: 1.67;
  text-align: center;
  color: #b36c00;
}
</style>

