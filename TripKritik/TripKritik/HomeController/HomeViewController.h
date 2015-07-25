//
//  HomeViewController.h
//  TripKritik
//
//  Created by youandme on 13/07/15.
//  Copyright (c) 2015 youandme. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIView *m_topImageView;
@property (weak, nonatomic) IBOutlet UIButton *m_btnAdmin;
@property (weak, nonatomic) IBOutlet UILabel *m_lblWelcomBack;
@property (weak, nonatomic) IBOutlet UIView *m_viewMeetMe;
@property (weak, nonatomic) IBOutlet UIView *m_viewFeedMe;
@property (weak, nonatomic) IBOutlet UIView *m_viewBedMe;
@property (weak, nonatomic) IBOutlet UIView *m_viewCheerMe;

- (IBAction)actionAccountTesting:(id)sender;

@end
