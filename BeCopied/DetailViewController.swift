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
    
    
    @IBOutlet weak var originalTextView: UITextView!
    @IBOutlet weak var copyViewController: UITextView!
}
