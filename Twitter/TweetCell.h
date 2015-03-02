//
//  TweetCell.h
//  Twitter
//
//  Created by David Tong on 2/22/15.
//  Copyright (c) 2015 David Tong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tweet.h"

extern NSString * const UserProfileDidSelect;

@interface TweetCell : UITableViewCell

@property (nonatomic, strong) Tweet * tweet;

@end
