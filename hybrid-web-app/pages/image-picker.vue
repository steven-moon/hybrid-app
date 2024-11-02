<template>
  <v-app>
    <v-container>
      <v-card class="mx-auto" max-width="400">
        <v-card-title>Image Picker</v-card-title>
        <v-btn class="pa-5" @click="openImagePicker">Open Image Picker</v-btn>
        <div v-if="imageSrc" class="pa-5">
      <h3>Selected Image:</h3>
      <img :src="imageSrc" alt="Selected Image" />
        </div>
      </v-card>
    </v-container>
  </v-app>
</template>

<script>
export default {
  data() {
    return {
      imageSrc: null,
    };
  },
  methods: {
    openImagePicker() {
      if (
        window.webkit &&
        window.webkit.messageHandlers &&
        window.webkit.messageHandlers.imagePicker
      ) {
        // Send message to iOS app
        window.webkit.messageHandlers.imagePicker.postMessage(null);
      } else {
        alert("Image picker not available");
      }
    },
    receiveImage(base64String) {
      this.imageSrc = `data:image/jpeg;base64,${base64String}`;
    },
  },
  mounted() {
    // Expose the receiveImage function to the global scope
    window.receiveImage = this.receiveImage;
  },
};
</script>

<style scoped>
button {
  padding: 10px 20px;
  font-size: 16px;
}

img {
  max-width: 100%;
  height: auto;
  margin-top: 20px;
}
</style>