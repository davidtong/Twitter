//
//  CompositeViewController.m
//  Twitter
//
//  Created by David Tong on 2/26/15.
//  Copyright (c) 2015 David Tong. All rights reserved.
//

#import "CompositeViewController.h"
#import "ProfileViewController.h"
#import "User.h"
#import "TweetsViewController.h"
#import "MenuViewController.h"
#import "UIImageView+AFNetworking.h"
#import "TweetCell.h"


@interface CompositeViewController ()
@property (assign, nonatomic) CGRect menuOrigin;
@property (retain, nonatomic) MenuViewController *mvc;
@property (nonatomic, assign) BOOL showingMenu;
@property (assign, nonatomic) int menuWidth;
@property (weak, nonatomic) IBOutlet UIView *mainView;
@property (strong, nonatomic) IBOutlet UIPanGestureRecognizer *panGesture;
@property (strong, nonatomic) UIViewController *currentViewController;

@end

@implementation CompositeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //[[UINavigationController alloc] initWithRootViewController:[[TweetsViewController alloc] init]];
    
    self.menuWidth = 160;
    
    if (_currentViewController) {
        [self changeMainView:_currentViewController];
    } else {
        // default to TweetsViewController
        [self changeMainView:[[TweetsViewController alloc] initWithNibName:@"TweetsViewController" bundle:nil]];
    }
    
    // left menu
    self.mvc = [[MenuViewController alloc] initWithNibName:@"MenuViewController" bundle:nil];
    [self addChildViewController:self.mvc];
    [self.view addSubview:self.mvc.view];
    [self.mvc.nameLabel setTitle:self.currentUser.name forState:UIControlStateNormal];
    [self.mvc.profileImage setImageWithURL:[NSURL URLWithString:self.currentUser.profileImageUrl]];
    
    // init size
    //self.mvc.view.frame = CGRectMake(- self.view.frame.size.width + self.menuWidth, 0, self.view.frame.size.width, self.view.frame.size.height);
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userProfileDidSelect:) name:UserProfileDidSelect object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(goToTweetsView) name:GoToTweetsView object:nil];
}

- (void)viewDidAppear:(BOOL)animated {
    //self.menuView.center = CGPointMake(-1 * self.containerView.bounds.size.width, self.menuView.center.y);
    self.mvc.view.frame = CGRectMake(- self.view.frame.size.width, 0, self.view.frame.size.width, self.view.frame.size.height);
    _menuOrigin = self.mvc.view.frame;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)panGesture:(UIPanGestureRecognizer *)sender {
    CGPoint velocity = [sender velocityInView:self.view];
    
    if (sender.state == UIGestureRecognizerStateBegan) {
    } else if (sender.state == UIGestureRecognizerStateChanged) {
        if (velocity.x > 0) {
            // open
            [UIView animateWithDuration:0.3 animations:^{
                self.mvc.view.frame = CGRectMake(- self.view.frame.size.width + self.menuWidth, 0, self.view.frame.size.width, self.view.frame.size.height);
                
                self.showingMenu = YES;
                
                //[self.view sendSubviewToBack:self.mvc.view];
                //[[sender self.view] bringSubviewToFront:[(UIPanGestureRecognizer*)sender self.view]];
                [[sender view] bringSubviewToFront:[(UIPanGestureRecognizer*)sender view]];
            }];
        } else {
            // close
            [self closeLeftMenu];
        }
    } else if (sender.state == UIGestureRecognizerStateEnded) {
        
    }
}

- (CompositeViewController *)initWithUser:(User *)user {
    _currentUser = user;
    return self;
}

- (CompositeViewController *)initWithUserAndView:(User *)user view:(UIViewController *)vc {
    _currentUser = user;
    _currentViewController = vc;
    return self;
}

- (void)closeLeftMenu {
    [UIView animateWithDuration:0.3 animations:^{
        self.mvc.view.frame = self.menuOrigin;
        self.showingMenu = NO;
    }];
}

- (void)changeMainView:(UIViewController *)vc {
    UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:vc];
    
    [self addChildViewController:nvc];
    [self.mainView addSubview:nvc.view];
    
    _currentViewController = vc;
    
    self.showingMenu = NO;
    [self closeLeftMenu];
    
    self.mvc.view.frame = CGRectMake(- self.view.frame.size.width, 0, self.view.frame.size.width, self.view.frame.size.height);
}


- (void)userProfileDidSelect:(NSNotification*)notification {
    NSDictionary* userInfo = notification.userInfo;
    User* user  = userInfo[@"user"];
    [self changeMainView:[[ProfileViewController alloc] initWithUser:user]];
}

- (void)goToTweetsView {
    [self changeMainView:[[TweetsViewController alloc] init]];
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
