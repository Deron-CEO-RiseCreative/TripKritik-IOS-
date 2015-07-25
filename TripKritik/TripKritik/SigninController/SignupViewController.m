//
//  SignupViewController.m
//  TripKritik
//
//  Created by youandme on 14/07/15.
//  Copyright (c) 2015 youandme. All rights reserved.
//

#import "SignupViewController.h"
#import "MBProgressHUD.h"
#import <Parse/Parse.h>

@interface SignupViewController ()

@end

@implementation SignupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    _bgTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bgTappedAction:)];
    [self initialUIAtLaunch];
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
    if (textField == self.m_txtDisplayName) {
        //[self.m_scrollView setContentOffset:CGPointMake(0, _scrollOffset) animated:YES];
    }
    [self.view addGestureRecognizer:_bgTapGesture];
}

- (void) textFieldDidEndEditing:(UITextField *)textField {
    [self.m_scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    [self.view removeGestureRecognizer:_bgTapGesture];
}

#pragma mark - Tap Gesture Recognizer Delegate
-(void)bgTappedAction:(UITapGestureRecognizer *)tap
{
    [self.m_txtID becomeFirstResponder];
    [self.m_txtID resignFirstResponder];
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
- (IBAction)actionImagePick:(id)sender {
    UIActionSheet *picActionSheet = [[UIActionSheet alloc] init];
    picActionSheet.delegate = self;
    [picActionSheet addButtonWithTitle:@"Take a Photo"];
    [picActionSheet addButtonWithTitle:@"Select from gallery"];
    [picActionSheet addButtonWithTitle:@"Cancel"];
    picActionSheet.cancelButtonIndex = 2;

    [picActionSheet showInView:self.view];
}

- (IBAction)actionSubmit:(id)sender {
    if ([self checkValid]) {
        [self signupUser];
    }
}

- (IBAction)actionBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - ActionSheetDelegate
-(void)actionSheet:(UIActionSheet*)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    UIImagePickerControllerSourceType   sourceType = 0;
    switch (buttonIndex) {
        case 0:
            sourceType = UIImagePickerControllerSourceTypeCamera;
            break;
        case 1:
            sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            break;
    }
    
    if (buttonIndex==2)
        return;
    
    if (![UIImagePickerController isSourceTypeAvailable:sourceType]) {
        [self showAlertWithTitle:@"Error" message:@"Cannot use source type!"];
        return;
    }
    
    UIImagePickerController *imagePicker;
    imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.sourceType = sourceType;
    imagePicker.allowsEditing = YES;
    imagePicker.delegate = self;
    
    [self presentViewController:imagePicker animated:YES completion:nil];
}

#pragma mark- UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController*)picker
        didFinishPickingImage:(UIImage*)image
                  editingInfo:(NSDictionary*)editingInfo
{
    
    UIImage *profileImage = [self crop:image size:CGSizeMake(60.0f, 60.0f)];
    self.m_imgProfile.image = profileImage;
    _profilePicData = UIImagePNGRepresentation(profileImage);
    
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController*)picker
{
    
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
    
}

- (UIImage *)crop:(UIImage *)largeImage size:(CGSize)size{
    
    CGRect cropRect = CGRectZero;
    
    if (largeImage.size.width > largeImage.size.height) {
        cropRect.size.height = largeImage.size.height;
        cropRect.size.width = size.width*largeImage.size.height/size.height;
        cropRect.origin.x = (largeImage.size.width-cropRect.size.width) / 2.0f;
        cropRect.origin.y = 0.0f;
    }else{
        cropRect.size.width = largeImage.size.width;
        cropRect.size.height = size.height*largeImage.size.width/size.width;
        cropRect.origin.x = 0.0f;
        cropRect.origin.y = 0.0f;
    }
    
    CGImageRef imageRef = CGImageCreateWithImageInRect([largeImage CGImage], cropRect);
    UIImage *resultImage = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    
    return resultImage;
}


#pragma mark - Common
- (void)initialUIAtLaunch {
    
    _scrollOffset = 140;
    if (self.view.frame.size.height < 568) {
        CGRect frame = self.m_scrollView.frame;
        frame.size.height = 650;
        self.m_scrollView.contentSize = frame.size;
        _scrollOffset = 240;
    } else if (self.view.frame.size.height < 667) {
        CGRect frame = self.m_scrollView.frame;
        frame.size.height = 650;
        self.m_scrollView.contentSize = frame.size;
        _scrollOffset = 210;
    } else if (self.view.frame.size.height < 736) {
        CGRect frame = self.m_scrollView.frame;
        frame.size.height = 680;
        self.m_scrollView.contentSize = frame.size;
        _scrollOffset = 210;
    }
    self.m_imgProfile.layer.borderWidth = 1.0;
    self.m_imgProfile.layer.borderColor = [UIColor colorWithWhite:0.5 alpha:1.0].CGColor;
    
    PFUser *user = [PFUser currentUser];
    if(user)
    {
        self.m_txtID.text = user.username;
        self.m_txtDisplayName.text = user[@"displayname"];
        PFFile *ProfilePicFile = user[@"profilepic"];
        [self.m_imgProfile setImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:ProfilePicFile.url]]]];
    }
    self.m_viewID.layer.cornerRadius = 3;
    self.m_viewPassword.layer.cornerRadius = 3;
    self.m_viewConfirmPassword.layer.cornerRadius = 3;
    self.m_viewDisplayName.layer.cornerRadius = 3;
    self.m_imgProfile.layer.borderWidth = 1.0;
    self.m_imgProfile.layer.borderColor = [UIColor whiteColor].CGColor;
}

-(BOOL) checkValid{
    if ([self.m_txtID.text isEqualToString:@""]) {
        [self showAlertWithTitle:@"" message:@"Please enter your id."];
        return NO;
    }
    
    if ([self.m_txtPassword.text isEqualToString:@""]) {
        [self showAlertWithTitle:@"" message:@"Please enter your password."];
        return NO;
    }
    
    if ([self.m_txtPassword.text length] < 6) {
        [self showAlertWithTitle:@"" message:@"Your password is too easy to guess."];
        return NO;
    }

    if ([self.m_txtConfirmPassword.text isEqualToString:@""]) {
        [self showAlertWithTitle:@"" message:@"Please enter your password again for confirm."];
        return NO;
    }
    
    if (![self.m_txtConfirmPassword.text isEqualToString:self.m_txtPassword.text]) {
        [self showAlertWithTitle:@"" message:@"Please check your password."];
        return NO;
    }

    if ([self.m_txtDisplayName.text isEqualToString:@""]) {
        [self showAlertWithTitle:@"" message:@"Please enter your full name."];
        return NO;
    }

    return YES;
}

- (void)showAlertWithTitle:(NSString *)title message:(NSString *)message {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    
    [alertView show];
}

- (void)signupUser {
    PFUser *user = [PFUser user];
    user.username = self.m_txtID.text;
    user[@"displayname"] = self.m_txtDisplayName.text;
    user[@"admin"] = @"no";
    user.password = self.m_txtPassword.text;
    PFFile *profilepic = [PFFile fileWithName:@"profilepic.png" data:_profilePicData];
    
    //show progress hud
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"Submiting...";
    [profilepic saveInBackground];
    user[@"profilepic"] = profilepic;
    [profilepic saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!succeeded) {
            [self showAlertWithTitle:@"error!" message:@"failed submit."];
            return;
        }
        user[@"profilepic"] = profilepic;
        if (!error) {
        } else {
            [self showAlertWithTitle:@"error!" message:@"failed submit."];
        }
    }];
}

@end
