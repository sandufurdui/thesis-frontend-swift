////
////  testController.swift
////  PlaniCo
////
////  Created by Sandu Furdui on 22.03.2023.
////
//
//import UIKit
//import FirebaseAuth
//
//class testController: UIViewController {
//    var dataSourceProvider: DataSourceProvider<AuthProvider>!
//    var tableView: UITableView!
//    var items: [[String: Any]] = []
//
//    var url: URL {
//        guard let userID = Auth.auth().currentUser?.uid else {
//            fatalError("Unable to get current user ID")
//        }
//        return URL(string: "https://thesis-backend-production.up.railway.app/get_transactions_data/\(userID)")!
//    }
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        configureNavigationBar()
//        configureTableView()
//
//        loadData()
//    }
//
//    private func configureNavigationBar() {
//        navigationItem.title = "All Transactions"
//        guard let navigationBar = navigationController?.navigationBar else { return }
//        navigationBar.prefersLargeTitles = true
//        let accentColor = UIColor(named: "AccentColor")
//        navigationBar.titleTextAttributes = [.foregroundColor: accentColor ?? .systemOrange]
//        navigationBar.largeTitleTextAttributes = [.foregroundColor: accentColor ?? .systemOrange]
//    }
//
//    private func configureTableView() {
//        tableView = UITableView(frame: view.bounds, style: .plain)
//        tableView.dataSource = self
//        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
//        view.addSubview(tableView)
//
//
//        //         Add pull-to-refresh functionality
//        let refreshControl = UIRefreshControl()
//        refreshControl.addTarget(self, action: #selector(loadData), for: .valueChanged)
//        tableView.refreshControl = refreshControl
//    }
//
//    @objc private func loadData() {
//        self.items.removeAll()
//        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
//            guard let data = data, error == nil else {
//                print("Error fetching data: \(error?.localizedDescription ?? "Unknown error")")
//                return
//            }
//
//            do {
//                let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
//                if let dict = json as? [String: Any], let data = dict["data"] {
//                    self.items = data as! [[String : Any]]
//
//                    // Sort items by purchase date
//                    self.items.sort { (item1, item2) -> Bool in
//                        guard let date1String = item1["purchase_date_time"] as? String, let date2String = item2["purchase_date_time"] as? String else {
//                            return false
//                        }
//                        let formatter = DateFormatter()
//                        formatter.dateFormat = "dd MMM yyyy, HH:mm"
//                        guard let date1 = formatter.date(from: date1String), let date2 = formatter.date(from: date2String) else {
//                            return false
//                        }
//                        return date1 > date2
//                    }
//
//                    DispatchQueue.main.async {
//                        self.tableView.reloadData()
//                        self.tableView.refreshControl?.endRefreshing()
//                    }
//                } else {
//                    print("Invalid JSON format")
//                }
//            } catch {
//                print("Error parsing JSON: \(error.localizedDescription)")
//            }
//
//        }
//        task.resume()
//    }
//
//}
//// MARK: - UITableViewDataSource
//
//extension testController: UITableViewDataSource {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return items.count
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
//        var purchaseTotal = 0.0
//        var companyName = ""
//        var purchaseDateTimeString = ""
//        var category = ""
//
//        if indexPath.row < items.count {
//            let item = items[indexPath.row]
//            purchaseTotal = item["purchase_total"] as? Double ?? 0.0
//            companyName = item["company_name"] as? String ?? ""
//            purchaseDateTimeString = item["purchase_date_time"] as? String ?? ""
//            category = item["category"] as? String ?? ""
//            var content = cell.defaultContentConfiguration()
//            content.text = "\(companyName): \(purchaseTotal) lei"
//            content.secondaryText = "\(category), \(purchaseDateTimeString)"
//            cell.contentConfiguration = content
//
//
//        } else {
//            print("Index out of range: \(indexPath.row)")
//        }
//
//        cell.detailTextLabel?.textColor = .gray
//        cell.backgroundColor = .systemGray5
//        cell.selectionStyle = .none
//
//        // Set margin for contentView
//        cell.contentView.layoutMargins = UIEdgeInsets(top: 10, left: 16, bottom: 10, right: 16)
//        cell.contentView.backgroundColor = .white
//        cell.contentView.layer.cornerRadius = 10
//
//        cell.contentView.layer.masksToBounds = true
//
//        // Hide separator line
//        cell.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
//
//        return cell
//    }
//}



