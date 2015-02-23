//
//  TweetCell.m
//  Twitter
//
//  Created by David Tong on 2/22/15.
//  Copyright (c) 2015 David Tong. All rights reserved.
//

#import "TweetCell.h"
#import "UIImageView+AFNetworking.h"
#import "ComposeViewController.h"
#import "TweetsViewController.h"
#import "Tweet.h"
#import "TwitterClient.h"

@interface TweetCell ()

@property (weak, nonatomic) IBOutlet UIButton *favoriteButton;
@property (weak, nonatomic) IBOutlet UIButton *retweetButton;
@property (weak, nonatomic) IBOutlet UILabel *tweetTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *handleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet UILabel *createdAtLabel;
//@property (nonatomic, strong) Tweet *tweet;


- (IBAction)retweetTouchUp:(id)sender;
- (IBAction)favoriteTouchUp:(id)sender;
- (IBAction)replyTouchUp:(id)sender;



@end

@implementation TweetCell

- (void)awakeFromNib {
    // Initialization code
    self.tweetTextLabel.preferredMaxLayoutWidth = self.tweetTextLabel.frame.size.width;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setTweet:(Tweet *)tweet {
    //_tweet = tweet;
    _tweet = tweet;
    self.tweetTextLabel.text = self.tweet.text;
    self.nameLabel.text = self.tweet.user.name;
    self.handleLabel.text = [NSString stringWithFormat:@"@%@", self.tweet.user.screenName];
    [self.profileImage setImageWithURL:[NSURL URLWithString:self.tweet.user.profileImageUrl]];
    
   // NSDate *timeSinceNow = [[NSDate alloc] initWithTimeIntervalSinceNow: [self.tweet.createdAt timeIntervalSinceNow]];
    
    NSTimeInterval time = [self.tweet.createdAt timeIntervalSinceNow];
    
    double timeInMin = abs(time / 60);
    NSString *createdLabel = @"";
    
    if (timeInMin < 60) {
        createdLabel = [NSString stringWithFormat:@"%.0fm", timeInMin];
    } else if (timeInMin >= 60 && timeInMin <= (60 * 24)) {
        createdLabel = [NSString stringWithFormat:@"%.0fh", timeInMin / 60];
    } else if (timeInMin > (60 * 24)) {
        createdLabel = [NSString stringWithFormat:@"%.0fd", timeInMin / 60 / 24];
    }
    
    self.createdAtLabel.text = createdLabel;
}

- (IBAction)retweetTouchUp:(id)sender {
    NSString *tweetId = _tweet.tweetId;
    [[TwitterClient sharedInstance] retweetWithParams:[[NSDictionary alloc] initWithObjectsAndKeys:tweetId, @"id", nil] completion:^(Tweet *tweet, NSError *error) {
        if (error == nil) {
            TweetsViewController *vc = [[TweetsViewController alloc] init];
            self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:vc];
        }
    }];
}

- (IBAction)favoriteTouchUp:(id)sender {
    NSString *tweetId = _tweet.tweetId;
    
    if (self.favoriteButton.backgroundColor == nil) {
        [[TwitterClient sharedInstance] favoriteWithParams:[[NSDictionary alloc] initWithObjectsAndKeys:tweetId, @"id", nil] completion:^(Tweet *tweet, NSError *error) {
            if (error == nil) {
                self.favoriteButton.backgroundColor = [UIColor brownColor];
            }
        }];
    } else {
        [[TwitterClient sharedInstance] unfavoriteWithParams:[[NSDictionary alloc] initWithObjectsAndKeys:tweetId, @"id", nil] completion:^(Tweet *tweet, NSError *error) {
            if (error == nil) {
                self.favoriteButton.backgroundColor = nil;
            }
        }];
    }
}

- (IBAction)replyTouchUp:(id)sender {
    ComposeViewController *vc = [[ComposeViewController alloc] init];
    vc.replyTweet = _tweet;
    
    self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:vc];
    //[self presentViewController:[[UINavigationController alloc] initWithRootViewController:vc] animated:YES completion:nil];
}
@end
