import imageToCanvas from '../../bin/svg'
import dtkSvgToPng from '../../bin/dtk'
import {TMPDIR} from '../../bin/conf'
import {curry} from 'lodash'
import {emptyDirSync} from 'fs-extra'
import {isSame} from '../../bin/util'

export default {
  state: {
    list: [],
    resultList: [],
    badSvgList: []
  },
  mutations: {
    setSvgList (state, payload) {
      state.list = payload
    },
    addResult (state, payload) {
      state.resultList.push(payload.result)
      payload.result.rate < 0.9 && state.badSvgList.push(payload)
    },
    initSvgList (state) {
      state.resultList = []
      state.badSvgList = []
    }
  },
  actions: {
    async checkSvg ({commit, state}) {
      commit('initSvgList')
      let jsSvgData, dtkSvgData
      let svgPathList = state.list.map(x => x.path)
      emptyDirSync(TMPDIR)
      for (let svgPath of svgPathList) {
        let dtkPngPath
        try {
          dtkSvgData = await dtkSvgToPng(svgPath).then(function (_) {
            dtkPngPath = _
            return _
          }).then(curry(imageToCanvas)('#dtkCanvas'))
        } catch (error) {
          dtkSvgData = []
          console.log(error)
        }
        jsSvgData = await imageToCanvas('#jsCanvas', svgPath)
        commit('addResult', {
          result: isSame(jsSvgData.data, dtkSvgData.data),
          svgPath,
          dtkPngPath
        })
      }
    }
  }
}
