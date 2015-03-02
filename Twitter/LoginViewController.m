//
//  LoginViewController.m
//  Twitter
//
//  Created by David Tong on 2/14/15.
//  Copyright (c) 2015 David Tong. All rights reserved.
//

#import "LoginViewController.h"
#import "TwitterClient.h"
#import "TweetsViewController.h"
#import "CompositeViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)onLogin {
    // Want to just login and complete
    [[TwitterClient sharedInstance] loginWithCompletion:^(User *user, NSError *error) {
        if (user != nil) {
            // present the tweets view
            //[self presentViewController:[[TweetsViewController alloc] init] animated:YES completion:nil];
            //[self presentViewController:[[UINavigationController alloc] initWithRootViewController:[[TweetsViewController alloc] init]] animated:YES completion:nil];
            [self presentViewController:[[CompositeViewController alloc] initWithUserAndView:user view:[[TweetsViewController alloc] initWithNibName:@"TweetsViewController" bundle:nil]] animated:YES completion:nil];
            //self.window.rootViewController = [[CompositeViewController alloc] initWithUserAndView:user view:[[TweetsViewController alloc] initWithNibName:@"TweetsViewController" bundle:nil]];
            //self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:[[TweetsViewController alloc] init]];
        } else {
            // present the error view
        }
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    UIColor *twitterDefaultColor = [UIColor colorWithHue:0.54 saturation:1 brightness:0.71 alpha:1];
    
    self.navigationItem.title = @"Twitter";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Login" style:UIBarButtonItemStyleDone target:self action:@selector(onLogin)];
    
    self.navigationController.navigationBar.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.barTintColor = twitterDefaultColor;
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor  whiteColor];
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

@end
