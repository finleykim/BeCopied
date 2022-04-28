

import UIKit
import Alamofire

class ViewController: UIViewController {
    
    @IBOutlet weak var sinceLabel: UILabel!
    @IBOutlet weak var CountLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    
    //actionMethod
    @IBAction func addButtonTapped(_ sender: UIButton) {
        guard let viewController = self.storyboard?.instantiateViewController(withIdentifier: "CollectionSelectViewController") as? CollectionSelectViewController else { return }
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    
    
    }
