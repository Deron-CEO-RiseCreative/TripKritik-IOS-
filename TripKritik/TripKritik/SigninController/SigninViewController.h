//
//  SigninViewController.h
//  TripKritik
//
//  Created by youandme on 14/07/15.
//  Copyright (c) 2015 youandme. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SigninViewController : UIViewController <UITextFieldDelegate> {
    UITapGestureRecognizer *_bgTapGesture;

}


@property (weak, nonatomic) IBOutlet UITextField *m_txtID;
@property (weak, nonatomic) IBOutlet UITextField *m_txtPassword;
@property (weak, nonatomic) IBOutlet UIView *m_viewID;
@property (weak, nonatomic) IBOutlet UIView *m_viewPassword;
@property (weak, nonatomic) IBOutlet UIButton *m_btnLogin;

- (IBAction)actionLogin:(id)sender;
- (IBAction)actionBack:(id)sender;
- (IBAction)actionLogout:(id)sender;

@end
