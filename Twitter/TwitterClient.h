//
//  TwitterClient.h
//  Twitter
//
//  Created by David Tong on 2/14/15.
//  Copyright (c) 2015 David Tong. All rights reserved.
//

#import "BDBOAuth1RequestOperationManager.h"
#import "User.h"
#import "Tweet.h"

@interface TwitterClient : BDBOAuth1RequestOperationManager

+ (TwitterClient *)sharedInstance;

- (void)loginWithCompletion:(void (^)(User *user, NSError *error))completion;
- (void)openURL:(NSURL *)url;

- (void)homeTimelineWithParams:(NSDictionary *)params completion:(void (^)(NSArray *tweets, NSError *error))completion;

- (void)tweetWithParams:(NSDictionary *)params completion:(void (^)(Tweet *, NSError *))completion;

- (void)favoriteWithParams:(NSDictionary *)params completion:(void (^)(Tweet *, NSError *))completion;

- (void)unfavoriteWithParams:(NSDictionary *)params completion:(void (^)(Tweet *, NSError *))completion;

- (void)retweetWithParams:(NSDictionary *)params completion:(void (^)(Tweet *, NSError *))completion;

@end
