//
//  MeetMeMenuViewController.h
//  TripKritik
//
//  Created by youandme on 16/07/15.
//  Copyright (c) 2015 youandme. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MeetMeMenuViewController : UIViewController


@property (weak, nonatomic) IBOutlet UIView *m_topImageView;
@property (weak, nonatomic) IBOutlet UILabel *m_lblMeetMeMenu;
@property (weak, nonatomic) IBOutlet UIButton *m_btnCreate;
@property (weak, nonatomic) IBOutlet UIButton *m_btnItinertary;
@property (weak, nonatomic) IBOutlet UIButton *m_btnPossiblities;

- (IBAction)actionBack:(id)sender;
@end
