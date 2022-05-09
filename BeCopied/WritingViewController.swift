//
//  WritingViewController.swift
//  BeCopied
//
//  Created by Finley on 2022/04/28.
//
import UIKit
import Alamofire
import AudioToolbox


protocol WritingViewDelegate: AnyObject{
    func didSelectReigster(writing: Writing)
}


//Collection enum
enum CollectionSelected{
    case techCrunchCollection
    case appleCollection
    case wallStreetJournalCollection
    case businessInUSCollection
    case teslaCollection
}

//Start, Pause, End
enum TimerStatus{
    case start
    case pause
    case end
}


//new, edit

enum EditMode{
    case new
    case edit(IndexPath, Writing)
}


class WritingViewController: UIViewController{
    
    //선언부
    var techCrunch = [TechCrunch]()
    var techCrunchDescription : TechCrunchDescription?
    var apple = [Apple]()
    var appleDescription : AppleDescription?
    var wallStreetJournal = [WallStreetJournal]()
    var wallStreetJournalDescription : WallStreetJournalDescription?
    var businessInUS = [BusinessInUS]()
    var businessInUSDescription : WallStreetJournalDescription?
    var tesla = [Tesla]()
    var teslaDescription : TeslaDescription?
    var collectionSelected: CollectionSelected?
    var duration = 60
    var timerStatus : TimerStatus = .end
    var timer: DispatchSourceTimer?
    var currentSeconds = 0
    var copyCurrentSeconds = 0
    weak var delegate: WritingViewDelegate?
    var editMode : EditMode = .new
    private var writingDate: Date?
    private var datePicker = UIDatePicker()
    var editDoneButton : UIBarButtonItem?
 
    
    
    
    
    
    //Oulets
    @IBOutlet weak var memorizeDatePicker: UIDatePicker!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var memorizeProgressView: UIProgressView!
    @IBOutlet weak var memorizeCountDownLabel: UILabel!
    @IBOutlet weak var originalTextView: UITextView!
    @IBOutlet weak var copyProgressView: UIProgressView!
    @IBOutlet weak var copyCountDownLabel: UILabel!
    @IBOutlet weak var copyTextView: UITextView!
    @IBOutlet weak var selfFinishButton: UIButton!
    @IBOutlet weak var finishButton: UIButton!

    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationBackSwipeMotion()
        navigationItem.leftBarButtonItem = UIBarButtonItem()
        
        //APIData Call
        self.collectionSelectedConfiguration()
        self.configureView()
        self.writingDate = datePicker.date
        self.navigationItem.backBarButtonItem?.tintColor = .white
        
        //Setup Label
        [originalTextView,copyTextView].forEach{
            $0?.layer.cornerRadius = 15
            $0?.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        }

        
        
        //style
        self.backgroundGradient()
        
