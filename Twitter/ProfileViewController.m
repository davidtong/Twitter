//
//  ProfileViewController.m
//  Twitter
//
//  Created by David Tong on 2/28/15.
//  Copyright (c) 2015 David Tong. All rights reserved.
//

#import "ProfileViewController.h"
#import "User.h"
#import "UIImageView+AFNetworking.h"
#import "CompositeViewController.h"
#import "TweetsViewController.h"

NSString * const GoToTweetsView = @"GoToTweetsView";

@interface ProfileViewController ()
@property (strong, nonatomic) User *user;
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    if (!_user) {
        return;
    }
    
    UIColor *twitterDefaultColor = [UIColor colorWithHue:0.54 saturation:1 brightness:0.71 alpha:1];
    
    self.navigationItem.title = @"Twitter";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"<" style:UIBarButtonItemStyleDone target:self action:@selector(returnToTweetsView)];
    self.navigationController.navigationBar.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.barTintColor = twitterDefaultColor;
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor  whiteColor];
    
    [_profileImageView setImageWithURL:[NSURL URLWithString:_user.profileImageUrl]];
    
    _nameLabel.text = _user.name;

    _handleLabel.text = _user.screenName;
    [_coverPhotoView setImageWithURL:[NSURL URLWithString:_user.coverImageUrl]];
    
    _numTweetLabel.text = _user.numTweet;

    _numFollowerLabel.text = _user.numFollower;
    
    _numFollowingLabel.text = _user.numFollowing;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)returnToTweetsView {
    [[NSNotificationCenter defaultCenter] postNotificationName:GoToTweetsView object:self userInfo:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(ProfileViewController *) initWithUser:(User *)user {
    _user = user;
    return self;
}


@end
