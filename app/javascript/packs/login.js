import Vue from 'vue'
import Home from '../views/Login.vue'
import Vuetify from "vuetify";
import "vuetify/dist/vuetify.min.css";
import '@mdi/font/css/materialdesignicons.css'

document.addEventListener('DOMContentLoaded', () => {
  Vue.use(Vuetify);
  const vuetify = new Vuetify();

  Vue.config.productionTip = process.env.NODE_ENV == "production";
  const app = new Vue({
    render: h => h(Home)
  }).$mount()

  document.body.appendChild(app.$el)

  console.log(app)
})