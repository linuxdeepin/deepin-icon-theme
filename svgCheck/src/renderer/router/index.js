import Vue from 'vue'
import Router from 'vue-router'

Vue.use(Router)

export default new Router({
  routes: [
    {
      path: '/',
      name: 'landing-page',
      component: require('../components/LandingPage').default
    },
    {
      path: '/check',
      name: 'check-page',
      component: require('../components/Check').default
    },
    {
      path: '/result',
      name: 'result-page',
      component: require('../components/Result').default
    },
    {
      path: '/resultView',
      name: 'resultView-page',
      component: require('../components/ResultView').default
    },
    {
      path: '*',
      redirect: '/'
    }
  ]
})
