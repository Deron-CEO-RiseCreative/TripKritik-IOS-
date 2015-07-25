//
//  MeetMeMenuViewController.m
//  TripKritik
//
//  Created by youandme on 16/07/15.
//  Copyright (c) 2015 youandme. All rights reserved.
//

#import "MeetMeMenuViewController.h"
#import <Parse/Parse.h>

@interface MeetMeMenuViewController ()

@end

@implementation MeetMeMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.m_btnCreate.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.m_btnItinertary.titleLabel.textAlignment = NSTextAlignmentCenter;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if ([PFUser currentUser] && [[PFUser currentUser] objectForKey:@"mygender"]) {
        [self.m_btnCreate setTitle:@"Change 'Meet Me' Profile" forState:UIControlStateNormal];
    }
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    CGRect frame = self.view.frame;
    
    //Welcome
    CGRect imageFrame = self.m_topImageView.frame;
    CGRect menuFrame = self.m_lblMeetMeMenu.frame;
    menuFrame.origin.y = imageFrame.origin.y + imageFrame.size.height + 12;
    self.m_lblMeetMeMenu.frame = menuFrame;
    //Meet Me
    CGRect meetFrame = self.m_btnCreate.frame;
    meetFrame.origin.y = menuFrame.origin.y + menuFrame.size.height + 12;
    meetFrame.size.width = frame.size.width * 0.53;
    meetFrame.size.height = (frame.size.height - meetFrame.origin.y) * 0.49;
    self.m_btnCreate.frame = meetFrame;
    //Intinertary
    CGRect intinFrame = self.m_btnItinertary.frame;
    intinFrame.origin.y = meetFrame.origin.y;
    intinFrame.origin.x = meetFrame.origin.x * 2 + meetFrame.size.width;
    intinFrame.size.width = frame.size.width - meetFrame.origin.x - intinFrame.origin.x;
    intinFrame.size.height = meetFrame.size.height;
    self.m_btnItinertary.frame = intinFrame;
    //Possibilities
    CGRect posiFrame = self.m_btnPossiblities.frame;
    posiFrame.origin.y = meetFrame.origin.y + meetFrame.size.height + 15;
    posiFrame.size.width = frame.size.width - 30;
    posiFrame.size.height = (frame.size.height - meetFrame.origin.y - meetFrame.size.height - 30);
    self.m_btnPossiblities.frame = posiFrame;
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

#pragma mark - Actions
- (IBAction)actionBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
