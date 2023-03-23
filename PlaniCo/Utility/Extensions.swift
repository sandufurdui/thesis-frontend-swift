//
//  Extensions.swift
//  PlaniCo
//
//  Created by Sandu Furdui on 21.02.2023.
//


import UIKit
import FirebaseAuth

// MARK: - Extending a `Firebase User` to conform to `DataSourceProvidable`

extension User: DataSourceProvidable {
    private var infoSection: Section {
        let items = [
            //        Item(title: providerID, detailTitle: "Provider ID"),
            Item(title: uid, detailTitle: "UUID"),
            Item(title: displayName ?? "––", detailTitle: "Numele de afișare", isEditable: true),
            Item(
                title: photoURL?.absoluteString ?? "––",
                detailTitle: "Adresa URL a fotografiei",
                isEditable: true
            ),
            Item(title: email ?? "––", detailTitle: "Email", isEditable: true),
            Item(title: phoneNumber ?? "––", detailTitle: "Numar de telefon")]
        return Section(headerDescription: "Info", items: items)
    }
    
    private var metaDataSection: Section {
        let metadataRows = [
            Item(title: metadata.lastSignInDate?.description, detailTitle: "Data ultimei conectări"),
            Item(title: metadata.creationDate?.description, detailTitle: "Data creării"),
        ]
        return Section(headerDescription: "Metadate", items: metadataRows)
    }
    
    private var otherSection: Section {
        let otherRows = [
            //        Item(title: isAnonymous ? "Yes" : "No", detailTitle: "Is User Anonymous?"),
            Item(title: isEmailVerified ? "Da" : "Nu", detailTitle: "E-mailul este verificat?")]
        return Section(headerDescription: "Altele", items: otherRows)
    }
    
    private var actionSection: Section {
        let actionsRows = [
            Item(title: UserAction.refreshUserInfo.rawValue, textColor: .systemBlue),
            Item(title: UserAction.requestVerifyEmail.rawValue, textColor: .systemBlue),
            Item(title: UserAction.signOut.rawValue, textColor: .systemBlue),
            //      Item(title: UserAction.tokenRefresh.rawValue, textColor: .systemBlue),
            //      Item(title: UserAction.delete.rawValue, textColor: .systemRed),
        ]
        return Section(headerDescription: "Acțiuni", items: actionsRows)
    }
    private var deleteSection: Section {
        let actionsRows = [
            Item(title: UserAction.delete.rawValue, textColor: .systemRed),
        ]
        
        return Section(headerDescription: "Șterge profilul", items: actionsRows)
    }
    
    var sections: [Section] {
        [infoSection, metaDataSection, otherSection, actionSection, deleteSection]
    }
}

// MARK: - UIKit Extensions

extension UIViewController {
    public func displayError(_ error: Error?, from function: StaticString = #function) {
        guard let error = error else { return }
        print("ⓧ Error in \(function): \(error.localizedDescription)")
        let message = "\(error.localizedDescription)\n\n Ocurred in \(function)"
        let errorAlertController = UIAlertController(
            title: "Error",
            message: message,
            preferredStyle: .alert
        )
        errorAlertController.addAction(UIAlertAction(title: "OK", style: .default))
        present(errorAlertController, animated: true, completion: nil)
    }
}

extension UINavigationController {
    func configureTabBar(title: String, systemImageName: String) {
        let tabBarItemImage = UIImage(systemName: systemImageName)
        tabBarItem = UITabBarItem(title: title,
                                  image: tabBarItemImage?.withRenderingMode(.alwaysTemplate),
                                  selectedImage: tabBarItemImage)
    }
    
    enum titleType: CaseIterable {
        case regular, large
    }
    
    func setTitleColor(_ color: UIColor, _ types: [titleType] = titleType.allCases) {
        if types.contains(.regular) {
            navigationBar.titleTextAttributes = [.foregroundColor: color]
        }
        if types.contains(.large) {
            navigationBar.largeTitleTextAttributes = [.foregroundColor: color]
        }
    }
}

