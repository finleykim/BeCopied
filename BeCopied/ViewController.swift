

import UIKit
import Alamofire

class ViewController: UIViewController{

    
    var List = [Writing]()

    

    

    @IBOutlet weak var CountLabel: UILabel!
    @IBOutlet weak var collections: UICollectionView!
    
    
    
    //선언부

    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionViewDelegate()
        registerNib()
        collections.backgroundColor = .clear
            
        
    }

    
    

    
    
    //Delegate
    private func collectionViewDelegate(){
        self.collections.delegate = self
        self.collections.dataSource = self
        self.collections.collectionViewLayout = UICollectionViewLayout()
        
    }
    
    
    //registerNib
    private func registerNib(){
        let nibName = UINib(nibName: "CollectionViewCell", bundle: nil)
        collections.register(nibName, forCellWithReuseIdentifier: "CollectionViewCell")
    }
    
    
    //Save UserDefaults
    private func saveWritingList(){
        
    }
    
    
 
    
    
    
    //actionMethod

    
    @IBAction func addButtonTapped(_ sender: UIBarButtonItem) {
        guard let viewController = self.storyboard?.instantiateViewController(withIdentifier: "CollectionSelectViewController") as? CollectionSelectViewController else { return }
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    
    }






extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as? CollectionViewCell else { return UICollectionViewCell() }
        let writing = self.List[indexPath.row]
        cell.contentLabel.text = writing.copy
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.List.count
        
  
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (UIScreen.main.bounds.width / 2) - 20, height: 219)
    }

    
}


extension ViewController: WritingViewDelegate{
    func didSelectReigster(writing: Writing) {
        self.List.append(writing)
        self.collections.reloadData()
    }
}
