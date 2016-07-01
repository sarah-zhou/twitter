//
//  ProfileViewController.swift
//  twitter
//
//  Created by Sarah Zhou on 6/28/16.
//  Copyright © 2016 Sarah Zhou. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var backgroundPic: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var handleLabel: UILabel!
    @IBOutlet weak var bioLabel: UILabel!
    @IBOutlet weak var numTweets: UILabel!
    @IBOutlet weak var numFollowers: UILabel!
    @IBOutlet weak var numFollowing: UILabel!
    
    @IBOutlet weak var back: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    @IBAction func indexChanged(sender: AnyObject) {
        setDataSource()
    }
    
    @IBAction func back(sender: AnyObject) {
        let presentingViewController: UIViewController! = self.presentingViewController
        
        self.dismissViewControllerAnimated(false) {
            // go back to MainMenuView as the eyes of the user
            presentingViewController.dismissViewControllerAnimated(false, completion: nil)
        }
    }
    
    private func setDataSource() {
        switch segmentedControl.selectedSegmentIndex
        {
        case 0:
            self.tableData = tweets
        case 1:
            self.tableData = favorites
        default:
            break;
        }
    }
    
    var tableData: [Tweet] = [] {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    var user: User!
    var tweets: [Tweet] = []
    var favorites: [Tweet] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if user == nil {
            user = User.currentUser!
            back.hidden = true
        }
        
        segmentedControl.selectedSegmentIndex = 0
        tableView.dataSource = self
        tableView.delegate = self
        
        nameLabel.text = user.name as? String
        handleLabel.text = "@\(user.screenname as! String)"
        bioLabel.text = user.tagline as? String
        
        numTweets.text = self.format(user.tweets)
        numFollowers.text = self.format(user.followers)
        numFollowing.text = self.format(user.following)
        
        profilePic.setImageWithURL((user?.profileUrl)!)
        profilePic.layer.borderWidth = 2
        profilePic.layer.borderColor = UIColor.whiteColor().CGColor
        backgroundPic.setImageWithURL((user?.backgroundUrl)!)
        
        view.sendSubviewToBack(backgroundPic)
        
        self.loadData(nil)
        
        // Initialize a UIRefreshControl
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(loadData(_:)), forControlEvents: UIControlEvents.ValueChanged)
        tableView.insertSubview(refreshControl, atIndex: 0)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadData(refreshControl: UIRefreshControl?) {
        let client = TwitterClient.sharedInstance
        client.userTweets((user.screenname as? String)!, exclude_replies: true, success: { (tweets: [Tweet]) in
            self.tweets = tweets
            self.setDataSource()
            if let refreshControl = refreshControl {
                refreshControl.endRefreshing()
            }
            }, failure: { (error: NSError) -> () in
                print("Error: \(error.localizedDescription)")
        })
        client.userFavorites((user.screenname as? String)!, success: { (tweets: [Tweet]) in
            self.favorites = tweets
            self.setDataSource()
            if let refreshControl = refreshControl {
                refreshControl.endRefreshing()
            }
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
        
        var tweet = tableData[indexPath.row]
        if tweet.originalTweet != nil {
            cell.retweeterImageView.hidden = false
            cell.retweeterLabel.text = "\(tweet.user!.name!) Retweeted"
            tweet = tweet.originalTweet!
        } else {
            cell.retweeterImageView.hidden = true
            cell.retweeterLabel.text = ""
        }
        cell.tweet = tweet
        
        let timestamp = tweet.timestamp
        let name = tweet.user?.name as? String
        let handle = tweet.user?.screenname as? String
        let text = tweet.text as? String
        
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
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetailViewController" {
            let button = sender as! UIButton
            let contentView = button.superview! as UIView
            let cell = contentView.superview as! TweetCell
            let indexPath = tableView.indexPathForCell(cell)
            let tweet = tweets[indexPath!.row]
            
            let detailViewController = segue.destinationViewController as! DetailViewController
            if tweet.originalTweet != nil {
                detailViewController.tweet = tweet.originalTweet
            } else {
                detailViewController.tweet = tweet
            }
        }
    }

}
