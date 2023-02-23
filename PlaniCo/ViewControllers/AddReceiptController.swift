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

    @objc func datePickerValueChanged(_ sender: UIDatePicker) {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short

        if let textField = (presentedViewController as? UIAlertController)?.textFields?.last {
            textField.text = formatter.string(from: sender.date)
            textField.text = textField.text?.replacingOccurrences(of: " at", with: ",")
        }
    }

    
    override func loadView() {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        let label = UILabel()
        label.text = "fuck u 2"
        label.textAlignment = .center
        tableView.backgroundView = label
        view = tableView
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
        let scanButton = UIBarButtonItem(title: "Scan", style: .plain, target: self, action: #selector(scanButtonTapped))
        navigationItem.rightBarButtonItem = scanButton
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
                    let url = URL(string: "https://thesis-backend-23143.onrender.com/process_data")!
                    var request = URLRequest(url: url)
                    request.httpMethod = "POST"
                    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                    let json = ["raw_text": recognizedText]
                    let jsonData = try! JSONSerialization.data(withJSONObject: json, options: [])
                    request.httpBody = jsonData

                    let task = URLSession.shared.dataTask(with: request) { data, response, error in
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

                            var companyLegalName = processedText["company_legal_name"] as? String ?? ""
                            var companyName = processedText["company_name"] as? String ?? ""
                            var companyType = processedText["company_type"] as? String ?? ""
                            var category = processedText["category"] as? String ?? ""
                            var purchaseTotal = processedText["purchase_total"] ?? ""
                            var purchaseDateTime = processedText["purchase_date_time"] ?? ""

                            DispatchQueue.main.async {

                                let alertController = UIAlertController(title: "Receipt details", message: "Please check if all the information displayed in this alert is veridic", preferredStyle: .alert)

                                alertController.addTextField { (textField) -> Void in
                                    textField.text = "Company legal name:"
                                    //                                    textField.keyboardType = .numberPad
                                    textField.isUserInteractionEnabled = false
                                }

                                alertController.addTextField { textField in
                                    textField.placeholder = "Company legal name"
                                    textField.text = companyLegalName
                                }

                                alertController.addTextField { (textField) -> Void in
                                    textField.text = "Company name:"
                                    //                                    textField.keyboardType = .numberPad
                                    textField.isUserInteractionEnabled = false
                                }

                                alertController.addTextField { textField in
                                    textField.placeholder = "Company name"
                                    textField.text = companyName
                                }

                                alertController.addTextField { (textField) -> Void in
                                    textField.text = "Company type:"
                                    //                                    textField.keyboardType = .numberPad
                                    textField.isUserInteractionEnabled = false
                                }

                                alertController.addTextField { textField in
                                    textField.placeholder = "Company type"
                                    textField.text = companyType
                                }

                                alertController.addTextField { (textField) -> Void in
                                    textField.text = "Company category:"
                                    //                                    textField.keyboardType = .numberPad
                                    textField.isUserInteractionEnabled = false
                                }

                                alertController.addTextField { textField in
                                    textField.placeholder = "Company category"
                                    textField.text = category
                                }

                                alertController.addTextField { (textField) -> Void in
                                    textField.text = "Purchase total:"
                                    //                                    textField.keyboardType = .numberPad
                                    textField.isUserInteractionEnabled = false
                                }

                                alertController.addTextField { textField in
                                    textField.placeholder = "Purchase total"
                                    textField.keyboardType = .decimalPad
                                    textField.text = "\(purchaseTotal)"
                                }

                                alertController.addTextField { (textField) -> Void in
                                    textField.text = "Purchase date:"
                                    textField.isUserInteractionEnabled = false
                                }

                                alertController.addTextField { textField in
                                    textField.placeholder = "Purchase date"
                                    textField.text = "\(purchaseDateTime)"
                                    let datePicker = UIDatePicker()
                                    datePicker.datePickerMode = .dateAndTime
                                    datePicker.preferredDatePickerStyle = .wheels // Set the preferred style to wheels
                                    datePicker.locale = Locale(identifier: "en_EN_POSIX")
                                    datePicker.addTarget(self, action: #selector(self.datePickerValueChanged), for: .valueChanged)

                                    textField.inputView = datePicker
                                }

                                if let textFields = alertController.textFields {
                                    for i in 0..<textFields.count {
                                        if i % 2 == 0 {
                                            textFields[i].superview!.superview!.subviews[0].removeFromSuperview()
                                            textFields[i].superview!.backgroundColor = UIColor.clear
                                        }
                                    }
                                }

                                let saveAction = UIAlertAction(title: "Save", style: .default) { _ in
                                    companyLegalName = alertController.textFields?[1].text ?? ""
                                    companyName = alertController.textFields?[3].text ?? ""
                                    companyType = alertController.textFields?[5].text ?? ""
                                    category = alertController.textFields?[7].text ?? ""
                                    purchaseTotal = alertController.textFields?[9].text ?? ""
                                    purchaseDateTime = alertController.textFields?[11].text ?? ""

                                    guard let currentUser = Auth.auth().currentUser else { return }
                                    let userId = currentUser.uid
                                    let postPaycheckPayload: [String: Any] = [
                                        "user_id": userId,
                                        "company_legal_name": companyLegalName as Any,
                                        "company_name": companyName as Any,
                                        "company_type": companyType as Any,
                                        "category": category as Any,
                                        "scanned_date": purchaseDateTime as Any,
                                        "purchase_date_time": purchaseDateTime as Any,
                                        "purchase_total": purchaseTotal as Any
                                    ]
                                    guard let postPaycheckUrl = URL(string: "https://thesis-backend-23143.onrender.com/post_paycheck") else { return }
                                    var postPaycheckRequest = URLRequest(url: postPaycheckUrl)
                                    postPaycheckRequest.httpMethod = "POST"
                                    postPaycheckRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
                                    postPaycheckRequest.httpBody = try? JSONSerialization.data(withJSONObject: postPaycheckPayload)

                                    URLSession.shared.dataTask(with: postPaycheckRequest) { (data, response, error) in
                                        if let error = error {
                                            let alertController = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                                            alertController.addAction(UIAlertAction(title: "OK", style: .default))
                                            self.present(alertController, animated: true)
                                            return
                                        }

                                        guard let data = data else {
                                            let alertController = UIAlertController(title: "Error", message: "No data received", preferredStyle: .alert)
                                            alertController.addAction(UIAlertAction(title: "OK", style: .default))
                                            self.present(alertController, animated: true)
                                            return
                                        }

                                        let json = try? JSONSerialization.jsonObject(with: data, options: [])
                                        //                                        print(json as Any)
                                        DispatchQueue.main.async {
                                            if let jsonData = try? JSONSerialization.data(withJSONObject: json ?? "{'message' : 'Error while parsing the response'}"),
                                               let jsonDictionary = try? JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any] {

                                                let resultMessage = jsonDictionary["message"] as? String ?? "Error while parsing the response"
                                                let alertController = UIAlertController(title: "Success", message: resultMessage, preferredStyle: .alert)
                                                alertController.addAction(UIAlertAction(title: "OK", style: .default))
                                                self.present(alertController, animated: true)
                                            }
                                        }

                                    }.resume()
                                }

                                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)

                                alertController.addAction(saveAction)
                                alertController.addAction(cancelAction)

                                self.present(alertController, animated: true, completion: nil)

                            }
                        } catch {
                            print("Error decoding JSON: \(error.localizedDescription)")
                        }

                    }

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
            //            self.showScanner = false
        }

        let scannerViewController = UIHostingController(rootView: scannerView)
        //        scannerViewController.modalPresentationStyle = .fullScreen
        present(scannerViewController, animated: true, completion: nil)
    }

}
