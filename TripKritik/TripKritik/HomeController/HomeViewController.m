//
//  HomeViewController.m
//  TripKritik
//
//  Created by youandme on 13/07/15.
//  Copyright (c) 2015 youandme. All rights reserved.
//

#import "HomeViewController.h"
#import "SearchViewController.h"
#import <Parse/Parse.h>

@interface HomeViewController ()

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if ([[[PFUser currentUser] objectForKey:@"admin"] isEqualToString:@"Yes"]) {
        self.m_btnAdmin.hidden = NO;
        self.m_btnAdmin.layer.borderWidth = 1.0;
        self.m_btnAdmin.layer.borderColor = [UIColor whiteColor].CGColor;
        self.m_btnAdmin.layer.cornerRadius = 2;
        self.m_btnAdmin.layer.masksToBounds = YES;
    } else {
        self.m_btnAdmin.hidden = YES;
    }
    if ([PFUser currentUser]) {
        self.m_lblWelcomBack.hidden = NO;
        self.m_lblWelcomBack.text = [NSString stringWithFormat:@"Welcome back, %@", [[PFUser currentUser] objectForKey:@"displayname"]];
    } else {
        self.m_lblWelcomBack.hidden = YES;
    }
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    CGRect frame = self.view.frame;
    
    //Welcome
    CGRect imageFrame = self.m_topImageView.frame;
    CGRect welcomeFrame = self.m_lblWelcomBack.frame;
    welcomeFrame.origin.y = imageFrame.origin.y + imageFrame.size.height + 12;
    self.m_lblWelcomBack.frame = welcomeFrame;
    //Meet Me
    CGRect meetFrame = self.m_viewMeetMe.frame;
    meetFrame.origin.y = welcomeFrame.origin.y + welcomeFrame.size.height + 12;
    meetFrame.size.width = frame.size.width * 0.53;
    meetFrame.size.height = (frame.size.height - meetFrame.origin.y) * 0.53;
    self.m_viewMeetMe.frame = meetFrame;
    //Feed Me
    CGRect feedFrame = self.m_viewFeedMe.frame;
    feedFrame.origin.y = meetFrame.origin.y;
    feedFrame.origin.x = meetFrame.origin.x * 2 + meetFrame.size.width;
    feedFrame.size.width = frame.size.width - meetFrame.origin.x - feedFrame.origin.x;
    feedFrame.size.height = meetFrame.size.height;
    self.m_viewFeedMe.frame = feedFrame;
    //Bed Me
    CGRect bedFrame = self.m_viewBedMe.frame;
    bedFrame.origin.y = meetFrame.origin.y + meetFrame.size.height + 15;
    bedFrame.size.width = frame.size.width * 0.35;
    bedFrame.size.height = (frame.size.height - meetFrame.origin.y - meetFrame.size.height - 30);
    self.m_viewBedMe.frame = bedFrame;
    //Cheer Me
    CGRect cheerFrame = self.m_viewCheerMe.frame;
    cheerFrame.origin.y = bedFrame.origin.y;
    cheerFrame.origin.x = bedFrame.origin.x * 2 + bedFrame.size.width;
    cheerFrame.size.width = frame.size.width - bedFrame.origin.x - cheerFrame.origin.x;
    cheerFrame.size.height = bedFrame.size.height;
    self.m_viewCheerMe.frame = cheerFrame;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"segueFeedMe"]) {
        SearchViewController *target = (SearchViewController *)segue.destinationViewController;
        target.m_searchType = 0;
    } else if ([segue.identifier isEqualToString:@"segueBedMe"]) {
        SearchViewController *target = (SearchViewController *)segue.destinationViewController;
        target.m_searchType = 2;
    } else if ([segue.identifier isEqualToString:@"segueCheerMe"]) {
        SearchViewController *target = (SearchViewController *)segue.destinationViewController;
        target.m_searchType = 1;
    }
}

- (IBAction)actionAccountTesting:(id)sender {
}
@end
