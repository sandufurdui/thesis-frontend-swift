//
//  ReceiptAlert.swift
//  PlaniCo
//
//  Created by Sandu Furdui on 23.02.2023.
//

import UIKit
import FirebaseAuth
@objc class ReceiptAlert: UIAlertController, UIPickerViewDelegate, UIPickerViewDataSource {

//    var pickerViewDataSource: UIPickerViewDataSource?
//    static var alertController: UIAlertController?
//    private static var companies: [[String: Any]] = []
//    static let companyNames = ["Maicom", "Pegas Trattoria", "KAUFLAND", "Salamander"]
    static var alertController: UIAlertController?
       private static var companies: [[String: Any]] = []
       static let companyNames = ["Maicom", "Pegas Trattoria", "KAUFLAND", "Salamander"]
       private var selectedCompanyName: String?
    
    @objc private static func datePickerValueChanged(_ sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy, HH:mm"
        let selectedDate = dateFormatter.string(from: sender.date)
        let textField = alertController?.textFields?[11]
        textField?.text = selectedDate
    }
    
    
    private static func loadCompanies() -> [[String: Any]]? {
        guard let path = Bundle.main.path(forResource: "companies", ofType: "json"),
              let data = try? Data(contentsOf: URL(fileURLWithPath: path)),
              let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
              let companies = json["companies"] as? [[String: Any]] else {
            return nil
        }
        return companies
    }
    
    @objc private static func updateFields( ) {
        if let loadedCompanies = loadCompanies() {
            companies = loadedCompanies
        }
        let textField = ReceiptAlert.alertController?.textFields?[3]
        let companyName = textField?.text
        for company in companies {
            if company["company_name"] as? String == companyName {
                if let legalName = company["company_legal_name"] {
                    let textField = ReceiptAlert.alertController?.textFields?[1]
                    textField?.text = legalName as? String
                }
                if let type = company["company_type"] {
                    let textField = ReceiptAlert.alertController?.textFields?[5]
                    textField?.text = type as? String
                }
                if let category = company["category"] {
                    let textField = ReceiptAlert.alertController?.textFields?[7]
                    textField?.text = category as? String
                }
                break
            }
        }
    }
    
