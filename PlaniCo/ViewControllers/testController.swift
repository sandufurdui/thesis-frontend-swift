////
////  testController.swift
////  PlaniCo
////
////  Created by Sandu Furdui on 24.02.2023.
////
//
//




import UIKit

class TestController: UIViewController {
 

        var loadingView: UIView!
        var stopButton: UIButton!

        override func viewDidLoad() {
            super.viewDidLoad()

            // Set up the loading view
            loadingView = UIView(frame: view.bounds)
            loadingView.backgroundColor = .white
            let activityIndicator = UIActivityIndicatorView(style: .gray)
            activityIndicator.center = loadingView.center
            loadingView.addSubview(activityIndicator)
            view.addSubview(loadingView)
            loadingView.isHidden = true

            // Set up the start button
            let startButton = UIButton(type: .system)
            startButton.setTitle("Start Loading", for: .normal)
            startButton.addTarget(self, action: #selector(startLoading), for: .touchUpInside)
            view.addSubview(startButton)
            startButton.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                startButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                startButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -30)
            ])

            // Set up the stop button
            stopButton = UIButton(type: .system)
            stopButton.setTitle("Stop Loading", for: .normal)
            stopButton.addTarget(self, action: #selector(stopLoading), for: .touchUpInside)
            view.addSubview(stopButton)
            stopButton.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                stopButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                stopButton.topAnchor.constraint(equalTo: startButton.bottomAnchor, constant: 20)
            ])
            stopButton.isHidden = true
        }

        @objc func startLoading() {
            // Show the loading view and start the activity indicator
            loadingView.isHidden = false
            if let activityIndicator = loadingView.subviews.first as? UIActivityIndicatorView {
                activityIndicator.startAnimating()
            }

            // Show the stop button and hide the start button
            stopButton.isHidden = false
            stopButton.isEnabled = true
            if let startButton = view.subviews.first(where: { $0 is UIButton && $0 != stopButton }) as? UIButton {
                startButton.isHidden = true
            }

            // Do some time-consuming task
            DispatchQueue.global(qos: .userInitiated).async {
                // Simulate a time-consuming task
                Thread.sleep(forTimeInterval: 100.0)

                // Hide the loading view and stop the activity indicator on the main thread
                DispatchQueue.main.async {
                    self.loadingView.isHidden = true
                    if let activityIndicator = self.loadingView.subviews.first as? UIActivityIndicatorView {
                        activityIndicator.stopAnimating()
                    }

                    // Hide the stop button and show the start button
                    self.stopButton.isHidden = true
                    if let startButton = self.view.subviews.first(where: { $0 is UIButton && $0 != self.stopButton }) as? UIButton {
                        startButton.isHidden = false
                    }
                }
            }
        }

        @objc func stopLoading() {
            // Hide the loading view and stop the activity indicator
            loadingView.isHidden = true
            if let activityIndicator = loadingView.subviews.first as? UIActivityIndicatorView {
                activityIndicator.stopAnimating()
            }

            // Hide the stop button and show the start button
            stopButton.isHidden = true
            if let startButton = view.subviews.first(where: { $0 is UIButton && $0 != stopButton }) as? UIButton {
                startButton.isHidden = false
            }
        }
    }





