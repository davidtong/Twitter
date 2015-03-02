//
//  CompositeViewController.h
//  Twitter
//
//  Created by David Tong on 2/26/15.
//  Copyright (c) 2015 David Tong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"

@interface CompositeViewController : UIViewController

@property (strong, nonatomic) User *currentUser;
- (CompositeViewController *)initWithUser:(User *)user;
- (CompositeViewController *)initWithUserAndView:(User *)user view:(UIViewController *)vc;
- (void)closeLeftMenu;
- (void)changeMainView:(UIViewController *)vc;

@end
