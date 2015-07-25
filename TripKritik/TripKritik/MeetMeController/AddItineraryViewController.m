//
//  AddItineraryViewController.m
//  TripKritik
//
//  Created by youandme on 24/07/15.
//  Copyright (c) 2015 youandme. All rights reserved.
//

#import "AddItineraryViewController.h"

@interface AddItineraryViewController ()

@end

@implementation AddItineraryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initialUIAtLaunch];
    _bgTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bgTappedAction:)];
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

- (void) textFieldDidBeginEditing:(UITextField *)textField {
    [self.view addGestureRecognizer:_bgTapGesture];
}

- (void) textFieldDidEndEditing:(UITextField *)textField {
    [self.view removeGestureRecognizer:_bgTapGesture];
}

#pragma mark - Tap Gesture Recognizer Delegate
-(void)bgTappedAction:(UITapGestureRecognizer *)tap
{
    [self.m_txtCityState resignFirstResponder];
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
- (IBAction)actionBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)actionChangeDateSegument:(id)sender {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd/MM/yyyy"];

    if (self.m_segDate.selectedSegmentIndex == 0) {
        _isStartDate = YES;
        if (![self.m_lblStartDate.text isEqualToString:@""]) {
            NSDate *startDate = [dateFormatter dateFromString:self.m_lblStartDate.text];
            self.m_datePicker.date = startDate;
        }
    } else {
        _isStartDate = NO;
        if (![self.m_lblEndDate.text isEqualToString:@""]) {
            NSDate *endDate = [dateFormatter dateFromString:self.m_lblEndDate.text];
            self.m_datePicker.date = endDate;
        }
    }
}

- (IBAction)actionChangeDate:(id)sender {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd/MM/yyyy"];
    NSString *strDate = [dateFormatter stringFromDate:self.m_datePicker.date];
    if (_isStartDate) {
        self.m_lblStartDate.text = strDate;
    } else {
        self.m_lblEndDate.text = strDate;
    }
}

- (IBAction)actionAdd:(id)sender {
    
    if ([self checkValid]) {

        PFObject *itinerary;
        if (self._itinerary) {
            [self._itinerary setObject:self.m_txtCityState.text forKey:@"city"];
            [self._itinerary setObject:self.m_lblStartDate forKey:@"startdate"];
            [self._itinerary setObject:self.m_lblEndDate forKey:@"enddate"];
            itinerary = self._itinerary;
        } else {
            itinerary = [[PFObject alloc] initWithClassName:@"Itinerary"];
            [itinerary setObject:[[PFUser currentUser] username]  forKey:@"username"];
            [itinerary setObject:[PFUser currentUser] forKey:@"user"];
            [itinerary setObject:self.m_txtCityState.text forKey:@"city"];
            [itinerary setObject:self.m_lblStartDate.text forKey:@"startdate"];
            [itinerary setObject:self.m_lblEndDate.text forKey:@"enddate"];
        }
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [itinerary saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            if (!error) {
                // Show success message
                [self.navigationController popViewControllerAnimated:YES];
            } else {
                [self showAlertWithTitle:@"" message:@"Itinerary Save failed."];
            }
        }];

    }
}

#pragma mark - Common
- (void)initialUIAtLaunch {
    self.m_viewCityState.layer.cornerRadius = 3;
    self.m_lblStartDate.layer.cornerRadius = 3;
    self.m_lblStartDate.layer.masksToBounds = YES;
    self.m_lblEndDate.layer.cornerRadius = 3;
    self.m_lblEndDate.layer.masksToBounds = YES;
    
    _isStartDate = YES;
    [self.m_segDate setSelectedSegmentIndex:0];
    
    if (self._itinerary) {
        self.m_txtCityState.text = [self._itinerary objectForKey:@"city"];
        self.m_lblStartDate.text = [self._itinerary objectForKey:@"startdate"];
        self.m_lblEndDate.text = [self._itinerary objectForKey:@"enddate"];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"dd/MM/yyyy"];
        NSDate *startDate = [dateFormatter dateFromString:self.m_lblStartDate.text];
        self.m_datePicker.date = startDate;
        
        self.m_lblTitle.text = @"Update Itinerary";
    } else {
        NSDate *now = [NSDate date];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"dd/MM/yyyy"];
        NSString *strDate = [dateFormatter stringFromDate:self.m_datePicker.date];
        self.m_lblStartDate.text = strDate;
        self.m_lblEndDate.text = strDate;
        self.m_datePicker.date = now;
    }
    
    if (self.view.frame.size.height < 568) {
        CGRect frame = self.m_scrollView.frame;
        frame.size.height = 490;
        self.m_scrollView.contentSize = frame.size;
    }
}

- (BOOL)checkValid{
    if ([self.m_txtCityState.text isEqualToString:@""]) {
        [self showAlertWithTitle:@"" message:@"Please type city or state."];
        return NO;
    }
    if ([self.m_lblStartDate.text isEqualToString:@""]) {
        [self showAlertWithTitle:@"" message:@"Please select start date."];
        return NO;
    }
    if ([self.m_lblEndDate.text isEqualToString:@""]) {
        [self showAlertWithTitle:@"" message:@"Please select end date."];
        return NO;
    }
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd/MM/yyyy"];
    NSDate *startDate = [dateFormatter dateFromString:self.m_lblStartDate.text];
    NSDate *endDate = [dateFormatter dateFromString:self.m_lblEndDate.text];
    if ([startDate compare:endDate] == NSOrderedDescending) {
        return NO;
    }
    return YES;
}

- (void)showAlertWithTitle:(NSString *)title message:(NSString *)message {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    
    [alertView show];
}

@end
