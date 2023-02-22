//
//  Section.swift
//  PlaniCo
//
//  Created by Sandu Furdui on 21.02.2023.

import UIKit

// Model object for a section in a tableview
struct Section: Sectionable {
  var headerDescription: String?
  var footerDescription: String?
  var items: [Item]
}

// Model object for a cell in a tableview section
struct Item: Itemable {
  var title: String?
  var detailTitle: String?
  var textColor: UIColor?
  let isEditable: Bool
  var hasNestedContent: Bool
  var isChecked: Bool

  private var _image: UIImage?
  var image: UIImage? {
    get { _image ?? UIImage(named: title ?? "?") }
    set { _image = newValue }
  }

  init(title: String? = nil,
       detailTitle: String? = nil,
       textColor: UIColor? = .label,
       isEditable: Bool = false,
       hasNestedContent: Bool = false,
       isChecked: Bool = false,
       image: UIImage? = nil) {
    self.title = title
    self.detailTitle = detailTitle
    self.textColor = textColor
    self.isEditable = isEditable
    self.hasNestedContent = hasNestedContent
    self.isChecked = isChecked
    self.image = image
  }
}

