//
//  HomeViewController.swift
//  PlaniCo
//
//  Created by Sandu Furdui on 21.02.2023.
//


import UIKit
import FirebaseAuth

class HomeViewController: UIViewController {
    var dataSourceProvider: DataSourceProvider<AuthProvider>!
    var tableView: UITableView!
    var items: [[String: Any]] = []
    var url: URL {
        guard let userID = Auth.auth().currentUser?.uid else {
            fatalError("Unable to get current user ID")
        }
        return URL(string: "https://thesis-backend-production.up.railway.app/get_transactions_data/\(userID)")!
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        configureTableView()
        
        loadData()
    }
    
    private func configureNavigationBar() {
        navigationItem.title = "Acasă"
        guard let navigationBar = navigationController?.navigationBar else { return }
        navigationBar.prefersLargeTitles = true
        let accentColor = UIColor(named: "AccentColor")
        navigationBar.titleTextAttributes = [.foregroundColor: accentColor ?? .systemOrange]
        navigationBar.largeTitleTextAttributes = [.foregroundColor: accentColor ?? .systemOrange]
    }
    
    private func configureTableView() {
        tableView = UITableView(frame: view.bounds, style: .plain)
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        view.addSubview(tableView)
        
        
        //         Add pull-to-refresh functionality
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(loadData), for: .valueChanged)
        tableView.refreshControl = refreshControl
    }
    
    @objc private func loadData() {
        self.items.removeAll()
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data, error == nil else {
                print("Error fetching data: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
                if let dict = json as? [String: Any], let data = dict["data"] {
                    self.items = data as! [[String : Any]]
                    print(self.items)
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                        self.tableView.refreshControl?.endRefreshing()
                    }
                } else {
                    print("Invalid JSON format")
                }
            } catch {
                print("Error parsing JSON: \(error.localizedDescription)")
            }
            
        }
        task.resume()
    }
    
    //    @objc private func refreshData() {
    //        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
    //            guard let data = data, error == nil else {
    //                print("Error fetching data: \(error?.localizedDescription ?? "Unknown error")")
    //                return
    //            }
    //
    //            do {
    //                let json = try JSONSerialization.jsonObject(with: data, options: [])
    //                if let dict = json as? [String: Any], let data = dict["data"] as? [[String: Any]] {
    //                    DispatchQueue.main.async {
    //                        self.items = data
    //                        self.tableView.reloadData()
    //                        self.tableView.refreshControl?.endRefreshing()
    //                    }
    //
    //                } else {
    //                    print("Invalid JSON format")
    //                }
    //            } catch {
    //                print("Error parsing JSON: \(error.localizedDescription)")
    //            }
    //        }
    //        task.resume()
    //    }
}

// MARK: - LoginDelegate

extension HomeViewController: LoginDelegate {
    public func loginDidOccur() {
        // Handle login
    }
}

// MARK: - UITableViewDataSource

extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    //    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    //        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
    //        let item = items[indexPath.row]
    //        let purchaseTotal = item["purchase_total"] as? Double ?? 0.0
    //        let companyName = item["company_name"] as? String ?? ""
    //        let purchaseDateTimeString = item["purchase_date_time"] as? String ?? ""
    //        let scannedDateString = item["scanned_date"] as? String ?? ""
    //        let category = item["category"] as? String ?? ""
    //        cell.backgroundColor = .systemGray5
    //        cell.selectionStyle = .none
    //        let titleLabel = UILabel()
    //        titleLabel.text = "\(companyName): \(purchaseTotal) lei"
    //        titleLabel.font = UIFont.boldSystemFont(ofSize: 16)
    //        let descriptionLabel = UILabel()
    //        descriptionLabel.text = "\(purchaseDateTimeString)"
    //        descriptionLabel.font = UIFont.systemFont(ofSize: 14)
    //        cell.contentView.addSubview(titleLabel)
    //        cell.contentView.addSubview(descriptionLabel)
    //        NSLayoutConstraint.activate([
    //            titleLabel.topAnchor.constraint(equalTo: cell.contentView.topAnchor, constant: 16),
    //            titleLabel.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor, constant: 16),
    //            titleLabel.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor, constant: -16),
    //            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
    //            descriptionLabel.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor, constant: 16),
    //            descriptionLabel.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor, constant: -16),
    //            descriptionLabel.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor, constant: -16)
    //        ])
    //
    //        return cell
    //    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let item = items[indexPath.row]
        let purchaseTotal = item["purchase_total"] as? Double ?? 0.0
        let companyName = item["company_name"] as? String ?? ""
        let purchaseDateTimeString = item["purchase_date_time"] as? String ?? ""
        let scannedDateString = item["scanned_date"] as? String ?? ""
        let category = item["category"] as? String ?? ""
        
        var content = cell.defaultContentConfiguration()
        content.text = "\(companyName): \(purchaseTotal) lei"
        content.secondaryText = "\(category), \(purchaseDateTimeString)"
        cell.contentConfiguration = content
        
        cell.detailTextLabel?.textColor = .gray
        cell.backgroundColor = .systemGray5
        cell.selectionStyle = .none
        
        // Set margin for contentView
        cell.contentView.layoutMargins = UIEdgeInsets(top: 10, left: 16, bottom: 10, right: 16)
        cell.contentView.backgroundColor = .white
        cell.contentView.layer.cornerRadius = 10
        cell.contentView.layer.masksToBounds = true
        
        // Hide separator line
        cell.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
            
        
        return cell
    }







    
    
    
    
    
}
