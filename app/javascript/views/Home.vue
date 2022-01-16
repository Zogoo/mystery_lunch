<template>
  <v-bottom-navigation v-model="value">
    <v-btn value="home">
      <span>Home</span>
      <v-icon>mdi-home</v-icon>
    </v-btn>
 
    <v-btn value="account" @click="openAccountUrl()">
      <span>Account</span>
      <v-icon>mdi-account</v-icon>
    </v-btn>
 
    <v-btn value="about">
      <span>About</span>
      <v-icon>mdi-information</v-icon>
    </v-btn>
  </v-bottom-navigation>
</template>

<script>
export default {
  methods: {
    openAccountUrl: function(){
      window.location = '/users'
    },
  }
}
</script>
