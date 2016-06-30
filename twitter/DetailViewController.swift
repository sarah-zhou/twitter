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
    
    @IBOutlet weak var replyImageView: UIImageView!
    @IBOutlet weak var retweetImageView: UIImageView!
    @IBOutlet weak var favoriteImageView: UIImageView!
    
    @IBAction func reply(sender: AnyObject) {
        
    }
    
    @IBAction func retweet(sender: AnyObject) {
        if self.tweet.retweeted == false {
            client.retweet(String(tweet.id), success: { (Tweet) -> () in
                print("yay retweeted something!")
                self.tweet = Tweet.originalTweet
                self.tweet.retweeted = true
                self.loadData()
                }, failure: { (error: NSError) -> () in
                    print("Error: \(error.localizedDescription)")
            })
        } else {
            client.unretweet(String(tweet.id), success: { (Tweet) -> () in
                print("yay retweeted something!")
                self.tweet = Tweet
                self.tweet.retweeted = false
                self.loadData()
                }, failure: { (error: NSError) -> () in
                    print("Error: \(error.localizedDescription)")
            })
        }
    }

    @IBAction func like(sender: AnyObject) {
        if self.tweet.favorited == false {
            client.like(String(tweet.id), success: { (Tweet) -> () in
                print("yay liked something!")
                self.tweet = Tweet
                self.loadData()
                }, failure: { (error: NSError) -> () in
                    print("Error: \(error.localizedDescription)")
            })
        } else {
            client.unlike(String(tweet.id), success: { (Tweet) -> () in
                print("yay liked something!")
                self.tweet = Tweet
                self.loadData()
                }, failure: { (error: NSError) -> () in
                    print("Error: \(error.localizedDescription)")
            })
        }
    }
    
    let client = TwitterClient.sharedInstance
    var tweet: Tweet!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Tweet"
        self.loadData()
    }
    
    func loadData() {
        retweetImageView.hidden = tweet.retweeted!
        favoriteImageView.hidden = tweet.favorited!
        
        nameLabel.text = tweet.user?.name as? String
        handleLabel.text = "@\(tweet.user?.screenname as! String)"
        tweetLabel.text = tweet.text as? String
        
        numRetweets.text = "\(tweet.retweetCount)"
        numFavorites.text = "\(tweet.favoritesCount)"
        
        profilePic.setImageWithURL((tweet.user?.profileUrl)!)
        
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
        if segue.identifier == "showOtherUser" && tweet.user != User.currentUser {
            let profileViewController = segue.destinationViewController as! ProfileViewController
            profileViewController.user = tweet.user
        }
    }
}
