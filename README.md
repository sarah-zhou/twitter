# Project 4 - *twitter*

**twitter** is a basic twitter app to read and compose tweets the [Twitter API](https://apps.twitter.com/).

Time spent: **30** hours spent in total

## User Stories

The following **required** functionality is completed:

- [X] User can sign in using OAuth login flow
- [X] The current signed in user will be persisted across restarts
- [X] User can view last 20 tweets from their home timeline
- [X] In the home timeline, user can view tweet with the user profile picture, username, tweet text, and timestamp.
- [X] User can pull to refresh.
- [X] User should display the relative timestamp for each tweet "8m", "7h"
- [X] Retweeting and favoriting should increment the retweet and favorite count.
- [X] User can tap on a tweet to view it, with controls to retweet, favorite, and reply.
- [X] User can compose a new tweet by tapping on a compose button.
- [X] User can tap the profile image in any tweet to see another user's profile
   - [X] Contains the user header view: picture and tagline
   - [X] Contains a section with the users basic stats: # tweets, # following, # followers
   - [X] Profile view should include that user's timeline
- [X] User can navigate to view their own profile
   - [X] Contains the user header view: picture and tagline
   - [X] Contains a section with the users basic stats: # tweets, # following, # followers

The following **optional** features are implemented:

- [ ] User can load more tweets once they reach the bottom of the feed using infinite loading similar to the actual Twitter client.
- [X] User should be able to unretweet and unfavorite and should decrement the retweet and favorite count.
- [X] When composing, you should have a countdown in the upper right for the tweet limit.
- [ ] After creating a new tweet, a user should be able to view it in the timeline immediately without refetching the timeline from the network.
- [X] User can reply to any tweet, and replies should be prefixed with the username and the reply_id should be set when posting the tweet
- [ ] Links in tweets are clickable
- [ ] User can switch between timeline, mentions, or profile view through a tab bar
- [ ] Pulling down the profile page should blur and resize the header image.

The following **additional** features are implemented:

- List anything else that you can get done to improve the app functionality!
- [X] Displays the original tweet when someone retweeted it 
- [X] Shows who retweeted above the original tweet
- [X] Launch screen

Please list two areas of the assignment you'd like to **discuss further with your peers** during the next class (examples include better ways to implement something, how to extend your app in certain ways, etc):

1. Allowing the bio information to push upwards when scrolling through the tableview
2. The last optional 

## Video Walkthrough

Here's a walkthrough of implemented user stories:

https://imgur.com/qKDnc5O
http://imgur.com/ozh1RTS - demonstrates autolayout (on an iPhone 5s)

GIF created with [LiceCap](http://www.cockos.com/licecap/).

## Notes

Describe any challenges encountered while building the app.

## Credits

List an 3rd party libraries, icons, graphics, or other assets you used in your app.

- [AFNetworking](https://github.com/AFNetworking/AFNetworking) - networking task library

## License

    Copyright [2016] [Sarah Zhou]

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
