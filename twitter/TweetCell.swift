//
//  TweetCell.swift
//  twitter
//
//  Created by Sarah Zhou on 6/28/16.
//  Copyright © 2016 Sarah Zhou. All rights reserved.
//

import UIKit

class TweetCell: UITableViewCell {

    @IBOutlet weak var profilePic: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var handleLabel: UILabel!
    @IBOutlet weak var tweetLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet weak var numRetweets: UILabel!
    @IBOutlet weak var numFavorites: UILabel!
    

    @IBOutlet weak var retweeterImageViewTopConstraint: NSLayoutConstraint!
    
//    @IBOutlet weak var replyImageView: UIImageView!
//    @IBOutlet weak var retweetImageView: UIImageView!
//    @IBOutlet weak var favoriteImageView: UIImageView!
    
    @IBOutlet weak var retweeterLabel: UILabel!
    @IBOutlet weak var retweeterImageView: UIImageView!
    
    var tweet: Tweet!
    let client = TwitterClient.sharedInstance
    
    @IBAction func retweet(sender: UIButton) {
        if self.tweet.retweeted == false {
            client.retweet(String(tweet.id), success: { (Tweet) -> () in
                print("yay retweeted something!")
                self.tweet = Tweet.originalTweet
                sender.selected = true
                self.tweet.retweeted = true
                self.numRetweets.text = self.format(self.tweet.retweetCount)
                //self.retweetImageView.hidden = self.tweet.retweeted!
                }, failure: { (error: NSError) -> () in
                    print("Error: \(error.localizedDescription)")
            })
        } else {
            client.unretweet(String(tweet.id), success: { (Tweet) -> () in
                print("yay retweeted something!")
                self.tweet = Tweet
                sender.selected = false
                self.tweet.retweeted = false
                self.numRetweets.text = self.format(self.tweet.retweetCount)
                //self.retweetImageView.hidden = self.tweet.retweeted!
                }, failure: { (error: NSError) -> () in
                    print("Error: \(error.localizedDescription)")
            })
        }
    }
    
    @IBAction func favorite(sender: UIButton) {
        if tweet.favorited == false {
            client.like(String(tweet.id), success: { (Tweet) -> () in
                print("yay liked something!")
                self.tweet = Tweet
                sender.selected = true
                self.numFavorites.text = self.format(self.tweet.favoritesCount)
                //self.favoriteImageView.hidden = self.tweet.favorited!
                }, failure: { (error: NSError) -> () in
                    print("Error: \(error.localizedDescription)")
            })
        } else {
            client.unlike(String(tweet.id), success: { (Tweet) -> () in
                print("yay liked something!")
                self.tweet = Tweet
                sender.selected = false
                self.numFavorites.text = self.format(self.tweet.favoritesCount)
                //self.favoriteImageView.hidden = self.tweet.favorited!
                }, failure: { (error: NSError) -> () in
                    print("Error: \(error.localizedDescription)")
            })
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func format(number: Int) -> String {
        
        let formatted: String
        
        if number > 1000000 {
            formatted = String(format: "%.0f", Double(number) / 1000000.0) + "m"
        } else if number > 1000 {
            formatted = String(format: "%.0f", Double(number) / 1000.0) + "k"
        } else {
            formatted = "\(number)"
        }
        
        return formatted
    }
}
