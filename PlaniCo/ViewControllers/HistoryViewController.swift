//
//  HomeViewController.swift
//  PlaniCo
//
//  Created by Sandu Furdui on 21.02.2023.
//


import UIKit
import FirebaseAuth

class HistoryViewController: UIViewController {
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
        navigationItem.title = "All Transactions"
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
                    
                    // Sort items by purchase date
                    self.items.sort { (item1, item2) -> Bool in
                        guard let date1String = item1["purchase_date_time"] as? String, let date2String = item2["purchase_date_time"] as? String else {
                            return false
                        }
                        let formatter = DateFormatter()
                        formatter.dateFormat = "dd MMM yyyy, HH:mm"
                        guard let date1 = formatter.date(from: date1String), let date2 = formatter.date(from: date2String) else {
                            return false
                        }
                        return date1 > date2
                    }
                    
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
    
}

// MARK: - LoginDelegate

extension HistoryViewController: LoginDelegate {
    public func loginDidOccur() {
        // Handle login
    }
}

// MARK: - UITableViewDataSource

extension HistoryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        var purchaseTotal = 0.0
        var companyName = ""
        var purchaseDateTimeString = ""
        var category = ""
        
        if indexPath.row < items.count {
            let item = items[indexPath.row]
            purchaseTotal = item["purchase_total"] as? Double ?? 0.0
            companyName = item["company_name"] as? String ?? ""
            purchaseDateTimeString = item["purchase_date_time"] as? String ?? ""
            category = item["category"] as? String ?? ""
            var content = cell.defaultContentConfiguration()
            content.text = "\(companyName): \(purchaseTotal) lei"
            content.secondaryText = "\(category), \(purchaseDateTimeString)"
            cell.contentConfiguration = content
            
            
        } else {
            print("Index out of range: \(indexPath.row)")
        }
        
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
