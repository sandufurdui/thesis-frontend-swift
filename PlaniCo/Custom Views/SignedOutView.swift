//
//  SignedOutView.swift
//  PlaniCo
//
//  Created by Sandu Furdui on 21.02.2023.
//


import UIKit

// This view is shown on the `User` screen when no one in signed in.
final class SignedOutView: UIView {
  init() {
    super.init(frame: CGRect.zero)
    setupSubviews()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

    //Layout exclamation symbol and label explaining there is no user signed in
  private func setupSubviews() {
    let systemImageName = "exclamationmark.circle"
    let placeHolderImage = UIImage(systemName: systemImageName)?
      .withTintColor(.secondaryLabel, renderingMode: .alwaysOriginal)
    let imageView = UIImageView(image: placeHolderImage)
    imageView.translatesAutoresizingMaskIntoConstraints = false
    addSubview(imageView)
    NSLayoutConstraint.activate([
      imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
      imageView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -50),
      imageView.heightAnchor.constraint(equalToConstant: 100),
      imageView.widthAnchor.constraint(equalToConstant: 100),
    ])

    let label = UILabel()
    label.numberOfLines = 3
    label.attributedText = configuredAttributedString()
    addSubview(label)
    label.translatesAutoresizingMaskIntoConstraints = false
    label.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20).isActive = true
    label.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
    label.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.80).isActive = true
  }

  private func configuredAttributedString() -> NSAttributedString {
    let paragraph = NSMutableParagraphStyle()
    paragraph.lineBreakMode = .byWordWrapping
    paragraph.alignment = .center

    let attributes: [NSAttributedString.Key: Any] = [
      .paragraphStyle: paragraph,
      .foregroundColor: UIColor.secondaryLabel,
    ]

    let imageAttachment = NSTextAttachment()
    let imageName = "person.crop.circle.fill.badge.plus"
    // MARK: - systemOrange
    let accentColor = UIColor(named: "AccentColor")
    let image = UIImage(systemName: imageName)?
          .withTintColor(accentColor ?? .systemOrange, renderingMode: .alwaysOriginal)
    imageAttachment.image = image

    let firstPartOfString = "There are no users currently signed in. Press the "
    let secondPartOfString = " button on the tab bar and select a login option."
    let fullString = NSMutableAttributedString(string: firstPartOfString)
    fullString.append(NSAttributedString(attachment: imageAttachment))
    fullString.append(NSAttributedString(string: secondPartOfString))
    fullString.addAttributes(attributes, range: NSRange(location: 0, length: fullString.length))

    return fullString
  }
}
