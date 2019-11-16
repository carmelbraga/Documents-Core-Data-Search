//
//  DocumentsViewController.swift
//  Document Core Data
//
//  Created by Carmel Braga on 9/20/19.
//  Copyright © 2019 Carmel Braga. All rights reserved.
//

import UIKit
import CoreData

enum SearchElements: String {
    
    case all
    case documentName
    case documentContent
    
    static var titles: [String] {
        get {
            return [SearchElements.all.rawValue, SearchElements.documentName.rawValue, SearchElements.documentContent.rawValue]
        }
    }
    
    static var elements: [SearchElements] {
        get {
            return [SearchElements.all, SearchElements.documentName, SearchElements.documentContent]
        }
    }
}

class DocumentsViewController: UIViewController, UISearchResultsUpdating, UISearchBarDelegate  {

    @IBOutlet weak var documentsTableView: UITableView!
    
    let dateFormatter = DateFormatter()
    
    var documents = [Document]()
    
    var searchController: UISearchController?
    var searchData = SearchElements.all
    
    override func viewDidLoad() {
        super.viewDidLoad()

        documentsTableView.dataSource = self
        documentsTableView.delegate = self
        dateFormatter.timeStyle = .long
        dateFormatter.dateStyle = .long
        
        searchController = UISearchController(searchResultsController: nil)
        searchController?.searchResultsUpdater = self
        searchController?.obscuresBackgroundDuringPresentation = false
        searchController?.searchBar.placeholder = "Search Documents"
        navigationItem.searchController = searchController
        definesPresentationContext = true
       
    }
    
    override func viewWillAppear(_ animated: Bool) {

         fetchSearch(searchContent: "")
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let destination = segue.destination as? SingleDocumentViewController,
            let selectedRow = self.documentsTableView.indexPathForSelectedRow?.row else{
                return
        }
        
        destination.existingDocument = documents[selectedRow]
    }
    
    func fetchSearch(searchContent: String){

        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Document> = Document.fetchRequest()
        
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "documentName", ascending: true)]
        do {
            if (searchContent != "") {
                switch (searchData) {
                case .all:
                    fetchRequest.predicate = NSPredicate(format: "documentName contains[c] %@ OR documentContent contains[c] %@", searchContent, searchContent)
                case .documentName:
                    fetchRequest.predicate = NSPredicate(format: "documentName contains[c] %@", searchContent)
                case .documentContent:
                    fetchRequest.predicate = NSPredicate(format: "documentContent contains[c] %@", searchContent)
                }
            }
            
            documents = try managedContext.fetch(fetchRequest)
            documentsTableView.reloadData()

        } catch {
            print("Fetch for documents could not be performed.")
            
            return
        }
      }
    
    func updateSearchResults(for searchController: UISearchController) {
        if let searchContent = searchController.searchBar.text {
            fetchSearch(searchContent: searchContent)
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedElements: Int) {
        searchData = SearchElements.elements[selectedElements]
        if let searchContent = searchController?.searchBar.text {
            fetchSearch(searchContent: searchContent)
        }
    }
    
    func deleteDocument(at indexPath: IndexPath){
        let document = documents[indexPath.row]

        if let managedContext = document.managedObjectContext{
            managedContext.delete(document)
            
            do{
                try managedContext.save()
                
                self.documents.remove(at: indexPath.row)
                
                documentsTableView.deleteRows(at: [indexPath], with: .automatic)
            }catch{
                print("Document could not be deleted.")
                
                documentsTableView.reloadRows(at: [indexPath], with: .automatic)
            }
        }
    }
}

extension DocumentsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return documents.count
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            deleteDocument(at: indexPath)
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "documentCell", for: indexPath)
               
               if let cell = cell as? DocumentTableViewCell {
                   let document = documents[indexPath.row]
                   cell.nameLabel.text = document.documentName
                   cell.sizeLabel.text = String(document.size) + " bytes"
                   
                   if let modifiedDate = document.modifiedDate {
                    cell.dataLabel.text = dateFormatter.string(from: modifiedDate)
                   } else {
                    cell.dataLabel.text = "unknown"
                   }
               }
               
               return cell
    }
}

extension DocumentsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "existingDocument", sender: self)
    }
}
