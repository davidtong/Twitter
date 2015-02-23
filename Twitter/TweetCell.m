//
//  TweetCell.m
//  Twitter
//
//  Created by David Tong on 2/22/15.
//  Copyright (c) 2015 David Tong. All rights reserved.
//

#import "TweetCell.h"
#import "UIImageView+AFNetworking.h"

@interface TweetCell ()

@property (weak, nonatomic) IBOutlet UILabel *tweetTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *handleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet UILabel *createdAtLabel;

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

@end
