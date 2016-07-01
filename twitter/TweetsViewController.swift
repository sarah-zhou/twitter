//
//  TweetsViewController.swift
//  twitter
//
//  Created by Sarah Zhou on 6/27/16.
//  Copyright © 2016 Sarah Zhou. All rights reserved.
//

import UIKit

class TweetsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var tweets: [Tweet] = []
    
    @IBOutlet weak var tweetsTableView: UITableView!
    
    @IBAction func onLogOut(sender: AnyObject) {
        TwitterClient.sharedInstance.logout()
    }
    
    let client = TwitterClient.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tweetsTableView.dataSource = self
        tweetsTableView.delegate = self
        
        tweetsTableView.estimatedRowHeight = 200
        tweetsTableView.rowHeight = UITableViewAutomaticDimension
        
        self.loadData(nil)
        
        let logo = UIImage(named: "logo")
        let imageView = UIImageView(image:logo)
        self.navigationItem.titleView = imageView
        
        // Initialize a UIRefreshControl
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(loadData(_:)), forControlEvents: UIControlEvents.ValueChanged)
        tweetsTableView.insertSubview(refreshControl, atIndex: 0)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.loadData(nil)
        tweetsTableView.reloadData()
    }
    
    func loadData(refreshControl: UIRefreshControl?) {
        TwitterClient.sharedInstance.homeTimeline(20, success: { (tweets: [Tweet]) in
            self.tweets = tweets
            self.tweetsTableView.reloadData()
            TwitterClient.sharedInstance.printRateStatuses()
            if let refreshControl = refreshControl {
                refreshControl.endRefreshing()
            }
            }, failure: { (error: NSError) -> () in
                print("Error: \(error.localizedDescription)")
        })
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets.count
        // how to account for infinite scrolling?
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tweetsTableView.dequeueReusableCellWithIdentifier("TweetCell", forIndexPath: indexPath) as! TweetCell
        
        var tweet = tweets[indexPath.row]
        if tweet.originalTweet != nil {
            cell.retweeterImageView.hidden = false
            cell.retweeterLabel.hidden = false
            cell.retweeterLabel.text = "\(tweet.user!.name!) Retweeted"
            tweet = tweet.originalTweet!
        } else {
            cell.retweeterImageView.hidden = true
            cell.retweeterLabel.text = ""
            
            cell.retweeterLabel.hidden = true
        }
        cell.tweet = tweet
        
        let timestamp = tweet.timestamp
        let name = tweet.user?.name as? String
        let handle = tweet.user?.screenname as? String
        let text = tweet.text as? String
        
        let seconds = timestamp!.timeIntervalSinceNow as NSTimeInterval
        cell.timestampLabel.text = formatDate(seconds)
        
        cell.tweetLabel.text = text
        cell.nameLabel.text = name
        cell.handleLabel.text = "@\(handle!)"
        
        cell.numRetweets.text = self.format(tweet.retweetCount)
        cell.numFavorites.text = self.format(tweet.favoritesCount)
        
        cell.retweetImageView.hidden = tweet.retweeted!
        cell.favoriteImageView.hidden = tweet.favorited!
        
        cell.profilePic.setImageWithURL((tweet.user?.profileUrl)!)
        
        return cell
    }
    
    func format(number: Int) -> String {
        
        var formatted: String
        
        if number > 1000000 {
            formatted = String(format: "%.0f", Double(number) / 1000000.0) + "m"
        } else if number > 1000 {
            formatted = String(format: "%.0f", Double(number) / 1000.0) + "k"
        } else {
            formatted = "\(number)"
        }
        
        return formatted
    }
    
    func formatDate(number: NSTimeInterval) -> String {
        var formatted = ""
        
        if number < 60 {
            formatted = "\(number)s"
        } else if number < 3600 {
            formatted = "\(number)m"
        } else if number < 216000 {
            formatted = "\(number)h"
        } else if number < 5184000 {
            formatted = "\(number)d"
        }
        
        return formatted
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetailViewController" {
            let button = sender as! UIButton
            let contentView = button.superview! as UIView
            let cell = contentView.superview as! TweetCell
            let indexPath = tweetsTableView.indexPathForCell(cell)
            let tweet = tweets[indexPath!.row]
            
            let detailViewController = segue.destinationViewController as! DetailViewController
            if tweet.originalTweet != nil {
                detailViewController.tweet = tweet.originalTweet
            } else {
                detailViewController.tweet = tweet
            }
        } else if segue.identifier == "replyTweet" {
            let button = sender as! UIButton
            let contentView = button.superview! as UIView
            let cell = contentView.superview as! TweetCell
            let indexPath = tweetsTableView.indexPathForCell(cell)
            let tweet = tweets[indexPath!.row]
            
            let newTweetViewController = segue.destinationViewController as! NewTweetViewController
            newTweetViewController.replyToUsername = tweet.user?.screenname as? String
        }
    }
}