extension UITextField {
    func setImage(_ image: UIImage?) {
        guard let image = image else { return }
        let imageView = UIImageView(image: image)
        imageView.frame = CGRect(x: 10, y: 10, width: 20, height: 20)
        imageView.contentMode = .scaleAspectFit
        
        let containerView = UIView()
        containerView.frame = CGRect(x: 20, y: 0, width: 40, height: 40)
        containerView.addSubview(imageView)
        leftView = containerView
        leftViewMode = .always
    }
}

extension UIImageView {
    convenience init(systemImageName: String, tintColor: UIColor? = nil) {
        var systemImage = UIImage(systemName: systemImageName)
        if let tintColor = tintColor {
            systemImage = systemImage?.withTintColor(tintColor, renderingMode: .alwaysOriginal)
        }
        self.init(image: systemImage)
    }
    
    func setImage(from url: URL?) {
        guard let url = url else { return }
        DispatchQueue.global(qos: .background).async {
            guard let data = try? Data(contentsOf: url) else { return }
            
            let image = UIImage(data: data)
            DispatchQueue.main.async {
                self.image = image
                self.contentMode = .scaleAspectFit
            }
        }
    }
}

extension UIImage {
    static func systemImage(_ systemName: String, tintColor: UIColor) -> UIImage? {
        let systemImage = UIImage(systemName: systemName)
        return systemImage?.withTintColor(tintColor, renderingMode: .alwaysOriginal)
    }
}

extension UIColor {
    static let highlightedLabel = UIColor.label.withAlphaComponent(0.8)
    
    var highlighted: UIColor { withAlphaComponent(0.8) }
    
    var image: UIImage {
        let pixel = CGSize(width: 1, height: 1)
        return UIGraphicsImageRenderer(size: pixel).image { context in
            self.setFill()
            context.fill(CGRect(origin: .zero, size: pixel))
        }
    }
}

// MARK: UINavigationBar + UserDisplayable Protocol

protocol UserDisplayable {
    func addProfilePic(_ imageView: UIImageView)
}

extension UINavigationBar: UserDisplayable {
    func addProfilePic(_ imageView: UIImageView) {
        let length = frame.height * 0.46
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = length / 2
        imageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5),
            imageView.heightAnchor.constraint(equalToConstant: length),
            imageView.widthAnchor.constraint(equalToConstant: length),
        ])
    }
    
    func addHomeProfilePic(_ imageView: UIImageView, titleLabel: UILabel, subtitleLabel: UILabel) {
        let length = frame.height * 0.7
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = length / 2
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        titleLabel.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        subtitleLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        subtitleLabel.textColor = .gray
        
        addSubview(imageView)
        addSubview(titleLabel)
        addSubview(subtitleLabel)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32),
            imageView.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            imageView.heightAnchor.constraint(equalToConstant: length),
            imageView.widthAnchor.constraint(equalToConstant: length),
            
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 24),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: CGFloat(length + 48)),
            
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            subtitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: CGFloat(length + 48)),
        ])
    }

    func addUserGreeting(_ titleLabel: UILabel, subtitleLabel: UILabel) {
        titleLabel.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        subtitleLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        subtitleLabel.textColor = .gray
        
        let containerView = UIView(frame: CGRect(x: 0, y: 0, width: 60, height: 60))
        containerView.addSubview(titleLabel)
        containerView.addSubview(subtitleLabel)
        
        addSubview(containerView)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerView.topAnchor.constraint(equalTo: topAnchor),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            subtitleLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            subtitleLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
        ])
    }


}

// MARK: Extending UITabBarController to work with custom transition animator

extension UITabBarController: UITabBarControllerDelegate {
    public func tabBarController(_ tabBarController: UITabBarController,
                                 animationControllerForTransitionFrom fromVC: UIViewController,
                                 to toVC: UIViewController)
    -> UIViewControllerAnimatedTransitioning? {
        let fromIndex = tabBarController.viewControllers!.firstIndex(of: fromVC)!
        let toIndex = tabBarController.viewControllers!.firstIndex(of: toVC)!
        
        let direction: Animator.TransitionDirection = fromIndex < toIndex ? .right : .left
        return Animator(direction)
    }
    
    func transitionToViewController(atIndex index: Int) {
        selectedIndex = index
    }
}

// MARK: - Foundation Extensions

extension Date {
    var description: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        return dateFormatter.string(from: self)
    }
}
