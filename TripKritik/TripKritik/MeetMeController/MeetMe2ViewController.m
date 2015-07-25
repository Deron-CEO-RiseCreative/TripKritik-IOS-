//
//  MeetMe2ViewController.m
//  TripKritik
//
//  Created by youandme on 15/07/15.
//  Copyright (c) 2015 youandme. All rights reserved.
//

#import "MeetMe2ViewController.h"
#import "MBProgressHUD.h"

@interface MeetMe2ViewController ()

@end

@implementation MeetMe2ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initialUIAtLaunch];
    _bgTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bgTappedAction:)];
    [self fetchMyMeetMeProfile];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - TextView Delegate
-(BOOL) textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@""]) return YES;
    
    if (range.location == 0) {
        if ([text isEqualToString:@"0"]) return NO;
    }
    
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    if (textView == self.m_txtDislike) {
        [self.m_scrollView setContentOffset:CGPointMake(0, _scrollOffset) animated:YES];
    }
    [self.view addGestureRecognizer:_bgTapGesture];
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    [self.m_scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    [self.view removeGestureRecognizer:_bgTapGesture];
}

#pragma mark - Actions
- (IBAction)actionBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)actionAdd:(id)sender {
    PFUser *currentUser = [PFUser currentUser];
    [currentUser setObject:[self.m_MeetMeProfile objectForKey:@"mygender"] forKey:@"mygender"];
    [currentUser setObject:[self.m_MeetMeProfile objectForKey:@"myage"] forKey:@"myage"];
    [currentUser setObject:[self.m_MeetMeProfile objectForKey:@"mycareer"] forKey:@"mycareer"];
    [currentUser setObject:[self.m_MeetMeProfile objectForKey:@"lookinggender"] forKey:@"lookinggender"];
    [currentUser setObject:[self.m_MeetMeProfile objectForKey:@"lookingage"] forKey:@"lookingage"];
    [currentUser setObject:[self.m_MeetMeProfile objectForKey:@"lookingcareer"] forKey:@"lookingcareer"];
    [currentUser setObject:[self.m_MeetMeProfile objectForKey:@"meeting1"] forKey:@"meeting1"];
    [currentUser setObject:[self.m_MeetMeProfile objectForKey:@"meeting2"] forKey:@"meeting2"];
    [currentUser setObject:self.m_txtLike.text forKey:@"like"];
    [currentUser setObject:self.m_txtDislike.text forKey:@"dislike"];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        if (!error) {
            // Show success message
            [self.navigationController popViewControllerAnimated:YES];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"didCreateMeetMe" object:self userInfo:nil];

            [self performSegueWithIdentifier:@"segueCreatedMeetMe" sender:self];
        } else {
            [self showAlertWithTitle:@"" message:@"Comment Save failed."];
        }
    }];

}

#pragma mark - Tap Gesture Recognizer Delegate
-(void)bgTappedAction:(UITapGestureRecognizer *)tap
{
    [self.m_txtLike becomeFirstResponder];
    [self.m_txtLike resignFirstResponder];
}

#pragma mark - Common
- (void)initialUIAtLaunch {
    
    _scrollOffset = 160;
    if (self.view.frame.size.height < 568) {
        CGRect frame = self.m_scrollView.frame;
        frame.size.height = 650;
        //self.m_scrollView.contentSize = frame.size;
        _scrollOffset = 160;
    } else if (self.view.frame.size.height < 667) {
        CGRect frame = self.m_scrollView.frame;
        frame.size.height = 650;
        //self.m_scrollView.contentSize = frame.size;
        _scrollOffset = 160;
    } else if (self.view.frame.size.height < 736) {
        CGRect frame = self.m_scrollView.frame;
        frame.size.height = 680;
        //self.m_scrollView.contentSize = frame.size;
        _scrollOffset = 160;
    }
}

- (void)fetchMyMeetMeProfile {
    if ([PFUser currentUser] == nil) return;
    if ([PFUser currentUser][@"mygender"] == nil) return;
    PFUser *me = [PFUser currentUser];
    
    self.m_txtLike.text = me[@"like"];
    self.m_txtDislike.text = me[@"dislike"];
}

- (void)showAlertWithTitle:(NSString *)title message:(NSString *)message {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    
    [alertView show];
}

@end
