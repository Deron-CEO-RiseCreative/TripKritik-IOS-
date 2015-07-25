//
//  WriteReviewViewController.h
//  TripKritik
//
//  Created by youandme on 15/07/15.
//  Copyright (c) 2015 youandme. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "RateView.h"

@interface WriteReviewViewController : UIViewController <UITextViewDelegate, RateViewDelegate> {
    PFObject *_comment;
    float _rating;
}

@property (strong, nonatomic) NSDictionary *m_BusinessSummary;

@property (weak, nonatomic) IBOutlet UILabel *m_lblBusinessName;
@property (weak, nonatomic) IBOutlet RateView *m_viewRate;
@property (weak, nonatomic) IBOutlet UITextView *m_txtReview;

- (IBAction)actionBack:(id)sender;
- (IBAction)actionSubmit:(id)sender;

@end
