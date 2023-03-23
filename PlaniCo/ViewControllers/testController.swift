//
//  testController.swift
//  PlaniCo
//
//  Created by Sandu Furdui on 22.03.2023.
//


import FirebaseAuth
import UIKit
import Charts

class testController: UIViewController {
    //    var userImage = UIImageView(systemImageName: "person.circle.fill", tintColor: .secondaryLabel)
    let accentColor = UIColor(named: "SecondaryTextColor")
    let accentColor1 = UIColor(named: "ReversedBackgroundColorSet")
    let boxBackgroundColor = UIColor(named: "BoxBackgroundColor")
    let separatorColor = UIColor(named: "SecondaryTextColor")
    let chartColors = ["color1": UIColor(named: "chartColors/beige"),
                       "color2": UIColor(named: "chartColors/brightRed"),
                       "color3": UIColor(named: "chartColors/bronze"),
                       "color4": UIColor(named: "chartColors/deepBrown"),
                       "color5": UIColor(named: "chartColors/forestGreen"),
                       "color6": UIColor(named: "chartColors/navyBlue"),
                       "color7": UIColor(named: "chartColors/paleYellow"),
                       "color8": UIColor(named: "chartColors/seafoamGreen"),
                       "color9": UIColor(named: "chartColors/sepia"),
                       "color10": UIColor(named: "chartColors/sienna"),
                       "color11": UIColor(named: "chartColors/slateBlue"),
                       "color12": UIColor(named: "chartColors/stoneGrey"),
                       "color12": UIColor(named: "chartColors/yellow")]

    
    let userImage: UIImageView = {
        let imageView = UIImageView(systemImageName: "person.circle.fill", tintColor: .secondaryLabel)
        return imageView
    }()
    
    private var _user: User?
    var user: User? {
        get { _user ?? Auth.auth().currentUser }
        set { _user = newValue }
    }
    
    // Init allows for injecting a `User` instance during UI Testing
    // - Parameter user: A Firebase User instance
    init(_ user: User? = nil) {
        super.init(nibName: nil, bundle: nil)
        self.user = user
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func updateUserImage() {
        guard let photoURL = user?.photoURL else {
            let defaultImage = UIImage(systemName: "person.circle.fill")
            userImage.image = defaultImage?.withTintColor(.secondaryLabel, renderingMode: .alwaysOriginal)
            return
        }
        userImage.setImage(from: photoURL)
    }
    
    @objc private func settingsButtonTapped() {
        print("settings tapped")
    }
    
    @objc private func refreshButtonTapped() {
        print("refreshButtonTapped tapped")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateUserImage()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        createBalanceView()
        createHotButtons()
        createSeparator()
        
    }
    let separator = UIView()
    func createSeparator(){
        separator.translatesAutoresizingMaskIntoConstraints = false
        separator.backgroundColor = separatorColor
        view.addSubview(separator)
        
        // Add constraints to position the separator within the stack view
        separator.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        separator.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        separator.heightAnchor.constraint(equalToConstant: 2).isActive = true
        separator.topAnchor.constraint(equalTo: vieww.bottomAnchor, constant: view.frame.height / 15).isActive = true
    }
    
    let hotButtonsStack = UIStackView()
    func createHotButtons(){
        hotButtonsStack.backgroundColor = boxBackgroundColor
        hotButtonsStack.layer.cornerRadius = 10
        hotButtonsStack.layer.cornerCurve = .continuous

        view.addSubview(hotButtonsStack)
        hotButtonsStack.translatesAutoresizingMaskIntoConstraints = false
        hotButtonsStack.heightAnchor.constraint(equalToConstant: 100).isActive = true
        hotButtonsStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24).isActive = true
        hotButtonsStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24).isActive = true
        hotButtonsStack.topAnchor.constraint(equalTo: vieww.bottomAnchor, constant: view.frame.height / 15 * 2 + 2).isActive = true

        // Add two vertical separators
        let separator0 = UIView()
        separator0.translatesAutoresizingMaskIntoConstraints = false
        
        let separator10 = UIView()
        separator10.translatesAutoresizingMaskIntoConstraints = false
        
