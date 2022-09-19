//
//  ViewController.swift
//  Challenge5
//
//  Created by Azoz Salah on 18/09/2022.
//

import UIKit

class ViewController: UITableViewController {
    var countries = [Country]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Countries"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        guard let url = Bundle.main.url(forResource: "countries", withExtension: "json") else {
            fatalError("Failed to locate countries file in bundle!")
        }
        
        guard let data = try? Data(contentsOf: url) else {
            fatalError("Failed to load countries from bundle. ")
        }
        
        do {
            let loaded = try JSONDecoder().decode([Country].self, from: data)
            countries = loaded
        } catch {
            print(error)
        }
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countries.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Country", for: indexPath)
        cell.textLabel?.text = countries[indexPath.row].name
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailTableViewController {
            vc.country = countries[indexPath.row]
            
            navigationController?.pushViewController(vc, animated: true)
        }
    }


}

