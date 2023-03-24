//
//  SummaryController.swift
//  PlaniCo
//
//  Created by Sandu Furdui on 21.03.2023.
//

import FirebaseAuth
import UIKit
//import Charts

class SummaryController: UIViewController , UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mySection.items.count
    }
    @objc func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        let item = mySection.items[indexPath.row]
        cell.textLabel?.text = item.title
//        cell.detailTextLabel?.text = item.detailTitle
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
//    let chartView = BarChartView()
    var stackView = UIStackView()
    let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        configureNavigationBar()
        get_transactions_data()
//        configureChartView()
//        setData()
//        configureCards()
        configureTable()
        
        
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
//           tableView.addSubview(refreshControl)

    }
   
    @objc private func refreshData() {
        // Fetch the data again and update the UI
        get_transactions_data()
//        setData()
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
                    let item = summaryItem(title: title, purchase_date_time: description)
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
//            cardView1.topAnchor.constraint(equalTo: self.chartView.bottomAnchor, constant: 116),
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