//let xx = { "recentTransactions": [ {"post_id": "2ab7aee9-8a1d-4cb9-a303-8115cafef22a", "scanned_date": "10 Mar 2023, 15:20", "purchase_date_time": "10 Mar 2023, 15:19", "purchase_total": 234.68, "company_type": "SRL", "company_name": "Nr.1 Supermarket", "category": "meal", "user_id": "fwvDxHqq1qOUEYxkC0bYBiH2T0z2", "company_legal_name": "A.B.C. GURMANDIS"} ], "diagramData":  [ {"month": "Jan", "spent": 1200, "anticipated": 1000, "income": 2500}, {"month": "Feb", "spent": 1300, "anticipated": 1100, "income": 2600}, {"month": "Mar", "spent": 1400, "anticipated": 1200, "income": 2700} ]}

//let dasda = [{"post_id": "2ab7aee9-8a1d-4cb9-a303-8115cafef22a", "scanned_date": "10 Mar 2023, 15:20", "purchase_date_time": "10 Mar 2023, 15:19", "purchase_total": 234.68, "company_type": "SRL", "company_name": "Nr.1 Supermarket", "category": "meal", "user_id": "fwvDxHqq1qOUEYxkC0bYBiH2T0z2", "company_legal_name": "A.B.C. GURMANDIS"},{"post_id": "3d1f96e7-44fd-4444-92fc-7d5cc49d4b8e", "scanned_date": "14 Mar 2023, 14:22", "purchase_date_time": "14 Mar 2023, 14:21", "purchase_total": 64.27, "company_type": "SRL", "company_name": "Linella", "category": "meal", "user_id": "fwvDxHqq1qOUEYxkC0bYBiH2T0z2", "company_legal_name": "MOLDRETAIL GROUP"},{"post_id": "3d7fc436-df1c-4d58-9067-158ae1571a74", "scanned_date": "11 Mar 2023, 17:56", "purchase_date_time": "11 Mar 2023, 17:55", "purchase_total": 58.85, "company_type": "SRL", "company_name": "Linella", "category": "meal", "user_id": "fwvDxHqq1qOUEYxkC0bYBiH2T0z2", "company_legal_name": "MOLDRETAIL GROUP"},{"post_id": "5d47ec2f-1fb8-4e3e-a961-b1303b956df9", "scanned_date": "20 Mar 2023, 14:19", "purchase_date_time": "20 Mar 2023, 14:17", "purchase_total": 182.56, "company_type": "SRL", "company_name": "Nr.1 Supermarket", "category": "meal", "user_id": "fwvDxHqq1qOUEYxkC0bYBiH2T0z2", "company_legal_name": "47TH PARALLEL"},{"post_id": "92ccd7da-6091-4719-9fc0-718ef79342d8", "scanned_date": "13 Mar 2023, 12:52", "purchase_date_time": "13 Mar 2023, 12:40", "purchase_total": 53.8, "company_type": "SRL", "company_name": "Nr.1 Supermarket", "category": "meal", "user_id": "fwvDxHqq1qOUEYxkC0bYBiH2T0z2", "company_legal_name": "47TH PARALLEL"},{"post_id": "bc1d2a8d-65af-4de6-9947-5611926758eb", "scanned_date": "10 Mar 2023, 02:20", "purchase_date_time": "04 Mar 2023, 17:20", "purchase_total": 39.8, "company_type": "SRL", "company_name": "Nr.1 Supermarket", "category": "meal", "user_id": "fwvDxHqq1qOUEYxkC0bYBiH2T0z2", "company_legal_name": "47TH PARALLEL"},{"post_id": "efe97356-db3e-4d9c-add9-dd079e0f089e", "scanned_date": "16 Mar 2023, 16:10", "purchase_date_time": "16 Mar 2023, 16:09", "purchase_total": 236.79, "company_type": "SRL", "company_name": "Linella", "category": "meal", "user_id": "fwvDxHqq1qOUEYxkC0bYBiH2T0z2", "company_legal_name": "MOLDRETAIL GROUP"},{"post_id": "f15eaa4b-4d90-440c-a423-178518e8b1c2", "scanned_date": "13 Mar 2023, 13:39", "purchase_date_time": "13 Mar 2023, 13:36", "purchase_total": 220, "company_type": "None", "company_name": "Floreni", "category": " poultry", "user_id": "fwvDxHqq1qOUEYxkC0bYBiH2T0z2", "company_legal_name": "None"}]













