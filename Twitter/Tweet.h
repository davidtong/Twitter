//
//  Tweet.h
//  Twitter
//
//  Created by David Tong on 2/14/15.
//  Copyright (c) 2015 David Tong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"
@interface Tweet : NSObject

@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) User *user;
@property (nonatomic, strong) NSDate *createdAt;
@property (nonatomic, assign) long id;


# pragma mark Instance methods

- (id)initWithDictionary:(NSDictionary *)dictionary;

#pragma mark class methods

+ (NSArray *)tweetsWithArray:(NSArray *)array;

@end
