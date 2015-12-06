//
//  HomeViewController.swift
//  Sky_Caramba
//
//  Created by Bartlomiej Siemieniuk on 05/12/2015.
//  Copyright © 2015 BSiemieniuk. All rights reserved.
//

import UIKit
import SwiftyJSON

class HomeViewController:UIViewController,UITableViewDataSource, UITableViewDelegate,RecorderDelegate  {
    
    var logic = Logic().shared()
    
    let suggestions = [
        "I just watched...",
        "I have some thoughs about...",
        "I would like to see...",
        "What do you think about..."
    ];

    @IBOutlet weak var tableView: UITableView!
    
    var conCtrl:ConversationViewController?
    
    
    func hideNavBar() {
        self.navigationController!.setNavigationBarHidden(true, animated: false)
    }
    
    @IBOutlet weak var microButton: UIButton!
    var pressed = false;
    
    @IBOutlet weak var activity: UIActivityIndicatorView!
    
    func gotAudio (data: NSData) {
        let that = self;
        
        self.logic.witWrapper = WitWrapper(audio: data, callback: { result in
            
            let json = JSON(data: result.dataUsingEncoding(NSUTF8StringEncoding)!)
            
            if let text = json["_text"].string {

                dispatch_async(dispatch_get_main_queue(), {
                    self.activity.hidden = true;
                    that.transitionToConversation(text);
                })

            } else {
                print("Try again")
            }
            
        })
    }
    
    
    @IBAction func buttonTapped(sender: AnyObject) {
        if(!pressed) {
            self.microButton.tintColor = UIColor(red: 115.0/255.0, green: 73.0/255.0, blue: 147.0/255.0, alpha: 1.0)
        } else {
            self.activity.hidden       = false;
            self.microButton.tintColor = UIColor.whiteColor();
        }
        
        self.pressed = !self.pressed;
        self.logic.buttonClicked()
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        setGradient()
        
        // set the microphone button
        let image = self.microButton.imageForState(
            .Normal)?.imageWithRenderingMode(.AlwaysTemplate);
    
        self.microButton.setImage(image, forState: .Normal)
        self.microButton.tintColor = UIColor.whiteColor();
        
        // cell
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        self.tableView.backgroundColor = UIColor(red: 135/255.0, green: 160.0/255.0, blue: 175.0/255.0, alpha: 0.05)


        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        self.logic.recorder.delegate = self;
        hideNavBar()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let stringVal = self.suggestions[indexPath.row];
        
        transitionToConversation(stringVal)
        
        self.tableView.deselectRowAtIndexPath(indexPath, animated: false)

    }
    
    
    func transitionToConversation(text: String) {
    
        self.conCtrl = ConversationViewController(nibName: "ConversationViewController", bundle:nil);
        
        let data     = self.conCtrl!.buildMyData(text);
        self.conCtrl!.loadMovieData(text);

        let response = self.conCtrl!.buildResponse("Oh cool, how did you enjoy it?");
        
        self.conCtrl?.dataArray.insert(data, atIndex: 0);
        self.conCtrl?.dataArray.insert(response
            , atIndex: 1);
        
        
        
        self.navigationController?.pushViewController(self.conCtrl!, animated: true)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return suggestions.count;
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        
        cell.textLabel!.text = self.suggestions[indexPath.row]
        
        cell.textLabel?.textColor = UIColor.whiteColor()
        cell.backgroundColor = UIColor.clearColor();

        
        return cell
    }

    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }

    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
