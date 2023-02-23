//
//  ScanerView.swift
//  PlaniCo
//
//  Created by Sandu Furdui on 22.02.2023.
//

import SwiftUI
import VisionKit

struct ScannerView: UIViewControllerRepresentable {
    var didFinishScanning: ((_ result: Result<[UIImage], Error>) -> Void)
    var didCancelScanning: () -> Void

    func makeUIViewController(context: Context) -> VNDocumentCameraViewController {
        let scannerViewController = VNDocumentCameraViewController()
        scannerViewController.delegate = context.coordinator
        scannerViewController.edgesForExtendedLayout = .all
        return scannerViewController
    }

    func updateUIViewController(_ uiViewController: VNDocumentCameraViewController, context: Context) { }


    func makeCoordinator() -> Coordinator {
        Coordinator(with: self)
    }


    class Coordinator: NSObject, VNDocumentCameraViewControllerDelegate {
        let scannerView: ScannerView

        init(with scannerView: ScannerView) {
            self.scannerView = scannerView
        }


        // MARK: - VNDocumentCameraViewControllerDelegate

        func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFinishWith scan: VNDocumentCameraScan) {
            var scannedPages = [UIImage]()

            for i in 0..<scan.pageCount {
                scannedPages.append(scan.imageOfPage(at: i))
            }

            scannerView.didFinishScanning(.success(scannedPages))
        }

        func documentCameraViewControllerDidCancel(_ controller: VNDocumentCameraViewController, didDiscardScan scan: VNDocumentCameraScan) {
            scannerView.didCancelScanning()
        }

        func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFailWithError error: Error) {
            scannerView.didFinishScanning(.failure(error))
        }
    }

}

