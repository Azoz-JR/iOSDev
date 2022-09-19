//
//  DetailTableViewController.swift
//  Challenge5
//
//  Created by Azoz Salah on 18/09/2022.
//

import UIKit

class DetailTableViewController: UITableViewController {
    var country: Country!
    lazy var mySections: [SectionData] = {
        let section1 = SectionData(title: "Capital", data: country.capital)
        let section2 = SectionData(title: "Region", data: country.region)
        let section3 = SectionData(title: "Language", data: ["Name: \(country.language.name)", "Code: \(country.language.code ?? "None")" ])
        let section4 = SectionData(title: "Currency", data: ["Name: \(country.currency.name)", "Code: \(country.currency.code)", "Symbol: \(country.currency.symbol ?? "None")"])
        
        return [section1, section2, section3, section4]
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = country.name
        navigationController?.navigationBar.prefersLargeTitles = false
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareTapped))
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return mySections.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        mySections[section].title
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return mySections[section].numberOfItems
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Data", for: indexPath)
        cell.textLabel?.text = mySections[indexPath.section][indexPath.row]

        return cell
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    @objc func shareTapped() {
        let ac = UIAlertController(title: "Choose which fact about \(country.name) you want to share", message: nil, preferredStyle: .actionSheet)
        ac.addAction(UIAlertAction(title: "Capital", style: .default, handler: submit))
        ac.addAction(UIAlertAction(title: "Region", style: .default, handler: submit))
        ac.addAction(UIAlertAction(title: "Language", style: .default, handler: submit))
        ac.addAction(UIAlertAction(title: "Currency", style: .default, handler: submit))
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(ac, animated: true)
    }
    
    func submit(action: UIAlertAction) {
        guard let actionTitle = action.title else { return }
        let sharedFact: String?
        
        switch actionTitle {
        case "Capital":
            sharedFact = country.capital
        case "Region":
            sharedFact = country.region
        case "Language":
            sharedFact = country.language.name
        case "Currency":
            sharedFact = country.currency.name
        default:
            sharedFact = "None"
        }
        
        let title = "\(country.name)'s \(actionTitle) is \(sharedFact!)"
        
        let vc = UIActivityViewController(activityItems: [title], applicationActivities: [])
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(vc, animated: true)
        
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
