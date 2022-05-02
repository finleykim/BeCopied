//
//  CollectionSelectViewController.swift
//  BeCopied
//
//  Created by Finley on 2022/04/28.
//

import UIKit

class CollectionSelectViewController: UIViewController{
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    
    
    
    //ActionMethod
    @IBAction func techCrunchButtonTapped(_ sender: UIButton) {
        guard let viewController = self.storyboard?.instantiateViewController(withIdentifier: "WritingViewController") as? WritingViewController else { return }
        viewController.collectionSelected = .techCrunchCollection
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    @IBAction func appleButtonTapped(_ sender: UIButton) {
        guard let viewController = self.storyboard?.instantiateViewController(withIdentifier: "WritingViewController") as? WritingViewController else { return }
        viewController.collectionSelected = .appleCollection
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    @IBAction func wallStreetJournalTapped(_ sender: UIButton) {
        guard let viewController = self.storyboard?.instantiateViewController(withIdentifier: "WritingViewController") as? WritingViewController else { return }
        viewController.collectionSelected = .wallStreetJournalCollection
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    @IBAction func tapBusinessInUSButtonTapped(_ sender: UIButton) {
        guard let viewController = self.storyboard?.instantiateViewController(withIdentifier: "WritingViewController") as? WritingViewController else { return }
        viewController.collectionSelected = .businessInUSCollection
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    @IBAction func teslaButtonTapped(_ sender: UIButton) {
        guard let viewController = self.storyboard?.instantiateViewController(withIdentifier: "WritingViewController") as? WritingViewController else { return }
        viewController.collectionSelected = .teslaCollection
        

            
        
        
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    
    
    
    
    
    
}
