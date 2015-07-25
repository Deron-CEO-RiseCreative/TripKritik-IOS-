//
//  MeetMe2ViewController.h
//  TripKritik
//
//  Created by youandme on 15/07/15.
//  Copyright (c) 2015 youandme. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface MeetMe2ViewController : UIViewController <UITextViewDelegate> {
    UITapGestureRecognizer *_bgTapGesture;
    UIEdgeInsets _contentInsets;
    int _scrollOffset;

    PFObject *_meetMe;
}

@property (strong, nonatomic) NSMutableDictionary *m_MeetMeProfile;

@property (weak, nonatomic) IBOutlet UIScrollView *m_scrollView;
@property (weak, nonatomic) IBOutlet UITextView *m_txtLike;
@property (weak, nonatomic) IBOutlet UITextView *m_txtDislike;

- (IBAction)actionBack:(id)sender;
- (IBAction)actionAdd:(id)sender;

@end
