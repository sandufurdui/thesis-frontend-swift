//
//  temp.swift
//  PlaniCo
//
//  Created by Sandu Furdui on 31.03.2023.
//

import Foundation
////
////  ViewController.swift
////  PlaniCo
////
////  Created by Sandu Furdui on 31.03.2023.
////
//
//import UIKit
//
////class ViewController: UIViewController {
////
////    override func viewDidLoad() {
////        super.viewDidLoad()
////        // Do any additional setup after loading the view.
////    }
////
////
////}
//
//
//import SwiftUI
//
//class ViewController: UIViewController {
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        // Create a SwiftUI Pie view and wrap it in a UIHostingController
//        let pieView = Pie(slices: [
//            (10, .red),
//            (3, .orange),
//            (4, .yellow),
//            (1, .green),
//            (5, .blue),
//            (4, .blue),
//            (2, .purple)
//        ])
//        let hostingController = UIHostingController(rootView: pieView)
////        hostingController.background
//        // Add the hosting controller's view to the view hierarchy
//        addChild(hostingController)
//        view.addSubview(hostingController.view)
//        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            hostingController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//            hostingController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
//            hostingController.view.topAnchor.constraint(equalTo: view.topAnchor),
//            hostingController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
//        ])
//        hostingController.didMove(toParent: self)
//        
//    }
//
//}
//
//struct Pie: View {
//
//    @State var slices: [(Double, Color)]
//
//    var body: some View {
//        Canvas { context, size in
//            let total = slices.reduce(0) { $0 + $1.0 }
//            context.translateBy(x: size.width * 0.5, y: size.height * 0.5)
//
//            let radius = min(size.width, size.height) * 0.5
//            let donutRadius = radius * 0.5
//            
//            let donut = Path { p in
//                p.addEllipse(in: CGRect(x: -donutRadius, y: -donutRadius, width: donutRadius * 2, height: donutRadius * 2))
//                p.addEllipse(in: CGRect(x: -radius, y: -radius, width: radius * 2, height: radius * 2))
//            }
//            context.clip(to: donut, style: .init(eoFill: true))
//
//            var pieContext = context
//            pieContext.rotate(by: .degrees(-90))
//            var startAngle = Angle.zero
//            for (value, color) in slices {
//                let angle = Angle(degrees: 360 * (value / total))
//                let endAngle = startAngle + angle
//                let path = Path { p in
//                    p.move(to: .zero)
//                    p.addArc(center: .zero, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: false)
//                    p.addLine(to: CGPoint(x: 0, y: 0))
//                }
//                pieContext.fill(path, with: .color(color))
//
//                startAngle = endAngle
//            }
//        }
//        .aspectRatio(1, contentMode: .fit)
//    }
//}
//
//
////struct Pie_Previews: PreviewProvider {
////    static var previews: some View {
////        Pie(slices: [
////            (2, .red),
////            (3, .orange),
////            (4, .yellow),
////            (1, .green),
////            (5, .blue),
////            (4, .indigo),
////            (2, .purple)
////        ])
////    }
////}
//
