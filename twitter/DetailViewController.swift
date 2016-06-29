//
//  DetailViewController.swift
//  twitter
//
//  Created by Sarah Zhou on 6/28/16.
//  Copyright © 2016 Sarah Zhou. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var profilePic: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var handleLabel: UILabel!
    @IBOutlet weak var tweetLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet weak var numRetweets: UILabel!
    @IBOutlet weak var numFavorites: UILabel!
    
    @IBOutlet weak var repliedImageView: UIImageView!
    @IBOutlet weak var retweetedImageView: UIImageView!
    @IBOutlet weak var favoritedImageView: UIImageView!
    
    @IBAction func reply(sender: AnyObject) {
        
    }
    
    @IBAction func retweet(sender: AnyObject) {
        client.tweet("\(tweet.id)", success: { (User) -> () in
            print("yay retweeted something!")
            }, failure: { (error: NSError) -> () in
                print("Error: \(error.localizedDescription)")
        })
    }

    @IBAction func like(sender: AnyObject) {
        client.like(tweet.id, success: { (User) -> () in
            print("yay retweeted something!")
            }, failure: { (error: NSError) -> () in
                print("Error: \(error.localizedDescription)")
        })
    }
    
    let client = TwitterClient.sharedInstance
    var tweet: Tweet!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Tweet"
        
        retweetedImageView.hidden = !(tweet.retweeted!)
        favoritedImageView.hidden = !(tweet.favorited!)
        
        nameLabel.text = tweet.user?.name as? String
        handleLabel.text = "@\(tweet.user?.screenname as! String)"
        tweetLabel.text = tweet.text as? String
        
        numRetweets.text = "\(tweet.retweetCount)"
        numFavorites.text = "\(tweet.favoritesCount)"
        
        let imageUrl = tweet.user?.profileUrl
        
        // Download task:
        // - sharedSession = global NSURLCache, NSHTTPCookieStorage and NSURLCredentialStorage objects.
        let task = NSURLSession.sharedSession().dataTaskWithURL(imageUrl!) { (responseData, responseUrl, error) -> Void in
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
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.timeStyle = NSDateFormatterStyle.ShortStyle
        dateFormatter.dateStyle = NSDateFormatterStyle.ShortStyle
        timestampLabel.text = dateFormatter.stringFromDate(tweet.timestamp!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showOtherUser" {
            let otherUserViewController = segue.destinationViewController as! OtherUserViewController
            otherUserViewController.user = tweet.user
        }
    }
}
