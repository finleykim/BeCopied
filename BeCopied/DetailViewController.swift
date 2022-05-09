//
//  DetailViewController.swift
//  BeCopied
//
//  Created by Finley on 2022/04/28.
//

import UIKit

class DetailViewController: UIViewController{

    
    
    @IBOutlet weak var originalTextView: UITextView!
    @IBOutlet weak var copyTextView: UITextView!
    
    
    var rightBarButton: UIBarButtonItem?
    var deleteButton: UIBarButtonItem?
    
    var writing: Writing?
    var indexPath: IndexPath?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureView()
        self.backgroundGradient()
        self.navigationBackSwipeMotion()
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    private func configureView(){
        guard let writing = self.writing else { return }
        
        //SetUp Label(originalLabel, copyLabel)
        self.originalTextView.text = "\n\(writing.original)"
        self.copyTextView.text = "\n\(writing.copy)"
        [originalTextView, copyTextView].forEach{
            $0?.clipsToBounds = true
            $0?.layer.shadowColor = UIColor.black.cgColor
            $0?.layer.shadowOpacity = 0.3
            $0?.layer.shadowRadius = 10
            $0?.layer.cornerRadius = 15
            $0?.isEditable = false
        }
        
        //SetUp Button (Edit, Delete)
        self.rightBarButton = UIBarButtonItem(image: UIImage(systemName: "ellipsis"),
                                          style: .plain,
                                          target: self,
                                          action: #selector(rightButtonTapped))
        self.rightBarButton?.tintColor = .white

        self.navigationItem.rightBarButtonItem = self.rightBarButton
        self.navigationItem.leftBarButtonItem = UIBarButtonItem()
        


        

    }
    func navigationBackSwipeMotion() {
        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil
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
    
    @objc func rightButtonTapped(){
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let editButton = UIAlertAction(title: "Edit", style: .default, handler: editButtonTapped)
        let deleteButton = UIAlertAction(title: "delete", style: .destructive, handler: deleteButtonTapped)
        
        actionSheet.addAction(editButton)
        actionSheet.addAction(deleteButton)
        
        self.present(actionSheet,animated: true){
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissAlertController))
            actionSheet.view.superview?.subviews[0].addGestureRecognizer(tapGesture)
        }
    }
    
    @objc func dismissAlertController(){
        self.dismiss(animated: true, completion: nil)
    }
    
    func editButtonTapped(_ action: UIAlertAction){
        
        
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
    
  func deleteButtonTapped(_ action: UIAlertAction){
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


