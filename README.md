# Hybrid App Project

This repository contains a hybrid application that combines a Vue/Nuxt web application with an iOS native application using WKWebView. The project demonstrates how to integrate web content into a native app and enable communication between JavaScript and Swift. It includes features such as accessing the device's image picker, obtaining GPS location, and using the native share sheet from the web app.


The repository is organized into two main folders:

* `hybrid-web-app`: Contains the Vue/Nuxt web application.
* `hybrid-ios-app`: Contains the iOS application built with SwiftUI.

## Features

### Hybrid Web App (Vue/Nuxt)

* Image Picker Integration: Allows users to select an image from their photo library and displays it within the web app.
* GPS Location Access: Retrieves the device's current latitude and longitude and displays it on the page.
* Native Share Sheet: Enables users to share text input using the iOS native share sheet.

### Hybrid iOS App (SwiftUI)

* WKWebView Implementation: Embeds the Vue/Nuxt web app within a WKWebView.
* JavaScript and Swift Communication: Utilizes WKScriptMessageHandler to handle messages between JavaScript and Swift.
* Image Picker Access: Presents the native image picker and sends the selected image back to the web view.
* Location Services: Accesses the device's GPS to provide location data to the web app.
* Share Sheet Presentation: Triggers the native iOS share sheet from the web app.