import FirebaseAuth
import UIKit
import Charts

class testController: UIViewController {
    var current_month_transactions_url: URL {
        guard let userID = Auth.auth().currentUser?.uid else {
            fatalError("Unable to get current user ID")
        }
//                return URL(string: "https://thesis-backend-production.up.railway.app/current_month_transactions/\(userID)")!
        return URL(string: "http://localhost:8000/current_month_transactions/\(userID)")!
    }
    
    var chart_url: URL {
        guard let userID = Auth.auth().currentUser?.uid else {
            fatalError("Unable to get current user ID")
        }
                return URL(string: "https://thesis-backend-production.up.railway.app/mobile_chart_data/\(userID)")!
//        return URL(string: "http://localhost:8000/mobile_chart_data/\(userID)")!
    }
    
    let activityIndicator = UIActivityIndicatorView(style: .medium)
    let chartView = BarChartView()
    var stackView = UIStackView()
    
    
    //    var diagramData = List[]
    override func viewDidLoad() {
        super.viewDidLoad()
         
        configureNavigationBar()
        configureChartView()
        setData()
        configureCards()
//        configureTable()
        
        
    }
    
    private func configureNavigationBar() {
        navigationItem.title = "Summary"
        guard let navigationBar = navigationController?.navigationBar else { return }
        navigationBar.prefersLargeTitles = true
        let accentColor = UIColor(named: "AccentColor")
        navigationBar.titleTextAttributes = [.foregroundColor: accentColor ?? .systemOrange]
        navigationBar.largeTitleTextAttributes = [.foregroundColor: accentColor ?? .systemOrange]
    }
    
