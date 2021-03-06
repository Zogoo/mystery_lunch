import Vue from "vue";
import Router from "vue-router";

const routerOptions = [
  { path: "/", component: "Landing" },
  { path: "/signin", beforeEnter(to, from, next) {
      window.location.replace("/users/sign_in")
    }
  },
  { path: "/about", component: "AboutUs" },
  { path: "*", component: "NotFound" }
];

const routes = routerOptions.map(route => {
  return {
    ...route,
    component: () => import(`../views/${route.component}.vue`)
  };
});

Vue.use(Router);

export default new Router({
  routes
});