        //shadowStyle
        [originalTextView,copyTextView].forEach{
            $0?.layer.shadowColor = UIColor.black.cgColor
            $0?.layer.shadowOpacity = 0.3
            $0?.layer.shadowRadius = 10
            
            self.originalTextView.isEditable = false
        }
    }
    

    
    //touchesBegan
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
    
    func navigationBackSwipeMotion() {
            self.navigationController?.interactivePopGestureRecognizer?.delegate = nil
        }
    
    //configureView
    private func configureView(){
        switch self.editMode{
        case .new:
            //ObjectStyle
            self.memorizeDatePicker.tintColor = .white
            //Object AlphaValue Defaults
            [memorizeDatePicker, startButton].forEach{ $0?.alpha = 1 }
            [memorizeCountDownLabel, memorizeProgressView, originalTextView, copyProgressView, copyCountDownLabel, copyTextView, selfFinishButton, finishButton].forEach{ $0.alpha = 0 }
  
            
        case let .edit(_, writing):
            self.copyTextView.text = writing.copy
            self.originalTextView.text = writing.original
            self.writingDate = writing.date
            [memorizeDatePicker, startButton, memorizeCountDownLabel, memorizeProgressView, copyProgressView, copyCountDownLabel, selfFinishButton, finishButton].forEach{ $0.alpha = 0 }
            [copyTextView, originalTextView].forEach{ $0.alpha = 1 }
            //barButton
            self.editDoneButton = UIBarButtonItem(image: nil, style: .plain, target: self, action: #selector(tapEditDoneButton))
            self.editDoneButton?.title = "Done"
            self.editDoneButton?.tintColor = .white
            navigationItem.rightBarButtonItem = self.editDoneButton
            navigationController?.navigationBar.isHidden = false

        }
        

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
    
    @objc func tapEditDoneButton(){
        guard let original = self.originalTextView.text else { return }
        guard let copy = self.copyTextView.text else { return }
        guard let date = self.writingDate else { return }
        switch self.editMode{
        case let .edit(_, writing):
            let writing = Writing(uuidString: writing.uuidString,
                                  original: original,
                                  copy: copy,
                                  date: date)
            NotificationCenter.default.post(name: NSNotification.Name("edit"),
                                            object: writing,
                                            userInfo: nil)
        default :
            break
        }
            self.navigationController?.popViewController(animated: true)
        self.memorizeStop()
        }
    
    

    
    //Timer
    private func startMemorizeTimer(){

        if self.timer == nil{
            self.timer = DispatchSource.makeTimerSource(flags: [], queue: .main)
            self.timer?.schedule(deadline: .now(), repeating: 1)
            self.timer?.setEventHandler(handler: {[weak self] in
                guard let self = self else { return }
                self.currentSeconds -= 1
                let hour = self.currentSeconds / 3600
                let minutes = (self.currentSeconds % 3600) / 60
                let seconds = (self.currentSeconds % 3600) % 60
                self.memorizeCountDownLabel.text = String(format: "%02d:%02d:%02d", hour, minutes, seconds)
                self.memorizeProgressView.progress = Float(self.currentSeconds) / Float(self.duration)
                if self.currentSeconds <= 0{
                    self.memorizeStop()
                    AudioServicesPlaySystemSound(1005)
                    self.startCopyTimer()
                    
                    

                }
            })
            self.timer?.resume()
        }
    }
    
    

    private func startCopyTimer(){
        if self.timer == nil{
            self.timer = DispatchSource.makeTimerSource(flags: [], queue: .main)
            self.timer?.schedule(deadline: .now(), repeating: 1)
            self.timer?.setEventHandler(handler: {[weak self] in
                guard let self = self else { return }
                self.copyCurrentSeconds -= 1
                let hour = self.copyCurrentSeconds / 3600
                let minutes = (self.copyCurrentSeconds % 3600) / 60
                let seconds = (self.copyCurrentSeconds % 3600) % 60
                self.copyCountDownLabel.text = String(format: "%02d:%02d:%02d", hour, minutes, seconds)
                self.copyProgressView.progress = Float(self.copyCurrentSeconds) / Float(self.duration)
                if self.copyCurrentSeconds <= 0{
                    self.copyTimerDone()
                    AudioServicesPlaySystemSound(1005)
                    self.copyTextView.isEditable = true
                    

                }
            })
            self.timer?.resume()
        }
        
    }
    
    
    private func memorizeStop(){
        if self.timerStatus == .pause{
            self.timer?.resume()
        }
        self.timerStatus = .end
        UIView.animate(withDuration: 0.5, animations: {
            self.memorizeCountDownLabel.alpha = 0
            self.memorizeProgressView.alpha = 0
            self.memorizeDatePicker.alpha = 0
            self.originalTextView.alpha = 0
            self.startButton.alpha = 0
            self.copyCountDownLabel.alpha = 1
            self.selfFinishButton.alpha = 1
            self.copyTextView.alpha = 1
            self.copyProgressView.alpha = 1
            
        })
        //self.startButton.isSelected = false
        self.timer?.cancel()
        self.timer = nil
        
    }
    
    private func copyTimerDone(){
        self.timerStatus = .end
        UIView.animate(withDuration: 0.5, animations: {
            self.memorizeCountDownLabel.alpha = 0
            self.memorizeProgressView.alpha = 0
            self.memorizeDatePicker.alpha = 0
            self.originalTextView.alpha = 0
            self.startButton.alpha = 0
            self.copyCountDownLabel.alpha = 0
            self.selfFinishButton.alpha = 0
            self.copyTextView.alpha = 1
            self.finishButton.alpha = 1
            self.copyProgressView.alpha = 0
        })
        self.timer?.cancel()
        self.timer = nil
    }
    
    
  //configuration - LabelText
    
    private func collectionSelectedConfiguration(){
        switch self.collectionSelected{
        case .techCrunchCollection :
            self.fetchTechCrunch(completionHandler: { [weak self] result in
                guard let self = self else { return }
                switch result{
                case let .success(result):
                    self.techCrunchconfiguration(techCrunchDescriptions: result)
                case let .failure(error):
                    self.errorAlert(message: "\(error)")
                    
                }
            })
        case .appleCollection :
            self.fetchTechCrunch(completionHandler: { [weak self] result in
            guard let self = self else { return }
            switch result{
            case let .success(result):
                self.techCrunchconfiguration(techCrunchDescriptions: result)
            case let .failure(error):
                self.errorAlert(message: "\(error)")
                
            }
        })
        case .wallStreetJournalCollection:
            self.fetchWallStreetJournal(completionHandler: { [weak self] result in
                guard let self = self else { return }
                switch result{
                case let .success(result):
                    self.wallStreetJournalCrunchconfiguration(wallStreetJournalDescriptions: result)
                case let .failure(error):
                    self.errorAlert(message: "\(error)")
                    
                }
            })
        case .businessInUSCollection:
            self.fetchTesla(completionHandler: { [weak self] result in
                guard let self = self else { return }
                switch result{
                case let .success(result):
                    self.teslaconfiguration(teslaDescriptions: result)
                case let .failure(error):
                    self.errorAlert(message: "\(error)")
                    
                }
            })
            
        case .teslaCollection:
            self.fetchApple(completionHandler: { [weak self] result in
                guard let self = self else { return }
                switch result{
                case let .success(result):
                    self.appleconfiguration(appleCrunchDescriptions: result)
                case let .failure(error):
                    self.errorAlert(message: "\(error)")
                    
                }
            })
        
            
            
        default :
            break
        }
        
        
    }
    
    
    private func techCrunchconfiguration(techCrunchDescriptions: TechCrunch){
        if let random = techCrunchDescriptions.articles.randomElement(){
            self.originalTextView.text = "\(random.description)"
        }
    }

    private func appleconfiguration(appleCrunchDescriptions: Apple){
        if let random = appleCrunchDescriptions.articles.randomElement(){
            self.originalTextView.text = "\(random.description)"
        }
    }
    
    private func wallStreetJournalCrunchconfiguration(wallStreetJournalDescriptions: WallStreetJournal){
        if let random = wallStreetJournalDescriptions.articles.randomElement(){
            self.originalTextView.text = "\(random.Description)"
        }
    }
    
    private func businessInUSconfiguration(businessInUSDescriptions: BusinessInUS){
        if let random = businessInUSDescriptions.articles.randomElement(){
            self.originalTextView.text = "\(random.description)"
        }
    }
    
    private func teslaconfiguration(teslaDescriptions: Tesla){
        if let random = teslaDescriptions.articles.randomElement(){
            self.originalTextView.text = "\(random.description)"
        }
    }
    
    
    //Error Alert
    private func errorAlert(message: String){
        let alert = UIAlertController(title: "ERROR", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    

    
    
    
    //Alamofire API

        
        //TechCrunch
        func fetchTechCrunch(completionHandler: @escaping (Result<TechCrunch, Error>) -> Void){
            let url = "https://newsapi.org/v2/top-headlines"
            let param = [
                "apiKey":"16507df6dd0a44f3b844085c284e32a8",
                "sources":"techcrunch"
            ]
            AF.request(url, method: .get, parameters: param)
                .responseData(completionHandler: { response in
                    switch response.result{
                    case let .success(data):
                        do{
                            let decoder = JSONDecoder()
                            let result = try decoder.decode(TechCrunch.self, from: data)
                            completionHandler(.success(result))
                        }catch{
                            completionHandler(.failure(error))
                        }
                    case let .failure(error):
                        completionHandler(.failure(error))
                    }
                })
        }

        
        //Apple
        func fetchApple(completionHandler: @escaping (Result<Apple, Error>) -> Void){
            let url = "https://newsapi.org/v2/everything"
            let param = [
                "q":"apple",
                "from":"2022-04-10",
                "to":"2022-05-05",
                "sortBy":"popularity",
                "apiKey":"16507df6dd0a44f3b844085c284e32a8"
                
            ]
            AF.request(url, method: .get, parameters: param)
                .responseData(completionHandler: { response in
                    switch response.result{
                    case let .success(data):
                        do{
                            let decoder = JSONDecoder()
                            let result = try decoder.decode(Apple.self, from: data)
                            completionHandler(.success(result))
                        }catch{
                            completionHandler(.failure(error))
                        }
                    case let .failure(error):
                        completionHandler(.failure(error))
                    }
                })
        }
        
        //WallStreetJournal
        func fetchWallStreetJournal(completionHandler: @escaping (Result<WallStreetJournal, Error>) -> Void){
            let url = "https://newsapi.org/v2/everything"
            let param = [
                "domains":"wsj.com",
                "apiKey":"16507df6dd0a44f3b844085c284e32a8"
            ]
            AF.request(url, method: .get, parameters: param)
                .responseData(completionHandler: { response in
                    switch response.result{
                    case let .success(data):
                        do{
                            let decoder = JSONDecoder()
                            let result = try decoder.decode(WallStreetJournal.self, from: data)
                            completionHandler(.success(result))
                        }catch{
                            completionHandler(.failure(error))
                        }
                    case let .failure(error):
                        completionHandler(.failure(error))
                    }
                })
        }
        
        //BusinessInUS
        func fetchBusinessInUS(completionHandler: @escaping (Result<BusinessInUS, Error>) -> Void){
            let url = "https://newsapi.org/v2/top-headlines"
            let param = [
                "country":"us",
                "category":"business",
                "apiKey":"16507df6dd0a44f3b844085c284e32a8"
            ]
            AF.request(url, method: .get, parameters: param)
                .responseData(completionHandler: { response in
                    switch response.result{
                    case let .success(data):
                        do{
                            let decoder = JSONDecoder()
                            let result = try decoder.decode(BusinessInUS.self, from: data)
                            completionHandler(.success(result))
                        }catch{
                            completionHandler(.failure(error))
                        }
                    case let .failure(error):
                        completionHandler(.failure(error))
                    }
                })
        }
        
        //Tesla
        func fetchTesla(completionHandler: @escaping (Result<Tesla, Error>) -> Void){
            let url = "https://newsapi.org/v2/everything"
            let param = [
                "q":"tesla",
                "apiKey":"16507df6dd0a44f3b844085c284e32a8"
            ]
            AF.request(url, method: .get, parameters: param)
                .responseData(completionHandler: { response in
                    switch response.result{
                    case let .success(data):
                        do{
                            let decoder = JSONDecoder()
                            let result = try decoder.decode(Tesla.self, from: data)
                            completionHandler(.success(result))
                        }catch{
                            completionHandler(.failure(error))
                        }
                    case let .failure(error):
                        completionHandler(.failure(error))
                    }
                })
        }

    
    
    
    
    //Action Method
    @IBAction func startButtonTapped(_ sender: UIButton) {
        self.duration = Int(self.memorizeDatePicker.countDownDuration)
        switch self.timerStatus{
        case .end :
            self.currentSeconds = self.duration
            self.copyCurrentSeconds = self.duration
            self.timerStatus = .start
            UIView.animate(withDuration: 0.5, animations: {
                self.memorizeCountDownLabel.alpha = 1
                self.memorizeProgressView.alpha = 1
                self.memorizeDatePicker.alpha = 0
                self.originalTextView.alpha = 1
                self.startButton.setImage(UIImage(named:"pauseButton"), for: .normal)
            })
            //self.startButton.isSelected = true
            self.startMemorizeTimer()
            
        case .start:
            self.timerStatus = .pause
            //self.startButton.isSelected = false
            self.originalTextView.alpha = 0
            self.startButton.setImage(UIImage(named:"StartButton"), for: .normal)
            self.timer?.suspend()
        case .pause:
            self.timerStatus = .start
            //self.startButton.isSelected = true
            self.originalTextView.alpha = 1
            self.timer?.resume()
            self.startButton.setImage(UIImage(named:"pauseButton"), for: .normal)

            
        }

        
    }
    @IBAction func selfFinishButtonTapped(_ sender: UIButton) {
        guard let original = self.originalTextView.text else { return }
        guard let copy = self.copyTextView.text else { return }
        guard let date = self.writingDate else { return }
        
        switch self.editMode{
        case .new:
            let writing = Writing(uuidString: UUID().uuidString,
                                  original: original,
                                  copy: copy,
                                  date: date)
            NotificationCenter.default.post(name: NSNotification.Name("new"),
                                            object: writing,
                                            userInfo: nil
            )
         self.navigationController?.popToRootViewController(animated: true)
            
        default:
            break
                                            }
                                            
        self.memorizeStop()
      
        
    }
    @IBAction func finishButtonTapped(_ sender: Any) {
        guard let original = self.originalTextView.text else { return }
        guard let copy = self.copyTextView.text else { return }
        guard let date = self.writingDate else { return }
        
      
            let writing = Writing(uuidString: UUID().uuidString,
                                  original: original,
                                  copy: copy,
                                  date: date)
            NotificationCenter.default.post(name: NSNotification.Name("new"),
                                            object: writing,
                                            userInfo: nil
            )
         self.navigationController?.popToRootViewController(animated: true)
        self.memorizeStop()

    }
    
//개발자용 타임워프버튼
//    @IBAction func temporaryButtonTapped(_ sender: Any) {
//        self.memorizeStop()
//        AudioServicesPlaySystemSound(1005)
//        self.startCopyTimer()
//
//    }
    
  
    
    
}


