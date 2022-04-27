//
//  LaunchScreen.swift
//  BeCopied
//
//  Created by Finley on 2022/04/27.
//

import UIKit


class LaunchScreen: UIViewController{
    @IBOutlet weak var symbol: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    private func introSybolAnimation(){
        UIView.animate(withDuration: 0.7, animations: {
            self.symbol.alpha = 1
        })
    }
}
