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
        TwitterClient.sharedInstance.homeTimeline({ (tweets: [Tweet]) in
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
        
        cell.selectionStyle = .None
        
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
        cell.numRetweets.text = "\(numRetweets)"
        cell.numFavorites.text = "\(numFavorites)"
        
        cell.retweetedImageView.hidden = !(tweet.retweeted!)
        cell.favoritedImageView.hidden = !(tweet.favorited!)
        
        let imageUrl = tweet.user?.profileUrl
        
        // Download task:
        // - sharedSession = global NSURLCache, NSHTTPCookieStorage and NSURLCredentialStorage objects.
        let task = NSURLSession.sharedSession().dataTaskWithURL(imageUrl!) { (responseData, responseUrl, error) -> Void in
            // if responseData is not null...
            if let data = responseData{
                
                // execute in UI thread
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    cell.profilePic.image = UIImage(data: data)
                })
            }
        }
        
        // Run task
        task.resume()
        
        return cell
    }

    // Makes a network request to get updated data
    // Updates the tableView with the new data
    // Hides the RefreshControl
    func refreshControlAction(refreshControl: UIRefreshControl) {
        
        self.tweetsTableView.reloadData()
        
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
