//
//  anotherTest.swift
//  PlaniCo
//
//  Created by Sandu Furdui on 27.03.2023.
//

import FirebaseAuth
import UIKit
import SwiftUI
import Charts

class anotherTest: UIViewController {

    let secondaryTextColor = UIColor(named: "SecondaryTextColor")
    let categoryIconColor = UIColor(named: "categoryIconColor")
    let reversedBackgroundColorSet = UIColor(named: "ReversedBackgroundColorSet")
    let boxBackgroundColor = UIColor(named: "BoxBackgroundColor")
    let separatorColor = UIColor(named: "SecondaryTextColor")
    
    
    let anticipated = 120
    let income = 100
    @objc private func settingsButtonTapped() {
        print("settings tapped")
    }

    // Declare timer and buttonPressCount at the class or file scope
    var timer: Timer?
    var buttonPressCount = 0

    @objc private func refreshButtonTapped() {
     print("refreshed")
    }
 
    @objc private func addIncomeTapped(income: Int) {
        print("refreshButtonTapped tapped")
    }
    
    
    @objc private func addAnticipatedTapped() {
        print("refreshButtonTapped tapped")
    }
    
    @objc private func addSpendingTapped() {
        print("refreshButtonTapped tapped")
    }
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        // Reload data here...
        // For example, you could fetch new data from a server, update your UI, etc.
        print("refresh pulled")
        
        // Add a sleep timer of 5 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
            // End the refreshing state of the control
            refreshControl.endRefreshing()
        }
    }

     
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        createBalanceView()
//        createSeparator()
//        createHotButtons()
//        createChartSummary()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        scrollView.backgroundColor = .red
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
        contentView.backgroundColor = .lightGray
        contentView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
        ])

        hotButtonsStack.translatesAutoresizingMaskIntoConstraints = false
        hotButtonsStack.backgroundColor = .blue
        contentView.addSubview(hotButtonsStack)
        NSLayoutConstraint.activate([
            hotButtonsStack.heightAnchor.constraint(equalToConstant: view.frame.height / 5),
            hotButtonsStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            hotButtonsStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            hotButtonsStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: view.frame.height / 20),
        ])
        separator.backgroundColor = .black
        separator.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(separator)
        NSLayoutConstraint.activate([
            separator.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            separator.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            separator.heightAnchor.constraint(equalToConstant: 2),
            separator.topAnchor.constraint(equalTo: contentView.topAnchor),
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
      
    let chartSummaryStack = UIStackView()
    let scrollView = UIScrollView()

    func createChartSummary() {
        chartSummaryStack.backgroundColor = boxBackgroundColor
        chartSummaryStack.layer.cornerRadius = 15
        chartSummaryStack.layer.cornerCurve = .continuous
        
//        let barChartView = UIHostingController(rootView: Test())
//        chartSummaryStack.addArrangedSubview(barChartView.view)
//        addChild(barChartView)
//        barChartView.didMove(toParent: self)
//        barChartView.view.backgroundColor = UIColor.blue
//        view.addSubview(chartSummaryStack)
//        
        chartSummaryStack.translatesAutoresizingMaskIntoConstraints = false
        var runtime_warning = ""
        NSLayoutConstraint.activate([
            chartSummaryStack.heightAnchor.constraint(equalToConstant: view.frame.height / 3),
            chartSummaryStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            chartSummaryStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            chartSummaryStack.topAnchor.constraint(equalTo: hotButtonsStack.bottomAnchor, constant: 30),
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
        
//        NSLayoutConstraint.activate([
//            navivationBar.heightAnchor.constraint(equalToConstant: 90),
//        ])
    }
    let vieww = UIView()
    private func createBalanceView() {
        vieww.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(vieww)
        
        NSLayoutConstraint.activate([
            vieww.topAnchor.constraint(equalTo: view.topAnchor, constant: view.frame.height / 5),
            vieww.widthAnchor.constraint(equalTo: view.widthAnchor),
            vieww.heightAnchor.constraint(equalToConstant: view.frame.height / 50 + view.frame.height / 15)
        ])
    }
}

