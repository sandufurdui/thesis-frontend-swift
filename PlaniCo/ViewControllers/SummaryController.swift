//
//  SummaryController.swift
//  PlaniCo
//
//  Created by Sandu Furdui on 21.03.2023.
//

import FirebaseAuth
import UIKit
import SwiftUI
import Charts

class SummaryController: UIViewController , UITableViewDelegate, UITableViewDataSource {
    
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
        return URL(string: "https://thesis-backend-production.up.railway.app/current_month_transactions/\(userID)")!
    }
    
    var current_month_brief_summary_url: URL {
        guard let userID = Auth.auth().currentUser?.uid else {
            fatalError("Unable to get current user ID")
        }
        return URL(string: "https://thesis-backend-production.up.railway.app/current_month_brief_summary/\(userID)")!
    }
    
    var set_anticipated_url: URL {
        guard let userID = Auth.auth().currentUser?.uid else {
            fatalError("Unable to get current user ID")
        }
        return URL(string: "https://thesis-backend-production.up.railway.app/post_anticipated/\(userID)")!
    }
    
    var set_income_url: URL {
        guard let userID = Auth.auth().currentUser?.uid else {
            fatalError("Unable to get current user ID")
        }
        return URL(string: "https://thesis-backend-production.up.railway.app/set_income/\(userID)")!
    }
