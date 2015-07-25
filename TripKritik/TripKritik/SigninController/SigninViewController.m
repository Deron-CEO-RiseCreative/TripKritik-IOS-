//
//  SigninViewController.m
//  TripKritik
//
//  Created by youandme on 14/07/15.
//  Copyright (c) 2015 youandme. All rights reserved.
//

#import "SigninViewController.h"
#import "MBProgressHUD.h"
#import <Parse/Parse.h>

@interface SigninViewController ()

@end

@implementation SigninViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _bgTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bgTappedAction:)];
    // Observer to update UI
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(finishSignup:)
                                                 name:@"finishSignup"
                                               object:nil];
    self.m_viewPassword.layer.cornerRadius = 3;
    self.m_viewID.layer.cornerRadius = 3;
    self.m_btnLogin.layer.cornerRadius = 3;
    self.m_btnLogin.layer.masksToBounds = YES;
    self.m_btnLogin.layer.borderWidth = 1.4;
    self.m_btnLogin.layer.borderColor = [UIColor colorWithRed:236.0/255.0 green:222.0/255.0 blue:117.0/255.0 alpha:1.0].CGColor;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - TextField Delegate
-(BOOL) textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([string isEqualToString:@""]) return YES;
    
    if (range.location == 0) {
        if ([string isEqualToString:@"0"]) return NO;
    }
    
    if(textField.text.length >= 15 && range.length == 0) {
        return NO;
        
    }
    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField*)textField
{
    NSInteger nextTag = textField.tag + 1;
    // Try to find next responder
    UIResponder* nextResponder = [textField.superview viewWithTag:nextTag];
    if (nextResponder) {
        // Found next responder, so set it.
        [nextResponder becomeFirstResponder];
    } else {
        // Not found, so remove keyboard.
        [textField resignFirstResponder];
    }
    return NO; // We do not want UITextField to insert line-breaks.
}

- (void) textFieldDidBeginEditing:(UITextField *)textField {
    [self.view addGestureRecognizer:_bgTapGesture];
}

- (void) textFieldDidEndEditing:(UITextField *)textField {
    [self.view removeGestureRecognizer:_bgTapGesture];
}

#pragma mark - Tap Gesture Recognizer Delegate
-(void)bgTappedAction:(UITapGestureRecognizer *)tap
{
    [self.m_txtID becomeFirstResponder];
    [self.m_txtID resignFirstResponder];
}

#pragma mark - Observer
- (void)finishSignup:(NSNotification *)notification {
    [self.navigationController popViewControllerAnimated:YES];
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
- (IBAction)actionLogin:(id)sender {
    if ([self checkValid]) {
        [self signinUser];
    }
}

- (IBAction)actionBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)actionLogout:(id)sender {
    [PFUser logOut];
}

#pragma mark - Common
-(BOOL) checkValid{
    if ([self.m_txtID.text isEqualToString:@""]) {
        [self showAlertWithTitle:@"" message:@"Please enter your id."];
        return NO;
    }
    
    if ([self.m_txtPassword.text isEqualToString:@""]) {
        [self showAlertWithTitle:@"" message:@"Please enter your password."];
        return NO;
    }
    
    return YES;
}

- (void)showAlertWithTitle:(NSString *)title message:(NSString *)message {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    
    [alertView show];
}

- (void)signinUser {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"Log in...";

    [PFUser logInWithUsernameInBackground:self.m_txtID.text password:self.m_txtPassword.text block:^(PFUser* user, NSError* error){
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        if (user) {
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            NSString *errorMessage = nil;
            if (!error) {
                NSLog(@"login failed.");
                errorMessage = @"Login Failed.";
            } else {
                NSLog(@"Uh oh. An error occurred: %@", error);
                errorMessage = [error localizedDescription];
            }
            [self showAlertWithTitle:@"" message:errorMessage];
        }
    }];
}

@end
