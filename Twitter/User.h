//
//  User.h
//  Twitter
//
//  Created by David Tong on 2/14/15.
//  Copyright (c) 2015 David Tong. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const UserDidLoginNotification;
extern NSString * const UserDidLogoutNotification;

@interface User : NSObject

@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSString * screenName;
@property (nonatomic, strong) NSString * profileImageUrl;
@property (nonatomic, strong) NSString * coverImageUrl;
@property (nonatomic, strong) NSString * tagLine;
@property (nonatomic, strong) NSString *  numFollower;
@property (nonatomic, strong) NSString *  numFollowing;
@property (nonatomic, strong) NSString * numTweet;


- (id) initWithDictionary: (NSDictionary *)dictionary;

+ (User *)currentUser;
+ (void)setCurrentUser:(User *)currentUser;
+ (void)logout;

@end
