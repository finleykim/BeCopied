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
        backgroundGradient()
        navigationController?.navigationBar.isHidden = true
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
    
    
    
    
}
