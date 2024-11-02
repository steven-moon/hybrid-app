import SwiftUI
import WebKit
import UIKit
import CoreLocation

struct WebView: UIViewRepresentable {
    let url: URL

    func makeCoordinator() -> Coordinator {
        Coordinator()
    }

    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()

        // Set up the message handlers
        webView.configuration.userContentController.add(context.coordinator, name: "imagePicker")
        webView.configuration.userContentController.add(context.coordinator, name: "getLocation")
        webView.configuration.userContentController.add(context.coordinator, name: "shareText") // Added this line

        webView.navigationDelegate = context.coordinator
        context.coordinator.webView = webView

        return webView
    }

    func updateUIView(_ webView: WKWebView, context: Context) {
        let request = URLRequest(url: url)
        webView.load(request)
    }

    class Coordinator: NSObject, WKNavigationDelegate, WKScriptMessageHandler, UIImagePickerControllerDelegate, UINavigationControllerDelegate, CLLocationManagerDelegate {
        var webView: WKWebView?
        var locationManager: CLLocationManager?

        // Handle messages from JavaScript
        func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
            if message.name == "imagePicker" {
                DispatchQueue.main.async {
                    self.presentImagePicker()
                }
            } else if message.name == "getLocation" {
                DispatchQueue.main.async {
                    self.startUpdatingLocation()
                }
            } else if message.name == "shareText" {
                if let text = message.body as? String {
                    DispatchQueue.main.async {
                        self.presentShareSheet(with: text)
                    }
                }
            }
        }

        // MARK: - Image Picker Methods

        func presentImagePicker() {
            guard let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                  let viewController = scene.windows.first?.rootViewController else {
                return
            }
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary
            viewController.present(imagePicker, animated: true, completion: nil)
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            picker.dismiss(animated: true, completion: nil)

            if let image = info[.originalImage] as? UIImage {
                sendImageToWebView(image)
            }
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            picker.dismiss(animated: true, completion: nil)
        }

        func sendImageToWebView(_ image: UIImage) {
            if let webView = self.webView {
                if let imageData = image.jpegData(compressionQuality: 0.8) {
                    let base64String = imageData.base64EncodedString()
                    let escapedBase64String = base64String.replacingOccurrences(of: "'", with: "\\'")
                    let jsCode = "receiveImage('\(escapedBase64String)');"
                    webView.evaluateJavaScript(jsCode, completionHandler: { (result, error) in
                        if let error = error {
                            print("Error sending image to web view: \(error)")
                        }
                    })
                }
            }
        }

        // MARK: - Location Methods

        func startUpdatingLocation() {
            if CLLocationManager.locationServicesEnabled() {
                locationManager = CLLocationManager()
                locationManager?.delegate = self
                locationManager?.desiredAccuracy = kCLLocationAccuracyBest
                locationManager?.requestWhenInUseAuthorization()
                locationManager?.startUpdatingLocation()
            } else {
                // Handle location services disabled
                sendLocationErrorToWebView("Location services are disabled.")
            }
        }

        // CLLocationManagerDelegate methods

        func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
            switch status {
            case .authorizedWhenInUse, .authorizedAlways:
                locationManager?.startUpdatingLocation()
            case .denied, .restricted:
                sendLocationErrorToWebView("Location access denied.")
            case .notDetermined:
                locationManager?.requestWhenInUseAuthorization()
            @unknown default:
                sendLocationErrorToWebView("Unknown authorization status.")
            }
        }

        func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            if let location = locations.last {
                sendLocationToWebView(location.coordinate)
                locationManager?.stopUpdatingLocation()
            }
        }

        func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
            sendLocationErrorToWebView("Failed to get location: \(error.localizedDescription)")
        }

        // Send location to the web view

        func sendLocationToWebView(_ coordinate: CLLocationCoordinate2D) {
            if let webView = self.webView {
                let latitude = coordinate.latitude
                let longitude = coordinate.longitude
                let jsCode = "receiveLocation(\(latitude), \(longitude));"
                webView.evaluateJavaScript(jsCode, completionHandler: { (result, error) in
                    if let error = error {
                        print("Error sending location to web view: \(error)")
                    }
                })
            }
        }

        func sendLocationErrorToWebView(_ message: String) {
            if let webView = self.webView {
                let escapedMessage = message.replacingOccurrences(of: "'", with: "\\'")
                let jsCode = "locationError('\(escapedMessage)');"
                webView.evaluateJavaScript(jsCode, completionHandler: { (result, error) in
                    if let error = error {
                        print("Error sending location error to web view: \(error)")
                    }
                })
            }
        }

        // MARK: - Share Sheet Methods

        func presentShareSheet(with text: String) {
            guard let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                  let viewController = scene.windows.first?.rootViewController else {
                return
            }
            let activityViewController = UIActivityViewController(activityItems: [text], applicationActivities: nil)
            viewController.present(activityViewController, animated: true, completion: nil)
        }
    }
}

struct ContentView: View {
    private let webURL = URL(string: "http://localhost:3000")!

    var body: some View {
        NavigationView {
            WebView(url: webURL)
                .navigationBarHidden(true)
        }
    }
}

#Preview {
    ContentView()
}