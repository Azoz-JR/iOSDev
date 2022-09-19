//
//  DetailViewController.swift
//  Challenge4
//
//  Created by Azoz Salah on 13/09/2022.
//

import UIKit

class DetailViewController: UIViewController {
    @IBOutlet var imageView: UIImageView!
    var image: Image?
    var pictures: [Image]?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = image?.caption
        navigationItem.largeTitleDisplayMode = .never
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Rename", style: .plain, target: self, action: #selector(renameImage))
        
        if let selectedImage = image?.name {
            let path = getDocumentsDirectory().appendingPathComponent(selectedImage)
            imageView.image = UIImage(contentsOfFile: path.path)
        }
    }
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.hidesBarsOnTap = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.hidesBarsOnTap = false
    }
    
    @objc func renameImage() {
        let ac = UIAlertController(title: "Write Suitable Caption", message: nil, preferredStyle: .alert)
        ac.addTextField()
        ac.addAction(UIAlertAction(title: "Done", style: .default) { [weak self, weak ac] _ in
            guard let caption = ac?.textFields?[0].text else { return }
            
            self?.image?.caption = caption
            save(pictures: (self?.pictures)!)
            self?.viewDidLoad()
        })
        
        present(ac, animated: true)
    }

}
