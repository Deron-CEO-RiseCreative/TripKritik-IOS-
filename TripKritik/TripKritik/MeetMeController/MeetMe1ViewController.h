//
//  MeetMe1ViewController.h
//  TripKritik
//
//  Created by youandme on 15/07/15.
//  Copyright (c) 2015 youandme. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NIDropDown.h"

@interface MeetMe1ViewController : UIViewController <NIDropDownDelegate> {
    NIDropDown *_dropDown;
    UITapGestureRecognizer *_bgTapGesture;

    NSInteger _curIDOfMyGender;
    NSArray *_Genders;
    NSInteger _curIDOfLookingGender;
    NSArray *_LookingGenders;
    NSInteger _curIDOfMyAge;
    NSArray *_Ages;
    NSInteger _curIDOfLookingAge;
    NSInteger _curIDOfMyCareer;
    NSArray *_Careers;
    NSInteger _curIDOfLookingCareer;
    NSInteger _curIDOfMeeting1;
    NSArray *_Meeting1s;
    NSInteger _curIDOfMeeting2;
    NSArray *_Meeting2s;

    UIButton *_curCombo;
    int _stateOfView;
    UIEdgeInsets _contentInsets;
    int _scrollOffset;
}

@property (weak, nonatomic) IBOutlet UIScrollView *m_scrollView;
@property (weak, nonatomic) IBOutlet UIButton *m_btnMyGender;
@property (weak, nonatomic) IBOutlet UIButton *m_btnLookingGender;
@property (weak, nonatomic) IBOutlet UILabel *m_lblLookingGender;
@property (weak, nonatomic) IBOutlet UIButton *m_btnMyAge;
@property (weak, nonatomic) IBOutlet UIButton *m_btnLookingAge;
@property (weak, nonatomic) IBOutlet UILabel *m_lblLookingAge;
@property (weak, nonatomic) IBOutlet UIButton *m_btnMyCareer;
@property (weak, nonatomic) IBOutlet UIButton *m_btnLookingCareer;
@property (weak, nonatomic) IBOutlet UILabel *m_lblLookingCareer;
@property (weak, nonatomic) IBOutlet UIButton *m_btnMeeting1;
@property (weak, nonatomic) IBOutlet UIButton *m_btnMeeting2;
@property (weak, nonatomic) IBOutlet UILabel *m_lblMeeting2;


- (IBAction)actionBack:(id)sender;
- (IBAction)actionMyGender:(id)sender;
- (IBAction)actionLookingGender:(id)sender;
- (IBAction)actionMyAge:(id)sender;
- (IBAction)actionLookingAge:(id)sender;
- (IBAction)actionMyCareer:(id)sender;
- (IBAction)actionLookingCareer:(id)sender;
- (IBAction)actionMeeting1:(id)sender;
- (IBAction)actionMeeting2:(id)sender;
- (IBAction)actionContinue:(id)sender;

@end
