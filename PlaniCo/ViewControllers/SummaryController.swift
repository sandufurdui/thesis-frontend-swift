//
//  SummaryController.swift
//  PlaniCo
//
//  Created by Sandu Furdui on 21.03.2023.
//


import UIKit
import Charts

class SummaryController: UIViewController {
    let chartView = BarChartView()
    let jsonData = """
        [
            {"month": "Jan", "spent": 1200, "anticipated": 1000, "income": 2500},
            {"month": "Feb", "spent": 1300, "anticipated": 1100, "income": 2600},
            {"month": "Mar", "spent": 1400, "anticipated": 1200, "income": 2700},
            {"month": "Apr", "spent": 1500, "anticipated": 1300, "income": 2800},
            {"month": "May", "spent": 1600, "anticipated": 1400, "income": 2900},
            {"month": "Jun", "spent": 1700, "anticipated": 1500, "income": 3000},
            {"month": "Jul", "spent": 1800, "anticipated": 1600, "income": 3100},
            {"month": "Aug", "spent": 1900, "anticipated": 1700, "income": 3200},
            {"month": "Sep", "spent": 2000, "anticipated": 1800, "income": 3300},
            {"month": "Oct", "spent": 2100, "anticipated": 1900, "income": 3400},
            {"month": "Nov", "spent": 2200, "anticipated": 2000, "income": 3500},
            {"month": "Dec", "spent": 2300, "anticipated": 2100, "income": 3600}
        ]
        """.data(using: .utf8)!

    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        configureChartView()
        setData()
        setupCards()
    }
    
    func setupCards(){
        let card1 = createCardView(title: "Income", number: 0)
        let card2 = createCardView(title: "Anticipated", number: 15323)
        let card3 = createCardView(title: "Spent", number: 15323)
        let card4 = createCardView(title: "Left to spend", number: 15323)
        
        let stackView = UIStackView(arrangedSubviews: [card1, card2, card3, card4])
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
        cardView.backgroundColor = .white
        cardView.layer.cornerRadius = 8
        cardView.layer.shadowColor = UIColor.black.cgColor
        cardView.layer.shadowOpacity = 0.2
        cardView.layer.shadowOffset = CGSize(width: 0, height: 2)
        cardView.layer.shadowRadius = 4
        
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = UIFont.boldSystemFont(ofSize: 12)
        titleLabel.textAlignment = .center
        
        let numberLabel = UILabel()
        numberLabel.text = "\(number)"
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
        if let cardView = gestureRecognizer.view as? UIView,
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
    
    
    
    private func configureNavigationBar() {
        navigationItem.title = "Summary"
        guard let navigationBar = navigationController?.navigationBar else { return }
        navigationBar.prefersLargeTitles = true
        let accentColor = UIColor(named: "AccentColor")
        navigationBar.titleTextAttributes = [.foregroundColor: accentColor ?? .systemOrange]
        navigationBar.largeTitleTextAttributes = [.foregroundColor: accentColor ?? .systemOrange]
    }
    
    private func configureChartView() {
        chartView.translatesAutoresizingMaskIntoConstraints = false
        let cardView = UIView()
        cardView.backgroundColor = .white
        cardView.layer.cornerRadius = 10.0
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
            cardView.heightAnchor.constraint(equalToConstant: 300),
            
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
        do {
            let jsonData = try JSONDecoder().decode([ChartDataEntry].self, from: jsonData)
            
            var spentEntries: [BarChartDataEntry] = []
            var anticipatedEntries: [BarChartDataEntry] = []
            var xValues: [String] = []
            for i in 0..<jsonData.count {
                let spentEntry = BarChartDataEntry(x: Double(i), y: Double(Int(jsonData[i].spent)))
                spentEntries.append(spentEntry)
                let anticipatedEntry = BarChartDataEntry(x: Double(i) + 0.2, y: Double(Int(jsonData[i].anticipated))) // shift the anticipated bar to the right by 0.2 units
                anticipatedEntries.append(anticipatedEntry)
                xValues.append(jsonData[i].month)
            }
            
            let spentDataSet = BarChartDataSet(entries: spentEntries, label: "Spent")
            spentDataSet.colors = [UIColor(named: "AccentColor1") ?? .systemOrange]
            
            let anticipatedDataSet = BarChartDataSet(entries: anticipatedEntries, label: "Anticipated")
            anticipatedDataSet.colors = [UIColor(named: "AccentColor") ?? .systemBlue]
            
            let chartData = BarChartData(dataSets: [spentDataSet, anticipatedDataSet])
            chartData.setValueFormatter(DefaultValueFormatter(decimals: 0))
            chartData.barWidth = 0.4 // set the width of the bars
            chartData.groupBars(fromX: 0, groupSpace: 0.10, barSpace: 0.04) // set the spacing between the bars
            
            chartView.data = chartData
            chartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: xValues)
            chartView.xAxis.labelPosition = .bothSided
            chartView.xAxis.granularity = 1
            chartView.xAxis.labelPosition = .bottom
            chartView.xAxis.axisMinimum = 0 // start the x-axis from 0
            
            // align the month labels with their bar groups
            chartView.xAxis.centerAxisLabelsEnabled = true
            chartView.xAxis.granularityEnabled = true
            chartView.xAxis.labelCount = jsonData.count
            chartView.animate(xAxisDuration: 2.0, yAxisDuration: 2.0)
        } catch {
            print("Error decoding JSON: \(error.localizedDescription)")
        }
    }
}

struct ChartDataEntry: Decodable {
    let month: String
    let spent: Double
    let anticipated: Double
}

