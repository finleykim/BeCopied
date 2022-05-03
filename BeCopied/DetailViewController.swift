//
//  DetailViewController.swift
//  BeCopied
//
//  Created by Finley on 2022/04/28.
//

import UIKit

class DetailViewController: UIViewController{

    
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var originalTextView: UITextView!
    @IBOutlet weak var copyTextView: UITextView!
    var editButton: UIBarButtonItem?
    var deleteButton: UIBarButtonItem?
    
    var writing: Writing?
    var indexPath: IndexPath?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureView()
    }
    
    
    private func configureView(){
        guard let writing = self.writing else { return }
        self.originalTextView.text = writing.original
        self.copyTextView.text = writing.copy
        self.editButton = UIBarButtonItem(image: nil, style: .plain, target: self, action: #selector(editButtonTapped(_:)))
        self.deleteButton = UIBarButtonItem(image: nil, style: .plain, target: self, action: #selector(deleteButtonTapped(_:)))
        self.navigationItem.rightBarButtonItem = self.editButton
        self.navigationItem.leftBarButtonItem = self.deleteButton
    }
    
    
    //objc
    
    @objc func editButtonTapped(_ notification: Notification){
        guard let viewController = self.storyboard?.instantiateViewController(identifier: "WritingViewController") as? WritingViewController else { return }
        guard let indexPath = self.indexPath else { return }
        guard let writing = self.writing else { return }
        viewController.editMode = .edit(indexPath, writing)
        NotificationCenter.default.addObserver(
          self,
          selector: #selector(editNotification(_:)),
          name: NSNotification.Name("edit"),
          object: nil
        )
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    @objc func editNotification(_ notification: Notification){
        guard let writing = notification.object as? Writing else { return }
        self.writing = writing
        self.configureView()
    }
    
    @objc func deleteButtonTapped(_ notification: Notification){
        guard let uuidString = self.writing?.uuidString else { return }
        NotificationCenter.default.post(
          name: NSNotification.Name("delete"),
          object: uuidString,
          userInfo: nil
        )
        self.navigationController?.popViewController(animated: true)
        
    }
    
    
    deinit {
      NotificationCenter.default.removeObserver(self)
    }

    
}
