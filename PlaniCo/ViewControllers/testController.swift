//
//  testController.swift
//  PlaniCo
//
//  Created by Sandu Furdui on 22.03.2023.
//

import FirebaseAuth
import UIKit
import SwiftUI
import Charts

class testController: UIViewController , UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mySection.items.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 60
        }

    
    @objc func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        let item = mySection.items[indexPath.row]
        
        // Add icon and rounded square background
        let iconImageView = UIImageView(frame: CGRect(x: 24, y: 8, width: 32, height: 32))
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.image = UIImage(named: item.category!.lowercased())
//        iconImageView.tintColor = .red
//        if let color = chartColors[item.category!.lowercased()] {
//            iconImageView.tintColor = color
//        } else {
//            iconImageView.tintColor = .gray
//        }
//        iconImageView.image = iconImage

        // Add rounded corners to iconImageView
//        iconImageView.layer.cornerRadius = 10
        iconImageView.layer.cornerCurve = .continuous
        iconImageView.clipsToBounds = true
        cell.contentView.addSubview(iconImageView)
        
        let iconBackgroundView = UIView(frame: CGRect(x: 0, y: 0, width: 48, height: 48))
        var iconBackgroundColor: UIColor?
        if let color = chartColorsUIKit[item.category!.lowercased()] {
            iconBackgroundColor = color
        } else {
            iconBackgroundColor = categoryIconColor // fallback color if category is not found in chartColors
        }
        iconBackgroundView.backgroundColor = iconBackgroundColor
        iconBackgroundView.layer.cornerRadius = 15
        iconBackgroundView.layer.cornerCurve = .continuous
        iconBackgroundView.center = iconImageView.center
        cell.contentView.addSubview(iconBackgroundView)
        
        let titleLabel = UILabel(frame: CGRect(x: 72, y: 0, width: tableView.frame.width - 120, height: 24))
        titleLabel.text = item.title
        titleLabel.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        titleLabel.textColor = reversedBackgroundColorSet
        cell.contentView.addSubview(titleLabel)
        
        let detailLabel = UILabel(frame: CGRect(x: 72, y: 24, width: tableView.frame.width - 120, height: 20))
        detailLabel.text = item.category
        detailLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        detailLabel.textColor = .gray
        cell.contentView.addSubview(detailLabel)

        // Show only the first 2 words of the date time string
        let words = item.purchase_date_time!.components(separatedBy: .whitespaces)
        let truncatedDate = words.prefix(2).joined(separator: " ")

        let dateLabel = UILabel(frame: CGRect(x: 0, y: 24, width: 0, height: 20))
        dateLabel.text = truncatedDate
        dateLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        dateLabel.textColor = .gray
        dateLabel.sizeToFit()
        let dateLabelXPosition = tableView.frame.width - dateLabel.frame.width - 16  // 16 is the right padding
        dateLabel.frame.origin.x = dateLabelXPosition
        cell.contentView.addSubview(dateLabel)

        let amountLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 84, height: 24))
        amountLabel.text = item.amount
        amountLabel.font = UIFont.systemFont(ofSize: 18, weight: .light)
        amountLabel.textColor = reversedBackgroundColorSet
        amountLabel.textAlignment = .right
        let amountLabelXPosition = tableView.frame.width - amountLabel.frame.width - 16 // 16 is the right padding
        amountLabel.frame.origin.x = amountLabelXPosition
        cell.contentView.addSubview(amountLabel)

        cell.contentView.addSubview(iconBackgroundView)
        cell.contentView.addSubview(iconImageView)
        cell.contentView.bringSubviewToFront(iconImageView)
        cell.backgroundColor = item.backgroundColor ?? boxBackgroundColor
        return cell
    }
    
    var current_month_transactions_url: URL {
        guard let userID = Auth.auth().currentUser?.uid else {
            fatalError("Unable to get current user ID")
        }
        //                return URL(string: "https://thesis-backend-production.up.railway.app/current_month_transactions/\(userID)")!
        return URL(string: "https://thesis-backend-production.up.railway.app/current_month_transactions/\(userID)")!
    }
    
    let secondaryTextColor = UIColor(named: "SecondaryTextColor")
    let categoryIconColor = UIColor(named: "categoryIconColor")
    let reversedBackgroundColorSet = UIColor(named: "ReversedBackgroundColorSet")
    let boxBackgroundColor = UIColor(named: "BoxBackgroundColor")
    let separatorColor = UIColor(named: "SecondaryTextColor")
    
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

    // Declare timer and buttonPressCount at the class or file scope
    var timer: Timer?
    var buttonPressCount = 0

    @objc private func refreshButtonTapped() {
        if buttonPressCount == 0 {
            // Start a timer to reset buttonPressCount after 10 seconds
            timer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true) { [weak self] _ in
                self?.buttonPressCount = 0
            }
        }
        
        // Increment buttonPressCount and check if it exceeds the limit
        buttonPressCount += 1
        if buttonPressCount > 1 {
            // Cancel the timer and display an alert
            timer?.invalidate()
            let alert = UIAlertController(title: "Button Pressed Too Many Times", message: "Please wait 10 seconds before pressing the button again.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
        } else {
            // Refresh the data
            refreshData()
        }
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
        configureTable()
        get_transactions_data()
    }
    
    @objc private func refreshData() {
        // Fetch the data again and update the UI
        get_transactions_data()
//        setData()
//        configureTable()
        itemss = [summaryItem]()
        // Stop the refreshing animation
//        refreshControl.endRefreshing()
    }
    
    let chartSummaryStack = UIStackView()

    
    private var mySection: summarySection {
        let items = itemss
        return summarySection(items: items)
    }
    
    private var myTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = UIColor.clear
        tableView.separatorStyle = .none
        return tableView
    }()
    
    var itemss = [summaryItem]()
    func get_transactions_data() {
        activityIndicator2.startAnimating()
        let task = URLSession.shared.dataTask(with: current_month_transactions_url) { (data, response, error) in
            guard let data = data, error == nil else {
                print("Error fetching data: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            do {
                let jsonData = try JSONDecoder().decode([TransactionsDataEntry].self, from: data )
                for entry in jsonData {
                    let title = "\(entry.company_name)"
                    let category = "\(entry.category)"
                    let purchase_date_time = "\(entry.purchase_date_time)"
                    let amountValue = Int(entry.purchase_total)
                    let amount = "-\(amountValue) lei"
                    let item = summaryItem(title: title, category: category, purchase_date_time: purchase_date_time, amount: amount)
                    self.itemss.append(item)
                }
                DispatchQueue.main.async {
                    self.activityIndicator2.stopAnimating()
                    self.myTableView.reloadData()
                }

            } catch {
                print("Error decoding JSON: \(error.localizedDescription)")
            }
        }
        task.resume()
    }
    
    
    
    func configureTable(){
        chartSummaryStack.addSubview(myTableView)
        chartSummaryStack.addSubview(activityIndicator2)
        NSLayoutConstraint.activate([
            activityIndicator2.centerXAnchor.constraint(equalTo: chartSummaryStack.centerXAnchor),
            activityIndicator2.centerYAnchor.constraint(equalTo: chartSummaryStack.centerYAnchor),
            myTableView.topAnchor.constraint(equalTo: chartSummaryStack.topAnchor, constant: view.frame.height / 5),
            myTableView.leadingAnchor.constraint(equalTo: chartSummaryStack.leadingAnchor),
            myTableView.trailingAnchor.constraint(equalTo: chartSummaryStack.trailingAnchor),
            myTableView.heightAnchor.constraint(equalTo: chartSummaryStack.heightAnchor, multiplier: 1/2),
        ])
        myTableView.dataSource = self
        myTableView.delegate = self
    }
    
    
    
    private var activityIndicator2: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.color = .gray
        return indicator
    }()
    
    
    
    
    func createChartSummary() {
        chartSummaryStack.backgroundColor = boxBackgroundColor
        chartSummaryStack.layer.cornerRadius = 15
        chartSummaryStack.layer.cornerCurve = .continuous
        
        let label = UILabel()
        label.text = "Operations"
        label.textColor = reversedBackgroundColorSet
        label.font = UIFont.systemFont(ofSize: view.frame.height / 50, weight: .medium)
        chartSummaryStack.addSubview(label)
        
        let spentSumLabel = UILabel()
        spentSumLabel.text = "2157.9 lei"
        spentSumLabel.textColor = reversedBackgroundColorSet
        spentSumLabel.font = UIFont.systemFont(ofSize: view.frame.height / 35, weight: .medium)
        chartSummaryStack.addSubview(spentSumLabel)
        
        //        spentSumLabel.backgroundColor = UIColor.red
        
        let spentInLabel = UILabel()
        spentInLabel.text = "spent in March"
        spentInLabel.textColor = secondaryTextColor
        spentInLabel.font = UIFont.systemFont(ofSize: view.frame.height / 60, weight: .medium)
        chartSummaryStack.addSubview(spentInLabel)
        
//        let barChartView = UIHostingController(rootView: BarChartSwiftUI())
//        chartSummaryStack.addArrangedSubview(barChartView.view)
//        addChild(barChartView)
//        barChartView.didMove(toParent: self)
//        barChartView.view.backgroundColor = UIColor.clear
        
        
        
//        let testChartView = UIView()
        
        let operationsSeparator = UIView()
        operationsSeparator.backgroundColor = .red
        chartSummaryStack.addSubview(operationsSeparator)
        
        let testChartView = UIView()
        testChartView.backgroundColor = .green
        chartSummaryStack.addSubview(testChartView)
        
        var ddd = ""

        view.addSubview(chartSummaryStack)
        label.translatesAutoresizingMaskIntoConstraints = false
        spentSumLabel.translatesAutoresizingMaskIntoConstraints = false
        spentInLabel.translatesAutoresizingMaskIntoConstraints = false
//        barChartView.view.translatesAutoresizingMaskIntoConstraints = false
        operationsSeparator.translatesAutoresizingMaskIntoConstraints = false
        chartSummaryStack.translatesAutoresizingMaskIntoConstraints = false
        var runtime_warning = ""
        NSLayoutConstraint.activate([
            
            chartSummaryStack.heightAnchor.constraint(equalToConstant: view.frame.height / 3),
            chartSummaryStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            chartSummaryStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            chartSummaryStack.topAnchor.constraint(equalTo: hotButtonsStack.bottomAnchor, constant: 30),
            testChartView.leadingAnchor.constraint(equalTo: chartSummaryStack.leadingAnchor, constant: 16),
            testChartView.trailingAnchor.constraint(equalTo: chartSummaryStack.trailingAnchor, constant: -16),
            testChartView.heightAnchor.constraint(equalToConstant: 0.5),
            testChartView.topAnchor.constraint(equalTo: spentInLabel.bottomAnchor, constant: 20),
            label.leadingAnchor.constraint(equalTo: chartSummaryStack.leadingAnchor, constant: 16),
            label.topAnchor.constraint(equalTo: chartSummaryStack.topAnchor, constant: 24),
            spentSumLabel.topAnchor.constraint(equalTo: chartSummaryStack.topAnchor, constant: 60),
            spentSumLabel.leadingAnchor.constraint(equalTo: chartSummaryStack.leadingAnchor, constant: 16),
            spentInLabel.bottomAnchor.constraint(equalTo: spentSumLabel.bottomAnchor, constant: -2),
            spentInLabel.leadingAnchor.constraint(equalTo: spentSumLabel.trailingAnchor, constant: 5),
            //"next constrait is causing the runtime warning"
//            barChartView.view.bottomAnchor.constraint(equalTo: chartSummaryStack.bottomAnchor, constant: 5),
            operationsSeparator.leadingAnchor.constraint(equalTo: chartSummaryStack.leadingAnchor, constant: 16),
            operationsSeparator.trailingAnchor.constraint(equalTo: chartSummaryStack.trailingAnchor, constant: -16),
            operationsSeparator.heightAnchor.constraint(equalToConstant: 0.5),
            operationsSeparator.topAnchor.constraint(equalTo: spentInLabel.bottomAnchor, constant: 20),
        ])
        
    }
    
    
    
  
    let hotButtonsStack = UIStackView()
    func createHotButtons(){
        hotButtonsStack.backgroundColor = boxBackgroundColor
        hotButtonsStack.layer.cornerRadius = 15
        hotButtonsStack.layer.cornerCurve = .continuous
        
        view.addSubview(hotButtonsStack)
        hotButtonsStack.translatesAutoresizingMaskIntoConstraints = false
        hotButtonsStack.heightAnchor.constraint(equalToConstant: 100).isActive = true
        hotButtonsStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24).isActive = true
        hotButtonsStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24).isActive = true
        hotButtonsStack.topAnchor.constraint(equalTo: vieww.bottomAnchor, constant: view.frame.height / 20 * 2 + 2).isActive = true
        
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
        button1.tintColor = reversedBackgroundColorSet
        let label = UILabel()
        label.text = "Income"
        label.textColor = reversedBackgroundColorSet
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
        //        button1.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 5)
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
        button2.tintColor = reversedBackgroundColorSet
        let label2 = UILabel()
        label2.text = "Anticipated"
        label2.textColor = reversedBackgroundColorSet
        label2.font = UIFont.systemFont(ofSize: view.frame.height / 70)
        label2.textAlignment = .center
        label2.translatesAutoresizingMaskIntoConstraints = false
        button2.addSubview(label2)
        
        // Add settings icon
        let image2 = UIImage(named: "anticipated")?.withRenderingMode(.alwaysTemplate)
        UIGraphicsBeginImageContextWithOptions(iconSize, false, 0.0)
        let iconSize2 = CGSize(width: 32, height: 32)
        let rect2 = CGRect(origin: .zero, size: iconSize2)
        image2?.draw(in: rect2)
        let scaledImage2 = UIGraphicsGetImageFromCurrentImageContext()?.withRenderingMode(.alwaysTemplate)
        UIGraphicsEndImageContext()
        button2.setImage(scaledImage2, for: .normal)
        button2.imageView?.contentMode = .scaleAspectFit
        //        button2.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 5)
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
        button3.tintColor = reversedBackgroundColorSet
        let label3 = UILabel()
        label3.text = "Spending"
        label3.textColor = reversedBackgroundColorSet
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
        //        button3.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 5)
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
        separator.topAnchor.constraint(equalTo: vieww.bottomAnchor, constant: view.frame.height / 20).isActive = true
    }
    
    
    private func configureNavigationBar() {
        guard let navigationBar = navigationController?.navigationBar else { return }
        navigationBar.prefersLargeTitles = true
        let secondaryTextColor = UIColor(named: "secondaryTextColor")
        navigationBar.titleTextAttributes = [.foregroundColor: secondaryTextColor ?? .systemOrange]
        navigationBar.largeTitleTextAttributes = [.foregroundColor: secondaryTextColor ?? .systemOrange]
        
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
        yourBalanceLabel.textColor = secondaryTextColor
        yourBalanceLabel.font = UIFont.systemFont(ofSize: view.frame.height / 50, weight: .light)
        vieww.addSubview(yourBalanceLabel)
        
        let sumLabel = UILabel()
        sumLabel.translatesAutoresizingMaskIntoConstraints = false
        sumLabel.text = "2232.23 lei"
        sumLabel.textColor = reversedBackgroundColorSet
        sumLabel.font = UIFont.systemFont(ofSize: view.frame.height / 15 , weight: .light)
        vieww.addSubview(sumLabel)
        view.addSubview(vieww)
        
        NSLayoutConstraint.activate([
            vieww.topAnchor.constraint(equalTo: view.topAnchor, constant: view.frame.height / 5),
            vieww.widthAnchor.constraint(equalTo: view.widthAnchor),
            vieww.heightAnchor.constraint(equalToConstant: view.frame.height / 50 + view.frame.height / 15),
            yourBalanceLabel.topAnchor.constraint(equalTo: vieww.topAnchor),
            yourBalanceLabel.leadingAnchor.constraint(equalTo: vieww.leadingAnchor, constant: 24),
            sumLabel.topAnchor.constraint(equalTo: yourBalanceLabel.bottomAnchor),
            sumLabel.leadingAnchor.constraint(equalTo: vieww.leadingAnchor, constant: 24)
        ])
    }
}


