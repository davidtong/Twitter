//
//  ProfileViewController.h
//  Twitter
//
//  Created by David Tong on 2/28/15.
//  Copyright (c) 2015 David Tong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"
extern NSString * const GoToTweetsView;

@interface ProfileViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *coverPhotoView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *handleLabel;
@property (weak, nonatomic) IBOutlet UILabel *numTweetLabel;
@property (weak, nonatomic) IBOutlet UILabel *numFollowerLabel;
@property (weak, nonatomic) IBOutlet UILabel *numFollowingLabel;

-(ProfileViewController *) initWithUser:(User *)user;

@end