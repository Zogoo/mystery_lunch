import Vue from 'vue'
import Home from '../views/Home.vue'
import Vuetify from "vuetify";
import "vuetify/dist/vuetify.min.css";
import '@mdi/font/css/materialdesignicons.css'
import router from "../routes/routes";

document.addEventListener('DOMContentLoaded', () => {

  Vue.use(Vuetify);
  const vuetify = new Vuetify();

  Vue.config.productionTip = process.env.NODE_ENV == "production";
  const app = new Vue({
    router,
    vuetify,
    render: h => h(Home)
  }).$mount()

  document.body.appendChild(app.$el)

  console.log(app)
})