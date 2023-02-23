//
//  TextRecognition.swift
//  PlaniCo
//
//  Created by Sandu Furdui on 22.02.2023.
//

import Foundation


//
//  TextRecognition.swift
//  ScanAndRecognizeText
//
//  Created by Gabriel Theodoropoulos.
//
import UIKit
import SwiftUI
import Vision

struct TextRecognition {
    var scannedImages: [UIImage]
    @ObservedObject var recognizedContent: RecognizedContent
    var didFinishRecognition: () -> Void
    
    //    func recognizeText() {
    //        let queue = DispatchQueue(label: "textRecognitionQueue", qos: .userInitiated)
    //        var recognizedText = ""
    //
    //        queue.async {
    //            for image in scannedImages {
    //                guard let cgImage = image.cgImage else { continue }
    //
    //                let requestHandler = VNImageRequestHandler(cgImage: cgImage, options: [:])
    //                let textItem = TextItem()
    //
    //                do {
    //                    try requestHandler.perform([getTextRecognitionRequest(with: textItem)])
    //
    //                    recognizedText += textItem.text
    //                } catch {
    //                    print(error.localizedDescription)
    //                }
    //            }
    //            print(recognizedText)
    //            DispatchQueue.main.async {
    //                //                completion(recognizedText)
    //                didFinishRecognition()
    //            }
    //        }
    //    }
    //    func recognizeText() {
    //        let queue = DispatchQueue(label: "textRecognitionQueue", qos: .userInitiated)
    //        var recognizedText = ""
    //
    //        queue.async {
    //            for image in scannedImages {
    //                guard let cgImage = image.cgImage else { continue }
    //
    //                let requestHandler = VNImageRequestHandler(cgImage: cgImage, options: [:])
    //                let textItem = TextItem()
    //
    //                do {
    //                    try requestHandler.perform([getTextRecognitionRequest(with: textItem)])
    //
    //                    recognizedText += textItem.text
    //                } catch {
    //                    print(error.localizedDescription)
    //                }
    //            }
    ////            print(recognizedText)
    //            DispatchQueue.main.async {
    //                //                completion(recognizedText)
    //                didFinishRecognition()
    //            }
    //            return recognizedText
    ////                               let processedText = json["processed_text"] as? [String: Any] {
    ////                                   let companyLegalName = processedText["company_legal_name"] as? String ?? ""
    ////                                   let companyName = processedText["company_name"] as? String ?? ""
    ////                                   let companyType = processedText["company_type"] as? String ?? ""
    ////                                   let category = processedText["category"] as? String ?? ""
    ////                                   let purchaseTotal = processedText["purchase_total"] ?? ""
    ////                                   let scannedDate = processedText["scanned_date"] ?? ""
    ////                                   let purchaseDateTime = processedText["purchase_date_time"] ?? ""
    //
    //
    //        }
    //    }
    
    func recognizeText(completion: @escaping (String) -> Void) {
        let queue = DispatchQueue(label: "textRecognitionQueue", qos: .userInitiated)
        var recognizedText = ""
        
        queue.async {
            for image in scannedImages {
                guard let cgImage = image.cgImage else { continue }
                
                let requestHandler = VNImageRequestHandler(cgImage: cgImage, options: [:])
                let textItem = TextItem()
                
                do {
                    try requestHandler.perform([getTextRecognitionRequest(with: textItem)])
                    
                    recognizedText += textItem.text
                } catch {
                    print(error.localizedDescription)
                }
            }
            DispatchQueue.main.async {
                completion(recognizedText)
            }
        }
    }
    
    
    
    
    
    private func getTextRecognitionRequest(with textItem: TextItem) -> VNRecognizeTextRequest {
        let request = VNRecognizeTextRequest { request, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            guard let observations = request.results as? [VNRecognizedTextObservation] else { return }
            
            observations.forEach { observation in
                guard let recognizedText = observation.topCandidates(1).first else { return }
                textItem.text += recognizedText.string
                textItem.text += " "
            }
        }
        
        request.recognitionLevel = .accurate
        request.usesLanguageCorrection = true
        
        return request
    }
}



//        https://thesis-backend-23143.onrender.com/process_data


