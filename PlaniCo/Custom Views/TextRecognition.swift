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

