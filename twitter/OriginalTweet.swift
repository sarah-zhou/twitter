//
//  OriginalTweet.swift
//  twitter
//
//  Created by Sarah Zhou on 6/30/16.
//  Copyright © 2016 Sarah Zhou. All rights reserved.
//

import UIKit

class OriginalTweet: NSObject {
    var user: User?
    var id: Int = 0
    var text: NSString?
    var timestamp: NSDate?
    var retweetCount: Int = 0
    var favoritesCount: Int = 0
    var retweeted: Bool?
    var favorited: Bool?
    
    init(dictionary: NSDictionary) {

        user = User(dictionary: dictionary["user"] as! NSDictionary)
        
        id = (dictionary["id"] as? Int)!
        
        text = dictionary["text"] as? String
        
        retweetCount = (dictionary["retweet_count"] as? Int) ?? 0
        retweeted = dictionary["retweeted"] as? Bool
        
        favoritesCount = (dictionary["favorite_count"] as? Int) ?? 0
        favorited = dictionary["favorited"] as? Bool
        
        let timestampString = dictionary["created_at"] as? String
        
        if let timestampString = timestampString {
            let formatter = NSDateFormatter()
            formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
            timestamp = formatter.dateFromString(timestampString)
        }
    }
}