//    func recognizeText() {
//        let queue = DispatchQueue(label: "textRecognitionQueue", qos: .userInitiated)
//        queue.async {
//            for image in scannedImages {
//                guard let cgImage = image.cgImage else { return }
//
//                let requestHandler = VNImageRequestHandler(cgImage: cgImage, options: [:])
//
//                do {
//                    let textItem = TextItem()
//                    try requestHandler.perform([getTextRecognitionRequest(with: textItem)])
//
//                    DispatchQueue.main.async {
//                        recognizedContent.items.append(textItem)
//                    }
//                } catch {
//                    print(error.localizedDescription)
//                }
//
//                DispatchQueue.main.async {
//                    didFinishRecognition()
//                }
//            }
//        }
//    }

//    var didFinishRecognition: () -> Void
//            make http request here
//            guard let url = URL(string: "https://thesis-backend-23143.onrender.com/process_data") else { return }
//                var request = URLRequest(url: url)
//                request.httpMethod = "POST"
//                request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//                print(textItem.text)
//                let json: [String: Any] = ["raw_text": textItem.text]
//                let jsonData = try? JSONSerialization.data(withJSONObject: json)
//                request.httpBody = jsonData
//
//                URLSession.shared.dataTask(with: request) { (data, response, error) in
//                    if let error = error {
//                        print(error.localizedDescription)
//                        return
//                    }
//
//                    guard let data = data else { return }
//                    let json = try? JSONSerialization.jsonObject(with: data, options: [])
//
//                    print(json as Any)
//
//                    guard let responseData = json as? [String: Any],
//                            let processedText = responseData["processed_text"] as? [String: Any] else {
//                                print("Error parsing JSON response")
//                                return
//                        }
//                        print(processedText)
//                        let userId = "Nq9Y2DqdnWgNL8CLK639mh9QCeE2"
//                        let companyLegalName = processedText["company_legal_name"] as? String
//                    let companyName = processedText["company_name"] as? String
//                    let companyType = processedText["company_type"] as? String
//                    let category = processedText["category"] as? String
//                    let purchaseTotal = processedText["purchase_total"]
//                    let scannedDate = processedText["scanned_date"]
//                    let purchaseDateTime = processedText["purchase_date_time"]







//                    let alert = UIAlertController(title: "Edit values", message: nil, preferredStyle: .alert)
//                    alert.addTextField { (textField) in
//                        textField.placeholder = "Company legal name"
//                        textField.text = companyLegalName
//                    }
//                    alert.addTextField { (textField) in
//                        textField.placeholder = "Company name"
//                        textField.text = companyName
//                    }
//                    alert.addTextField { (textField) in
//                        textField.placeholder = "Company type"
//                        textField.text = companyType
//                    }
//                    alert.addTextField { (textField) in
//                        textField.placeholder = "Category"
//                        textField.text = category
//                    }
//                    let updateAction = UIAlertAction(title: "Update", style: .default) { (action) in
//                        // update the variables with the new values entered by the user
//                        companyLegalName = alert.textFields?[0].text
//                        companyName = alert.textFields?[1].text
//                        companyType = alert.textFields?[2].text
//                        category = alert.textFields?[3].text
//                    }
//                    alert.addAction(updateAction)
//                    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
//                    alert.addAction(cancelAction)
//                    alert.present(alert, animated: true, completion: nil)


















//                        let postPaycheckPayload: [String: Any] = [
//                            "user_id": userId,
//                            "company_legal_name": companyLegalName as Any,
//                            "company_name": companyName as Any,
//                            "company_type": companyType as Any,
//                            "category": category as Any,
//                            "scanned_date": scannedDate as Any,
//                            "purchase_date_time": purchaseDateTime as Any,
//                            "purchase_total": purchaseTotal as Any
//                        ]
//                    guard let postPaycheckUrl = URL(string: "https://thesis-backend-23143.onrender.com/post_paycheck") else { return }
//                        var postPaycheckRequest = URLRequest(url: postPaycheckUrl)
//                        postPaycheckRequest.httpMethod = "POST"
//                        postPaycheckRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
//                        postPaycheckRequest.httpBody = try? JSONSerialization.data(withJSONObject: postPaycheckPayload)
//
//                        URLSession.shared.dataTask(with: postPaycheckRequest) { (data, response, error) in
//                            if let error = error {
//                                print(error.localizedDescription)
//                                return
//                            }
//
//                            guard let data = data else { return }
//                            let json = try? JSONSerialization.jsonObject(with: data, options: [])
//                            print(json as Any)
//                        }.resume()
//
//                }.resume()
