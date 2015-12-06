//
//  ConversationViewController.swift
//  Sky_Caramba
//
//  Created by Bartlomiej Siemieniuk on 05/12/2015.
//  Copyright © 2015 BSiemieniuk. All rights reserved.
//

import UIKit
import SwiftyJSON
import AVFoundation

enum WorkFlow {
    case Initial
    case FirstSuggestion
    case TellMeMore
    case FinalSuggestion
}

class ConversationViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, RecorderDelegate, JSONDelegate {
    
    var dataArray = [Data]();
    var logic     = Logic().shared()
    var step      = WorkFlow.Initial;

    var initShow:String?
    var likedShow:String?

    let synth      = AVSpeechSynthesizer()
    var myUtterance: AVSpeechUtterance? = nil
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var activity: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.logic.recorder.delegate = self;
        
        
        // set the microphone button
        let image = self.microButton.imageForState(
            .Normal)?.imageWithRenderingMode(.AlwaysTemplate);
        
        self.microButton.setImage(image, forState: .Normal)
        self.microButton.tintColor = UIColor.whiteColor();

        
        setGradient()
        registerCells()
        setNavBar()
        addPictureToUIView();
        //mockData();
        
    }
    
    func speakToMe(text :String) {
        myUtterance = AVSpeechUtterance(string: text);
        myUtterance!.rate = 0.5
        synth.speakUtterance(myUtterance!)
    }
    
    func addMovies(json: JSON) {
        
        for (_, subJson):(String, JSON) in json["recommendation"] {
            let movie = buildMovieData(subJson);
            self.dataArray.append(movie);
        }

    }
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 350.0
    }
    
    // json callback witht he api
    func callback(json: JSON) {
        
        dispatch_async(dispatch_get_main_queue(), {

        switch self.step {
            
            case .Initial:
                self.addMovies(json);
            
            case .FirstSuggestion:
                self.addMovies(json);
            
            case .FinalSuggestion:
                
                let str1 = "Cool. So based on my super cool advanced";
                let str2 = " wizardry, I think you might really like these TV Shows";
                
                let data  = self.buildResponse(str1);
                let data1 = self.buildResponse(str2);

                self.dataArray.append(data);
                self.dataArray.append(data1);
                
                self.addMovies(json);
            
            default:
                print("defaut")
            
        }
            
        self.reloadData()
            
        })
    }
    
    func buildMovieData(data: JSON) -> Data {
     
        let movie = Data()
        movie.type = CellType.Movie;
        
        movie.title = data["name"].string!;
        movie.genre = data["genre"].string!;

        if let url = data["image"].string {
            movie.pictureUrl = url;
        }
        
        return movie;
    }
    
    func loadMovieData(text:String) {
        
        let kernel = "I just watched";
        let title  = substring(text, kernel: kernel)
        self.initShow = title as String;
        
        self.logic.api.getMovieInfo(title, ctrl: self);
        
    }
    
    func substring(string:String, kernel:String) -> NSString {

        let string    = string as NSString;
        let kernelLen = kernel.characters.count;
        
        let title  = string.substringWithRange(
            NSRange(
                location: kernelLen,
                length: string.length - kernelLen
            )
        )
        
        return title;
    
    }
    
    
    @IBOutlet weak var microButton: UIButton!
    
    // got audio callback
    func gotAudio (data: NSData) {

        let that = self;
        
        self.logic.witWrapper = WitWrapper(audio: data, callback: { result in
            
            dispatch_async(dispatch_get_main_queue(), {
            
                self.activity.hidden = true;
                
                let json = JSON(data: result.dataUsingEncoding(NSUTF8StringEncoding)!)
            
                if let text = json["_text"].string {
                
                let my   = self.buildMyData(text);
                self.dataArray.append(my);
                
                switch self.step {
                    
                //
                case .Initial:
                    
                   let data = self.buildResponse(
                    "Awesome! So these TV shows look pretty similar");
                   
                   let data1 = self.buildResponse("Do you like any of them?");
                        
                   self.dataArray.append(data);
                   self.dataArray.append(data1);
                   
                   self.step = .FirstSuggestion
                   self.logic.api.getInitialSuggestion(self.initShow!, ctrl: self)
                    
                case .FirstSuggestion:
                    
                    let kernel = "I like";
                    let title  = self.substring(text, kernel: kernel)
                    
                    self.likedShow      = title as String;
                    
                    let responseString  = "Ah Ok. In a couple of sentences, tell"
                    let responseString2 = "me why do you like " + (title as String)
                    
                    let response = self.buildResponse(responseString);
                    self.dataArray.append(response);

                    let response1 = self.buildResponse(responseString2);
                    self.dataArray.append(response1);
                    
                    self.step = .TellMeMore
                    
                case .TellMeMore:

                    self.step = .FinalSuggestion
                    
                    self.logic.api.sendOpinion(
                        self.likedShow!,
                        opinion: text,
                        ctrl: self)
                    
                    default:
                        print("defaut")
                    
                }
                    that.reloadData();
                
            } else {
                print("Try again")
            }
                
                                })
            
        })
    }
    
    func buildMyData(text: String)-> Data {
        let data = Data()
        data.type = CellType.MyText;
        data.text = text;
        return data;
    }

    func buildResponse(text: String)-> Data {
        let data = Data()
        data.type = CellType.Response;
        data.text = text;
        
        self.speakToMe(text);
        
        return data;
    }

    func registerCells() {
        self.tableView
            .registerClass(ConCellTableViewCell.self, forCellReuseIdentifier: "con")

        self.tableView
            .registerClass(ResponseTableViewCell.self, forCellReuseIdentifier: "response")

        self.tableView
            .registerClass(MovieTableViewCell.self, forCellReuseIdentifier: "movie")
        
        let movieNib = UINib(nibName: "MovieTableViewCell", bundle: nil
        )
        
        self.tableView.registerNib(movieNib, forCellReuseIdentifier: "movie")
    }
    
    func setNavBar() {
        self.navigationController!.setNavigationBarHidden(false, animated: true)
        
        self.navigationController!.navigationBar.barTintColor = UIColor(red: 8.0/255.0, green: 40.0/255.0, blue: 67.0/255.0, alpha: 1.0)
        
        self.navigationController!.navigationBar.tintColor = UIColor(red: 115.0/255.0, green: 73.0/255.0, blue: 147.0/255.0, alpha: 1.0)
        
        self.navigationController!.navigationBar.translucent = false;
        
    }
    
    func addPictureToUIView() {
        
        let image: UIImage = UIImage(named: "logo-small")!
        let bgImage = UIImageView(image: image)
        
        let x = (self.view.frame.width - 50) / 2;
        
        bgImage.frame = CGRectMake(x,0,50,33)
        self.navigationController?.navigationBar.addSubview(bgImage)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func reloadData() {
        self.tableView.reloadData();
        let iPath = NSIndexPath(forRow: self.dataArray.count - 1, inSection: 0)

        self.tableView.scrollToRowAtIndexPath(iPath, atScrollPosition:
            .Top, animated: true)
    }
    
    var pressed = false;

    @IBAction func microTyped(sender: AnyObject) {
        if(!pressed) {
            self.microButton.tintColor = UIColor(red: 115.0/255.0, green: 73.0/255.0, blue: 147.0/255.0, alpha: 1.0)
        } else {
            self.microButton.tintColor = UIColor.whiteColor();
            self.activity.hidden = false;
        }
        
        self.pressed = !self.pressed;

        
        self.logic.buttonClicked()
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let data = self.dataArray[indexPath.row];
        
        var cell:ConCell?;
        
        switch data.type! {
            case .Movie:
                cell = tableView.dequeueReusableCellWithIdentifier("movie", forIndexPath: indexPath) as! MovieTableViewCell

            case .Response:
                cell = tableView.dequeueReusableCellWithIdentifier("response", forIndexPath: indexPath) as! ResponseTableViewCell

            case .MyText:
                cell = tableView.dequeueReusableCellWithIdentifier("con", forIndexPath: indexPath) as! ConCellTableViewCell
        }
        
        (cell as! UITableViewCell).backgroundColor = UIColor.clearColor();
        cell!.customizeCell(data);

        return cell as! UITableViewCell
    }
    
}
