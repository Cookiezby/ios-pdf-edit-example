//
//  ViewController.swift
//  ios-pdf-edit-example
//
//  Created by 朱冰一 on 2023/10/21.
//

import UIKit

class ViewController: UIViewController {
    private var documentURLs: [URL] = []
    private let examplePDFURL = Bundle.main.url(
        forResource: "example",
        withExtension: "pdf"
    )!
    
    private lazy var tableView: UITableView = {
        let view = UITableView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.register(
            UITableViewCell.self,
            forCellReuseIdentifier: UITableViewCell.description()
        )
        view.delegate = self
        view.dataSource = self
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        do {
            try loadLocalFile()
            tableView.reloadData()
        } catch {
            fatalError("load pdf file failed")
        }
    }
    
    private func loadLocalFile() throws {
        let fileManager = FileManager.default
        let documentsURL = try fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        let fileURLs = try fileManager.contentsOfDirectory(at: documentsURL, includingPropertiesForKeys: nil)
        documentURLs = fileURLs.filter { $0.pathExtension == "pdf" }
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return documentURLs.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UITableViewCell.description(), for: indexPath)
        cell.accessoryType = .disclosureIndicator
        switch indexPath.section {
        case 0:
            cell.textLabel?.text = "Example PDF"
        case 1:
            cell.textLabel?.text = documentURLs[indexPath.row].lastPathComponent
        default:
            break
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        var vc: UIViewController?
        switch indexPath.section {
        case 0:
            vc = CanvasPDFViewController(fileURL: examplePDFURL)
        case 1:
            vc = CanvasPDFViewController(fileURL: documentURLs[indexPath.row])
        default:
            break
        }
        if let vc {
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}

