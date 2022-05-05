//
//  DetailViewController.swift
//  BeCopied
//
//  Created by Finley on 2022/04/28.
//

import UIKit

class DetailViewController: UIViewController{

    
    
    @IBOutlet weak var originalLabel: UILabel!
    @IBOutlet weak var copyLabel: UILabel!
    var editButton: UIBarButtonItem?
    var deleteButton: UIBarButtonItem?
    
    var writing: Writing?
    var indexPath: IndexPath?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureView()
        self.backgroundGradient()
    }
    

    
    private func configureView(){
        guard let writing = self.writing else { return }
        
        //SetUp Label(originalLabel, copyLabel)
        self.originalLabel.text = writing.original
        self.originalLabel.layer.cornerRadius = 30
        
        self.copyLabel.text = writing.copy
        self.copyLabel.layer.cornerRadius = 30
        
        //SetUp Button (Edit, Delete)
        self.editButton = UIBarButtonItem(image: nil, style: .plain, target: self, action: #selector(editButtonTapped))
        self.editButton?.tintColor = .white
        self.editButton?.title = "Edit"
        self.navigationItem.rightBarButtonItem = self.editButton
        
        self.deleteButton = UIBarButtonItem(image: nil, style: .plain, target: self, action: #selector(deleteButtonTapped))
        self.deleteButton?.tintColor = .systemRed
        self.deleteButton?.title = "Delete"
        self.navigationItem.leftBarButtonItem = self.deleteButton
        
        
        
    }
    
    
    //Background Gradient
    func backgroundGradient(){
            let gradient: CAGradientLayer = CAGradientLayer()
        gradient.colors = [UIColor(red: 38/255, green: 38/255, blue: 103/255, alpha: 1).cgColor, UIColor(red: 134/255, green: 134/255, blue: 186/255, alpha: 1).cgColor]
            gradient.locations = [0.0 , 1.0]
            gradient.startPoint = CGPoint(x: 0, y: 1)
            gradient.endPoint = CGPoint(x: 0, y: 0)
            gradient.frame = CGRect(x: 0.0, y: 0.0, width: self.view.frame.size.width, height: self.view.frame.size.height)
            self.view.layer.insertSublayer(gradient, at: 0)
    }
    
    //objc (EditButton, DeleteButton Action)
    
    @objc func editButtonTapped(){
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
    
    @objc func deleteButtonTapped(){
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
