<template>
<div :class="{'dark':dark}" class="result-view">
  <p class="top-svgName">{{svgName(badSvgList[cursor].svgPath)}}</p>
  <div @click="showList = false" class="image-differ">
    <div class="chromeSvg">
      <p>
        <span>chrome渲染</span>
      </p>
      <img :width="scalaPx" :height="scalaPx" :src="'file://'+badSvgList[cursor].svgPath" alt="">
    </div>
    <div class="dtkPng">
        <p><span>dtk渲染</span> </p>
    <img :width="scalaPx" :height="scalaPx" :src="'file://'+badSvgList[cursor].dtkPngPath" alt="">
    </div>
  </div>
  <div class="control">
    <img @click="previous" class="previous-img" :src="dark ? 'static/previous_dark.png' : 'static/previous.svg'" alt="">
    <img @click="next" class="next-img" :src="dark ? 'static/next_dark.png' : 'static/next.svg'" alt="">
    <img @click="scale = 50" class="img1_1" :src="dark ? 'static/1:1_dark.svg' : 'static/1:1.svg'" alt="">
    <img @click="scale -= 10" :src="dark ? 'static/zoom_out_dark.svg' : 'static/zoom_out.svg'" alt="">
    <input id="scaleRange" v-model="scale" type="range">
    <img @click="scale += 10" class="zoom_in" :src="dark? 'static/zoom_in_dark.svg' : 'static/zoom_in.svg'" alt="">
    <img @click="dark = !dark" :src="dark ? 'static/light.svg' : 'static/dark.svg'" alt="">
    <span class="result-count">{{cursor + 1}}/{{badSvgList.length}}</span>
    <img @click="showList = !showList" class="list" :src="dark ? 'static/list_dark.svg' : 'static/list.svg'" alt="">
  </div>
  <transition name="fade">
    <div v-show="showList" :class="{'dark':dark}"  class="badList" >
      <div @click="cursor = index" v-for="(svg,index) in badSvgList" :key="svg.dtkPngPath">
        <img :src="'file://'+svg.svgPath" alt="">
        <span :class="{'dark':dark}">{{svgName(svg.svgPath)}}</span>
      </div>
    </div>
  </transition>
</div>
 
</template>
<script>
import {mapState} from 'vuex'
import path from 'path'

export default {
  data () {
    return {
      scale: 50,
      inputRange: {},
      cursor: 0,
      scalaPx: 200,
      showList: false,
      dark: false
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
      this.inputRange.style.background = `linear-gradient(to right, #2ca7f8 0%,#2ca7f8 ${newValue}%, 
        ${this.dark ? '#3f3f3f' : '#a4a4a4'}  ${newValue}% ,
        ${this.dark ? '#3f3f3f' : '#a4a4a4'})`
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
      this.cursor = cursor >= badSvgList.length - 1 ? 0 : cursor + 1
    },
    svgName (name) {
      return path.parse(name).base
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
.dark {
  background-color: #101010 !important;
  color: white !important;
}
.dark .badList>div{
  box-shadow: inset 0 -1px 0 0 rgba(228, 224, 224, 0.24);
}
.dark.result-view>.control{
  box-shadow: inset 0 1px 0 0 rgba(228, 224, 224, 0.24);
}
.top-svgName {
  margin: 0 auto;
  margin-top: 8px;
  font-size: 12px;
  text-align: center;
}
.badList{
  overflow-x: hidden;
  box-shadow: -1px 0 0 0 rgba(0, 0, 0, 0.1);
  background-color: white;
  position: fixed;
  right: 0px;
  height: 483px;
  width: 225px;
}
.badList>div{
  cursor: pointer;
  white-space: nowrap;
  overflow: hidden;
  width: 216px;
  height: 40px;
  box-shadow: inset 0 -1px 0 0 rgba(0, 0, 0, 0.05);
}
.badList>div>span{
  height: 18px;
  font-size: 12px;
  text-align: left;
  color: #303030;
}
.badList>div>img{
  margin-left: 8px;
  border: solid 1px rgba(0, 0, 0, 0.1);
  position: relative;
  top: 7px;
  width: 24px;
  height: 24px;
}
.result-view {
  width: 100%;
  height: 100%;
  display: flex;
  align-content: space-around;
  flex-wrap: wrap;
}
.image-differ>div{
  box-shadow: inset 0 -1px 0 0 rgba(0, 0, 0, 0.05);
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
  /* background-color: rgba(125, 125, 125, 0.1); */
  font-size: 12px;
  /* color: #8c8c8c; */
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
  height: 462px;
}
.previous-img {
  width: 25px;
  height: 24px;
  margin-top: 14px;
  margin-left: 18px;
  margin-right: 3px
}
.next-img {
  width: 25px;
  height: 24px;
  margin-top: 14px;
}
.img1_1 {
  margin-left: 37px;
  margin-right: 5px;
}
.zoom_in{
  margin-right: 8px
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
  box-shadow: inset 0 -1px 0 0 rgba(0, 0, 0, 0.05);
  display: flex;
  justify-content: space-around;
  height: 52px;
}
.result-view .list {
  margin-top: 2px;
  margin-left: 11px;
}
.result-view .result-count,.rate{
  margin-top: 19px;
  margin-left: 33px;
  height: 18px;
  font-size: 12px;
  text-align: right;
  color: #878787;
}
</style>
