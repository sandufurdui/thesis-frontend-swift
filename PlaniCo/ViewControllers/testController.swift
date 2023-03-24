//
//  testController.swift
//  PlaniCo
//
//  Created by Sandu Furdui on 22.03.2023.
//

import FirebaseAuth
import UIKit
import Charts 
//import SwiftyMenu

class testController: UIViewController {

    
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
                       "color13": UIColor(named: "chartColors/yellow")]

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
    
    let anticipated = 120
    let income = 100
    @objc private func settingsButtonTapped() {
        print("settings tapped")
        let alert = UIAlertController(title: "Settings", message: "will present settings :)", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))

        present(alert, animated: true, completion: nil)
    }
    
    @objc private func refreshButtonTapped() {
        print("refreshButtonTapped tapped")
        let alert = UIAlertController(title: "Refresh", message: "refreshed :)", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))

        present(alert, animated: true, completion: nil)
    }
    
    @objc private func addIncomeTapped(income: Int) {
        print("refreshButtonTapped tapped")
        let alert = UIAlertController(title: "Add income", message: "Please input the income.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Add", style: .default, handler: { action in
            // Handle adding new spending here
        }))
        present(alert, animated: true, completion: nil)
    }

    
    @objc private func addAnticipatedTapped() {
        print("refreshButtonTapped tapped")
        if anticipated == 0 {
            let alert = UIAlertController(title: "Add Anticipated", message: "Please input the sum you want to spend this month. \nPlease note that you can add only once a month and you will not be able to edit it ", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "Add", style: .default, handler: { action in
                // Handle adding new spending here
            }))
            present(alert, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "Anticipated is already addded", message: "The anticipated spending is already added for this month and is set to \(anticipated) lei. \nYou can set one only once a month.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }
    @objc private func addSpendingTapped() {
        print("refreshButtonTapped tapped")
        
        let alert = UIAlertController(title: "Add Spending", message: "Do you want to add a new spending?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Add", style: .default, handler: { action in
            // Handle adding new spending here
        }))
        present(alert, animated: true, completion: nil)
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
        createChartSummary()
    }
    
    let chartSummaryStack = UIStackView()
    
    
    
    
    
    
    
    
    
    
    
    let currentMonthLabel = UILabel()
    func createChartSummary() {
        chartSummaryStack.backgroundColor = boxBackgroundColor
        chartSummaryStack.layer.cornerRadius = 10
        chartSummaryStack.layer.cornerCurve = .continuous
        
        // Add label to top left corner
        let label = UILabel()
        label.text = "Operations"
        label.textColor = accentColor1
        label.font = UIFont.systemFont(ofSize: view.frame.height / 50, weight: .medium)
        chartSummaryStack.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.leadingAnchor.constraint(equalTo: chartSummaryStack.leadingAnchor, constant: 16).isActive = true
        label.topAnchor.constraint(equalTo: chartSummaryStack.topAnchor, constant: 24).isActive = true
        
        // Add label to top left corner
        let spentText = UILabel()
        spentText.text = "2157. lei"
        spentText.textColor = accentColor1
        spentText.font = UIFont.systemFont(ofSize: view.frame.height / 35, weight: .medium)
        chartSummaryStack.addSubview(spentText)
        spentText.translatesAutoresizingMaskIntoConstraints = false
        spentText.topAnchor.constraint(equalTo: chartSummaryStack.topAnchor, constant: view.frame.height / 50 + 48).isActive = true
        spentText.leadingAnchor.constraint(equalTo: chartSummaryStack.leadingAnchor, constant: 16).isActive = true
        
        // Add label to top left corner
        let spentText2 = UILabel()
        spentText2.text = "spent in March"
        spentText2.textColor = accentColor
        spentText2.font = UIFont.systemFont(ofSize: view.frame.height / 60, weight: .medium)
        chartSummaryStack.addSubview(spentText2)
        spentText2.translatesAutoresizingMaskIntoConstraints = false
        spentText2.bottomAnchor.constraint(equalTo: spentText.bottomAnchor, constant: -2).isActive = true
        spentText2.leadingAnchor.constraint(equalTo: spentText.trailingAnchor, constant: 5).isActive = true
        
        
        
        
        
        
        
        
        
            
            // Add chart summary stack to view
            view.addSubview(chartSummaryStack)
            chartSummaryStack.translatesAutoresizingMaskIntoConstraints = false
            chartSummaryStack.heightAnchor.constraint(equalToConstant: 200).isActive = true
            chartSummaryStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24).isActive = true
            chartSummaryStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24).isActive = true
            chartSummaryStack.topAnchor.constraint(equalTo: hotButtonsStack.bottomAnchor, constant: 30).isActive = true
            
        
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
        button1.addTarget(self, action: #selector(addIncomeTapped), for: .touchUpInside)



        
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
        button2.addTarget(self, action: #selector(addAnticipatedTapped), for: .touchUpInside)
        
        
        
        
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
        button3.addTarget(self, action: #selector(addSpendingTapped), for: .touchUpInside)
        
        
        
        
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
