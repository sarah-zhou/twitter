//
//  NewTweetViewController.swift
//  twitter
//
//  Created by Sarah Zhou on 6/28/16.
//  Copyright © 2016 Sarah Zhou. All rights reserved.
//

import UIKit

class NewTweetViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var tweetTextView: UITextView!
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var handleLabel: UILabel!
    
    @IBAction func cancelButton(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func tweetTweet(sender: AnyObject) {
        
        let client = TwitterClient.sharedInstance
        
        
        client.tweet({
            print("yay tweeted something!")
            }, failure: { (error: NSError) -> () in
                print("Error: \(error.localizedDescription)")
        })
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tweetTextView.delegate = self
        tweetTextView.becomeFirstResponder()
        
        let user = User.currentUser
        nameLabel.text = user?.name as? String
        handleLabel.text = "@\(user?.screenname as! String)"
        
        let task = NSURLSession.sharedSession().dataTaskWithURL((user?.profileUrl)!) { (responseData, responseUrl, error) -> Void in
            // if responseData is not null...
            if let data = responseData{
                
                // execute in UI thread
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.profilePic.image = UIImage(data: data)
                })
            }
        }
        
        // Run task
        task.resume()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
