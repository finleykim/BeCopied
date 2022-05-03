

import UIKit
import Alamofire

class ViewController: UIViewController{

    
    var List = [Writing]()
    var writingViewController = WritingViewController()
    

    

    @IBOutlet weak var CountLabel: UILabel!
    @IBOutlet weak var collections: UICollectionView!
    
    
    
    //선언부
    private var writingList = [Writing](){
        didSet{
            self.saveWritingList()
        }
    }
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionViewDelegate()
        self.registerNib()
        self.loadWritingList()
        
        //style
        collections.backgroundColor = .clear
        
        //NotificationCenter
        NotificationCenter.default.addObserver(self, selector: #selector(newNotification(_:)), name: NSNotification.Name("new"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(editNotification(_:)), name: NSNotification.Name("edit"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(deleteNotification(_:)), name: Notification.Name("delete"), object: nil)

    }

    //objc
    @objc func newNotification(_ notification: Notification){
        guard let writing = notification.object as? Writing else { return }
        self.writingList.append(writing)
        self.writingList = self.writingList.sorted(by: {
            $0.date.compare($1.date) == .orderedDescending
        })
        self.collections.reloadData()
    }
    @objc func editNotification(_ notification: Notification){
        guard let writing = notification.object as? Writing else { return }
        guard let index = self.writingList.firstIndex(where: { $0.uuidString == writing.uuidString}) else { return }
        self.writingList[index] = writing
        self.writingList = self.writingList.sorted(by: {
            $0.date.compare($1.date) == .orderedDescending
        })
        self.collections.reloadData()
    }
    @objc func deleteNotification(_ notification: Notification){
        guard let uuidString = notification.object as? String else { return }
        guard let index = self.writingList.firstIndex(where: { $0.uuidString == uuidString }) else { return }
        self.writingList.remove(at: index)
        self.collections.deleteItems(at: [IndexPath(row: index, section: 0)])
    }
    

    
    private func saveWritingList(){
        let date = self.writingList.map {
            [
                "uuidString" : $0.uuidString,
                "original" : $0.original,
                "copy" : $0.copy,
                "date" : $0.date
            ]
        }
        let userDefaults = UserDefaults.standard
        userDefaults.set(date, forKey: "writingList")
    }
    
    private func loadWritingList(){
        let userDefaults = UserDefaults.standard
        guard let data = userDefaults.object(forKey: "writingList") as? [[String: Any]] else { return }
        self.writingList = data.compactMap {
            guard let uuidString = $0["uuidString"] as? String else { return nil }
            guard let original = $0["original"] as? String else { return nil }
            guard let copy = $0["copy"] as? String else { return nil }
            guard let date = $0["date"] as? Date else { return nil }
            return Writing(uuidString: uuidString, original: original, copy: copy, date: date)
        }
        self.writingList = self.writingList.sorted(by: {
            $0.date.compare($1.date) == .orderedDescending
        })
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
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.writingList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as? CollectionViewCell else { return UICollectionViewCell() }
        let writing = self.writingList[indexPath.row]
        cell.contentLabel.text = writing.copy
        return cell
    }
    

    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (UIScreen.main.bounds.width / 2) - 20, height: 219)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let detailViewController = self.storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController else { return }
        let writing = self.writingList[indexPath.row]
        detailViewController.writing = writing
        detailViewController.indexPath = indexPath
        self.navigationController?.pushViewController(detailViewController, animated: true)
    }
}
