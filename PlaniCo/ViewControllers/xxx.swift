class SummaryController: UIViewController , UITableViewDelegate, UITableViewDataSource {
 
    override func viewDidLoad() {
        super.viewDidLoad()
        // ...
        createChartSummary() 
        get_transactions_data()
    }
    /// ...
    var storageList = [Storage(name: "None", value: 100)]

    func get_transactions_data() {
//        activityIndicator2.startAnimating()
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
                
                // Convert storageDict to array format and assign to storage variable
                self.storageList = storageDict.map { Storage(name: $0.key, value: $0.value) }
                print(self.storageList)
                
                DispatchQueue.main.async {
                    self.myTableView.reloadData()
//                    self.chartView.reloadData()
                }
            } catch {
                print("Error decoding JSON: \(error.localizedDescription)")
            }

        }
        task.resume()
    }
    
    func createChartSummary() {
        
        let barChartView = UIHostingController(rootView: BarChartSwiftUI(locatStorageList: storageList))
        testChartView.addArrangedSubview(barChartView.view)
                addChild(barChartView)
                barChartView.didMove(toParent: self)
                barChartView.view.backgroundColor = UIColor.clear
         
        testChartView.translatesAutoresizingMaskIntoConstraints = false
        var runtime_warning = ""
        NSLayoutConstraint.activate([
            // ...
        ])
        
    }
     
}