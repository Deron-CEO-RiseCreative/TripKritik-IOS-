//
//  WriteReviewViewController.m
//  TripKritik
//
//  Created by youandme on 15/07/15.
//  Copyright (c) 2015 youandme. All rights reserved.
//

#import "WriteReviewViewController.h"
#import "MBProgressHUD.h"

@interface WriteReviewViewController ()

@end

@implementation WriteReviewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.m_lblBusinessName.text = [self.m_BusinessSummary objectForKey:@"name"];
    self.m_viewRate.notSelectedImage = [UIImage imageNamed:@"icon_rate_empty.png"];
    self.m_viewRate.halfSelectedImage = [UIImage imageNamed:@"icon_rate_full.png"];
    self.m_viewRate.fullSelectedImage = [UIImage imageNamed:@"icon_rate_full.png"];
    self.m_viewRate.editable = YES;
    self.m_viewRate.maxRating = 5;
    self.m_viewRate.midMargin = 0;
    self.m_viewRate.delegate = self;
    [self fetchUsersComment];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Actions
- (IBAction)actionBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)actionSubmit:(id)sender {
    PFObject *comment;
    if (_comment) {
        [_comment setObject:self.m_txtReview.text forKey:@"review"];
        [_comment setObject:[NSNumber numberWithFloat:_rating] forKey:@"rating"];
        [_comment setObject:@"hold" forKey:@"status"];
        comment = _comment;
    } else {
        comment = [[PFObject alloc] initWithClassName:@"Comment"];
        [comment setObject:[[PFUser currentUser] username]  forKey:@"username"];
        [comment setObject:[PFUser currentUser] forKey:@"user"];
        [comment setObject:self.m_txtReview.text forKey:@"review"];
        [comment setObject:[NSNumber numberWithFloat:_rating] forKey:@"rating"];
        [comment setObject:[self.m_BusinessSummary objectForKey:@"id"] forKey:@"businessid"];
        [comment setObject:[self.m_BusinessSummary objectForKey:@"name"] forKey:@"businessname"];
        [comment setObject:@"hold" forKey:@"status"];
    }
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [comment saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        if (!error) {
            // Show success message
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            [self showAlertWithTitle:@"" message:@"Comment Save failed."];
        }
    }];
}

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
    
}

- (void)textViewDidEndEditing:(UITextView *)textView {
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - RatingView Delegate
-(void)rateView:(RateView *)rateView ratingDidChange:(float)rating {
    _rating = rating;
}

#pragma mark - Common
- (void)showAlertWithTitle:(NSString *)title message:(NSString *)message {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    
    [alertView show];
}

- (void)fetchUsersComment {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    PFQuery *query = [PFQuery queryWithClassName:@"Comment"];
    [query whereKey:@"username" equalTo:[[PFUser currentUser] username]];
    [query whereKey:@"businessid" equalTo:[self.m_BusinessSummary objectForKey:@"id"]];
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error){
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (!error) { //remove note
            _comment = object;
            self.m_txtReview.text = _comment[@"review"];
            [self.m_viewRate setRating:[_comment[@"rating"] floatValue]];
        } else if ([error.userInfo[@"error"] rangeOfString:@"No results matched the query"].location != NSNotFound) {
            //[self showAlertWithTitle:@"" message:@"Connection Error."];
        } else {
            [self showAlertWithTitle:@"" message:@"Connection Error."];
        }
    }];
}

@end