    //    static func createAlert(companyLegalName: String, companyName: String, companyType: String, category: String, purchaseTotal: String, purchaseDateTime: String, confirmHandler: ((UIAlertAction) -> Void)? = nil) -> UIAlertController {
    //        alertController = UIAlertController(title: "Receipt details", message: "Please confirm if all the information displayed in this alert is veridic", preferredStyle: .alert)
    static func createAlert(companyLegalName: String, companyName: String, companyType: String, category: String, purchaseTotal: String, purchaseDateTime: String, confirmHandler: ((UIAlertAction) -> Void)? = nil) -> UIAlertController {
        alertController = UIAlertController(title: "Receipt details", message: "Please confirm if all the information displayed in this alert is veridic", preferredStyle: .alert)
        
        alertController?.addTextField { (textField) -> Void in
            textField.text = "Company legal name:"
            textField.isUserInteractionEnabled = false
        }
        
        alertController?.addTextField { textField in
            textField.placeholder = "Company legal name"
            textField.text = companyLegalName
            textField.isEnabled = false
            textField.textColor = .gray
        }
        
        alertController?.addTextField { (textField) -> Void in
            textField.text = "Company name:"
            textField.isUserInteractionEnabled = false
        }
        
                alertController?.addTextField { textField in
                    textField.placeholder = "Company name"
                    textField.text = companyName
                    textField.addTarget(ReceiptAlert.self, action: #selector(ReceiptAlert.updateFields), for: .editingChanged)
                }
        
//        let companyPicker = UIPickerView()
//        var pickerDataSource = ["White", "Red", "Green", "Blue"]
//
//        alertController?.addTextField { textField in
//            textField.placeholder = "Company name"
//            textField.text = companyName
//            textField.inputView = companyPicker
//            textField.addTarget(self, action: #selector(updateFields), for: .editingChanged)
//            companyPicker.dataSource = self
//            companyPicker.delegate = self
//        }
        
        
        alertController?.addTextField { (textField) -> Void in
            textField.text = "Company type:"
            textField.isUserInteractionEnabled = false
        }
        
        alertController?.addTextField { textField in
            textField.placeholder = "Company type"
            textField.text = companyType
            textField.isEnabled = false
            textField.textColor = .gray
        }
        
        alertController?.addTextField { (textField) -> Void in
            textField.text = "Company category:"
            textField.isUserInteractionEnabled = false
        }
        
        alertController?.addTextField { textField in
            textField.placeholder = "Company category"
            textField.text = category
            textField.isEnabled = false
            textField.textColor = .gray
        }
        
        alertController?.addTextField { (textField) -> Void in
            textField.text = "Purchase total:"
            textField.isUserInteractionEnabled = false
        }
        
        alertController?.addTextField { textField in
            textField.placeholder = "Purchase total"
            textField.keyboardType = .decimalPad
            textField.text = "\(purchaseTotal)"
        }
        
        alertController?.addTextField { (textField) -> Void in
            textField.text = "Purchase date:"
            textField.isUserInteractionEnabled = false
        }
        
        alertController?.addTextField { textField in
            textField.placeholder = "Purchase date"
            textField.text = "\(purchaseDateTime)"
            textField.tintColor = .clear // remove cursor
            let datePicker = UIDatePicker()
            datePicker.datePickerMode = .dateAndTime
            datePicker.preferredDatePickerStyle = .wheels // Set the preferred style to wheels
            datePicker.locale = Locale(identifier: "ro_RO_POSIX")
            datePicker.minimumDate = Calendar.current.date(byAdding: .year, value: -1, to: Date()) // Set the minimum date to one year ago
            datePicker.maximumDate = Date() // Set the maximum date to today
            datePicker.addTarget(self, action: #selector(self.datePickerValueChanged), for: .valueChanged)
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd MMM yyyy, HH:mm"
            if let purchaseDate = dateFormatter.date(from: purchaseDateTime) {
                datePicker.date = purchaseDate
            } else {
                datePicker.date = Date()
            }
            
            textField.inputView = datePicker
        }
        
        //        alertController.addTextField { textField in
        //            textField.placeholder = "Purchase date"
        //            textField.text = "\(purchaseDateTime)"
        //            textField.tintColor = .clear // remove cursor
        //            let datePicker = UIDatePicker()
        //            datePicker.datePickerMode = .dateAndTime
        //            datePicker.preferredDatePickerStyle = .wheels // Set the preferred style to wheels
        //            datePicker.locale = Locale(identifier: "ro_RO_POSIX")
        //            datePicker.minimumDate = Calendar.current.date(byAdding: .year, value: -1, to: Date()) // Set the minimum date to one year ago
        //            datePicker.maximumDate = Date() // Set the maximum date to today
        //            datePicker.addTarget(self, action: #selector(self.datePickerValueChanged), for: .valueChanged)
        //
        //            let dateFormatter = DateFormatter()
        //            dateFormatter.dateFormat = "dd MMM yyyy, HH:mm"
        //            if let purchaseDate = dateFormatter.date(from: purchaseDateTime) {
        //                datePicker.date = purchaseDate
        //            } else {
        //                datePicker.date = Date()
        //            }
        //
        //            textField.inputView = datePicker
        //        }
        
        
        
        
        
        
        if let textFields = alertController?.textFields {
            for i in 0..<textFields.count {
                if i % 2 == 0 {
                    textFields[i].superview!.superview!.subviews[0].removeFromSuperview()
                    textFields[i].superview!.backgroundColor = UIColor.clear
                }
            }
        }
        let saveAction = UIAlertAction(title: "Save", style: .default) { _ in
            let companyLegalName1 = alertController?.textFields?[1].text ?? ""
            let companyName1 = alertController?.textFields?[3].text ?? ""
            let companyType1 = alertController?.textFields?[5].text ?? ""
            let category1 = alertController?.textFields?[7].text ?? ""
            let purchaseTotal1 = alertController?.textFields?[9].text ?? ""
            let purchaseDateTime1 = alertController?.textFields?[11].text ?? ""
            
            guard let currentUser = Auth.auth().currentUser else { return }
            let userId = currentUser.uid
            let postPaycheckPayload: [String: Any] = [
                "user_id": userId,
                "company_legal_name": companyLegalName1 as Any,
                "company_name": companyName1 as Any,
                "company_type": companyType1 as Any,
                "category": category1 as Any,
                "purchase_date_time": purchaseDateTime1 as Any,
                "purchase_total": purchaseTotal1 as Any
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
                    //                    self.present(alertController, animated: true)
                    return
                }
                
                guard let data = data else {
                    let alertController = UIAlertController(title: "Error", message: "No data received", preferredStyle: .alert)
                    alertController.addAction(UIAlertAction(title: "OK", style: .default))
                    //                                        self.present(alertController, animated: true)
                    return
                }
                
                let json = try? JSONSerialization.jsonObject(with: data, options: [])
                DispatchQueue.main.async {
                    if let jsonData = try? JSONSerialization.data(withJSONObject: json ?? "{'message' : 'Error while parsing the response'}"),
                       let jsonDictionary = try? JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any] {
                        
                        let resultMessage = jsonDictionary["message"] as? String ?? "Error while parsing the response"
                        let resultTitle = jsonDictionary["result"] as? String ?? "Error while parsing the response"
                        let alertController = UIAlertController(title: resultTitle, message: resultMessage, preferredStyle: .alert)
                        alertController.addAction(UIAlertAction(title: "OK", style: .default))
                        //                                                self.present(alertController, animated: true)
                    }
                }
                
                
            }.resume()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController?.addAction(saveAction)
        alertController?.addAction(cancelAction)
        
        return alertController!
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
            return 1
        }
        
        func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
            return ReceiptAlert.companyNames.count
        }
        
        // MARK: - UIPickerViewDelegate methods
        
        func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
            return ReceiptAlert.companyNames[row]
        }
        
        func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
            selectedCompanyName = ReceiptAlert.companyNames[row]
        }
        
        // MARK: - Target action method
        
        @objc private func updateFields() {
            if let companyNameTextField = ReceiptAlert.alertController?.textFields?[1] {
                companyNameTextField.text = selectedCompanyName
            }
        }
}


