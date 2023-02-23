//
//  Model.swift
//  PlaniCo
//
//  Created by Sandu Furdui on 22.02.2023.
//

import Foundation
class TextItem: Identifiable {
    var id: String
    var text: String = ""
    
    init() {
        id = UUID().uuidString
    }
}


class RecognizedContent: ObservableObject {
    @Published var items = [TextItem]()
}
