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
    
    @IBOutlet weak var countLabel: UILabel!
    
    @IBAction func cancelButton(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func tweetTweet(sender: AnyObject) {
        
        let client = TwitterClient.sharedInstance
        
        client.tweet(tweetTextView.text, success: {
            print("yay tweeted something!")
            }, failure: { (error: NSError) -> () in
                print("Error: \(error.localizedDescription)")
        })
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    var replyToUsername: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tweetTextView.delegate = self
        tweetTextView.becomeFirstResponder()
        
        let user = User.currentUser
        nameLabel.text = user?.name as? String
        handleLabel.text = "@\(user?.screenname as! String)"
        
        profilePic.setImageWithURL((user?.profileUrl)!)
        
        countLabel.text = "140"
        
        if replyToUsername != nil {
            tweetTextView.text = "@\(replyToUsername): "
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textViewDidChange(textView: UITextView) {
        countLabel.text = "\(140 - textView.text.characters.count)"
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
