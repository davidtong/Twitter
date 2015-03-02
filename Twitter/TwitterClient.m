//
//  TwitterClient.m
//  Twitter
//
//  Created by David Tong on 2/14/15.
//  Copyright (c) 2015 David Tong. All rights reserved.
//

#import "TwitterClient.h"

NSString * const kTwitterConsumerKey = @"TPG14kqnP2FLKnK0oaKgtn4ox";
NSString * const kTwitterConsumerSecret = @"vJ7npy2Hd24I4Fxuwro6HpysQEww5NZ4yAhtYFEkdGZ3Vk8oxP";
NSString * const kTwitterBaseUrl = @"https://api.twitter.com";

@interface TwitterClient()

@property (nonatomic, strong) void (^loginCompletion)(User *user, NSError *error);

@end


@implementation TwitterClient

// @NOTE(dtong) Create singleton for easy access of the Twitter client
+ (TwitterClient *)sharedInstance {
    
    // @NOTE(dtong) run only once because it's static
    // see http://iosdevelopertips.com/objective-c/java-developers-guide-to-static-variables-in-objective-c.html
    static TwitterClient *instance = nil;
    
    // Thread safe??
    // And similar to @synchronize but more performant
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (instance == nil) {
            instance = [[TwitterClient alloc] initWithBaseURL:[NSURL URLWithString:kTwitterBaseUrl] consumerKey:kTwitterConsumerKey consumerSecret:kTwitterConsumerSecret];
        }
    });
    
    return instance;
}

- (void)loginWithCompletion:(void (^)(User *, NSError *))completion {
    self.loginCompletion = completion;
    
    // @NOTE clear state in case logged in before to prevent 401 access denied
    [self.requestSerializer removeAccessToken];
    
    // @NOTE callbackURL protocol must be in the app's info tab here in the project
    [self fetchRequestTokenWithPath:@"oauth/request_token" method:@"GET" callbackURL:[NSURL URLWithString:@"cptwitterdemo://oauth"] scope:nil success:^(BDBOAuth1Credential *requestToken) {
        
        NSURL *authURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://api.twitter.com/oauth/authorize?oauth_token=%@", requestToken.token]];
        
        // another singleton of the global application object
        // if authURL is https, then Safari handles it. Otherwise, it checks if any app can handle its specific protocol
        [[UIApplication sharedApplication] openURL:authURL];
        
    } failure:^(NSError *error) {
        NSLog(@"failed to get the request token!");
        self.loginCompletion(nil, error);
    }];
}

- (void)openURL:(NSURL *)url {
    
    [self fetchAccessTokenWithPath:@"oauth/access_token" method:@"POST" requestToken:[BDBOAuth1Credential credentialWithQueryString:url.query] success:^(BDBOAuth1Credential *accessToken) {
        
        [self.requestSerializer saveAccessToken:accessToken];
        
        [self GET:@"1.1/account/verify_credentials.json" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            User *user = [[User alloc] initWithDictionary:responseObject];
            
            [User setCurrentUser:user];
            
            self.loginCompletion(user, nil);

        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            NSLog(@"failed to get current user");
            self.loginCompletion(nil, error);
        }];
        
        /*
        [[TwitterClient sharedInstance] GET:@"1.1/statuses/home_timeline.json" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSArray *tweets = [Tweet tweetsWithArray:responseObject];
            
            for (Tweet *tweet in tweets) {
                NSLog(@"tweets: %@, created %@", tweet.text, tweet.createdAt);
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
        }];
         */
        
    } failure:^(NSError *error) {
        
        NSLog(@"failed to get the access token");
        self.loginCompletion(nil, error);
    }];

}

- (void)homeTimelineWithParams:(NSDictionary *)params completion:(void (^)(NSArray *, NSError *))completion {
    [self GET:@"1.1/statuses/home_timeline.json" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSArray *tweets = [Tweet tweetsWithArray:responseObject];
        completion(tweets, nil);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completion(nil, error);
    }];
}

- (void)mentionsWithParams:(NSDictionary *)params completion:(void (^)(NSArray *, NSError *))completion {
    [self GET:@"1.1/statuses/mentions_timeline.json" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSArray *tweets = [Tweet tweetsWithArray:responseObject];
        completion(tweets, nil);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completion(nil, error);
    }];
}

- (void)tweetWithParams:(NSDictionary *)params completion:(void (^)(Tweet *, NSError *))completion {
    [self POST:@"1.1/statuses/update.json" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        Tweet * tweet = [[Tweet alloc] initWithDictionary:responseObject];
        completion(tweet, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completion(nil, error);
    }];
}

- (void)favoriteWithParams:(NSDictionary *)params completion:(void (^)(Tweet *, NSError *))completion {
    [self POST:@"1.1/favorites/create.json" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        Tweet * tweet = [[Tweet alloc] initWithDictionary:responseObject];
        completion(tweet, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completion(nil, error);
    }];
}

- (void)unfavoriteWithParams:(NSDictionary *)params completion:(void (^)(Tweet *, NSError *))completion {
    [self POST:@"1.1/favorites/destroy.json" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        Tweet * tweet = [[Tweet alloc] initWithDictionary:responseObject];
        completion(tweet, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completion(nil, error);
    }];
}

- (void)retweetWithParams:(NSDictionary *)params completion:(void (^)(Tweet *, NSError *))completion {
    [self POST:[NSString stringWithFormat:@"1.1/statuses/retweet/%@.json", params[@"id"]] parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        Tweet * tweet = [[Tweet alloc] initWithDictionary:responseObject];
        completion(tweet, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completion(nil, error);
    }];
}
@end
