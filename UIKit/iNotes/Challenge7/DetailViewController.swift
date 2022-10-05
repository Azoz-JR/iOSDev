//
//  DetailViewController.swift
//  Challenge7
//
//  Created by Azoz Salah on 27/09/2022.
//

import UIKit

class DetailViewController: UIViewController {
    @IBOutlet var textView: UITextView!
    
    var note: Notes!
    var notes: [Notes]!
    var index: IndexPath!
    var isDeleted = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = note.title
        navigationItem.largeTitleDisplayMode = .never
        
        //navigationItem.leftItemsSupplementBackButton = true
        
        textView.text = note.body
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareNote))
        
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        let delete = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(deleteNote))
        delete.tintColor = .red
        
        toolbarItems = [spacer, delete]
        navigationController?.isToolbarHidden = false
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
    }
    
    @objc func done() {
        
        navigationController?.popViewController(animated: true)
    }
    
    @objc func shareNote() {
        guard let note = textView.text else { return }
        
        let vc = UIActivityViewController(activityItems: [note], applicationActivities: nil)
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(vc, animated: true)
    }
    
    @objc func adjustForKeyboard(notification: NSNotification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        
        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
        
        if notification.name == UIResponder.keyboardWillHideNotification {
            textView.contentInset = .zero
        } else {
            textView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom, right: 0)
        }
        
        textView.scrollIndicatorInsets = textView.contentInset
        
        let selectedRange = textView.selectedRange
        textView.scrollRangeToVisible(selectedRange)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if !isDeleted {
            note.body = textView.text
            notes[index.row] = note
            save(notes: notes)
        }
    }
    
    @objc func deleteNote() {
        let ac = UIAlertController(title: "Are yoy sure you want to delete this note?", message: nil, preferredStyle: .alert)
        
        ac.addAction(UIAlertAction(title: "Delete", style: .destructive) { [weak self] _ in
            self?.notes.remove(at: (self?.index.row)!)
            save(notes: (self?.notes)!)
            self?.isDeleted = true
            self?.navigationController?.popViewController(animated: true)
        })
        
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        present(ac, animated: true)
        
    }

}
