//
//  ContactViewController.h
//  TripKritik
//
//  Created by youandme on 18/07/15.
//  Copyright (c) 2015 youandme. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface ContactViewController : UIViewController

@property (strong, nonatomic) PFObject *m_possiblity;

@property (weak, nonatomic) IBOutlet UILabel *m_lblName;
@property (weak, nonatomic) IBOutlet UIImageView *m_imgProfilePic;
@property (weak, nonatomic) IBOutlet UILabel *m_lblPlace;
@property (weak, nonatomic) IBOutlet UILabel *m_lblDate;
@property (weak, nonatomic) IBOutlet UITextView *m_txtLikeDislike;

- (IBAction)actionBack:(id)sender;

@end
