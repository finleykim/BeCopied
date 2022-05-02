

import UIKit
import Alamofire

class ViewController: UIViewController{

    
    var List = [Writing]()
    var writingViewController = WritingViewController()
    

    

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
        self.collections.collectionViewLayout = UICollectionViewFlowLayout()
        
    }
    
    
    //registerNib
    private func registerNib(){
        let nibName = UINib(nibName: "CollectionViewCell", bundle: nil)
        collections.register(nibName, forCellWithReuseIdentifier: "CollectionViewCell")
    }
    
    

    
 
    
    
    
    //actionMethod

    
    @IBAction func addButtonTapped(_ sender: UIBarButtonItem) {
        guard let viewController = self.storyboard?.instantiateViewController(withIdentifier: "CollectionSelectViewController") as? CollectionSelectViewController else { return }
  
        
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    
    }






extension ViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let detailViewController = self.storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController else { return }
        let writing = self.List[indexPath.row]
        detailViewController.writing = writing
        detailViewController.indexPath = indexPath
        self.navigationController?.pushViewController(detailViewController, animated: true)
    }
}


extension ViewController: WritingViewDelegate{
    func didSelectReigster(writing: Writing) {
        self.List.append(writing)
        self.collections.reloadData()
    }
}
