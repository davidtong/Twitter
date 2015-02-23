//
//  TweetDetailsViewController.m
//  Twitter
//
//  Created by David Tong on 2/22/15.
//  Copyright (c) 2015 David Tong. All rights reserved.
//

#import "TweetDetailsViewController.h"
#import "ComposeViewController.h"
#import "TweetsViewController.h"
#import "UIImageView+AFNetworking.h"
#import "TwitterClient.h"


@interface TweetDetailsViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *handleLabel;
@property (weak, nonatomic) IBOutlet UILabel *tweetLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIButton *favoriteButton;
@property (weak, nonatomic) IBOutlet UIButton *retweetButton;
@property (weak, nonatomic) IBOutlet UIButton *replyButton;
- (IBAction)favoriteTouchUp:(id)sender;
- (IBAction)replyTouchUp:(id)sender;
- (IBAction)retweetTouchUp:(id)sender;

- (void)onReturn;
- (void)setTweet;

@end

@implementation TweetDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    UIColor *twitterDefaultColor = [UIColor colorWithHue:0.54 saturation:1 brightness:0.71 alpha:1];
    
    self.navigationItem.title = @"Twitter";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"<" style:UIBarButtonItemStylePlain target:self action:@selector(onReturn)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleDone target:self action:nil];
    
    self.navigationController.navigationBar.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.barTintColor = twitterDefaultColor;
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor  whiteColor];
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor  whiteColor];
    
    [self setTweet];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)favoriteTouchUp:(id)sender {
    NSString *tweetId = self.tweet.tweetId;
    
    if (self.favoriteButton.enabled == YES) {
        [[TwitterClient sharedInstance] favoriteWithParams:[[NSDictionary alloc] initWithObjectsAndKeys:tweetId, @"id", nil] completion:^(Tweet *tweet, NSError *error) {
            if (error == nil) {
                self.favoriteButton.enabled = NO;
            }
        }];
    } else {
        [[TwitterClient sharedInstance] unfavoriteWithParams:[[NSDictionary alloc] initWithObjectsAndKeys:tweetId, @"id", nil] completion:^(Tweet *tweet, NSError *error) {
            if (error == nil) {
                self.favoriteButton.enabled = YES;
            }
        }];
    }

}

- (IBAction)replyTouchUp:(id)sender {
    ComposeViewController *vc = [[ComposeViewController alloc] init];
    vc.replyTweet = self.tweet;
    
    [self presentViewController:[[UINavigationController alloc] initWithRootViewController:vc] animated:YES completion:nil];
}

- (IBAction)retweetTouchUp:(id)sender {
    NSString *tweetId = self.tweet.tweetId;
    [[TwitterClient sharedInstance] retweetWithParams:[[NSDictionary alloc] initWithObjectsAndKeys:tweetId, @"id", nil] completion:^(Tweet *tweet, NSError *error) {
        if (error == nil) {
            [self onReturn];
        }
    }];
}

- (void)onReturn {
    [self presentViewController:[[UINavigationController alloc] initWithRootViewController:[[TweetsViewController alloc] init]] animated:YES completion:nil];
}

- (void)setTweet {
        self.tweetLabel.text = self.tweet.text;
        self.nameLabel.text = self.tweet.user.name;
        self.handleLabel.text = [NSString stringWithFormat:@"@%@", self.tweet.user.screenName];
        [self.profileImageView setImageWithURL:[NSURL URLWithString:self.tweet.user.profileImageUrl]];
    
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
        
        self.timeLabel.text = createdLabel;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
