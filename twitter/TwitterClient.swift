//
//  TwitterClient.swift
//  twitter
//
//  Created by Sarah Zhou on 6/27/16.
//  Copyright © 2016 Sarah Zhou. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class TwitterClient: BDBOAuth1SessionManager {
    
    static let sharedInstance = TwitterClient(baseURL: NSURL(string: "https://api.twitter.com")!, consumerKey: "DRsiV2OYylhuGb4F8SqQkOLvC", consumerSecret: "vp0HjtmK701CKiRy7jLCoSnWpjIjNnTVW8ziddTdmywJUXBBtR")
    
    var loginSuccess: (() -> ())?
    var loginFailure: ((NSError) -> ())?
    
    func homeTimeline(count: Int, success: ([Tweet]) -> (), failure: (NSError) -> ()) {
        let params = ["count": count]
        
        GET("1.1/statuses/home_timeline.json", parameters: params, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) -> Void in
            let dictionaries = response as! [NSDictionary]
            
            let tweets = Tweet.tweetsWithArray(dictionaries)
            
            success(tweets)
            
        }, failure: { (task: NSURLSessionDataTask?, error: NSError) -> Void in
            failure(error)
        })
    }
    
    func userTweets(screen_name: String, exclude_replies: Bool, success: ([Tweet]) -> (), failure: (NSError) -> ()) {
        let params = ["screen_name": screen_name, "exclude_replies": exclude_replies]
        
        GET("1.1/statuses/user_timeline.json", parameters: params, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) -> Void in
            let dictionaries = response as! [NSDictionary]
            let tweets = Tweet.tweetsWithArray(dictionaries)
            
            success(tweets)
            
            }, failure: { (task: NSURLSessionDataTask?, error: NSError) -> Void in
                failure(error)
        })
    }
    
    func userFavorites(screen_name: String, success: ([Tweet]) -> (), failure: (NSError) -> ()) {
        let params = ["screen_name": screen_name]
        
        GET("1.1/favorites/list.json", parameters: params, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) -> Void in
            let dictionaries = response as! [NSDictionary]
            
            let tweets = Tweet.tweetsWithArray(dictionaries)
            
            success(tweets)
            
            }, failure: { (task: NSURLSessionDataTask?, error: NSError) -> Void in
                failure(error)
        })
    }
    
    func currentAccount(success: (User) -> (), failure: (NSError) -> ()) {
        GET("1.1/account/verify_credentials.json", parameters: nil, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) -> Void in
            print("account: \(response)")
            let userDictionary = response as! NSDictionary
            
            let user = User(dictionary: userDictionary)
            
            success(user)
            
//            print("user: \(user)")
//            print("name: \(user.name)")
//            print("screenname: \(user.screenname)")
//            print("profile url: \(user.profileUrl)")
//            print("description: \(user.tagline)")
            
        }, failure: { (task: NSURLSessionDataTask?, error: NSError) -> Void in
            failure(error)
        })
    }
    
    func tweet(status: String, replyTo: String, success: () -> (), failure: (NSError) -> ()) {
        let params = ["status": status, "in_reply_to_status_id": replyTo]

        POST("1.1/statuses/update.json", parameters: params, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) -> Void in
            //print("tweet: \(response)")
            }, failure: { (task: NSURLSessionDataTask?, error: NSError) -> Void in
                failure(error)
        })
    }
    
    func retweet(id: String, success: (Tweet) -> (), failure: (NSError) -> ()) {
        
        POST("1.1/statuses/retweet/\(id).json", parameters: nil, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) -> Void in
            
            let updatedTweetDictionary = response as! NSDictionary
            let updatedTweet = Tweet(dictionary: updatedTweetDictionary)
            success(updatedTweet)
            
            }, failure: { (task: NSURLSessionDataTask?, error: NSError) -> Void in
                failure(error)
        })
    }
    
    func unretweet(id: String, success: (Tweet) -> (), failure: (NSError) -> ()) {
        
        POST("1.1/statuses/unretweet/\(id).json", parameters: nil, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) -> Void in
            
            let updatedTweetDictionary = response as! NSDictionary
            let updatedTweet = Tweet(dictionary: updatedTweetDictionary)
            success(updatedTweet)
            
            }, failure: { (task: NSURLSessionDataTask?, error: NSError) -> Void in
                failure(error)
        })
    }
    
    func like(id: String, success: (Tweet) -> (), failure: (NSError) -> ()) {
        let params = ["id": id]
        
        POST("1.1/favorites/create.json", parameters: params, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) -> Void in
            
            let updatedTweetDictionary = response as! NSDictionary
            let updatedTweet = Tweet(dictionary: updatedTweetDictionary)
            success(updatedTweet)
            
            //print("favorite: \(response)")
            }, failure: { (task: NSURLSessionDataTask?, error: NSError) -> Void in
                failure(error)
        })
    }
    
    func unlike(id: String, success: (Tweet) -> (), failure: (NSError) -> ()) {
        let params = ["id": id]
        
        POST("1.1/favorites/destroy.json", parameters: params, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) -> Void in
            
            let updatedTweetDictionary = response as! NSDictionary
            let updatedTweet = Tweet(dictionary: updatedTweetDictionary)
            success(updatedTweet)
            
            //print("favorite: \(response)")
            }, failure: { (task: NSURLSessionDataTask?, error: NSError) -> Void in
                failure(error)
        })
    }
    
    func login(success: () -> (), failure: (NSError) -> ()) {
        
        loginSuccess = success
        loginFailure = failure
        
        TwitterClient.sharedInstance.deauthorize()
        TwitterClient.sharedInstance.fetchRequestTokenWithPath("oauth/request_token", method: "GET", callbackURL: NSURL(string: "twitterdemo://oauth"), scope: nil, success: { ( requestToken: BDBOAuth1Credential!) -> Void in
            print("got a token")
            
            let url = NSURL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken.token)")!
            UIApplication.sharedApplication().openURL(url)
        }) { (error: NSError!) -> Void in
            print("error: \(error.localizedDescription)")
            self.loginFailure?(error)
        }
    }
    
    func logout() {
        User.currentUser = nil
        deauthorize()
        
        NSNotificationCenter.defaultCenter().postNotificationName(User.userDidLogoutNotification, object: nil)
    }
    
    func handleOpenUrl(url: NSURL) {
        let requestToken = BDBOAuth1Credential(queryString: url.query)
        fetchAccessTokenWithPath("oauth/access_token", method: "POST", requestToken: requestToken, success: { (accessToken: BDBOAuth1Credential!) -> Void in
            
            self.currentAccount({ (user: User) -> () in
                User.currentUser = user
                self.loginSuccess?()
            }, failure: { (error: NSError) -> () in
                self.loginFailure?(error)
            })
            
        }) { (error: NSError!) -> Void in
            print("error: \(error.localizedDescription)")
            self.loginFailure?(error)
        }
    }

    func getRateStatuses(handler: ((response: NSDictionary?, error: NSError?) -> Void)) {
        GET("1.1/application/rate_limit_status.json?resources=statuses", parameters:nil,
            success: { (task: NSURLSessionDataTask, response: AnyObject?) -> Void in
                if let dict = response as? NSDictionary {
                    handler(response:dict, error:nil)
                }
                //print("favorite: \(response)")
            }, failure: { (task: NSURLSessionDataTask?, error: NSError) -> Void in
                handler(response:nil, error:error)
        })
    }
    
    private static let ratePrintLabels = [
        "/statuses/home_timeline":"home timeline",
        "/statuses/retweets/:id":"retweet",
        "/statuses/user_timeline":"user timeline"]
    
    func printRateStatuses() {
        self.getRateStatuses { (response, error) in
            if let error = error {
                print("received error getting rate limits")
            }else{
                if let dictionary = response {
                    for (key,value) in TwitterClient.ratePrintLabels {
                        let dict = dictionary["resources"]!["statuses"]!![key] as! NSDictionary
                        let limit = dict["limit"] as! Int
                        let remaining = dict["remaining"] as! Int
                        let epoch = dict["reset"] as! Int
                        let resetDate = NSDate(timeIntervalSince1970: Double(epoch))
                        print("\(value) rate: limit=\(limit), remaining=\(remaining); expires in \(TwitterClient.formatIntervalElapsed(resetDate.timeIntervalSinceNow))")
                    }
                }
            }
        }
    }
    
    private static var elapsedTimeFormatter: NSDateComponentsFormatter = {
        let formatter = NSDateComponentsFormatter()
        formatter.unitsStyle = NSDateComponentsFormatterUnitsStyle.Abbreviated
        formatter.collapsesLargestUnit = true
        formatter.maximumUnitCount = 1
        return formatter
    }()
    
    static func formatTimeElapsed(sinceDate: NSDate) -> String {
        let interval = NSDate().timeIntervalSinceDate(sinceDate)
        return elapsedTimeFormatter.stringFromTimeInterval(interval)!
    }
    
    static func formatIntervalElapsed(interval: NSTimeInterval) -> String {
        return elapsedTimeFormatter.stringFromTimeInterval(interval)!
    }
    
}