//
//    let url = URL(string: "http://localhost:8001/post_anticipated/\(self.userID)/\(anticipated)")!
    
    let secondaryTextColor = UIColor(named: "SecondaryTextColor")
    let categoryIconColor = UIColor(named: "categoryIconColor")
    let reversedBackgroundColorSet = UIColor(named: "ReversedBackgroundColorSet")
    let boxBackgroundColor = UIColor(named: "BoxBackgroundColor")
    let separatorColor = UIColor(named: "SecondaryTextColor")
    
    let userID = Auth.auth().currentUser?.uid
    
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateUserImage()
    }
    
    @objc private func addAnticipatedTapped() {
        print("refreshButtonTapped tapped")
        if totalAnticipated == 0 {
            let alert = UIAlertController(title: "Add Anticipated", message: "Please input the sum you want to spend this month. \nPlease note that you can add only once a month and you will not be able to edit it ", preferredStyle: .alert)
            
            // Add a text field for the anticipated spending input
            alert.addTextField { (textField) in
                textField.keyboardType = .decimalPad
                textField.placeholder = "Enter Anticipated"
            }
            
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            
            alert.addAction(UIAlertAction(title: "Add", style: .default, handler: { action in
                // Handle adding new spending here
                if let anticipatedString = alert.textFields?[0].text?.replacingOccurrences(of: ",", with: "."),
                   let anticipated = Float(anticipatedString) {
                    
//                    let url = URL(string: "http://127.0.0.1:8001/post_anticipated/\(self.userID)")!
                    var request = URLRequest(url: self.set_anticipated_url)
                    request.httpMethod = "POST"
                    let jsonBody: [String: Any] = ["totalAnticipated": anticipated]
                    let jsonData = try! JSONSerialization.data(withJSONObject: jsonBody)
                    request.httpBody = jsonData
                    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
 
                    
                    let task = URLSession.shared.dataTask(with: request) { data, response, error in
                        if let error = error {
                            // Handle error here
                            DispatchQueue.main.async {
                                let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                                self.present(alert, animated: true, completion: nil)
                            }
                            return
                        }
                        
                        guard let httpResponse = response as? HTTPURLResponse,
                              (200...299).contains(httpResponse.statusCode) else {
                            // Handle invalid response here
                            DispatchQueue.main.async {
                                let alert = UIAlertController(title: "Error", message: "Invalid response from server", preferredStyle: .alert)
                                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                                self.present(alert, animated: true, completion: nil)
                            }
                            return
                        }
                        
                        // Handle successful response here
                        DispatchQueue.main.async {
                            let alert = UIAlertController(title: "Success", message: "Anticipated spending added successfully", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                            self.present(alert, animated: true, completion: nil)
                        }
                    }

                    task.resume()

                    
                    task.resume()
                }

            }))
            present(alert, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "Anticipated is already addded", message: "The anticipated spending is already added for this month and is set to \(totalAnticipated) lei. \nYou can set one only once a month.", preferredStyle: .alert)
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
    
    @objc private func settingsButtonTapped() {
        print("settings tapped")
        let alert = UIAlertController(title: "Settings", message: "will present settings :)", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        
        present(alert, animated: true, completion: nil)
    }
    
    
    @objc private func refreshButtonTapped() {
        refreshData()
    }
    
    @objc private func addIncomeTapped(income: Int) {
        print("refreshButtonTapped tapped")
        let alert = UIAlertController(title: "Add income", message: "Please input the income you want to add.", preferredStyle: .alert)
        
        // Add a text field for the anticipated spending input
        alert.addTextField { (textField) in
            textField.keyboardType = .decimalPad
            textField.placeholder = "Enter Income"
        }
        
//        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Add", style: .default, handler: { action in
            // Handle adding new spending here
            if let anticipatedString = alert.textFields?[0].text?.replacingOccurrences(of: ",", with: "."),
               let anticipated = Float(anticipatedString) {
                
//                    let url = URL(string: "http://127.0.0.1:8001/post_anticipated/\(self.userID)")!
                var request = URLRequest(url: self.set_income_url)
                request.httpMethod = "POST"
                let jsonBody: [String: Any] = ["income": anticipated]
                let jsonData = try! JSONSerialization.data(withJSONObject: jsonBody)
                request.httpBody = jsonData
                request.addValue("application/json", forHTTPHeaderField: "Content-Type")

                
                let task = URLSession.shared.dataTask(with: request) { data, response, error in
                    if let error = error {
                        // Handle error here
                        DispatchQueue.main.async {
                            let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                            self.present(alert, animated: true, completion: nil)
                        }
                        return
                    }
                    
                    guard let httpResponse = response as? HTTPURLResponse,
                          (200...299).contains(httpResponse.statusCode) else {
                        // Handle invalid response here
                        DispatchQueue.main.async {
                            let alert = UIAlertController(title: "Error", message: "Invalid response from server", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                            self.present(alert, animated: true, completion: nil)
                        }
                        return
                    }
                    
                    // Handle successful response here
                    DispatchQueue.main.async {
                        let alert = UIAlertController(title: "Success", message: "Income added successfully", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    }
                }

                task.resume()

                
                task.resume()
            }

        }))
        present(alert, animated: true, completion: nil)
    }
    
    @objc private func refreshData() {
        // Fetch the data again and update the UI
        getTransactionsData()
        recentTransactions = [summaryItem]()
        getCurrentMonthStats()
        
        DispatchQueue.main.async{
            self.barChartView.view.removeFromSuperview()
            // Add the new bar chart view back to the view hierarchy
            self.barChartView = UIHostingController(rootView: BarChartSwiftUI(storageList: self.localStorageList))
            self.addChild(self.barChartView)
            self.testChartView.addArrangedSubview(self.barChartView.view)
            self.barChartView.didMove(toParent: self)
            self.barChartView.view.backgroundColor = UIColor.clear
            self.testChartView.backgroundColor = UIColor.clear
        }
    }
    
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        print("refresh pulled")
        refreshData()
        DispatchQueue.main.async {
            // End the refreshing state of the control
            refreshControl.endRefreshing()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        createBalanceView()
        createSeparator()
        configureScrollStack()
        createHotButtons()
        createChartSummary()
        configureTable()
        getTransactionsData()
        getCurrentMonthStats()
    }
    
    
    var localStorageList = [Storage(name: "None", value: 100)]
    let scrollView = UIScrollView()
    let chartSummaryStack = UIStackView()
    let testChartView = UIStackView()
    let hotButtonsStack = UIStackView()
    let mainSeparator = UIView()
    let balanceView = UIView()
    let yourBalanceLabel = UILabel()
    let sumLabel = UILabel()
    let spentSumLabel = UILabel()
    let spentInLabel = UILabel()
    var barChartView = UIHostingController(rootView: BarChartSwiftUI(storageList: [Storage(name: "None", value: 100)]))
    var recentTransactions = [summaryItem]()
    var totalSpent = 0.0
    var totalAnticipated = 0.0
    var totalLeft = 0.01
    var totalIncome = 0.0
    
    
    func configureScrollStack(){
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: view.topAnchor, constant: view.frame.height / 3),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
        
        let refreshControl = UIRefreshControl()
        scrollView.addSubview(refreshControl)
        refreshControl.addTarget(self, action: #selector(handleRefresh(_:)), for: .valueChanged)
        
        let contentView = UIView()
        scrollView.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
        ])
        
        hotButtonsStack.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(hotButtonsStack)
        NSLayoutConstraint.activate([
            hotButtonsStack.heightAnchor.constraint(equalToConstant: 100),
            hotButtonsStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            hotButtonsStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            hotButtonsStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: view.frame.height / 20)
        ])
        
        chartSummaryStack.translatesAutoresizingMaskIntoConstraints = false
        chartSummaryStack.backgroundColor = .orange
        contentView.addSubview(chartSummaryStack)
        NSLayoutConstraint.activate([
            chartSummaryStack.heightAnchor.constraint(equalToConstant: view.frame.height / 2),
            chartSummaryStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            chartSummaryStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            chartSummaryStack.topAnchor.constraint(equalTo: hotButtonsStack.bottomAnchor, constant: 32),
            chartSummaryStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -30),
        ])
    }
    
    private var mySection: summarySection {
        let items = recentTransactions
        return summarySection(items: items)
    }
    
    private var myTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = UIColor.clear
        tableView.separatorStyle = .none
        return tableView
    }()
    
    
    func getCurrentMonthStats(){
//        activityIndicator2.startAnimating()
        let task = URLSession.shared.dataTask(with: current_month_brief_summary_url) { (data, response, error) in
            guard let data = data, error == nil else {
                print("Error fetching data: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            do {
                let jsonData = try JSONDecoder().decode(monthSummary.self, from: data )
                DispatchQueue.main.async {
                    self.totalLeft = jsonData.totalLeft
                    self.totalSpent = jsonData.totalSpent
                    self.totalAnticipated = jsonData.totalAnticipated
                    self.totalIncome = jsonData.totalIncome
                    self.yourBalanceLabel.removeFromSuperview()
                    self.sumLabel.removeFromSuperview()
                    self.spentSumLabel.removeFromSuperview()
                    self.spentInLabel.removeFromSuperview()
                    self.createBalanceView()
                    self.createChartSummary()
                    
                    
                    if self.totalIncome == 0 {
                        let alert = UIAlertController(title: "New Income", message: "As it is the start of new month, for the record, please add new income.", preferredStyle: .alert)
                        
                        alert.addTextField { (textField) in
                            textField.keyboardType = .decimalPad
                            textField.placeholder = "Enter Income"
                        }
                        
                //        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                        
                        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                        alert.addAction(UIAlertAction(title: "Add", style: .default, handler: { action in
                            // Handle adding new spending here
                            if let incomeString = alert.textFields?[0].text?.replacingOccurrences(of: ",", with: "."),
                               let income = Float(incomeString) {
                                
                //                    let url = URL(string: "http://127.0.0.1:8001/post_anticipated/\(self.userID)")!
                                var request = URLRequest(url: self.set_income_url)
                                request.httpMethod = "POST"
                                let jsonBody: [String: Any] = ["income": income]
                                let jsonData = try! JSONSerialization.data(withJSONObject: jsonBody)
                                request.httpBody = jsonData
                                request.addValue("application/json", forHTTPHeaderField: "Content-Type")

                                
                                let task = URLSession.shared.dataTask(with: request) { data, response, error in
                                    if let error = error {
                                        // Handle error here
                                        DispatchQueue.main.async {
                                            let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                                            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                                            self.present(alert, animated: true, completion: nil)
                                        }
                                        return
                                    }
                                    
                                    guard let httpResponse = response as? HTTPURLResponse,
                                          (200...299).contains(httpResponse.statusCode) else {
                                        // Handle invalid response here
                                        DispatchQueue.main.async {
                                            let alert = UIAlertController(title: "Error", message: "Invalid response from server", preferredStyle: .alert)
                                            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                                            self.present(alert, animated: true, completion: nil)
                                        }
                                        return
                                    }
                                    
                                    // Handle successful response here
                                    DispatchQueue.main.async {
                                        let alert = UIAlertController(title: "Success", message: "Income added successfully", preferredStyle: .alert)
                                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                                        self.present(alert, animated: true, completion: nil)
                                    }
                                }

                                task.resume()

                                
                                task.resume()
                            }

                        }))
                        self.present(alert, animated: true, completion: nil)
                    }
                    
                    if self.totalAnticipated == 0 {
                        let alert = UIAlertController(title: "New Anticipated", message: "As it is the start of new month, for a better experiance, please input the sum you want to spend this month. \nPlease note that you can add only once a month and you will not be able to edit it", preferredStyle: .alert)
                        
                        // Add a text field for the anticipated spending input
                        alert.addTextField { (textField) in
                            textField.keyboardType = .decimalPad
                            textField.placeholder = "Enter Anticipated"
                        }
                        
                        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                        
                        alert.addAction(UIAlertAction(title: "Add", style: .default, handler: { action in
                            // Handle adding new spending here
                            if let anticipatedString = alert.textFields?[0].text?.replacingOccurrences(of: ",", with: "."),
                               let anticipated = Float(anticipatedString) {
                                
            //                    let url = URL(string: "http://127.0.0.1:8001/post_anticipated/\(self.userID)")!
                                var request = URLRequest(url: self.set_anticipated_url)
                                request.httpMethod = "POST"
                                let jsonBody: [String: Any] = ["totalAnticipated": anticipated]
                                let jsonData = try! JSONSerialization.data(withJSONObject: jsonBody)
                                request.httpBody = jsonData
                                request.addValue("application/json", forHTTPHeaderField: "Content-Type")
             
                                
                                let task = URLSession.shared.dataTask(with: request) { data, response, error in
                                    if let error = error {
                                        // Handle error here
                                        DispatchQueue.main.async {
                                            let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                                            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                                            self.present(alert, animated: true, completion: nil)
                                        }
                                        return
                                    }
                                    
                                    guard let httpResponse = response as? HTTPURLResponse,
                                          (200...299).contains(httpResponse.statusCode) else {
                                        // Handle invalid response here
                                        DispatchQueue.main.async {
                                            let alert = UIAlertController(title: "Error", message: "Invalid response from server", preferredStyle: .alert)
                                            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                                            self.present(alert, animated: true, completion: nil)
                                        }
                                        return
                                    }
                                    
                                    // Handle successful response here
                                    DispatchQueue.main.async {
                                        let alert = UIAlertController(title: "Success", message: "Anticipated spending added successfully", preferredStyle: .alert)
                                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                                        self.present(alert, animated: true, completion: nil)
                                    }
                                }

                                task.resume()

                                
                                task.resume()
                            }

                        }))
                        self.present(alert, animated: true, completion: nil)
                    }
                }
            } catch {
                print("Error decoding JSON: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "Success", message: "Income added successfully", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
                
            }
        }
        task.resume()
    }
    
    
    func getTransactionsData() {
        activityIndicator2.startAnimating()
        let task = URLSession.shared.dataTask(with: current_month_transactions_url) { (data, response, error) in
            guard let data = data, error == nil else {
                print("Error fetching data: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            do {
                var storageDict = [String: Int]()
                let jsonData = try JSONDecoder().decode([TransactionsDataEntry].self, from: data )
                for entry in jsonData {
                    let title = "\(entry.company_name)"
                    let category = "\(entry.category)"
                    let purchase_date_time = "\(entry.purchase_date_time)"
                    let amountValue = Int(entry.purchase_total)
                    let amount = "-\(amountValue) lei"
                    let item = summaryItem(title: title, category: category, purchase_date_time: purchase_date_time, amount: amount)
                    self.recentTransactions.append(item)
                    
                    // Add category totals to storageDict
                    if let existingTotal = storageDict[category] {
                        storageDict[category] = existingTotal + amountValue
                    } else {
                        storageDict[category] = amountValue
                    }
                }
                self.localStorageList = storageDict.map { Storage(name: $0.key, value: $0.value) }
                self.localStorageList.sort(by: { $0.value > $1.value })

                DispatchQueue.main.async {
                    self.barChartView.view.removeFromSuperview()
                    // Add the new bar chart view back to the view hierarchy
                    self.barChartView = UIHostingController(rootView: BarChartSwiftUI(storageList: self.localStorageList))
                    self.addChild(self.barChartView)
                    self.testChartView.addArrangedSubview(self.barChartView.view)
                    self.barChartView.didMove(toParent: self)
                    self.barChartView.view.backgroundColor = UIColor.clear
                    self.testChartView.backgroundColor = UIColor.clear
                    self.myTableView.reloadData()
                    self.activityIndicator2.stopAnimating()
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
        //        activityIndicator2.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        
        myTableView.backgroundColor = boxBackgroundColor
        myTableView.layer.cornerRadius = 15
        myTableView.layer.cornerCurve = .continuous
        
        activityIndicator2.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator2.backgroundColor = UIColor(white: 0.5, alpha: 0.5)
        activityIndicator2.color = .white
        activityIndicator2.style = .large
        
        NSLayoutConstraint.activate([
            myTableView.topAnchor.constraint(equalTo: testChartView.bottomAnchor, constant: 8),
            myTableView.leadingAnchor.constraint(equalTo: chartSummaryStack.leadingAnchor),
            myTableView.trailingAnchor.constraint(equalTo: chartSummaryStack.trailingAnchor),
            myTableView.bottomAnchor.constraint(equalTo: chartSummaryStack.bottomAnchor),
            activityIndicator2.widthAnchor.constraint(equalTo: view.widthAnchor),
            activityIndicator2.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 2/3),
            activityIndicator2.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator2.bottomAnchor.constraint(equalTo: view.bottomAnchor),
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
        print(view.frame.height / 50)
        chartSummaryStack.addSubview(label)
        
        spentSumLabel.text = "\(totalSpent) lei"
        spentSumLabel.textColor = reversedBackgroundColorSet
        spentSumLabel.font = UIFont.systemFont(ofSize: view.frame.height / 35, weight: .medium)
        chartSummaryStack.addSubview(spentSumLabel)
        
        spentInLabel.text = "spent in March"
        spentInLabel.textColor = secondaryTextColor
        spentInLabel.font = UIFont.systemFont(ofSize: view.frame.height / 60, weight: .medium)
        chartSummaryStack.addSubview(spentInLabel)
        
        chartSummaryStack.backgroundColor = boxBackgroundColor
        chartSummaryStack.layer.cornerRadius = 15
        chartSummaryStack.layer.cornerCurve = .continuous
        
        let operationsSeparator = UIView()
        operationsSeparator.backgroundColor = separatorColor
        chartSummaryStack.addSubview(operationsSeparator)
        chartSummaryStack.addSubview(testChartView)
        
        testChartView.addArrangedSubview(barChartView.view)
        addChild(barChartView)
        barChartView.didMove(toParent: self)
        barChartView.view.backgroundColor = UIColor.clear
        
        label.translatesAutoresizingMaskIntoConstraints = false
        spentSumLabel.translatesAutoresizingMaskIntoConstraints = false
        spentInLabel.translatesAutoresizingMaskIntoConstraints = false
        operationsSeparator.translatesAutoresizingMaskIntoConstraints = false
        testChartView.translatesAutoresizingMaskIntoConstraints = false
        chartSummaryStack.translatesAutoresizingMaskIntoConstraints = false
        
        var runtime_warning = ""
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: chartSummaryStack.leadingAnchor, constant: 16),
            label.topAnchor.constraint(equalTo: chartSummaryStack.topAnchor, constant: 24),
            spentSumLabel.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 20),
            spentSumLabel.leadingAnchor.constraint(equalTo: chartSummaryStack.leadingAnchor, constant: 16),
            spentInLabel.bottomAnchor.constraint(equalTo: spentSumLabel.bottomAnchor, constant: -2),
            spentInLabel.leadingAnchor.constraint(equalTo: spentSumLabel.trailingAnchor, constant: 5),
            operationsSeparator.leadingAnchor.constraint(equalTo: chartSummaryStack.leadingAnchor, constant: 16),
            operationsSeparator.trailingAnchor.constraint(equalTo: chartSummaryStack.trailingAnchor, constant: -16),
            operationsSeparator.heightAnchor.constraint(equalToConstant: 0.5),
            operationsSeparator.topAnchor.constraint(equalTo: spentInLabel.bottomAnchor, constant: 15),
            testChartView.leadingAnchor.constraint(equalTo: chartSummaryStack.leadingAnchor ),
            testChartView.trailingAnchor.constraint(equalTo: chartSummaryStack.trailingAnchor),
            testChartView.heightAnchor.constraint(equalToConstant: 15),
            testChartView.topAnchor.constraint(equalTo: spentInLabel.bottomAnchor, constant: 22),
        ])
        
    }
    
    func createHotButtons(){
        hotButtonsStack.backgroundColor = boxBackgroundColor
        hotButtonsStack.layer.cornerRadius = 15
        hotButtonsStack.layer.cornerCurve = .continuous
        
        // Add two vertical separators
        let leftInvisibleSeparator = UIView()
        leftInvisibleSeparator.translatesAutoresizingMaskIntoConstraints = false
        
        let rightInvisibleSeparator = UIView()
        rightInvisibleSeparator.translatesAutoresizingMaskIntoConstraints = false
        
        
        let addIncomeButton = UIButton()
        addIncomeButton.translatesAutoresizingMaskIntoConstraints = false
        addIncomeButton.tintColor = reversedBackgroundColorSet
        let addIncomeLabel = UILabel()
        
        addIncomeLabel.text = "Income"
        addIncomeLabel.textColor = reversedBackgroundColorSet
        addIncomeLabel.font = UIFont.systemFont(ofSize: view.frame.height / 70)
        addIncomeLabel.textAlignment = .center
        addIncomeLabel.translatesAutoresizingMaskIntoConstraints = false
        addIncomeButton.addSubview(addIncomeLabel)
        
        // Add settings icon
        let walletImage = UIImage(named: "wallet")?.withRenderingMode(.alwaysTemplate)
        let walletIconSize = CGSize(width: 35, height: 35)
        UIGraphicsBeginImageContextWithOptions(walletIconSize, false, 0.0)
        let walletRect = CGRect(origin: .zero, size: walletIconSize)
        walletImage?.draw(in: walletRect)
        let scaledWalletImage = UIGraphicsGetImageFromCurrentImageContext()?.withRenderingMode(.alwaysTemplate)
        UIGraphicsEndImageContext()
        addIncomeButton.setImage(scaledWalletImage, for: .normal)
        addIncomeButton.imageView?.contentMode = .scaleAspectFit
        NSLayoutConstraint.activate([
            addIncomeButton.widthAnchor.constraint(equalToConstant: 70),
            addIncomeButton.heightAnchor.constraint(equalToConstant: 70),
            addIncomeLabel.topAnchor.constraint(equalTo: addIncomeButton.imageView!.bottomAnchor, constant: 3),
            addIncomeLabel.leadingAnchor.constraint(equalTo: addIncomeButton.leadingAnchor),
            addIncomeLabel.trailingAnchor.constraint(equalTo: addIncomeButton.trailingAnchor)
        ])
        addIncomeButton.addTarget(self, action: #selector(addIncomeTapped), for: .touchUpInside)
        
        
        
        
        let addAnticipatedButton = UIButton()
        addAnticipatedButton.translatesAutoresizingMaskIntoConstraints = false
        addAnticipatedButton.tintColor = reversedBackgroundColorSet
        let addAnticipatedLabel = UILabel()
        addAnticipatedLabel.text = "Anticipated"
        addAnticipatedLabel.textColor = reversedBackgroundColorSet
        addAnticipatedLabel.font = UIFont.systemFont(ofSize: view.frame.height / 70)
        addAnticipatedLabel.textAlignment = .center
        addAnticipatedLabel.translatesAutoresizingMaskIntoConstraints = false
        addAnticipatedButton.addSubview(addAnticipatedLabel)
        
        // Add settings icon
        let anticipatedImage = UIImage(named: "anticipated")?.withRenderingMode(.alwaysTemplate)
        UIGraphicsBeginImageContextWithOptions(walletIconSize, false, 0.0)
        let anticipatedIconSize = CGSize(width: 32, height: 32)
        let anticipatedRect = CGRect(origin: .zero, size: anticipatedIconSize)
        anticipatedImage?.draw(in: anticipatedRect)
        let scaledAnticipatedImage = UIGraphicsGetImageFromCurrentImageContext()?.withRenderingMode(.alwaysTemplate)
        UIGraphicsEndImageContext()
        addAnticipatedButton.setImage(scaledAnticipatedImage, for: .normal)
        addAnticipatedButton.imageView?.contentMode = .scaleAspectFit
        NSLayoutConstraint.activate([
            addAnticipatedButton.widthAnchor.constraint(equalToConstant: 70),
            addAnticipatedButton.heightAnchor.constraint(equalToConstant: 70),
            addAnticipatedLabel.topAnchor.constraint(equalTo: addAnticipatedButton.imageView!.bottomAnchor, constant: 3),
            addAnticipatedLabel.leadingAnchor.constraint(equalTo: addAnticipatedButton.leadingAnchor),
            addAnticipatedLabel.trailingAnchor.constraint(equalTo: addAnticipatedButton.trailingAnchor)
        ])
        addAnticipatedButton.addTarget(self, action: #selector(addAnticipatedTapped), for: .touchUpInside)
        
        
        
        
        let incomeLeftSeparator = UIView()
        incomeLeftSeparator.backgroundColor = separatorColor
        incomeLeftSeparator.translatesAutoresizingMaskIntoConstraints = false
        
        let anticipatedLeftSeparator = UIView()
        anticipatedLeftSeparator.backgroundColor = separatorColor
        anticipatedLeftSeparator.translatesAutoresizingMaskIntoConstraints = false
        
        let addSpendingButton = UIButton()
        addSpendingButton.translatesAutoresizingMaskIntoConstraints = false
        addSpendingButton.tintColor = reversedBackgroundColorSet
        let addSpendingLabel = UILabel()
        addSpendingLabel.text = "Spending"
        addSpendingLabel.textColor = reversedBackgroundColorSet
        addSpendingLabel.font = UIFont.systemFont(ofSize: view.frame.height / 70)
        addSpendingLabel.textAlignment = .center
        addSpendingLabel.translatesAutoresizingMaskIntoConstraints = false
        addSpendingButton.addSubview(addSpendingLabel)
        
        // Add settings icon
        let cartImage = UIImage(systemName: "cart")?.withRenderingMode(.alwaysTemplate)
        let iconSize3 = CGSize(width: 30, height: 30)
        UIGraphicsBeginImageContextWithOptions(iconSize3, false, 0.0)
        let cartRect = CGRect(origin: .zero, size: iconSize3)
        cartImage?.draw(in: cartRect)
        let scaledCartImage = UIGraphicsGetImageFromCurrentImageContext()?.withRenderingMode(.alwaysTemplate)
        UIGraphicsEndImageContext()
        addSpendingButton.setImage(scaledCartImage, for: .normal)
        addSpendingButton.imageView?.contentMode = .scaleAspectFit
        NSLayoutConstraint.activate([
            addSpendingButton.widthAnchor.constraint(equalToConstant: 70),
            addSpendingButton.heightAnchor.constraint(equalToConstant: 70),
            addSpendingLabel.topAnchor.constraint(equalTo: addSpendingButton.imageView!.bottomAnchor, constant: 5.5),
            addSpendingLabel.leadingAnchor.constraint(equalTo: addSpendingButton.leadingAnchor),
            addSpendingLabel.trailingAnchor.constraint(equalTo: addSpendingButton.trailingAnchor)
        ])
        addSpendingButton.addTarget(self, action: #selector(addSpendingTapped), for: .touchUpInside)
        
        // Add the separators and buttons to the stack view as arranged subviews
        hotButtonsStack.addArrangedSubview(leftInvisibleSeparator)
        hotButtonsStack.addArrangedSubview(addIncomeButton)
        hotButtonsStack.addArrangedSubview(incomeLeftSeparator)
        hotButtonsStack.addArrangedSubview(addAnticipatedButton)
        hotButtonsStack.addArrangedSubview(anticipatedLeftSeparator)
        hotButtonsStack.addArrangedSubview(addSpendingButton)
        hotButtonsStack.addArrangedSubview(rightInvisibleSeparator)
        
        // Set the width of the separators to be equal to the spacing between the arranged subviews
        incomeLeftSeparator.widthAnchor.constraint(equalToConstant: 0.5).isActive = true
        anticipatedLeftSeparator.widthAnchor.constraint(equalToConstant: 0.5).isActive = true
        incomeLeftSeparator.heightAnchor.constraint(equalToConstant: 50).isActive = true
        anticipatedLeftSeparator.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        // Set the distribution and alignment of the stack view
        hotButtonsStack.axis = .horizontal
        hotButtonsStack.distribution = .equalSpacing
        hotButtonsStack.alignment = .center
    }
    
    
    func createSeparator(){
        mainSeparator.translatesAutoresizingMaskIntoConstraints = false
        mainSeparator.backgroundColor = separatorColor
        view.addSubview(mainSeparator)
        
        mainSeparator.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        mainSeparator.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        mainSeparator.heightAnchor.constraint(equalToConstant: 2).isActive = true
        mainSeparator.topAnchor.constraint(equalTo: view.topAnchor, constant: view.frame.height / 3).isActive = true
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
    
    
    private func createBalanceView() {
        balanceView.translatesAutoresizingMaskIntoConstraints = false
        
        
        yourBalanceLabel.translatesAutoresizingMaskIntoConstraints = false
        if self.totalLeft > 0 {
            yourBalanceLabel.text = "You can spend"
        } else {
            yourBalanceLabel.text = "You have exceeded your limit by"
        }
        yourBalanceLabel.textColor = secondaryTextColor
        yourBalanceLabel.font = UIFont.systemFont(ofSize: view.frame.height / 50, weight: .light)
        balanceView.addSubview(yourBalanceLabel)
        
        sumLabel.translatesAutoresizingMaskIntoConstraints = false
        sumLabel.text = "\(self.totalLeft) lei"
        if self.totalLeft > 0 {
            sumLabel.textColor = reversedBackgroundColorSet
        } else {
            sumLabel.textColor = .red
        }
        
        sumLabel.font = UIFont.systemFont(ofSize: view.frame.height / 15 , weight: .light)
        balanceView.addSubview(sumLabel)
        view.addSubview(balanceView)
        
        NSLayoutConstraint.activate([
            balanceView.topAnchor.constraint(equalTo: view.topAnchor, constant: view.frame.height / 5),
            balanceView.widthAnchor.constraint(equalTo: view.widthAnchor),
            balanceView.heightAnchor.constraint(equalToConstant: view.frame.height / 50 + view.frame.height / 15),
            yourBalanceLabel.topAnchor.constraint(equalTo: balanceView.topAnchor),
            yourBalanceLabel.leadingAnchor.constraint(equalTo: balanceView.leadingAnchor, constant: 24),
            sumLabel.topAnchor.constraint(equalTo: yourBalanceLabel.bottomAnchor),
            sumLabel.leadingAnchor.constraint(equalTo: balanceView.leadingAnchor, constant: 24)
        ])
    }
}

 
struct BarChartSwiftUI: View {
    @State private var storageList: [Storage]
    
    init(storageList: [Storage]) {
        _storageList = State(initialValue: storageList)
    }
    
    var body: some View {
        Chart {
            ForEach(storageList) { item in
                BarMark(
                    x: .value("Name", item.value),
                    y: .value("Storage", item.type),
                    stacking: .center)
                .foregroundStyle(chartColors[item.name] ?? .blue)
//                                .foregroundStyle(by: .value("Storage", item.type))
                    .cornerRadius(10)
            }
        }
        .padding(.horizontal, 16)
        .frame(maxWidth: .infinity, minHeight: 15, maxHeight: 15)
        .chartXAxis(.hidden)
        .chartYAxis(.hidden)
    }
}

struct Storage: Identifiable {
    let id = UUID().uuidString
    let type: String = "Storage"
    let name: String
    let value: Int
    
    init(name: String, value: Int) {
        self.name = name
        self.value = value
    }
}

struct CellModel: Decodable {
    let title: String
    let subtitle: String
}


struct TransactionsDataEntry: Decodable {
    let post_id: String
    let scanned_date: String
    let purchase_date_time: String
    let company_type: String
    let company_name: String
    let category: String
    let user_id: String
    let company_legal_name: String
    let purchase_total: Double
}


struct monthSummary: Decodable{
    let totalSpent: Double
    let totalLeft: Double
    let totalAnticipated: Double
    let totalIncome: Double
}
