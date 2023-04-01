//
//  SearchViewController.swift
//  Maps
//
//  Created by Akbarshah Jumanazarov on 4/1/23.
//

import UIKit
import CoreLocation

protocol SearchViewControllerDelegate: AnyObject {
    func searchViewController(_ vc: SearchViewController, didSelectLocationWith coordinates: CLLocationCoordinate2D?)
}

class SearchViewController: UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource {
    
    var locations = [Location]()
    weak var delegate: SearchViewControllerDelegate?
    
    private let label: UILabel = {
        let label = UILabel()
        label.text = "Where to?"
        label.font = .systemFont(ofSize: 24, weight: .semibold)
        return label
    }()
    
    private let textField: UITextField = {
        let text = UITextField()
        text.placeholder = "Enter destination"
        text.layer.masksToBounds = true
        text.layer.cornerRadius = 8
        text.backgroundColor = .tertiarySystemBackground
        return text
    }()
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        table.backgroundColor = .secondarySystemBackground
        return table
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .secondarySystemBackground
        view.addSubview(label)
        view.addSubview(textField)
        textField.delegate = self
        view.addSubview(tableView)
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 50))
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        label.sizeToFit()
        label.frame = CGRect(x: 10, y: 10, width: label.frame.size.width, height: label.frame.size.height)
        textField.frame = CGRect(x: 10, y: label.frame.size.height + 20, width: view.frame.size.width - 20, height: 50)
        let tableY: CGFloat = textField.frame.origin.y + textField.frame.size.height + 5
        tableView.frame = CGRect(x: 0, y: tableY, width: view.frame.size.width, height: view.frame.size.height - tableY)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if let text = textField.text, !text.isEmpty {
            LocationManager.shared.findLocations(with: text) { [weak self] locations in
                DispatchQueue.main.async {
                    self?.locations = locations
                    self?.tableView.reloadData()
                }
            }
        }
        return true
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.backgroundColor = .secondarySystemBackground
        cell.contentView.backgroundColor = .secondarySystemBackground
        cell.textLabel?.text =  locations[indexPath.row].title
        cell.textLabel?.numberOfLines = 0
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let coordinate = locations[indexPath.row].coordinates
        delegate?.searchViewController(self, didSelectLocationWith: coordinate)
    }
}
