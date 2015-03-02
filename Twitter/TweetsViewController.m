//
//  TweetsViewController.m
//  Twitter
//
//  Created by David Tong on 2/22/15.
//  Copyright (c) 2015 David Tong. All rights reserved.
//

#import "TweetsViewController.h"
#import "ComposeViewController.h"
#import "CompositeViewController.h"
#import "TweetDetailsViewController.h"
#import "User.h"
#import "Tweet.h"
#import "TwitterClient.h"
#import "TweetCell.h"



@interface TweetsViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSArray *tweets;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (strong, nonatomic) NSString *type;

- (void)onRefresh;
- (void)onCompose;


@end

@implementation TweetsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    UIColor *twitterDefaultColor = [UIColor colorWithHue:0.54 saturation:1 brightness:0.71 alpha:1];
    
    self.navigationItem.title = @"Twitter";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Logout" style:UIBarButtonItemStyleDone target:self action:@selector(onLogout)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Compose" style:UIBarButtonItemStyleDone target:self action:@selector(onCompose)];
    self.navigationController.navigationBar.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.barTintColor = twitterDefaultColor;
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor  whiteColor];
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor  whiteColor];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"TweetCell" bundle:nil] forCellReuseIdentifier:@"TweetCell"];
    self.tableView.rowHeight = UITableViewAutomaticDimension;

    [self onRefresh];

    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(onRefresh) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:self.refreshControl atIndex:0];
    
}

- (void)viewWillAppear:(BOOL)animated {
    //[self onRefresh];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tweets.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TweetCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TweetCell"];
    
    cell.tweet = self.tweets[indexPath.row];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    TweetDetailsViewController * vc = [[TweetDetailsViewController alloc] init];

    // @NOTE(dtong) instead of assigning, can also define a initWithTweet
    vc.tweet = self.tweets[indexPath.row];
    
    CompositeViewController *cvc = (CompositeViewController*)self.parentViewController.parentViewController;
    [cvc changeMainView:vc];
    
    //[self presentViewController:[[UINavigationController alloc] initWithRootViewController:vc] animated:YES completion:nil];
}

- (void)onLogout {
    //[User setCurrentUser:nil];
    
    [User logout];
}

- (void)onCompose {
    [self presentViewController:[[UINavigationController alloc] initWithRootViewController:[[ComposeViewController alloc] init]] animated:YES completion:nil];
}

- (void)onRefresh {
    if ([self.type isEqual: @"mentions"]) {
        [[TwitterClient sharedInstance] mentionsWithParams:[NSDictionary dictionaryWithObjectsAndKeys:@"24", @"count", nil] completion:^(NSArray *tweets, NSError *error) {
            if (error == nil) {
                self.tweets = tweets;
                
                //[Tweet tweetsWithArray:tweets];
                [self.tableView reloadData];
                [self.refreshControl endRefreshing];
            } else {
                // @NOTE(dtong) Occasionally, network request fails with a status code 429 Too Many Requests
                NSLog(@"Error on refresh: %@", error);
            }
        }];
    } else {
        [[TwitterClient sharedInstance] homeTimelineWithParams:[NSDictionary dictionaryWithObjectsAndKeys:@"24", @"count", nil] completion:^(NSArray *tweets, NSError *error) {
            if (error == nil) {
                self.tweets = tweets;
                
                //[Tweet tweetsWithArray:tweets];
                [self.tableView reloadData];
                [self.refreshControl endRefreshing];
            } else {
                // @NOTE(dtong) Occasionally, network request fails with a status code 429 Too Many Requests
                NSLog(@"Error on refresh: %@", error);
            }
        }];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (TweetsViewController *) initWithType:(NSString *)type {
    self.type = type;
    return self;
}

@end
