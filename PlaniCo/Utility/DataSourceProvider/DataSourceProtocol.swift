//
//  DataSourceProtocol.swift
//  PlaniCo
//
//  Created by Sandu Furdui on 21.02.2023.
//


import UIKit

/// Models an object that can be used as an item in a tableview
protocol Itemable {
  var title: String? { get }
  var detailTitle: String? { get }
  var image: UIImage? { get set }
  var textColor: UIColor? { get }
  var isEditable: Bool { get }
  var hasNestedContent: Bool { get set }
  var isChecked: Bool { get set }
}

/// Models an object that can be used as a section in a tableview
protocol Sectionable {
  associatedtype Item: Itemable
  var headerDescription: String? { get }
  var footerDescription: String? { get }
  var items: [Item] { get set }
}

/// Delegate Protocol to handle cell selection and tableview scrolling
protocol DataSourceProviderDelegate: AnyObject {
  func didSelectRowAt(_ indexPath: IndexPath, on tableView: UITableView)
  func tableViewDidScroll(_ tableView: UITableView)
}

extension DataSourceProviderDelegate {
  /// Provide default implementation to prevent a required implementation when conforming to this protocol
  func tableViewDidScroll(_ tableView: UITableView) {}
}

/// Models a type that can be used for the datasource in a DataSourceProvider
protocol DataSourceProvidable {
  associatedtype Section: Sectionable
  var sections: [Section] { get }
}

