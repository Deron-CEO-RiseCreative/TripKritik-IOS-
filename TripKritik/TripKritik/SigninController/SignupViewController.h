//
//  SignupViewController.h
//  TripKritik
//
//  Created by youandme on 14/07/15.
//  Copyright (c) 2015 youandme. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SignupViewController : UIViewController <UITextFieldDelegate, UIImagePickerControllerDelegate, UIActionSheetDelegate, UINavigationControllerDelegate> {
    UITapGestureRecognizer *_bgTapGesture;
    
    UIEdgeInsets _contentInsets;
    int _scrollOffset;
    NSData *_profilePicData;
}


@property (weak, nonatomic) IBOutlet UIScrollView *m_scrollView;
@property (weak, nonatomic) IBOutlet UITextField *m_txtID;
@property (weak, nonatomic) IBOutlet UIView *m_viewID;
@property (weak, nonatomic) IBOutlet UITextField *m_txtPassword;
@property (weak, nonatomic) IBOutlet UIView *m_viewPassword;
@property (weak, nonatomic) IBOutlet UITextField *m_txtConfirmPassword;
@property (weak, nonatomic) IBOutlet UIView *m_viewConfirmPassword;
@property (weak, nonatomic) IBOutlet UITextField *m_txtDisplayName;
@property (weak, nonatomic) IBOutlet UIView *m_viewDisplayName;
@property (weak, nonatomic) IBOutlet UIImageView *m_imgProfile;

- (IBAction)actionImagePick:(id)sender;
- (IBAction)actionSubmit:(id)sender;
- (IBAction)actionBack:(id)sender;

@end
