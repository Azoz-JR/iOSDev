//
//  ViewController.swift
//  Challenge8
//
//  Created by Azoz Salah on 04/12/2022.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet var imageView: UIImageView!
    
    var currentImage: UIImage?
    var upperText: String?
    var lowerText: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "MemeGen"
        
        let importButton = UIBarButtonItem(barButtonSystemItem: .camera, target: self, action: #selector(importPicture))
        let shareButton = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareTapped))
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        
        toolbarItems = [importButton, spacer, shareButton]
        navigationController?.isToolbarHidden = false
        
        navigationController?.hidesBarsOnTap = true
    }

    @objc func importPicture() {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        
        currentImage = image
        dismiss(animated: true)
        
        let ac = UIAlertController(title: "Enter Upper Text", message: nil, preferredStyle: .alert)
        ac.addTextField()
        ac.addAction(UIAlertAction(title: "Done", style: .default) {[weak self, weak ac] _ in
            if let text = ac?.textFields?[0].text {
                self?.upperText = text
            }
            
            self?.lowerTextac()
        })
        
        present(ac, animated: true)
    }
    
    func lowerTextac() {
        let ac = UIAlertController(title: "Enter Lower Text", message: nil, preferredStyle: .alert)
        ac.addTextField()
        ac.addAction(UIAlertAction(title: "Done", style: .default) {[weak self, weak ac] _ in
            if let text = ac?.textFields?[0].text {
                self?.lowerText = text
            }
            
            self?.drawPictureAndText()
        })
        present(ac, animated: true)
    }
    
    func drawPictureAndText() {
        let size = CGSize(width: view.frame.width, height: view.frame.height)
        let renderer = UIGraphicsImageRenderer(size: size)
        
        let image = renderer.image { ctx in
            ctx.cgContext.translateBy(x: 0, y: navigationController?.navigationBar.frame.maxY ?? 0)
            
            let rect = CGRect(x: 0, y: 0, width: view.frame.width, height: (navigationController?.toolbar.frame.minY ?? 0) - (navigationController?.navigationBar.frame.maxY ?? 0))
            
            currentImage?.draw(in: rect)
            
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .center
            
            let attrs: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 36),
                .paragraphStyle: paragraphStyle,
                .foregroundColor: UIColor.yellow
            ]
            
            let attributedUpper = NSAttributedString(string: upperText ?? "", attributes: attrs)
            let attributedLower = NSAttributedString(string: lowerText ?? "", attributes: attrs)
            
            attributedUpper.draw(with: CGRect(x: 0, y: 0, width: view.frame.width, height: 50), options: .usesLineFragmentOrigin, context: nil)
            attributedLower.draw(with: CGRect(x: 0, y: (navigationController?.toolbar.frame.minY ?? 0) - (navigationController?.navigationBar.frame.maxY ?? 0) - 60, width: view.frame.width, height: 50), options: .usesLineFragmentOrigin, context: nil)
        }
        
        imageView.image = image
    }
    
    @objc func shareTapped() {
        guard let sharedImage = imageView.image?.jpegData(compressionQuality: 0.9) else {
            print("No image")
            return
        }
        
        let vc = UIActivityViewController(activityItems: [sharedImage], applicationActivities: [])
        vc.popoverPresentationController?.barButtonItem = toolbarItems?.last
        present(vc, animated: true)
    }
}

