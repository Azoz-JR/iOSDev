//
//  ViewController.swift
//  Challenge7
//
//  Created by Azoz Salah on 27/09/2022.
//

import UIKit

class ViewController: UITableViewController {
    var notes = [Notes]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        title = "Notes"
        
        navigationController?.navigationBar.prefersLargeTitles = true
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(createNote))
        
        //navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        navigationController?.navigationBar.tintColor = .orange
        
        notes = loadNotes()
    }
    
    @objc func createNote() {
        let ac = UIAlertController(title: "Enter Note's title ", message: nil, preferredStyle: .alert)
        ac.addTextField()
        
        ac.addAction(UIAlertAction(title: "Submit", style: .default) {[weak self] _ in
            guard let title = ac.textFields?[0].text else { return }
            
            let note = Notes(title: title, body: "")
            self?.notes.append(note)
            self?.tableView.reloadData()
        })
        
        present(ac, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Note", for: indexPath)
        
        let note = notes[indexPath.row]
        cell.textLabel?.text = note.title
        cell.textLabel?.sizeToFit()
        cell.detailTextLabel?.text = note.body
        cell.detailTextLabel?.sizeToFit()
        
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
            vc.note = self.notes[indexPath.row]
            vc.notes = notes
            vc.index = indexPath
            
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            deleteNote(index: indexPath.row)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        notes = loadNotes()
        tableView.reloadData()
        
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    func loadNotes() -> [Notes] {
        var notes = [Notes]()
        let defaults = UserDefaults.standard
        if let savedNotes = defaults.object(forKey: "notes") as? Data {
            let decoder = JSONDecoder()
            
            do {
                notes = try decoder.decode([Notes].self, from: savedNotes)
            } catch {
                print("Failed to load Notes.")
            }
        }
        return notes
    }
    
    func deleteNote(index: Int) {
        let ac = UIAlertController(title: "Are yoy sure you want to delete this note?", message: nil, preferredStyle: .alert)
        
        ac.addAction(UIAlertAction(title: "Delete", style: .destructive) { [weak self] _ in
            self?.notes.remove(at: index)
            save(notes: (self?.notes)!)
            self?.navigationController?.popViewController(animated: true)
        })
        
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        present(ac, animated: true)
        
    }


}

