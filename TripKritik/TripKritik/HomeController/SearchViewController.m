//
//  SearchViewController.m
//  TripKritik
//
//  Created by youandme on 13/07/15.
//  Copyright (c) 2015 youandme. All rights reserved.
//

#import "SearchViewController.h"
#import "SearchResultViewController.h"
#import "MBProgressHUD.h"
#import "Define.h"

#define def_None                0
#define def_OpenFilter          1
#define def_OpenMile            2

@interface SearchViewController ()

@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initialUIAtLaunch];
    _bgTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bgTappedAction:)];
    _stateOfView = def_None;
    NSArray *filters = @[@"Restaurant", @"Bar", @"Hotel"];
    [self.m_btnSelectFilter setTitle:filters[self.m_searchType] forState:UIControlStateNormal];
    
    _appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"segueSearchResult"]) {
        SearchResultViewController *target = (SearchResultViewController *)segue.destinationViewController;
        target.m_Results = _results;
        target.m_businessType = @[@"Feed Me", @"Cheer Me", @"Bed Me"][self.m_searchType];
    }
}

#pragma mark - Actions
- (IBAction)actionBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)actionSelectFilter:(id)sender {
    if(_dropDown == nil) {
        CGFloat f = 40*3;
        _dropDown = [[NIDropDown alloc] showDropDown:sender :&f :_Filters :nil :@"down"];
        _dropDown.delegate = self;
        _stateOfView = def_OpenFilter;
        _curCombo = sender;
        //[self.view addGestureRecognizer:_bgTapGesture];
    } else if (_curCombo != nil){
        [_dropDown hideDropDown:_curCombo];
        [self rel];
    }
}

- (IBAction)actionSelectMile:(id)sender {
    if(_dropDown == nil) {
        CGFloat f = 40*3;
        _dropDown = [[NIDropDown alloc] showDropDown:sender :&f :_Miles :nil :@"down"];
        _dropDown.delegate = self;
        _stateOfView = def_OpenMile;
        _curCombo = sender;
        //[self.view addGestureRecognizer:_bgTapGesture];
    } else if (_curCombo != nil){
        [_dropDown hideDropDown:_curCombo];
        [self rel];
    }
}

- (IBAction)actionSearch:(id)sender {
    [self fetchFeedMe];
}

- (IBAction)actionGoNext:(id)sender {
    [self performSegueWithIdentifier:@"segueSearchResult" sender:self];

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
    [self.m_scrollView setContentOffset:CGPointMake(0, _scrollOffset) animated:YES];
    [self.view addGestureRecognizer:_bgTapGesture];
}

- (void) textFieldDidEndEditing:(UITextField *)textField {
    [self.m_scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    [self.view removeGestureRecognizer:_bgTapGesture];
}

#pragma mark - NIDropDownDelegate
- (void) niDropDownDelegateMethod: (NIDropDown *) sender selectedIndex:(NSIndexPath *)selectedIndex {
    
    if (_curCombo == self.m_btnSelectFilter) {
        self.m_searchType = selectedIndex.row;
    } else if (_curCombo == self.m_btnSelectMile) {
        _curIDOfMiles = selectedIndex.row;
    }
    
    [self rel];
}

-(void)rel{
    _dropDown = nil;
    [self.view removeGestureRecognizer:_bgTapGesture];
}

#pragma mark - Tap Gesture Recognizer Delegate
-(void)bgTappedAction:(UITapGestureRecognizer *)tap
{
    [_dropDown hideDropDown:_curCombo];
    [self rel];

    [self.m_txtFromLocation becomeFirstResponder];
    [self.m_txtFromLocation resignFirstResponder];
}

#pragma mark - Observer
- (void)finishFetch:(NSNotification *)notification {
    [self performSegueWithIdentifier:@"segueSearchResult" sender:self];
}

# pragma mark - Yelp API Delegate Method
-(void)loadResultWithDataDictionary:(NSDictionary *)resultDictionary {
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    _results = resultDictionary;
    [self performSegueWithIdentifier:@"segueSearchResult" sender:self];
}

- (void)failedConnection {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

#pragma mark - Common
- (void)fetchFeedMe {
    if (![self checkValid]) return;
    
    if (!_yelpService) {
        _yelpService = [[YelpAPIService alloc] init];
        _yelpService.delegate = self;
    }
    
    NSString *term = @"";
    NSString *location = self.m_txtFromLocation.text;
    double radius = _curIDOfMiles * 5;
    if (radius == 1.0) radius = 1;
    radius = radius * METES_PER_MILE;
    radius = METES_PER_MILE;
    NSString *category;
    if (self.m_searchType == 0) category = @"restaurants";
    else if (self.m_searchType == 1) category = @"hotels";
    else category = @"bars";

    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    if (![location isEqualToString:@""]) {
        [_yelpService searchNearbyBusinessesByTerm:term category:category radius:radius location:location];
    } else {
        [_yelpService searchNearbyBusinessesFromLocationByTerm:term category:category radius:radius atLatitude:_appDelegate.m_myLocation.coordinate.latitude andLongitude:_appDelegate.m_myLocation.coordinate.longitude];
    }
}

- (void)initialUIAtLaunch {
    _curIDOfMiles = 0;
    _Filters = @[@"Restaurant", @"Bar", @"Hotel"];
    _Miles = @[@"1 mile", @"5 mile", @"10 mile", @"15 mile", @"20 mile", @"25 mile"];
    
    _scrollOffset = 140;
    if (self.view.frame.size.height < 568) {
        CGRect frame = self.m_scrollView.frame;
        frame.size.height = 650;
        _scrollOffset = 240;
    } else if (self.view.frame.size.height < 667) {
        CGRect frame = self.m_scrollView.frame;
        frame.size.height = 650;
        _scrollOffset = 210;
    } else if (self.view.frame.size.height < 736) {
        CGRect frame = self.m_scrollView.frame;
        frame.size.height = 680;
        _scrollOffset = 110;
    }
    
    self.m_btnSelectFilter.layer.cornerRadius = 2;
    self.m_btnSelectMile.layer.cornerRadius = 2;
    self.m_txtFromLocation.layer.cornerRadius = 2;
}

-(BOOL) checkValid{
    if ([self.m_txtFromLocation.text isEqualToString:@""]) {
        if (_appDelegate.m_myLocation == nil) {
            [self showAlertWithTitle:@"" message:@"Sorry but not received your location information yet. Please try later!"];
            return NO;
        }
    }
    return YES;
}

- (void)showAlertWithTitle:(NSString *)title message:(NSString *)message {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    
    [alertView show];
}

@end
