

import UIKit
import Alamofire

class ViewController: UIViewController{

    
    private var List = [Writing]()
    private var data = Data()
    

    

    @IBOutlet weak var CountLabel: UILabel!
    @IBOutlet weak var collections: UICollectionView!
    
    
    
    //선언부

    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionViewDelegate()
        registerNib()
        collections.backgroundColor = .clear
    }
    
    
    
    private func collectionViewDelegate(){
        collections.delegate = self
        collections.dataSource = self
    }
    
    
    private func registerNib(){
        let nibName = UINib(nibName: "CollectionViewCell", bundle: nil)
        collections.register(nibName, forCellWithReuseIdentifier: "CollectionViewCell")
    }
    
    
    
    
    
    //actionMethod
    @IBAction func addButtonTapped(_ sender: UIButton) {
        guard let viewController = self.storyboard?.instantiateViewController(withIdentifier: "CollectionSelectViewController") as? CollectionSelectViewController else { return }
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    
    
    }






extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! CollectionViewCell
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (UIScreen.main.bounds.width / 2), height: 219)
    }

    
}
