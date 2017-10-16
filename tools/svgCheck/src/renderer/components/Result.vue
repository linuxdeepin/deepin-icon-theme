<template>
  <div>
    <div class="result" v-show="!badSvgListLength"> <img class="result-success" src="../assets/success.svg" alt="">
      <p class="result-tip">恭喜您，没有发现有问题的svg文件</p>
      <div style="text-align:center">
        <button class="block-button" @click="$router.push('/')">完成</button>
      </div>
    </div>
    <div class="result" v-show="!!badSvgListLength"> <img class="result-success" src="../assets/warning.svg" alt="">
      <p class="result-tip">发现 {{badSvgListLength}} 个有问题的svg文件</p>
      <div style="text-align:center">
        <button class="block-button" @click="$router.push('/ResultView')">查看</button>
      </div>
    </div>
  </div>
</template>
<script>
export default {
  computed: {
    badSvgListLength () {
      return this.$store.state.svgList.badSvgList.length
    }
  }
}
</script>
<style>
.result-success {
  margin-top: 174px;
  margin-left: 276px;
  width: 128px;
  height: 128px;
}

.result-tip {
  font-size: 14px;
  text-align: center;
  color: #000000;
}


.block-button {
  text-align: center;
  margin-top: 110px;
  width: 310px;
  height: 36px;
  border-radius: 4px;
  background-color: white;
  border: solid 1px #4fbaff;
  color: #4fbaff;
}

.block-button:hover {
  background-image: linear-gradient(to bottom, #88ceff, #4fbaff);
  color: whitesmoke;
}

.block-button:active {
  background: #2ca7f8;
  color: whitesmoke;
}
</style>
