//
//  SummaryController.swift
//  PlaniCo
//
//  Created by Sandu Furdui on 21.03.2023.
//

import FirebaseAuth
import UIKit
import Charts

class SummaryController: UIViewController , UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mySection.items.count
    }
    @objc func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        let item = mySection.items[indexPath.row]
        cell.textLabel?.text = item.title
        cell.detailTextLabel?.text = item.detailTitle
        return cell
    }

    var current_month_transactions_url: URL {
        guard let userID = Auth.auth().currentUser?.uid else {
            fatalError("Unable to get current user ID")
        }
        //                return URL(string: "https://thesis-backend-production.up.railway.app/current_month_transactions/\(userID)")!
        return URL(string: "https://thesis-backend-production.up.railway.app/current_month_transactions/\(userID)")!
    }

    var chart_url: URL {
        guard let userID = Auth.auth().currentUser?.uid else {
            fatalError("Unable to get current user ID")
        }
        return URL(string: "https://thesis-backend-production.up.railway.app/mobile_chart_data/\(userID)")!
    }

    let activityIndicator = UIActivityIndicatorView(style: .medium)
    let chartView = BarChartView()
    var stackView = UIStackView()
    let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        get_transactions_data()
        configureChartView()
        setData()
        configureCards()
        configureTable()
        
        
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
//           tableView.addSubview(refreshControl)

    }
   
    @objc private func refreshData() {
        // Fetch the data again and update the UI
        get_transactions_data()
        setData()
        itemss = [summaryItem]()
        // Stop the refreshing animation
        refreshControl.endRefreshing()
    }

    
    private var activityIndicator2: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.color = .gray
        return indicator
    }()


    private func configureNavigationBar() {
        navigationItem.title = "Summary"
        guard let navigationBar = navigationController?.navigationBar else { return }
        navigationBar.prefersLargeTitles = true
        let accentColor = UIColor(named: "AccentColor")
        navigationBar.titleTextAttributes = [.foregroundColor: accentColor ?? .systemOrange]
        navigationBar.largeTitleTextAttributes = [.foregroundColor: accentColor ?? .systemOrange]

        // Add a refresh button to the navigation bar
        let refreshButton = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(refreshData))
        refreshButton.tintColor = accentColor
        navigationItem.rightBarButtonItem = refreshButton
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
                        var count = 0
                        if jsonData.count == 0 {
                            count = jsonData.count
//                            self.chartView.noDataText = "fsgdfsd"
                        } else {
                            count = jsonData.count - 1
                        }
//                        let count = jsonData.count - 1
                        print(count)
                        let card1 = self.createCardView(title: "Income", number: Int(jsonData[count].income) )
                        let card2 = self.createCardView(title: "Anticipated", number: Int(jsonData[count].anticipated))
                        let card3 = self.createCardView(title: "Spent", number: Int(jsonData[count].spent))
                        let card4 = self.createCardView(title: "Left", number: Int(Int(jsonData[count].anticipated) - Int(jsonData[count].spent)))

                        self.stackView.removeFromSuperview()

                        self.stackView = UIStackView(arrangedSubviews: [card1, card2, card3, card4])
                        self.stackView.axis = .horizontal
                        self.stackView.spacing = 16

                        self.view.addSubview(self.stackView)

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

    private var mySection: summarySection {
        let items = itemss
        return summarySection(items: items)
    }

    private var myTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.layer.cornerCurve = CALayerCornerCurve.continuous
        tableView.layer.cornerRadius = 15.0
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
                    let title = "\(entry.company_name): \(entry.purchase_total) lei"
                    let description = "\(entry.category), \(entry.purchase_date_time)"
                    let item = summaryItem(title: title, detailTitle: description)
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
        let cardView1 = UIView()
        cardView1.backgroundColor = .systemBackground
        cardView1.layer.cornerCurve = CALayerCornerCurve.continuous
        cardView1.layer.cornerRadius = 15.0
        cardView1.layer.shadowColor = UIColor.black.cgColor
        cardView1.layer.shadowOffset = CGSize(width: 0, height: 1)
        cardView1.layer.shadowOpacity = 0.2
        cardView1.layer.shadowRadius = 3.0
        cardView1.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(cardView1)
        cardView1.addSubview(myTableView)
        cardView1.addSubview(activityIndicator2)
        NSLayoutConstraint.activate([
            activityIndicator2.centerXAnchor.constraint(equalTo: cardView1.centerXAnchor),
            activityIndicator2.centerYAnchor.constraint(equalTo: cardView1.centerYAnchor)
        ])

        NSLayoutConstraint.activate([
            cardView1.topAnchor.constraint(equalTo: self.chartView.bottomAnchor, constant: 116),
            cardView1.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            cardView1.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            cardView1.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 1/3),
        ])

        NSLayoutConstraint.activate([
            myTableView.topAnchor.constraint(equalTo: cardView1.topAnchor),
            myTableView.leadingAnchor.constraint(equalTo: cardView1.leadingAnchor),
            myTableView.trailingAnchor.constraint(equalTo: cardView1.trailingAnchor),
            myTableView.bottomAnchor.constraint(equalTo: cardView1.bottomAnchor)
        ])
        myTableView.dataSource = self
        myTableView.delegate = self
    }
}


struct ChartDataEntry: Decodable {
    let month: String
    let spent: Double
    let anticipated: Double
    let income: Double
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
