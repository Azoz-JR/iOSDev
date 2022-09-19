//
//  ViewController.swift
//  Challenge4
//
//  Created by Azoz Salah on 13/09/2022.
//

import UIKit

class ViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    var pictures = [Image]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        performSelector(inBackground: #selector(fetchPictures), with: nil)
        
        title = "Gallery"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewImage))
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pictures.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Image", for: indexPath)
        
        let image = pictures[indexPath.row]
        cell.textLabel?.text = image.caption
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
            let picture = pictures[indexPath.row]
            
            vc.image = picture
            vc.pictures = pictures
            
            navigationController?.pushViewController(vc, animated: true)
        }
        
        
    }
    
    
    @objc func addNewImage() {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            picker.sourceType = .camera
        }
        present(picker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage? else { return }
        
        let imageName = UUID().uuidString
        let imagePath = getDocumentsDirectory().appendingPathComponent(imageName)
        
        if let jpegData = image?.jpegData(compressionQuality: 0.9) {
            try? jpegData.write(to: imagePath)
        }
        
        let picture = Image(name: imageName, caption: "Unknown")
        
        pictures.append(picture)
        save(pictures: pictures)
        tableView.reloadData()
        
        dismiss(animated: true)
    }
    
    @objc func fetchPictures() {
        if let savedPictures = UserDefaults.standard.object(forKey: "pictures") as? Data {
            do {
                pictures = try JSONDecoder().decode([Image].self, from: savedPictures)
                DispatchQueue.main.async {[weak self] in
                    self?.tableView.reloadData()
                }
            } catch {
                print("Failed to load pictures")
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    

}