    private func configureChartView() {
        chartView.addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.centerXAnchor.constraint(equalTo: chartView.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: chartView.centerYAnchor).isActive = true
        
        chartView.translatesAutoresizingMaskIntoConstraints = false
        chartView.noDataText = ""
        let cardView = UIView()
        cardView.backgroundColor = .systemBackground
        cardView.layer.cornerCurve = CALayerCornerCurve.continuous
        cardView.layer.cornerRadius = 15.0
        cardView.layer.shadowColor = UIColor.black.cgColor
        cardView.layer.shadowOffset = CGSize(width: 0, height: 1)
        cardView.layer.shadowOpacity = 0.2
        cardView.layer.shadowRadius = 3.0
        cardView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(cardView)
        cardView.addSubview(chartView)
        
        NSLayoutConstraint.activate([
            cardView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            cardView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            cardView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            cardView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 1/4),
            
            chartView.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 16),
            chartView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16),
            chartView.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -16),
            chartView.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -8)
        ])
        
        chartView.xAxis.drawGridLinesEnabled = false
        chartView.leftAxis.drawGridLinesEnabled = false
        chartView.leftAxis.drawAxisLineEnabled = false
        chartView.leftAxis.drawLabelsEnabled = false
        chartView.highlightPerTapEnabled = false
        chartView.highlightPerDragEnabled = false
        chartView.scaleYEnabled = false // Disable scaling on the y-axis
        chartView.rightAxis.enabled = false
        chartView.pinchZoomEnabled = true
        chartView.viewPortHandler.setMaximumScaleX(3.0)
    }
    
    private func setData() {
        activityIndicator.startAnimating()
        do {
            let task = URLSession.shared.dataTask(with: chart_url) { (data, response, error) in
                guard let data = data, error == nil else {
                    print("Error fetching data: \(error?.localizedDescription ?? "Unknown error")")

                    return
                }
                
                do {
                    let jsonData = try JSONDecoder().decode([ChartDataEntry].self, from: data )
                    var spentEntries: [BarChartDataEntry] = []
                    var anticipatedEntries: [BarChartDataEntry] = []
                    var xValues: [String] = []
                    for i in 0..<jsonData.count {
                        let spentEntry = BarChartDataEntry(x: Double(i), y: Double(Int(jsonData[i].spent)))
                        spentEntries.append(spentEntry)
                        let anticipatedEntry = BarChartDataEntry(x: Double(i) + 0.2, y: Double(Int(jsonData[i].anticipated)))
                        anticipatedEntries.append(anticipatedEntry)
                        xValues.append(jsonData[i].month)
                    }
                    
                    let spentDataSet = BarChartDataSet(entries: spentEntries, label: "Spent")
                    spentDataSet.colors = [UIColor(named: "AccentColor1") ?? .systemOrange]
                    
                    let anticipatedDataSet = BarChartDataSet(entries: anticipatedEntries, label: "Anticipated")
                    anticipatedDataSet.colors = [UIColor(named: "AccentColor") ?? .systemBlue]
                    
                    DispatchQueue.main.async {
                        self.activityIndicator.stopAnimating()
                        let chartData = BarChartData(dataSets: [spentDataSet, anticipatedDataSet])
                        chartData.setValueFormatter(DefaultValueFormatter(decimals: 0))
                        chartData.barWidth = 0.4 // set the width of the bars
                        chartData.groupBars(fromX: 0, groupSpace: 0.10, barSpace: 0.04) // set the spacing between the bars
                        
                        self.chartView.data = chartData
                        self.chartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: xValues)
                        self.chartView.xAxis.labelPosition = .bothSided
                        self.chartView.xAxis.granularity = 1
                        self.chartView.xAxis.labelPosition = .bottom
                        self.chartView.xAxis.axisMinimum = 0 // start the x-axis from 0
                        // align the month labels with their bar groups
                        self.chartView.xAxis.centerAxisLabelsEnabled = true
                        self.chartView.xAxis.granularityEnabled = true
                        self.chartView.xAxis.labelCount = jsonData.count
                        
                        
                        
                        let count = jsonData.count - 1
                        let card1 = self.createCardView(title: "Income", number: Int(jsonData[count].income) )
                        var card2 = self.createCardView(title: "Anticipated", number: Int(jsonData[count].anticipated))
                        var card3 = self.createCardView(title: "Spent", number: Int(jsonData[count].spent))
                        var card4 = self.createCardView(title: "Left", number: Int(Int(jsonData[count].anticipated) - Int(jsonData[count].spent)))

//                        self.stackView = UIStackView()
//                        self.view.removeArrangedSubview(stackView)
                        self.stackView.removeFromSuperview()
                        self.stackView = UIStackView(arrangedSubviews: [card1, card2, card3, card4])
                        self.stackView.axis = .horizontal
                        self.stackView.spacing = 16

                        self.view.addSubview(self.stackView)

//                        self.configureCards.
//                        stackView
                        // Set constraints for stack view
                        self.stackView.translatesAutoresizingMaskIntoConstraints = false
                        self.stackView.topAnchor.constraint(equalTo: self.chartView.bottomAnchor, constant: 20).isActive = true
                        self.stackView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 16).isActive = true
                        self.stackView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -16).isActive = true
                        self.stackView.heightAnchor.constraint(equalToConstant: 80).isActive = true


                        // Set constraints for individual cards
                        card1.heightAnchor.constraint(equalTo: self.stackView.heightAnchor).isActive = true
                        card2.heightAnchor.constraint(equalTo: self.stackView.heightAnchor).isActive = true
                        card3.heightAnchor.constraint(equalTo: self.stackView.heightAnchor).isActive = true
                        card4.heightAnchor.constraint(equalTo: self.stackView.heightAnchor).isActive = true
                        card1.widthAnchor.constraint(equalTo: card2.widthAnchor).isActive = true
                        card2.widthAnchor.constraint(equalTo: card3.widthAnchor).isActive = true
                        card3.widthAnchor.constraint(equalTo: card4.widthAnchor).isActive = true
                    }
                    self.chartView.animate(xAxisDuration: 0.0, yAxisDuration: 1.5)
                    
                } catch {
                    print("Error decoding JSON: \(error.localizedDescription)")
                }
                
            }
            task.resume()
        }
        
    }

    
    func configureCards(){

        let card1 = createCardView(title: "", number: 0)
        let card2 = createCardView(title: "", number: 0)
        let card3 = createCardView(title: "", number: 0)
        let card4 = createCardView(title: "", number: 0)

        stackView = UIStackView(arrangedSubviews: [card1, card2, card3, card4])
        stackView.axis = .horizontal
        stackView.spacing = 16

        view.addSubview(stackView)

        // Set constraints for stack view
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.topAnchor.constraint(equalTo: chartView.bottomAnchor, constant: 20).isActive = true
        stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        stackView.heightAnchor.constraint(equalToConstant: 80).isActive = true


        // Set constraints for individual cards
        card1.heightAnchor.constraint(equalTo: stackView.heightAnchor).isActive = true
        card2.heightAnchor.constraint(equalTo: stackView.heightAnchor).isActive = true
        card3.heightAnchor.constraint(equalTo: stackView.heightAnchor).isActive = true
        card4.heightAnchor.constraint(equalTo: stackView.heightAnchor).isActive = true
        card1.widthAnchor.constraint(equalTo: card2.widthAnchor).isActive = true
        card2.widthAnchor.constraint(equalTo: card3.widthAnchor).isActive = true
        card3.widthAnchor.constraint(equalTo: card4.widthAnchor).isActive = true
    }
    
    func createCardView(title: String, number: Int) -> UIView {
        let cardView = UIView()
        cardView.backgroundColor = .systemBackground
        cardView.layer.cornerCurve = CALayerCornerCurve.continuous
        cardView.layer.cornerRadius = 15.0
        cardView.layer.shadowColor = UIColor.black.cgColor
        cardView.layer.shadowOpacity = 0.2
        cardView.layer.shadowOffset = CGSize(width: 0, height: 2)
        cardView.layer.shadowRadius = 4
        
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = UIFont.boldSystemFont(ofSize: 12)
        titleLabel.textAlignment = .center
        
        let numberLabel = UILabel()
        if number == 0{
            numberLabel.text = ""
        } else {
            numberLabel.text = "\(number)"
        }
        
        numberLabel.font = UIFont.systemFont(ofSize: 20)
        numberLabel.textAlignment = .center
        
        let stackView = UIStackView(arrangedSubviews: [titleLabel, numberLabel])
        stackView.axis = .vertical
        stackView.spacing = 4
        
        cardView.addSubview(stackView)
        
        // Set constraints for stack view
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.centerXAnchor.constraint(equalTo: cardView.centerXAnchor).isActive = true
        stackView.centerYAnchor.constraint(equalTo: cardView.centerYAnchor).isActive = true
        
        // Set constraints for card view
        cardView.translatesAutoresizingMaskIntoConstraints = false
        
        // Add tap gesture recognizer
        cardView.isUserInteractionEnabled = true
        cardView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(cardTapped(_:))))
        cardView.tag = number
        
        return cardView
    }
    @objc func cardTapped(_ gestureRecognizer: UITapGestureRecognizer) {
        if let cardView = gestureRecognizer.view,
           let numberLabel = cardView.subviews.first(where: { $0 is UIStackView })?.subviews.last as? UILabel,
           let number = Int(numberLabel.text ?? ""),
           let tag = cardView.tag as? Int {
            if number == 0 {
                let alert = UIAlertController(title: "Number is not zero", message: "The number on this card is \(number).", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                present(alert, animated: true, completion: nil)
            }
        }
    }
    
}

