//
//  DetailViewController.swift
//  BeCopied
//
//  Created by Finley on 2022/04/28.
//

import UIKit

class DetailViewController: UIViewController{
    var writing: Writing?
    var indexPath: IndexPath?
    
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var originalTextView: UITextView!
    @IBOutlet weak var copyTextView: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    private func configureView(){
        guard let writing = self.writing else { return }
        self.originalTextView.text = writing.original
        self.copyTextView.text = writing.copy
        
        
        
    }
    
    
    
    
    @IBAction func editButtonTapped(_ sender: UIBarButtonItem) {
        guard let writingViewController = storyboard?.instantiateViewController(withIdentifier: "WritingViewController") as? WritingViewController else { return }
        guard let indexPath = self.indexPath else { return }
        guard let writing = self.writing else { return }
        writingViewController.editMode = .edit(indexPath, writing)
        navigationController?.pushViewController(writingViewController, animated: true)
    }
    
}
