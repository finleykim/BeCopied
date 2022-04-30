//
//  WritingViewController.swift
//  BeCopied
//
//  Created by Finley on 2022/04/28.
//

import UIKit
import Alamofire
import AudioToolbox


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
    
        
        //APIData Call
        self.collectionSelectedConfiguration()
        //ObjectStyle
        self.memorizeDatePicker.tintColor = .white
        //Object AlphaValue Defaults
        [memorizeDatePicker, startButton].forEach{ $0?.alpha = 1 }
        [memorizeCountDownLabel, memorizeProgressView, originalTextView, copyProgressView, copyCountDownLabel, copyTextView, selfFinishButton, finishButton].forEach{ $0.alpha = 0 }

        
        
        //barbutton Style
        navigationItem.backBarButtonItem?.tintColor = .white


  
    }
    
    //touchesBegan
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
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
                    self.memorizeStop()
                    AudioServicesPlaySystemSound(1005)

                    

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
        self.startButton.isSelected = false
        self.timer?.cancel()
        self.timer = nil
        
    }
    
    private func copyStop(){
        
        
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
            self.originalTextView.text = random.description
        }
    }

    private func appleconfiguration(appleCrunchDescriptions: Apple){
        if let random = appleCrunchDescriptions.articles.randomElement(){
            self.originalTextView.text = random.description
        }
    }
    
    private func wallStreetJournalCrunchconfiguration(wallStreetJournalDescriptions: WallStreetJournal){
        if let random = wallStreetJournalDescriptions.articles.randomElement(){
            self.originalTextView.text = random.description
        }
    }
    
    private func businessInUSconfiguration(businessInUSDescriptions: BusinessInUS){
        if let random = businessInUSDescriptions.articles.randomElement(){
            self.originalTextView.text = random.description
        }
    }
    
    private func teslaconfiguration(teslaDescriptions: Tesla){
        if let random = teslaDescriptions.articles.randomElement(){
            self.originalTextView.text = random.description
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
            let url = "https://newsapi.org/v2/top-headline"
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
            self.startButton.isSelected = true
            self.startMemorizeTimer()
            
        case .start:
            self.timerStatus = .pause
            self.startButton.isSelected = false
            self.originalTextView.alpha = 0
            self.startButton.setImage(UIImage(named:"startButton"), for: .normal)
            self.timer?.suspend()
        case .pause:
            self.timerStatus = .start
            self.startButton.isSelected = true
            self.originalTextView.alpha = 1
            self.timer?.resume()
            self.startButton.setImage(UIImage(named:"pauseButton"), for: .normal)

            
        }

        
    }
    @IBAction func selfFinishButtonTapped(_ sender: UIButton) {
        guard let viewController = self.storyboard?.instantiateViewController(withIdentifier: "ViewController") as? ViewController else { return }
        navigationController?.pushViewController(viewController, animated: true)
        
        //저장코드
    }
    @IBAction func finishButtonTapped(_ sender: Any) {
        guard let viewController = self.storyboard?.instantiateViewController(withIdentifier: "ViewController") as? ViewController else { return }
    
        
        
        navigationController?.pushViewController(viewController, animated: true)
        
        
        //저장코드
    }
    
}



