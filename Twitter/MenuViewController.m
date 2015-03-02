//
//  MenuViewController.m
//  Twitter
//
//  Created by David Tong on 2/26/15.
//  Copyright (c) 2015 David Tong. All rights reserved.
//

#import "MenuViewController.h"
#import "CompositeViewController.h"
#import "TweetsViewController.h"
#import "ProfileViewController.h"

@interface MenuViewController ()

@property (strong, nonatomic) CompositeViewController *cvc;

@end

@implementation MenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.cvc = (CompositeViewController*)self.parentViewController;
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)onTimelineButton:(id)sender {
    //[self presentedViewController:]
    //self.presentedViewController  = [[CompositeViewController alloc] initWithUserAndView:nil view:[[TweetsViewController alloc] init]];
    //self.view.window.
    //[self presentViewController:[[CompositeViewController alloc] initWithUserAndView:nil view:[[TweetsViewController alloc] init]]  animated:NO completion:nil];
    self.cvc = (CompositeViewController*)self.parentViewController;
    [self.cvc changeMainView:[[TweetsViewController alloc] init]];
}

- (IBAction)onProfileButton:(id)sender {
    [self.cvc changeMainView:[[ProfileViewController alloc] initWithUser:self.cvc.currentUser]];
}

- (IBAction)onMentionsButton:(id)sender {
    [self.cvc changeMainView:[[TweetsViewController alloc] initWithType:@"mentions"]];

}

@end
