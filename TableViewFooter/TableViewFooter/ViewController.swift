//
//  ViewController.swift
//  TableViewFooter
//
//  Created by Haris Zaman on 1/15/22.
//

import UIKit

class ViewController: UIViewController {

    struct Person {
        let name: String
    }
    
    private let dummyCellId = "DummmyCellId"
    private let people = [
        Person(name: "John Doe"),
        Person(name: "Alex Wonder"),
        Person(name: "Elon Musk"),
        Person(name: "Rebecca Jonson"),
        Person(name: "Harry king"),
        Person(name: "Ahmad Hussain"),
        Person(name: "App Developer"),
        Person(name: "Random Guy"),
        Person(name: "Alice Bob"),
        Person(name: "Lost Chap"),
        Person(name: "Stefan Hawk"),
        Person(name: "Justin Timber"),
        Person(name: "Nadal Virk")
    ]
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        // Do any additional setup after loading the view.
    }
    
    var footerView: TableFooterView!
    var shouldCalculateOffsetForFooter = false
    
    private func setup() {
       
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(TableViewCell.self, forCellReuseIdentifier: dummyCellId)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        let strings = ["Lorem ipsum dolor sit amet, consectetur adipiscing elit.",
                       "Aenean tempus, eros in sodales iaculis, est metus ultricies ligula, sit amet sodales ipsum metus sit amet purus. Nullam euismod dui neque, in condimentum dui rutrum quis. Vivamus eget mollis purus.",
                       "Donec ante ex, ullamcorper nec venenatis id, facilisis vitae nulla.",
                       "Proin id faucibus eros, nec cursus ligula. Nam sit amet tincidunt lectus, quis elementum eros. Aenean vehicula non ex ut varius. ",
                       "Interdum et malesuada fames ac ante ipsum primis in faucibus. Vestibulum ac placerat orci. Cras quis risus id justo aliquet tristique.",
                       "Mauris urna ligula, pellentesque in nisl a, porta pulvinar dolor. Donec eget mi congue, pretium dui at, pharetra lectus.",
                       "Suspendisse lacinia nulla eu urna dapibus congue. In bibendum faucibus pellentesque. Suspendisse potenti."
        ]
        
        footerView = TableFooterView(strings: strings)
        
        footerView.lessOrMoreButtonCallback = {
            self.shouldCalculateOffsetForFooter = true
            self.updateFooter()
        }
        
        footerView.hideButtonCallback = {
            self.shouldCalculateOffsetForFooter = true
            self.updateFooter()
        }
        
        footerView?.backgroundColor = .red
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateFooter()
    }
}

extension ViewController {
    private func updateFooter() {
        
        var frame = footerView.frame
        frame.size.width = tableView.frame.size.width
        footerView.frame = frame
        
        footerView.layoutIfNeeded()
        
        let height = footerView.systemLayoutSizeFitting(CGSize(width: footerView.frame.size.width, height: UIView.layoutFittingCompressedSize.height), withHorizontalFittingPriority: .required, verticalFittingPriority: .fittingSizeLevel).height
        
        if height != frame.size.height {
            footerView.frame.size.height = height
            if shouldCalculateOffsetForFooter {
                var currentOffset = tableView.contentOffset
                let diffHeight = height - frame.size.height
                if diffHeight > 0 {
                    currentOffset.y += diffHeight
                } else {
                    currentOffset.y -= diffHeight
                }
                
                tableView.contentOffset = currentOffset
            }
        }
        
        tableView.tableFooterView = footerView
        view.layoutIfNeeded()
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return people.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: dummyCellId) else {
            return UITableViewCell()
        }
        
        let person = people[indexPath.row]
        cell.textLabel?.text = person.name
        return cell
    }
}

