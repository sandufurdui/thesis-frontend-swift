//
//  SummaryController.swift
//  PlaniCo
//
//  Created by Sandu Furdui on 24.02.2023.
//


//
//import UIKit
//import Charts
//
//class SummaryController: UIViewController {
//
//    let chartView = BarChartView()
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        configureNavigationBar()
//        configureChartView()
//        setData()
//    }
//
//    private func configureNavigationBar() {
//        navigationItem.title = "Summary"
//        guard let navigationBar = navigationController?.navigationBar else { return }
//        navigationBar.prefersLargeTitles = true
//        let accentColor = UIColor(named: "AccentColor")
//        navigationBar.titleTextAttributes = [.foregroundColor: accentColor ?? .systemOrange]
//        navigationBar.largeTitleTextAttributes = [.foregroundColor: accentColor ?? .systemOrange]
//    }
//
//    private func configureChartView() {
//        chartView.translatesAutoresizingMaskIntoConstraints = false
//        view.addSubview(chartView)
//
//        NSLayoutConstraint.activate([
//            chartView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
//            chartView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
//            chartView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
//            chartView.heightAnchor.constraint(equalToConstant: 250)
//        ])
//
//        chartView.xAxis.drawGridLinesEnabled = false
//        chartView.leftAxis.drawGridLinesEnabled = false
//        chartView.leftAxis.drawAxisLineEnabled = false
//        chartView.leftAxis.drawLabelsEnabled = false
//
//        chartView.scaleYEnabled = false // Disable scaling on the y-axis
//        chartView.rightAxis.enabled = false
//        chartView.pinchZoomEnabled = true
//
//            chartView.viewPortHandler.setMaximumScaleX(3.0)
//    }
//
//
//    private func setData() {
//        let jsonData = """
//            [
//                {"month": "Jan", "spent": 500.0, "anticipated": 750.0},
//                {"month": "Feb", "spent": 600.0, "anticipated": 800.0},
//                {"month": "Mar", "spent": 800.0, "anticipated": 900.0},
//                {"month": "Apr", "spent": 1000.0, "anticipated": 1200.0},
//                {"month": "May", "spent": 1200.0, "anticipated": 1500.0},
//                {"month": "Jun", "spent": 1500.0, "anticipated": 1700.0},
//                {"month": "Jul", "spent": 1700.0, "anticipated": 2000.0},
//                {"month": "Aug", "spent": 2000.0, "anticipated": 2500.0},
//                {"month": "Sep", "spent": 2300.0, "anticipated": 2800.0},
//                {"month": "Oct", "spent": 2500.0, "anticipated": 3000.0},
//                {"month": "Nov", "spent": 2800.0, "anticipated": 3500.0},
//                {"month": "Dec", "spent": 3000.0, "anticipated": 4000.0}
//            ]
//        """.data(using: .utf8)!
//
//        do {
//            let jsonData = try JSONDecoder().decode([MonthData].self, from: jsonData)
//
//            var dataEntries: [BarChartDataEntry] = []
//            for i in 0..<jsonData.count {
//                let entry = BarChartDataEntry(x: Double(i), yValues: [jsonData[i].spent, jsonData[i].anticipated])
//                dataEntries.append(entry)
//            }
//
//            let chartDataSet = BarChartDataSet(entries: dataEntries, label: "")
//            chartDataSet.colors = [UIColor(named: "AccentColor") ?? .systemBlue, UIColor(named: "SecondaryColor") ?? .systemOrange]
//            chartDataSet.stackLabels = ["Spent", "Anticipated"]
//            let chartData = BarChartData(dataSet: chartDataSet)
//            chartData.setValueFormatter(DefaultValueFormatter(decimals: 0))
//            chartView.data = chartData
//
//            chartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: jsonData.map { $0.month })
//            chartView.xAxis.granularity = 1
//            chartView.xAxis.labelPosition = .bottom
//            chartView.rightAxis.enabled = false
//            chartView.animate(xAxisDuration: 2.0, yAxisDuration: 2.0)
//        } catch {
//            print("Error decoding JSON: \(error.localizedDescription)")
//        }
//    }
//
//}
//
//struct MonthData: Decodable {
//    let month: String
//    let spent: Double
//    let anticipated: Double
//}


