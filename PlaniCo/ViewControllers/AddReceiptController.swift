//
//  AddReceiptController.swift
//  PlaniCo
//
//  Created by Sandu Furdui on 22.02.2023.
//

import SwiftUI
import FirebaseAuth


class AddReceiptController: UIViewController {
    var dataSourceProvider: DataSourceProvider<AuthProvider>!
    @ObservedObject var recognizedContent = RecognizedContent()
    @State private var showScanner = false
    @State private var isRecognizing = false
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        configureScanButton()
    }
    
    private func configureNavigationBar() {
        navigationItem.title = "Add receipt"
        guard let navigationBar = navigationController?.navigationBar else { return }
        navigationBar.prefersLargeTitles = true
        let accentColor = UIColor(named: "AccentColor")
        navigationBar.titleTextAttributes = [.foregroundColor: accentColor ?? .systemOrange]
        navigationBar.largeTitleTextAttributes = [.foregroundColor: accentColor ?? .systemOrange]
    }
     
    private func configureScanButton() {
        let buttonWidth: CGFloat = 200
        let buttonHeight: CGFloat = 50
        let scanButton = UIButton(type: .system)
        scanButton.setTitle("Scan a receipt", for: .normal)
        scanButton.tintColor = .white
        scanButton.addTarget(self, action: #selector(scanButtonTapped), for: .touchUpInside)
        scanButton.backgroundColor = .systemTeal
        
        scanButton.layer.cornerRadius = 20
        scanButton.layer.masksToBounds = true
        view.addSubview(scanButton)
        
        let screenHeight = UIScreen.main.bounds.size.height
        scanButton.frame = CGRect(x: (view.bounds.width - buttonWidth) / 2, y: screenHeight/2 + screenHeight/4, width: buttonWidth, height: buttonHeight)
    }
 
    private func dismissScannerView() {
        self.showScanner = false
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func scanButtonTapped() {
        let scannerView = ScannerView { result in
            switch result {
            case .success(let scannedImages):
                self.isRecognizing = true
                self.showScanner = true
                TextRecognition(scannedImages: scannedImages, recognizedContent: self.recognizedContent) {
                    // Text recognition is finished, hide the progress indicator.
                    self.isRecognizing = false
                }
                .recognizeText() { recognizedText in
                    // show loading screen while waiting for response
                    
                    //                    self.isLoading = true
                    //                    self.loadingState.isLoading.toggle()
                    //                    self.isLoading = true
                    let url = URL(string: "https://thesis-backend-production.up.railway.app/process_data")!
                    var request = URLRequest(url: url)
                    request.httpMethod = "POST"
                    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                    let json = ["raw_text": recognizedText]
//                    print(recognizedText)
                    let jsonData = try! JSONSerialization.data(withJSONObject: json, options: [])
                    request.httpBody = jsonData
                    
                    let task = URLSession.shared.dataTask(with: request) { data, response, error in
                        // hide loading
                        //                        self.isLoading = false
                        //                        self.loadingState.isLoading.toggle()
                        
                        if let error = error {
                            print("Error: \(error.localizedDescription)")
                            return
                        }
                        
                        guard let data = data, let response = response as? HTTPURLResponse else {
                            print("Invalid response")
                            return
                        }
                        
                        guard response.statusCode == 200 else {
                            DispatchQueue.main.async {
                                let alertController = UIAlertController(title: "Error", message: "Invalid status code: \(response.statusCode)", preferredStyle: .alert)
                                alertController.addAction(UIAlertAction(title: "OK", style: .default))
                                self.present(alertController, animated: true)
                                
                            }
                            return
                        }
                        
                        do {
                            let json = try JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                            guard let processedText = json["processed_text"] as? [String: Any] else {
                                print("Error: Could not parse processed_text from JSON.")
                                return
                            }
                            
                            let companyLegalName = processedText["company_legal_name"] as? String ?? ""
                            let companyName = processedText["company_name"] as? String ?? ""
                            let companyType = processedText["company_type"] as? String ?? ""
                            let category = processedText["category"] as? String ?? ""
                            let purchaseTotal = processedText["purchase_total"] as? String ?? ""
                            let purchaseDateTime = processedText["purchase_date_time"] as? String ?? ""
                            
                            DispatchQueue.main.async {
                                let alert = ReceiptAlert.createAlert(companyLegalName: companyLegalName, companyName: companyName, companyType: companyType, category: category, purchaseTotal: purchaseTotal, purchaseDateTime: purchaseDateTime)
                                self.present(alert, animated: true)
                            }
                        } catch {
                            print("Error decoding JSON: \(error.localizedDescription)")
                        }
                        
                    }
                    //                    self.isLoading = false
                    
                    task.resume()
                }
                self.dismissScannerView()
                
            case .failure(let error):
                let alert = UIAlertController(title: "Error",
                                              message: error.localizedDescription,
                                              preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                alert.addAction(okAction)
                self.present(alert, animated: true, completion: nil)
            }
        } didCancelScanning: {
            // Dismiss the scanner controller and the sheet.
            self.dismissScannerView()
        }
        
        let scannerViewController = UIHostingController(rootView: scannerView)
        //        scannerViewController.modalPresentationStyle = .fullScreen
        present(scannerViewController, animated: true, completion: nil)
    }
}