//let chartColors = ["1": UIColor(named: "chartColors/beige"),
//                   "poultry": UIColor(named: "brightRed"),
//                   "3": UIColor(named: "bronze"),
//                   "4": UIColor(named: "chartColors/deepBrown"),
//                   "grocery": UIColor(named: "forestGreen"),
//                   "6": UIColor(named: "chartColors/navyBlue"),
//                   "7": UIColor(named: "paleYellow"),
//                   "33": UIColor(named: "seafoamGreen"),
//                   "clothing": UIColor(named: "sienna"),
//                   "meat shop": UIColor(named: "purpleRed"),
//                   "pharma": UIColor(named: "pharmacyBlue"),
//                   "gas": UIColor(named: "stoneBlue"),
//                   "restaurant": UIColor(named: "yellow")]

//
//struct Test: View {
//    var body: some View {
//        Chart {
//            ForEach(storage) { item in
//                BarMark(
//                    x: .value("Name", item.value),
//                    y: .value("Storage", item.type),
//                    stacking: .center)
//                .foregroundStyle(by: .value("Name", item.name))
//                .cornerRadius(10)
////                .chartForegroundStyleScale(type: <#T##Charts.ScaleType?#>)
//            }
//        }
//        .padding(.horizontal, 16)
//        .frame(maxWidth: .infinity, minHeight: 35, maxHeight: 35)
//        .background(Color.clear)
//        .chartXAxis(.hidden)
//        .chartYAxis(.hidden)
//    }
//}

//
//struct Storage: Identifiable {
//    let id = UUID().uuidString
//    let type: String = "Storage"
//    let name: String
//    let value: Int
//
//    init(name: String, value: Int) {
//        self.name = name
//        self.value = value
//    }
//}

//var storage: [Storage] = [
//    .init(name: "Photos", value: 40),
//    .init(name: "Video", value: 30),
//    .init(name: "Music", value: 20),
//    .init(name: "Docs", value: 10)
//]


//
//struct CellModel: Decodable {
//    let title: String
//    let subtitle: String
//}