//
//  SummaryController.swift
//  PlaniCo
//
//  Created by Sandu Furdui on 24.02.2023.
//

import UIKit
import Charts

class SummaryController: UIViewController {

    let chartView = LineChartView()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        configureChartView()
        setData()
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
        view.addSubview(chartView)

        NSLayoutConstraint.activate([
            chartView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            chartView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            chartView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            chartView.heightAnchor.constraint(equalToConstant: 250)
        ])
        chartView.leftAxis.enabled = false
        chartView.rightAxis.enabled = false
        chartView.xAxis.drawGridLinesEnabled = false
        chartView.xAxis.labelPosition = .bottom
//        chartView.xAxis.labelCount = 3
        chartView.xAxis.granularityEnabled = true
        chartView.xAxis.granularity = 1
        chartView.pinchZoomEnabled = true
        chartView.setScaleEnabled(true)
//        chartView.maxVisibleCount = 3
        chartView.animate(xAxisDuration: 2.0, yAxisDuration: 2.0)

    }

    let jsonData = """
        [
            {"month": "Jan", "spent": 500.0, "anticipated": 750.0},
            {"month": "Feb", "spent": 600.0, "anticipated": 800.0},
            {"month": "Mar", "spent": 900.5, "anticipated": 900.0},
            {"month": "Apr", "spent": 1000.0, "anticipated": 1200.0},
            {"month": "May", "spent": 1200.0, "anticipated": 1500.0},
            {"month": "Jun", "spent": 1500.0, "anticipated": 1700.0},
            {"month": "Jul", "spent": 1700.0, "anticipated": 2000.0},
            {"month": "Aug", "spent": 2000.0, "anticipated": 2500.0},
            {"month": "Sep", "spent": 2300.0, "anticipated": 2800.0},
            {"month": "Oct", "spent": 2500.0, "anticipated": 3000.0},
            {"month": "Nov", "spent": 2800.0, "anticipated": 3500.0},
            {"month": "Dec", "spent": 3000.0, "anticipated": 4000.0}
        ]
    """.data(using: .utf8)!

    private func setData() {
        do {
            let jsonData = try JSONDecoder().decode([MonthData].self, from: jsonData)

            var spentEntries: [ChartDataEntry] = []
            var anticipatedEntries: [ChartDataEntry] = []
            for i in 0..<jsonData.count {
                let spentEntry = ChartDataEntry(x: Double(i), y: jsonData[i].spent)
                spentEntries.append(spentEntry)
                let anticipatedEntry = ChartDataEntry(x: Double(i), y: jsonData[i].anticipated)
                anticipatedEntries.append(anticipatedEntry)
            }

            let spentDataSet = LineChartDataSet(entries: spentEntries, label: "Spent")
            spentDataSet.colors = [UIColor(named: "AccentColor1") ?? .systemOrange]
            spentDataSet.circleColors = [UIColor(named: "AccentColor1") ?? .systemOrange]
            spentDataSet.circleRadius = 4.0
            spentDataSet.lineWidth = 2.0

            let anticipatedDataSet = LineChartDataSet(entries: anticipatedEntries, label: "Anticipated")
            anticipatedDataSet.colors = [UIColor(named: "AccentColor2") ?? .systemBlue]
            anticipatedDataSet.circleColors = [UIColor(named: "AccentColor2") ?? .systemBlue]
            anticipatedDataSet.circleRadius = 4.0
            anticipatedDataSet.lineWidth = 2.0

            let chartData = LineChartData(dataSets: [spentDataSet, anticipatedDataSet])
            chartData.setValueFormatter(DefaultValueFormatter(decimals: 0))

            chartView.data = chartData
            chartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: jsonData.map { $0.month })
            chartView.xAxis.granularity = 1
            chartView.xAxis.labelPosition = .bottom
            chartView.animate(xAxisDuration: 2.0, yAxisDuration: 2.0)
        } catch {
            print("Error decoding JSON: \(error.localizedDescription)")
        }
    }

}

struct MonthData: Decodable {
    let month: String
    let spent: Double
    let anticipated: Double
}
