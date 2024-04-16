//
//  NotesViewController.swift
//  WaitressBook
//
//  Created by  on 4/10/24.
//

import UIKit

class NotesViewController: UIViewController, UITextViewDelegate {

    @IBOutlet var noteField: UITextView!
    var tableName: String = ""

    // TODO: Save information for when the table cell gets tapped again to be viewed.
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        noteField.delegate = self
        noteField.becomeFirstResponder()
        if let savedNotes = UserDefaults.standard.string(forKey: tableName) {
            noteField.text = savedNotes
        }

        
        // Do any additional setup after loading the view.
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UserDefaults.standard.set(noteField.text, forKey: tableName)
    }
    
}

