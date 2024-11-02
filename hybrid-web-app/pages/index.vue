<!-- pages/index.vue -->
<template>
  <v-app>
    <v-main>
      <v-container>
        <v-card class="mx-auto" max-width="400">
          <v-card-title>Hybrid Web App</v-card-title>
          <textarea v-model="text" placeholder="Enter text to share" rows="5" cols="40"></textarea>
          <br/>
          <button @click="shareText">Share</button>
        </v-card>
      </v-container>
    </v-main>
  </v-app>
</template>

<script>
export default {
  data() {
    return {
      text: '',
    };
  },
  methods: {
    shareText() {
      if (
        window.webkit &&
        window.webkit.messageHandlers &&
        window.webkit.messageHandlers.shareText
      ) {
        // Send the text to the iOS app to trigger the share sheet
        window.webkit.messageHandlers.shareText.postMessage(this.text);
      } else {
        alert("Sharing is not available.");
      }
    },
  },
};
</script>

<style scoped>
textarea {
  width: 100%;
  max-width: 400px;
  font-size: 16px;
  padding: 10px;
}
button {
  padding: 10px 20px;
  font-size: 16px;
  margin-top: 10px;
}
</style>