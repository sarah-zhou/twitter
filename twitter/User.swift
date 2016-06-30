//
//  User.swift
//  
//
//  Created by Sarah Zhou on 6/27/16.
//
//

import UIKit

class User: NSObject {
    
    var name: NSString?
    var screenname: NSString?
    var tagline: NSString?
    var profileUrl: NSURL?
    var backgroundUrl: NSURL?
    var tweets: Int = 0
    var followers: Int = 0
    var following: Int = 0
    
    var dictionary: NSDictionary?
    
    init(dictionary: NSDictionary) {
        
        self.dictionary = dictionary
        name = dictionary["name"] as? String
        screenname = dictionary["screen_name"] as? String
        
        let profileUrlString = dictionary["profile_image_url_https"] as? String
        if let profileUrlString = profileUrlString {
            let modified = profileUrlString.stringByReplacingOccurrencesOfString("_normal", withString: "_bigger")
            profileUrl = NSURL(string: modified)
        }
        
        let backgroundUrlString = dictionary["profile_banner_url"] as? String
        if let backgroundUrlString = backgroundUrlString {
            backgroundUrl = NSURL(string: backgroundUrlString)
        }
        
        tweets = (dictionary["statuses_count"] as? Int) ?? 0
        followers = (dictionary["followers_count"] as? Int) ?? 0
        following = (dictionary["friends_count"] as? Int) ?? 0
        
        tagline = dictionary["description"] as? String
    }
    
    static let userDidLogoutNotification = "UserDidLogout"
    static var _currentUser: User?
    
    class var currentUser: User? {
        get {
            if _currentUser == nil {
                
                let defaults = NSUserDefaults.standardUserDefaults()
                let userData = defaults.objectForKey("currentUser") as? NSData
            
                if let userData = userData {
                    let dictionary = try! NSJSONSerialization.JSONObjectWithData(userData, options: []) as! NSDictionary
                
                    _currentUser = User(dictionary: dictionary)
                }
            }
            return _currentUser
        }
        
        set(user) {
            _currentUser = user
            let defaults = NSUserDefaults.standardUserDefaults()
            
            if let user = user {
                let data = try! NSJSONSerialization.dataWithJSONObject(user.dictionary!, options: [])
                defaults.setObject(data, forKey: "currentUser")
            } else {
                defaults.setObject(nil, forKey: "currentUser")
            }
        
            defaults.synchronize()
        }
    }
}