        let separator1 = UIView()
        separator1.backgroundColor = separatorColor
        separator1.translatesAutoresizingMaskIntoConstraints = false

        
        let button1 = UIButton()
        button1.translatesAutoresizingMaskIntoConstraints = false
        button1.tintColor = accentColor1
        let label = UILabel()
        label.text = "Income"
        label.textColor = accentColor1
        label.font = UIFont.systemFont(ofSize: view.frame.height / 70)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        button1.addSubview(label)
        
        // Add settings icon
        let image = UIImage(named: "wallet")?.withRenderingMode(.alwaysTemplate)
        let iconSize = CGSize(width: 35, height: 35)
        UIGraphicsBeginImageContextWithOptions(iconSize, false, 0.0)
        let rect = CGRect(origin: .zero, size: iconSize)
        image?.draw(in: rect)
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()?.withRenderingMode(.alwaysTemplate)
        UIGraphicsEndImageContext()
        button1.setImage(scaledImage, for: .normal)
        button1.imageView?.contentMode = .scaleAspectFit
        button1.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 5)
        NSLayoutConstraint.activate([
            button1.widthAnchor.constraint(equalToConstant: 70),
            button1.heightAnchor.constraint(equalToConstant: 70),
            label.topAnchor.constraint(equalTo: button1.imageView!.bottomAnchor, constant: 3),
            label.leadingAnchor.constraint(equalTo: button1.leadingAnchor),
            label.trailingAnchor.constraint(equalTo: button1.trailingAnchor)
        ])
        button1.addTarget(self, action: #selector(lllll), for: .touchUpInside)



        
        let button2 = UIButton()
        button2.translatesAutoresizingMaskIntoConstraints = false
        button2.tintColor = accentColor1
        let label2 = UILabel()
        label2.text = "Anticipated"
        label2.textColor = accentColor1
        label2.font = UIFont.systemFont(ofSize: view.frame.height / 70)
        label2.textAlignment = .center
        label2.translatesAutoresizingMaskIntoConstraints = false
        button2.addSubview(label2)
        
        // Add settings icon
        let image2 = UIImage(named: "anticipated")?.withRenderingMode(.alwaysTemplate)
        UIGraphicsBeginImageContextWithOptions(iconSize, false, 0.0)
        let rect2 = CGRect(origin: .zero, size: iconSize)
        image2?.draw(in: rect2)
        let scaledImage2 = UIGraphicsGetImageFromCurrentImageContext()?.withRenderingMode(.alwaysTemplate)
        UIGraphicsEndImageContext()
        button2.setImage(scaledImage2, for: .normal)
        button2.imageView?.contentMode = .scaleAspectFit
        button2.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 5)
        NSLayoutConstraint.activate([
            button2.widthAnchor.constraint(equalToConstant: 70),
            button2.heightAnchor.constraint(equalToConstant: 70),
            label2.topAnchor.constraint(equalTo: button2.imageView!.bottomAnchor, constant: 3),
            label2.leadingAnchor.constraint(equalTo: button2.leadingAnchor),
            label2.trailingAnchor.constraint(equalTo: button2.trailingAnchor)
        ])
        button2.addTarget(self, action: #selector(lllll), for: .touchUpInside)
        
        
        
        
        let separator2 = UIView()
        separator2.backgroundColor = separatorColor
        separator2.translatesAutoresizingMaskIntoConstraints = false

//        let button2 = UIButton()
//        button2.setTitle("Button 2", for: .normal)
//        button2.backgroundColor = .green
//        button2.translatesAutoresizingMaskIntoConstraints = false

        let separator3 = UIView()
        separator3.backgroundColor = separatorColor
        separator3.translatesAutoresizingMaskIntoConstraints = false

//        let button3 = UIButton()
//        button3.setTitle("Button 3", for: .normal)
//        button3.backgroundColor = .red
//        button3.translatesAutoresizingMaskIntoConstraints = false

        
        let button3 = UIButton()
        button3.translatesAutoresizingMaskIntoConstraints = false
        button3.tintColor = accentColor1
        let label3 = UILabel()
        label3.text = "Spending"
        label3.textColor = accentColor1
        label3.font = UIFont.systemFont(ofSize: view.frame.height / 70)
        label3.textAlignment = .center
        label3.translatesAutoresizingMaskIntoConstraints = false
        button3.addSubview(label3)
        
        // Add settings icon
        let image3 = UIImage(systemName: "cart")?.withRenderingMode(.alwaysTemplate)
        let iconSize3 = CGSize(width: 30, height: 30)
        UIGraphicsBeginImageContextWithOptions(iconSize3, false, 0.0)
        let rect3 = CGRect(origin: .zero, size: iconSize3)
        image3?.draw(in: rect3)
        let scaledImage3 = UIGraphicsGetImageFromCurrentImageContext()?.withRenderingMode(.alwaysTemplate)
        UIGraphicsEndImageContext()
        button3.setImage(scaledImage3, for: .normal)
        button3.imageView?.contentMode = .scaleAspectFit
        button3.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 5)
        NSLayoutConstraint.activate([
            button3.widthAnchor.constraint(equalToConstant: 70),
            button3.heightAnchor.constraint(equalToConstant: 70),
            label3.topAnchor.constraint(equalTo: button3.imageView!.bottomAnchor, constant: 5.5),
            label3.leadingAnchor.constraint(equalTo: button3.leadingAnchor),
            label3.trailingAnchor.constraint(equalTo: button3.trailingAnchor)
        ])
        button3.addTarget(self, action: #selector(lllll), for: .touchUpInside)
        
        
        
        
        // Add the separators and buttons to the stack view as arranged subviews
        hotButtonsStack.addArrangedSubview(separator0)
        hotButtonsStack.addArrangedSubview(button1)
        hotButtonsStack.addArrangedSubview(separator2)
        hotButtonsStack.addArrangedSubview(button2)
        hotButtonsStack.addArrangedSubview(separator3)
        hotButtonsStack.addArrangedSubview(button3)
        hotButtonsStack.addArrangedSubview(separator10)

        // Set the width of the separators to be equal to the spacing between the arranged subviews
        separator2.widthAnchor.constraint(equalToConstant: 0.5).isActive = true
        separator3.widthAnchor.constraint(equalToConstant: 0.5).isActive = true
        separator2.heightAnchor.constraint(equalToConstant: 50).isActive = true
        separator3.heightAnchor.constraint(equalToConstant: 50).isActive = true

        // Set the distribution and alignment of the stack view
        hotButtonsStack.axis = .horizontal
        hotButtonsStack.distribution = .equalSpacing
        hotButtonsStack.alignment = .center


    }
    @objc func lllll() {
        print("Settings button tapped!")
    }
    
    
    
    
    private func configureNavigationBar() {
        guard let navigationBar = navigationController?.navigationBar else { return }
        navigationBar.prefersLargeTitles = true
        let accentColor = UIColor(named: "AccentColor")
        navigationBar.titleTextAttributes = [.foregroundColor: accentColor ?? .systemOrange]
        navigationBar.largeTitleTextAttributes = [.foregroundColor: accentColor ?? .systemOrange]
        
        // Create and configure the title label
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        var firstName = " "
        if let displayName = user?.displayName {
            firstName = String(displayName.split(separator: " ", maxSplits: 1, omittingEmptySubsequences: true).first ?? "")
        }
        titleLabel.text = "Hey, " + (firstName)
        
        // Create and configure the subtitle label
        let subtitleLabel = UILabel()
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        //        subtitleLabel.text = user?.email
        subtitleLabel.text = "Welcome Back!"
        // Add the profile picture and labels to the navigation bar
        navigationBar.addHomeProfilePic(userImage, titleLabel: titleLabel, subtitleLabel: subtitleLabel)
        
        // Create and configure the settings button
        let settingsButton = UIButton(type: .system)
        settingsButton.setImage(UIImage(systemName: "gearshape"), for: .normal)
        settingsButton.addTarget(self, action: #selector(settingsButtonTapped), for: .touchUpInside)
        settingsButton.translatesAutoresizingMaskIntoConstraints = false
        
        // Create and configure the refresh button
        let refreshButton = UIButton(type: .system)
        refreshButton.setImage(UIImage(systemName: "arrow.clockwise"), for: .normal)
        refreshButton.addTarget(self, action: #selector(refreshButtonTapped), for: .touchUpInside)
        refreshButton.translatesAutoresizingMaskIntoConstraints = false
        
        // Add the buttons to the navigation bar
        navigationBar.addSubview(settingsButton)
        navigationBar.addSubview(refreshButton)
        NSLayoutConstraint.activate([
            settingsButton.widthAnchor.constraint(equalToConstant: 30),
            settingsButton.heightAnchor.constraint(equalToConstant: 30),
            settingsButton.trailingAnchor.constraint(equalTo: navigationBar.trailingAnchor, constant: -16),
            settingsButton.centerYAnchor.constraint(equalTo: navigationBar.centerYAnchor),
            refreshButton.widthAnchor.constraint(equalToConstant: 30),
            refreshButton.heightAnchor.constraint(equalToConstant: 30),
            refreshButton.trailingAnchor.constraint(equalTo: settingsButton.leadingAnchor, constant: -16),
            refreshButton.centerYAnchor.constraint(equalTo: navigationBar.centerYAnchor)
        ])
    }
    let vieww = UIView()
    private func createBalanceView() {
        //        let vieww = UIView()
        vieww.translatesAutoresizingMaskIntoConstraints = false
        
        let yourBalanceLabel = UILabel()
        yourBalanceLabel.translatesAutoresizingMaskIntoConstraints = false
        yourBalanceLabel.text = "You can spend"
        yourBalanceLabel.textColor = accentColor
        yourBalanceLabel.font = UIFont.systemFont(ofSize: view.frame.height / 50, weight: .light)
        vieww.addSubview(yourBalanceLabel)
        
        let sumLabel = UILabel()
        sumLabel.translatesAutoresizingMaskIntoConstraints = false
        sumLabel.text = "2232.23 lei"
        sumLabel.textColor = accentColor1
        sumLabel.font = UIFont.systemFont(ofSize: view.frame.height / 15 , weight: .light)
        vieww.addSubview(sumLabel)
        view.addSubview(vieww)
        
        NSLayoutConstraint.activate([
            //            vieww.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            vieww.topAnchor.constraint(equalTo: view.topAnchor, constant: view.frame.height / 5),
            //            vieww.bottomAnchor.constraint(equalTo: view.topAnchor, constant: view.frame.height / 5),
            vieww.widthAnchor.constraint(equalTo: view.widthAnchor),
            vieww.heightAnchor.constraint(equalToConstant: view.frame.height / 50 + view.frame.height / 15),
            //            vieww.heightAnchor.constraint(equalToConstant: 100),
            yourBalanceLabel.topAnchor.constraint(equalTo: vieww.topAnchor),
            yourBalanceLabel.leadingAnchor.constraint(equalTo: vieww.leadingAnchor, constant: 24),
            //            yourBalanceLabel.bottomAnchor.constraint(equalTo: vieww.trailingAnchor, constant: 100),
            //            yourBalanceLabel.bottomAnchor.constraint(equalTo: sumLabel.topAnchor, constant: -4),
            //
            sumLabel.topAnchor.constraint(equalTo: yourBalanceLabel.bottomAnchor),
            sumLabel.leadingAnchor.constraint(equalTo: vieww.leadingAnchor, constant: 24),
            //            sumLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            //            sumLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        //        return view
    }
    
}


//    private func configureNavigationBar() {
//        guard let navigationBar = navigationController?.navigationBar else { return }
//        navigationBar.prefersLargeTitles = true
//        let accentColor = UIColor(named: "AccentColor")
//        navigationBar.titleTextAttributes = [.foregroundColor: accentColor ?? .systemOrange]
//        navigationBar.largeTitleTextAttributes = [.foregroundColor: accentColor ?? .systemOrange]
//
//        // Create and configure the title label
//        let titleLabel = UILabel()
//        titleLabel.translatesAutoresizingMaskIntoConstraints = false
//        var firstName = " "
//        if let displayName = user?.displayName {
//            firstName = String(displayName.split(separator: " ", maxSplits: 1, omittingEmptySubsequences: true).first ?? "")
//        }
//        titleLabel.text = "Hey, " + (firstName)
//
//        // Create and configure the subtitle label
//        let subtitleLabel = UILabel()
//        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
//        subtitleLabel.text = user?.email
//
//        // Add the profile picture and labels to the navigation bar
//        navigationBar.addHomeProfilePic(userImage, titleLabel: titleLabel, subtitleLabel: subtitleLabel)
//
//        // Create and configure the settings button
//        let settingsButton = UIBarButtonItem(image: UIImage(systemName: "gearshape.fill"), style: .plain, target: self, action: #selector(settingsButtonTapped))
//
//        // Create and configure the refresh button
//        let refreshButton = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(refreshButtonTapped))
//
//        // Add the buttons to the navigation bar
//        navigationItem.rightBarButtonItems = [settingsButton, refreshButton]
//    }
