//
//  AddItineraryViewController.h
//  TripKritik
//
//  Created by youandme on 24/07/15.
//  Copyright (c) 2015 youandme. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "MBProgressHUD.h"

@interface AddItineraryViewController : UIViewController <UITextFieldDelegate> {
    UITapGestureRecognizer *_bgTapGesture;
    BOOL _isStartDate;
}

@property (strong, nonatomic) PFObject *_itinerary;
@property (weak, nonatomic) IBOutlet UILabel *m_lblTitle;
@property (weak, nonatomic) IBOutlet UIScrollView *m_scrollView;
@property (weak, nonatomic) IBOutlet UIView *m_viewCityState;
@property (weak, nonatomic) IBOutlet UITextField *m_txtCityState;
@property (weak, nonatomic) IBOutlet UISegmentedControl *m_segDate;
@property (weak, nonatomic) IBOutlet UILabel *m_lblStartDate;
@property (weak, nonatomic) IBOutlet UILabel *m_lblEndDate;
@property (weak, nonatomic) IBOutlet UIButton *m_btnAdd;
@property (weak, nonatomic) IBOutlet UIDatePicker *m_datePicker;

- (IBAction)actionBack:(id)sender;
- (IBAction)actionChangeDateSegument:(id)sender;
- (IBAction)actionChangeDate:(id)sender;
- (IBAction)actionAdd:(id)sender;

@end
