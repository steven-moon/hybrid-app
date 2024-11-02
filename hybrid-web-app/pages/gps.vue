<template>
  <v-app>
    <v-container>
      <v-card class="mx-auto" max-width="400">
        <v-card-title>GPS</v-card-title>
        <v-btn class="pa-5" @click="getLocation">Get Current Location</v-btn>
        <div v-if="latitude && longitude" class="pa-5">
          <h3>Current Location:</h3>
          <p>Latitude: {{ latitude }}</p>
          <p>Longitude: {{ longitude }}</p>
        </div>
        <div v-if="errorMessage" class="pa-5">
          <p style="color: red;">Error: {{ errorMessage }}</p>
        </div>
      </v-card>
    </v-container>
  </v-app>
</template>

<script>
export default {
  data() {
    return {
      latitude: null,
      longitude: null,
      errorMessage: null,
    };
  },
  methods: {
    getLocation() {
      if (
        window.webkit &&
        window.webkit.messageHandlers &&
        window.webkit.messageHandlers.getLocation
      ) {
        // Send message to iOS app to get location
        window.webkit.messageHandlers.getLocation.postMessage(null);
      } else {
        this.errorMessage = "Location services not available.";
      }
    },
    receiveLocation(latitude, longitude) {
      this.latitude = latitude;
      this.longitude = longitude;
      this.errorMessage = null;
    },
    locationError(message) {
      this.errorMessage = message;
    },
  },
  mounted() {
    // Expose the receiveLocation and locationError functions to the global scope
    window.receiveLocation = this.receiveLocation;
    window.locationError = this.locationError;
  },
};
</script>

<style scoped>
button {
  padding: 10px 20px;
  font-size: 16px;
}

h3 {
  margin-top: 20px;
}

p {
  font-size: 18px;
}
</style>