<template>
  <v-bottom-navigation grow>
    <v-btn to="/">
      <v-icon>mdi-share</v-icon>
      <span>Share</span>
    </v-btn>

    <v-btn to="/gps">
      <v-icon>mdi-map-marker</v-icon>
      <span>GPS</span>
    </v-btn>

    <v-btn to="/image-picker">
      <v-icon>mdi-image</v-icon>
      <span>Image Picker</span>
    </v-btn>
  </v-bottom-navigation>
</template>
