<template>
  <div class="result-view">
    <div class="image-differ">
      <div class="chromeSvg">
        <p><span>chrome渲染</span> </p>
        <img :width="scalaPx" :height="scalaPx" :src="'file://'+badSvgList[cursor].svgPath" alt="">
      </div>
      <div class="dtkPng">
        <p><span>dtk渲染</span> </p>
        <img :width="scalaPx" :height="scalaPx" :src="'file://'+badSvgList[cursor].dtkPngPath" alt="">
      </div>
    </div>
    <div class="control">
      <img @click="previous" class="previous-img" src="/src/renderer/assets/previous.svg" alt="">
      <img @click="next" src="/src/renderer/assets/next.svg" alt="">
      <img @click="scale = 50" class="img1_1" src="/src/renderer/assets/1:1.svg" alt="">
      <img @click="scale -= 10" src="/src/renderer/assets/zoom_out.svg" alt="">
      <input id="scaleRange" v-model="scale" type="range">
      <img @click="scale += 10" class="zoom_in" src="/src/renderer/assets/zoom_in.svg" alt="">
      <img src="/src/renderer/assets/dark.svg" alt="">
      <span class="rate">{{(badSvgList[cursor].result.rate*100).toFixed(1)}}%</span>
      <span class="result-count">{{cursor + 1}}/{{badSvgList.length}}</span>
      <img @click="showList" class="list" src="/src/renderer/assets/list.svg" alt="">
    </div>
    <div v-show="showList" class="badList">
      <div>
        
      </div>
    </div>
  </div>
</template>
<script>
import {mapState} from 'vuex'
export default {
  data () {
    return {
      scale: 50,
      inputRange: {},
      cursor: 0,
      scalaPx: 200,
      showList: false
    }
  },
  computed: {
    ...mapState({
      badSvgList: state => state.svgList.badSvgList
    })
  },
  watch: {
    scale (newValue) {
      if (newValue > 100 || newValue < 10) {
        this.scale = newValue > 100 ? 100 : 10
        return
      }
      this.inputRange.style.background = `linear-gradient(to right, #2ca7f8 0%,#2ca7f8 ${newValue}%, #a4a4a4 ${newValue}% ,#a4a4a4)`
      this.scalaPx = newValue * 4 // ( 原图的大小是 200 也就是说当newvaluee为 50 的时候 px 是200,也就是 4倍的关系)
    }
  },
  methods: {
    previous () {
      let {cursor, badSvgList} = this
      this.cursor = cursor <= 0 ? badSvgList.length - 1 : cursor - 1
    },
    next () {
      let {cursor, badSvgList} = this
      this.cursor = cursor >= badSvgList.length ? 0 : cursor + 1
    }
  },
  mounted () {
    let $ = function (query) {
      return document.querySelector(query)
    }
    this.inputRange = $('#scaleRange')
  }
}
</script>
<style>
.result-view {
  width: 100%;
  height: 100%;
  display: flex;
  align-content: space-around;
  flex-wrap: wrap;
}
.image-differ>div{
    display: flex;
  flex-wrap: wrap;
  align-content: center;
  justify-content:center;
  width: 100%;
  text-align: center;
}
.image-differ>div>p{
  width: 100%;
}
.image-differ>div>p>span{
  display: inline;
  background-color: rgba(125, 125, 125, 0.1);
  font-family: SourceHanSansSC;
  font-size: 12px;
  color: #8c8c8c;
}
.result-view img {
  cursor: pointer;
}
.image-differ {
  display: flex;
  flex-wrap: nowrap;
  align-content: center;
  justify-content:center;
  width: 100%;
  height: 486px;
}
.previous-img {
  margin-left: 18px;
  margin-right: 3px
}
.img1_1 {
  margin-left: 37px;
  margin-right: 5px;
}
.zoom_in{
  margin-right: 8px
}
.list {
  margin-left: 3px;
  margin-top: 5px;
}
input[type=range] {
   height: 2px;
  -webkit-appearance: none;
  width: 322px;
  margin-left: 8px;
  margin-top: 25px;
  margin-right: 8px;
  background: linear-gradient(to right,#4fbaff 0%, #2ca7f8 50%,#a4a4a4 50%, #a4a4a4 100%)
}
input[type='range']::-webkit-slider-runnable-track{  
    background-color: #eee;
}
input[type=range]:focus {
    outline: none;
}
input[type=range]::-webkit-slider-thumb {
    -webkit-appearance: none;
    height: 16px;

    width: 16px;
    margin-top: -8px;
    background: #ffffff; 
    border-radius: 50%; 
    border: solid 1px #cecece; 
}
input[type='range']::-webkit-slider-runnable-track{
    height: 2px;
    background: transparent;
}
.result-view>.control {
  display: flex;
  justify-content: space-around;
  height: 52px;
}
.result-view .result-count,.rate{
  margin-top: 19px;
  margin-left: 5px;
  height: 18px;
  font-family: SourceHanSansSC;
  font-size: 13px;
  text-align: right;
  color: #878787;
}
</style>