//extension testController: UITableViewDelegate, UITableViewDataSource {
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return 1 // We only have one section
//    }
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return mySection.items.count
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
//        let item = mySection.items[indexPath.row]
//        cell.textLabel?.text = item.title
//        cell.detailTextLabel?.text = item.detailTitle
//        cell.accessoryType = item.isEditable ? .disclosureIndicator : .none
//        return cell
//    }
//
//}




//
//
//import UIKit
//
//class testController: UIViewController {
//
//    private var mySection: summarySection {
//        let items = [
//            summaryItem(title: "John Doe", detailTitle: "Software Engineer" ),
//            summaryItem(title: "Jane Doe", detailTitle: "Product Manager" ),
//            summaryItem(title: "Bob Smith", detailTitle: "UX Designer" ),
//            summaryItem(title: "John Doe", detailTitle: "Software Engineer" ),
//            summaryItem(title: "Jane Doe", detailTitle: "Product Manager" ),
//            summaryItem(title: "Bob Smith", detailTitle: "UX Designer" ),
//            summaryItem(title: "John Doe", detailTitle: "Software Engineer" ),
//            summaryItem(title: "Jane Doe", detailTitle: "Product Manager" ),
//            summaryItem(title: "Bob Smith", detailTitle: "UX Designer" )
//        ]
//        return summarySection(items: items)
//    }
//
//    private var myTableView: UITableView = {
//        let tableView = UITableView(frame: .zero, style: .grouped)
//        tableView.translatesAutoresizingMaskIntoConstraints = false
//        return tableView
//    }()
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        let cardView = UIView()
//        cardView.backgroundColor = .white
//        cardView.layer.cornerRadius = 10.0
//        cardView.layer.shadowColor = UIColor.black.cgColor
//        cardView.layer.shadowOffset = CGSize(width: 0, height: 1)
//        cardView.layer.shadowOpacity = 0.2
//        cardView.layer.shadowRadius = 3.0
//        cardView.translatesAutoresizingMaskIntoConstraints = false
//        view.addSubview(cardView)
//        cardView.addSubview(myTableView)
//
//
//
//
//        NSLayoutConstraint.activate([
//            cardView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
//            cardView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
//            cardView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
//            cardView.heightAnchor.constraint(equalToConstant: 400),
//        ])
//        NSLayoutConstraint.activate([
//            myTableView.topAnchor.constraint(equalTo: cardView.topAnchor),
//            myTableView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor),
//            myTableView.trailingAnchor.constraint(equalTo: cardView.trailingAnchor),
//            myTableView.bottomAnchor.constraint(equalTo: cardView.bottomAnchor)
//        ])
//        myTableView.dataSource = self
//        myTableView.delegate = self
//
//    }
//}
//
//extension testController: UITableViewDelegate, UITableViewDataSource {
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return 1 // We only have one section
//    }
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return mySection.items.count
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
//        let item = mySection.items[indexPath.row]
//        cell.textLabel?.text = item.title
//        cell.detailTextLabel?.text = item.detailTitle
//        cell.accessoryType = item.isEditable ? .disclosureIndicator : .none
//        return cell
//    }
//
//    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        return mySection.headerDescription
//    }
//
//    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
//        return mySection.footerDescription
//    }
//}
