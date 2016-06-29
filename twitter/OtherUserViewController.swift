//
//  OtherUserViewController.swift
//  twitter
//
//  Created by Sarah Zhou on 6/28/16.
//  Copyright © 2016 Sarah Zhou. All rights reserved.
//

import UIKit

class OtherUserViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var backgroundPic: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var handleLabel: UILabel!
    @IBOutlet weak var bioLabel: UILabel!
    @IBOutlet weak var numTweets: UILabel!
    @IBOutlet weak var numFollowers: UILabel!
    @IBOutlet weak var numFollowing: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    @IBAction func indexChanged(sender: AnyObject) {
        switch segmentedControl.selectedSegmentIndex
        {
        case 0:
            self.tableData = tweets
            self.tableView.reloadData()
        case 1:
            self.tableData = favorites
            self.tableView.reloadData()
        default:
            break;
        }
    }
    
    var user: User!
    var tableData: [Tweet] = []
    var tweets: [Tweet] = []
    var favorites: [Tweet] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        nameLabel.text = user.name as? String
        handleLabel.text = "@\(user.screenname as! String)"
        bioLabel.text = user.tagline as? String
        
        numTweets.text = self.format(user.tweets)
        numFollowers.text = self.format(user.followers)
        numFollowing.text = self.format(user.following)
        
        profilePic.setImageWithURL((user?.profileUrl)!)
        backgroundPic.setImageWithURL((user?.backgroundUrl)!)
        
        self.loadData()
        
        // Initialize a UIRefreshControl
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), forControlEvents: UIControlEvents.ValueChanged)
        tableView.insertSubview(refreshControl, atIndex: 0)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.indexChanged(self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadData() {
        let client = TwitterClient.sharedInstance
        client.userTweets((user.screenname as? String)!, exclude_replies: true, success: { (tweets: [Tweet]) in
            self.tweets = tweets
            }, failure: { (error: NSError) -> () in
                print("Error: \(error.localizedDescription)")
        })
        client.userFavorites((user.screenname as? String)!, success: { (tweets: [Tweet]) in
            self.favorites = tweets
            }, failure: { (error: NSError) -> () in
                print("Error: \(error.localizedDescription)")
        })
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
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TweetCell", forIndexPath: indexPath) as! TweetCell
        
        let tweet = tableData[indexPath.row]
        
        let timestamp = tweet.timestamp
        let name = tweet.user?.name as? String
        let handle = tweet.user?.screenname as? String
        let text = tweet.text as? String
        
        cell.tweetLabel.text = text
        cell.nameLabel.text = name
        cell.handleLabel.text = "@\(handle!)"
        
        cell.numRetweets.text = self.format(tweet.retweetCount)
        cell.numFavorites.text = self.format(tweet.favoritesCount)
        
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
