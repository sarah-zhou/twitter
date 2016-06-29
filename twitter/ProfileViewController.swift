//
//  ProfileViewController.swift
//  twitter
//
//  Created by Sarah Zhou on 6/28/16.
//  Copyright © 2016 Sarah Zhou. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var backgroundPic: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var handleLabel: UILabel!
    @IBOutlet weak var bioLabel: UILabel!
    @IBOutlet weak var numTweets: UILabel!
    @IBOutlet weak var numFollowers: UILabel!
    @IBOutlet weak var numFollowing: UILabel!
    
    var user: User!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        user = User.currentUser!
        
        nameLabel.text = user.name as? String
        handleLabel.text = "@\(user.screenname as! String)"
        bioLabel.text = user.tagline as? String
        
        let followers = user.followers
        let following = user.following
        
        if followers > 1000000 {
            numFollowers.text = String(format: "%.0f", Double(followers) / 1000000.0) + "m"
        } else if followers > 1000 {
            numFollowers.text = String(format: "%.0f", Double(followers) / 1000.0) + "k"
        } else {
            numFollowers.text = "\(followers)"
        }
        
        if following > 1000000 {
            numFollowing.text = String(format: "%.0f", Double(following) / 1000000.0) + "m"
        } else if followers > 1000 {
            numFollowing.text = String(format: "%.0f", Double(following) / 1000.0) + "k"
        } else {
            numFollowing.text = "\(following)"
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

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
