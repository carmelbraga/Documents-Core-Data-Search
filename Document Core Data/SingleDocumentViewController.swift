//
//  SingleDocumentViewController.swift
//  Document Core Data
//
//  Created by Carmel Braga on 9/20/19.
//  Copyright © 2019 Carmel Braga. All rights reserved.
//

import UIKit

class SingleDocumentViewController: UIViewController {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var contentTextField: UITextView!
    
    var existingDocument: Document?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameTextField.delegate = self
        contentTextField.delegate = self as? UITextViewDelegate
        
        nameTextField.text = existingDocument?.documentName
        contentTextField.text = existingDocument?.documentContent
        
        title = ""

        if let existingDocument = existingDocument {
            let name = existingDocument.documentName
            nameTextField.text = name
            contentTextField.text = existingDocument.documentContent
            title = name
               }
   
    }
    
 
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func save(_ sender: Any)
    
    {
        
     guard let name = nameTextField.text else {
               print("Document not saved.\nThe name is not accessible.")
               return
           }
           
           let documentName = name.trimmingCharacters(in: .whitespaces)
           if (documentName == "") {
               print("Document not saved.\nA name is required.")
               return
           }
           
           let content = contentTextField.text
           
           if existingDocument == nil {
              existingDocument = Document(documentName: documentName, documentContent: content)
           } else {
             existingDocument?.update(documentName: documentName, documentContent: content)
           }
           
           if let existingDocument = existingDocument {
               do {
                   let managedContext = existingDocument.managedObjectContext
                   try managedContext?.save()
               } catch {
                   print("The document context could not be saved.")
               }
           } else {
               print("The document could not be created.")
           }
           
           navigationController?.popViewController(animated: true)

    }
    
}

extension SingleDocumentViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

