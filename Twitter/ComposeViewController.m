//
//  ComposeViewController.m
//  Twitter
//
//  Created by David Tong on 2/22/15.
//  Copyright (c) 2015 David Tong. All rights reserved.
//

#import "ComposeViewController.h"
#import "TweetsViewController.h"
#import "TwitterClient.h"

@interface ComposeViewController () <UITextViewDelegate>


@property (strong, nonatomic) IBOutlet UITextView *composeTextView;
@property (weak, nonatomic) IBOutlet UILabel *remainingLabel;

- (void)onReturn;
- (void)onTweet;

@end

@implementation ComposeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    UIColor *twitterDefaultColor = [UIColor colorWithHue:0.54 saturation:1 brightness:0.71 alpha:1];
    
    self.navigationItem.title = @"Compose";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"<" style:UIBarButtonItemStylePlain target:self action:@selector(onReturn)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Tweet" style:UIBarButtonItemStyleDone target:self action:@selector(onTweet)];

    
    self.navigationController.navigationBar.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.barTintColor = twitterDefaultColor;
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor  whiteColor];
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor  whiteColor];
    
    self.composeTextView.delegate = self;
    
    if (self.replyHandle.length > 0) {
        self.composeTextView.text = [NSString stringWithFormat:@"@%@ ", self.replyHandle];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)textViewDidChange:(UITextView *)textView {
    if (self.composeTextView.text.length > 140) {
        self.remainingLabel.textColor = [UIColor redColor];
        self.remainingLabel.text = [NSString stringWithFormat:@"-%lu", (self.composeTextView.text.length - 140)];
        self.navigationItem.rightBarButtonItem.enabled = NO;
    } else {
        self.remainingLabel.textColor = [UIColor blackColor];
        self.remainingLabel.text = [NSString stringWithFormat:@"%lu", (140 - self.composeTextView.text.length)];
        
        self.navigationItem.rightBarButtonItem.enabled = YES;
    }
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    if (self.replyHandle.length == 0) {
        self.composeTextView.text = @"";
    }
}


- (void)onReturn {
    [self presentViewController:[[UINavigationController alloc] initWithRootViewController:[[TweetsViewController alloc] init]] animated:YES completion:nil];
}

- (void)onTweet {
    [[TwitterClient sharedInstance] tweetWithParams:[NSDictionary dictionaryWithObjectsAndKeys:self.composeTextView.text, @"status", nil] completion:^(Tweet *tweet, NSError *error) {
        if (error == nil) {
            [self onReturn];
        } else {
        }
    }];
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