//import SwiftUI
//
//enum AlertType {
//    case generalError(description: String)
//    case invalidResponse(description: String)
//    case notHTTP200(description: String)
//    case HTTP200(description: String)
////    case receiptAlert(description: String, type: String)
//}
//
//
//class LoadingState: ObservableObject {
//    @Published var isLoading = false
//    @Published var showAlert = false
//    @Published var alertType: AlertType? = nil
//}
//
//
//
//struct TestController: View {
//    @StateObject var loadingState = LoadingState()
//    @State private var showScanner = false
//    @ObservedObject var recognizedContent = RecognizedContent()
//    @State private var isRecognizing = false
//    private func dismissScannerView() {
//        self.showScanner = false
//    }
//
//    var body: some View {
//        ZStack {
//            VStack {
//                Text("Hello")
//                    .padding()
//                Button("Scan") {
//                    showScanner.toggle()
//                }
//                .padding()
//                .foregroundColor(Color.white)
//                .background(Color("AccentColor"))
//                .cornerRadius(10)
//
//
//                Button("show alert") {
//                    loadingState.alertType = .invalidResponse(description: "could not receive response")
//                    loadingState.showAlert = true
//                }
//                .padding()
//                .foregroundColor(Color.white)
//                .background(Color("AccentColor"))
//                .cornerRadius(10)
//            }
//            if loadingState.isLoading {
//                ZStack {
//                    Color.gray.opacity(0.7).ignoresSafeArea()
//
//                    VStack {
//                        ProgressView()
//                            .progressViewStyle(CircularProgressViewStyle())
//                            .scaleEffect(2.0)
//                            .padding()
//                    }
//                }
//            }
//        }
//        .alert(isPresented: $loadingState.showAlert) {
//            switch loadingState.alertType {
//            case .generalError(let description):
//                return Alert(title: Text("Error"), message: Text(description), dismissButton: .default(Text("OK")))
//            case .invalidResponse(let description):
//                return Alert(title: Text("Invalid Response"), message: Text(description), dismissButton: .default(Text("OK")))
//            case .notHTTP200(let description):
//                return Alert(title: Text("Error"), message: Text(description), dismissButton: .default(Text("OK")))
//            case .HTTP200(let description):
//                return Alert(title: Text("Success"), message: Text(description), dismissButton: .default(Text("OK")))
//            case .custom(let inputText):
//                Alert(title: Text("Enter Text"), message: nil, primaryButton: .default(Text("OK"), action: {
//                            // Perform some action with the inputText value
//                            print("Entered text: \(inputText)")
//                        }), secondaryButton: .cancel(), dismissButton: .default(Text("Dismiss"))) {
//                            // Add a text field input to the alert
//                            TextField("Enter Text", text: $inputText)
//                        }
//
//
//
//            case .none:
//                return Alert(title: Text(""), message: Text(""), dismissButton: .default(Text("OK")))
//            }
//        }
//
//        .sheet(isPresented: $showScanner) {
//
//            ScannerView { result in
//                switch result {
//                case .success(let scannedImages):
//                    self.isRecognizing = true
//                    DispatchQueue.main.async {
//                        loadingState.isLoading = true
//                    }
//
//                    TextRecognition(scannedImages: scannedImages, recognizedContent: self.recognizedContent) {
//                        self.isRecognizing = false
//                    }
//                    .recognizeText() { recognizedText in
//                        print(recognizedText)
//                        let url = URL(string: "https://thesis-backend-23143.onrender.com/process_data")!
//                        var request = URLRequest(url: url)
//                        request.httpMethod = "POST"
//                        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//                        let json = ["raw_text": recognizedText]
//                        let jsonData = try! JSONSerialization.data(withJSONObject: json, options: [])
//                        request.httpBody = jsonData
//
//                        let task = URLSession.shared.dataTask(with: request) { data, response, error in
//                            DispatchQueue.main.async {
//                                loadingState.isLoading = false
//                            }
//                            if let error = error {
//                                loadingState.alertType = .generalError(description: "Fatal error, crashing everything, ruuuuun")
//                                loadingState.showAlert = true
//                                print("Error: \(error.localizedDescription)")
//                                return
//                            }
//
//                            guard let data = data, let response = response as? HTTPURLResponse else {
//                                DispatchQueue.main.async {
//                                    loadingState.alertType = .invalidResponse(description: "could not receive response")
//                                    loadingState.showAlert = true
//                                }
//                                print("Invalid response")
//                                return
//                            }
//
//                            guard response.statusCode == 200 else {
//                                DispatchQueue.main.async {
//                                    loadingState.alertType = .notHTTP200(description: "Could not perform the request")
//                                    loadingState.showAlert = true
//                                }
//                                return
//                            }
//
//
//                            do {
//
//                                let json = try JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
//                                guard let processedText = json["processed_text"] as? [String: Any] else {
//                                    print("Error: Could not parse processed_text from JSON.")
//                                    return
//                                }
//
//                                //show the alert here
//                                // Extract the necessary information to show in the receipt alert
//                                guard let companyLegalName = processedText["company_legal_name"] as? String,
//                                      let companyName = processedText["company_name"] as? String,
//                                      let companyType = processedText["company_type"] as? String,
//                                      let category = processedText["category"] as? String,
//                                      let purchaseTotal = processedText["purchase_total"] as? String,
//                                      let purchaseDateTime = processedText["purchase_date_time"] as? String else {
//                                    print("Error: Could not extract necessary information from processed_text.")
//                                    return
//                                }
//
//                                DispatchQueue.main.async {
//
//                                }
//
//
//                            } catch {
//                                print("Error decoding JSON: \(error.localizedDescription)")
//                            }
//
//                        }
//                        task.resume()
//                    }
//                    self.dismissScannerView()
//
//                case .failure(let error):
//                    let alert = UIAlertController(title: "Error",
//                                                  message: error.localizedDescription,
//                                                  preferredStyle: .alert)
//                    let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
//                    alert.addAction(okAction)
//                    UIApplication.shared.windows.first?.rootViewController?.present(alert, animated: true, completion: nil)
//                }
//            } didCancelScanning: {
//                // Dismiss the scanner controller and the sheet.
//                self.dismissScannerView()
//            }
//
//        }
//
//    }
//}
//
//
////struct AddReceiptView: View {
////    @ObservedObject var recognizedContent = RecognizedContent()
////    @State private var showScanner = false
////    @State private var isRecognizing = false
////    @StateObject var loadingState = LoadingState()
////    @State private var isShowingErrorAlert = false
////    @State private var isShowingReceiptAlert = false
////    @State private var receiptAlertContent: ReceiptAlertContent?
////
////    private func dismissScannerView() {
////        self.showScanner = false
////    }
////
////    var body: some View {
////        VStack {
////            if loadingState.isLoading {
////                ProgressView()
////                    .progressViewStyle(CircularProgressViewStyle())
////                    .padding(.bottom, 20)
////            }
////            Button(action: {
////                loadingState.isLoading.toggle()
////            }) {
////                Text("Loading...")
////                    .foregroundColor(.white)
////                    .padding(.horizontal, 15)
////                    .padding(.vertical, 10)
////                    .background(Color.blue)
////                    .cornerRadius(5)
////            }
////            Button("scan"){
////
////                self.showScanner = true
////
////            }
////        }
////        .alert(isPresented: $isShowingReceiptAlert) {
////           // Define the alert
////           Alert(title: Text("Receipt details"), message: Text(receiptAlertContent?.message ?? ""), primaryButton: .default(Text("OK"), action: {
////              // Handle primary button action
////           }), secondaryButton: .cancel())
////        }
////        .alert(isPresented: $isShowingReceiptAlert) {
////           // Define the alert
////           Alert(title: Text("Receipt details"), message: Text(receiptAlertContent?.message ?? ""), primaryButton: .default(Text("OK"), action: {
////              // Handle primary button action
////           }), secondaryButton: .cancel())
////        }
////        .sheet(isPresented: $showScanner) {
////            ScannerView { result in
////                switch result {
////                case .success(let scannedImages):
////                    self.isRecognizing = true
////                    TextRecognition(scannedImages: scannedImages, recognizedContent: self.recognizedContent) {
////                        // Text recognition is finished, hide the progress indicator.
////                        self.isRecognizing = false
////                    }
////                    .recognizeText() { recognizedText in
////                        print(recognizedText)
////                        let url = URL(string: "https://thesis-backend-23143.onrender.com/process_data")!
////                        var request = URLRequest(url: url)
////                        request.httpMethod = "POST"
////                        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
////                        let json = ["raw_text": recognizedText]
////                        let jsonData = try! JSONSerialization.data(withJSONObject: json, options: [])
////                        request.httpBody = jsonData
////
////                        let task = URLSession.shared.dataTask(with: request) { data, response, error in
////                            loadingState.isLoading.toggle()
////                            if let error = error {
////                                print("Error: \(error.localizedDescription)")
////                                return
////                            }
////
////                            guard let data = data, let response = response as? HTTPURLResponse else {
////                                print("Invalid response")
////                                return
////                            }
////
////                            guard response.statusCode == 200 else {
////                                isShowingErrorAlert = true
//////                                DispatchQueue.main.async {
//////                                    alert(isPresented: $isShowingErrorAlert) {
//////                                        // Define the alert
//////                                        Alert(title: Text("Error"), message: Text("Invalid status code: \(response.statusCode)"), dismissButton: .default(Text("OK")))
//////                                    }
//////                                }
////                                return
////                            }
////
////
////                            do {
////                                let json = try JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
////                                guard let processedText = json["processed_text"] as? [String: Any] else {
////                                    print("Error: Could not parse processed_text from JSON.")
////                                    return
////                                }
////
////                                //show the alert here
////                                // Extract the necessary information to show in the receipt alert
////                                    guard let companyLegalName = processedText["company_legal_name"] as? String,
////                                          let companyName = processedText["company_name"] as? String,
////                                          let companyType = processedText["company_type"] as? String,
////                                          let category = processedText["category"] as? String,
////                                          let purchaseTotal = processedText["purchase_total"] as? String,
////                                          let purchaseDateTime = processedText["purchase_date_time"] as? String else {
////                                        print("Error: Could not extract necessary information from processed_text.")
////                                        return
////                                    }
////
////                                    // Construct the receipt alert content
//////                                    let receiptAlertContent = ReceiptAlertContent(companyLegalName: companyLegalName, companyName: companyName, companyType: companyType, category: category, purchaseTotal: purchaseTotal, purchaseDateTime: purchaseDateTime)
//////                                let content =  """
//////                                            Company Legal Name: \(companyLegalName)
//////                                            Company Name: \(companyName)
//////                                            Company Type: \(companyType)
//////                                            Category: \(category)
//////                                            Purchase Total: \(purchaseTotal)
//////                                            Purchase Date Time: \(purchaseDateTime)
//////                                            """
////                                let receiptAlertContent = "processedText"
////                                    isShowingReceiptAlert = true
////                                    DispatchQueue.main.async {
////                                        alert(isPresented: $isShowingReceiptAlert) {
////                                            // Define the alert
////                                            Alert(title: Text("Error"), message: Text(receiptAlertContent), dismissButton: .default(Text("OK")))
////                                        }
////                                    }
////
////
////                            } catch {
////                                print("Error decoding JSON: \(error.localizedDescription)")
////                            }
////
////                        }
////                    }
////                    self.dismissScannerView()
////
////                case .failure(let error):
////                    let alert = UIAlertController(title: "Error",
////                                                  message: error.localizedDescription,
////                                                  preferredStyle: .alert)
////                    let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
////                    alert.addAction(okAction)
////                    UIApplication.shared.windows.first?.rootViewController?.present(alert, animated: true, completion: nil)
////                }
////            } didCancelScanning: {
////                // Dismiss the scanner controller and the sheet.
////                self.dismissScannerView()
////            }
////        }
////    }
////}
////
////struct ReceiptAlertContent: Identifiable {
////    let id = UUID()
////    let title: String
////    let message: String
////}
