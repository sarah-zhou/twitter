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
    
    @IBAction func reply(sender: AnyObject) {
        
    }
    
    @IBAction func retweet(sender: AnyObject) {
        
    }
    
    @IBAction func favorite(sender: AnyObject) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tweetsTableView.dataSource = self
        tweetsTableView.delegate = self
        
        self.loadData()
        
        let logo = UIImage(named: "logo")
        let imageView = UIImageView(image:logo)
        self.navigationItem.titleView = imageView
        
        // Initialize a UIRefreshControl
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), forControlEvents: UIControlEvents.ValueChanged)
        tweetsTableView.insertSubview(refreshControl, atIndex: 0)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadData() {
        TwitterClient.sharedInstance.homeTimeline(20, success: { (tweets: [Tweet]) in
            self.tweets = tweets
            self.tweetsTableView.reloadData()
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
        
        let tweet = tweets[indexPath.row]
        
        let timestamp = tweet.timestamp
        let name = tweet.user?.name as? String
        let handle = tweet.user?.screenname as? String
        let text = tweet.text as? String
        let numRetweets = tweet.retweetCount
        let numFavorites = tweet.favoritesCount
        
        cell.tweetLabel.text = text
        cell.nameLabel.text = name
        cell.handleLabel.text = "@\(handle!)"
        
        if numRetweets > 1000000 {
            cell.numRetweets.text = String(format: "%.0f", Double(numRetweets) / 1000000.0) + "m"
        } else if numRetweets > 1000 {
            cell.numRetweets.text = String(format: "%.0f", Double(numRetweets) / 1000.0) + "k"
        } else {
            cell.numRetweets.text = "\(numRetweets)"
        }
        
        if numFavorites > 1000000 {
            cell.numFavorites.text = String(format: "%.0f", Double(numFavorites) / 1000000.0) + "m"
        } else if numFavorites > 1000 {
            cell.numFavorites.text = String(format: "%.0f", Double(numFavorites) / 1000.0) + "k"
        } else {
            cell.numFavorites.text = "\(numFavorites)"
        }
        
        cell.retweetedImageView.hidden = !(tweet.retweeted!)
        cell.favoritedImageView.hidden = !(tweet.favorited!)
        
        cell.profilePic.setImageWithURL((tweet.user?.profileUrl)!)
        
        return cell
    }

    // Makes a network request to get updated data
    // Updates the tableView with the new data
    // Hides the RefreshControl
    func refreshControlAction(refreshControl: UIRefreshControl) {
        
        self.loadData()
        
        // Tell the refreshControl to stop spinning
        refreshControl.endRefreshing()
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetailViewController" {
            let button = sender as! UIButton
            let contentView = button.superview! as UIView
            let cell = contentView.superview as! TweetCell
            let indexPath = tweetsTableView.indexPathForCell(cell)
            let tweet = tweets[indexPath!.row]
            
            let detailViewController = segue.destinationViewController as! DetailViewController
            detailViewController.tweet = tweet
        }
    }
}
