import Vue from 'vue'
import Home from '../views/Home.vue'
import Vuetify from "vuetify";
import "vuetify/dist/vuetify.min.css";
import '@mdi/font/css/materialdesignicons.css'

document.addEventListener('DOMContentLoaded', () => {

  Vue.use(Vuetify);
  const vuetify = new Vuetify();

  Vue.config.productionTip = process.env.NODE_ENV == "production";
  const app = new Vue({
    vuetify,
    data () {
      return {
        items: [
          { title: 'Home', icon: 'mdi-home-city' },
          { title: 'My Account', icon: 'mdi-account' },
          { title: 'Users', icon: 'mdi-account-group-outline' },
        ],
      }
    },
    render: h => h(Home)
  }).$mount()

  document.body.appendChild(app.$el)

  console.log(app)
})