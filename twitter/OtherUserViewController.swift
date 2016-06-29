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
        
        print("other user screenname: \(user.screenname)")
        
        tableView.dataSource = self
        tableView.delegate = self
        
        nameLabel.text = user.name as? String
        handleLabel.text = "@\(user.screenname as! String)"
        bioLabel.text = user.tagline as? String
        
        let followers = user.followers
        let following = user.following
        
        if followers > 1000000 {
            numFollowers.text = String(format: "%.0f", Double(followers) / 1000000.0) + "m"
        } else if followers > 1000 {
            numFollowers.text = String(format: "%.0f", Double(followers) / 1000.0) + "k"
        }
        
        if following > 1000000 {
            numFollowing.text = String(format: "%.0f", Double(following) / 1000000.0) + "m"
        } else if followers > 1000 {
            numFollowing.text = String(format: "%.0f", Double(following) / 1000.0) + "k"
        }
        
        let imageUrl = user?.profileUrl
        
        // Download task:
        // - sharedSession = global NSURLCache, NSHTTPCookieStorage and NSURLCredentialStorage objects.
        let task = NSURLSession.sharedSession().dataTaskWithURL(imageUrl!) { (responseData, responseUrl, error) -> Void in
            // if responseData is not null...
            if let data = responseData{
                
                // execute in UI thread
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.profilePic.layer.borderWidth = 3
                    self.profilePic.layer.borderColor = UIColor.whiteColor().CGColor
                    // self.profilePic.layer.cornerRadius = self.profilePic.frame.height/10
                    self.profilePic.image = UIImage(data: data)
                })
            }
        }
        
        // Run task
        task.resume()
        
        self.loadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadData() {
        let client = TwitterClient.sharedInstance
        client.userTweets((user.screenname as? String)!, success: { (tweets: [Tweet]) in
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
