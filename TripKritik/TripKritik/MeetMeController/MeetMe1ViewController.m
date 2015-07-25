//
//  MeetMe1ViewController.m
//  TripKritik
//
//  Created by youandme on 15/07/15.
//  Copyright (c) 2015 youandme. All rights reserved.
//

#import "MeetMe1ViewController.h"
#import <Parse/Parse.h>
#import "MeetMe2ViewController.h"

#define def_None                0
#define def_OpenMyGender        1
#define def_OpenLookingGender   2
#define def_OpenMyAge           3
#define def_OpenLookingAge      4
#define def_OpenMyCareer        5
#define def_OpenLookingCareer   6
#define def_OpenMeeting1        7
#define def_OpenMeeting2        8
#define def_OpenKeyBoard        9

@interface MeetMe1ViewController ()

@end

@implementation MeetMe1ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self initialUIAtLaunch];
    _bgTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bgTappedAction:)];
    _stateOfView = def_None;

    // Observer to created or changed MeetMe profile
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didCreateMeetMe:)
                                                 name:@"didCreateMeetMe"
                                               object:nil];
    
    [self fetchMyMeetMeProfile];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    CGRect frame = self.m_scrollView.frame;
    CGFloat oneWidth = (frame.size.width-12*3)/2;
    
    self.m_btnMyGender.layer.cornerRadius = 3;
    self.m_btnMyGender.layer.masksToBounds = YES;
    [self buttonImgAndTitleAdjust:self.m_btnMyGender andWidth:oneWidth];
    self.m_btnLookingGender.layer.cornerRadius = 3;
    self.m_btnLookingGender.layer.masksToBounds = YES;
    [self buttonImgAndTitleAdjust:self.m_btnLookingGender andWidth:oneWidth];

    CGRect lblLookingGenderF = self.m_lblLookingGender.frame;
    lblLookingGenderF.origin.x = 24+oneWidth;
    self.m_lblLookingGender.frame = lblLookingGenderF;
    CGRect btnMyGenderF = self.m_btnMyGender.frame;
    btnMyGenderF.size.width = oneWidth;
    self.m_btnMyGender.frame = btnMyGenderF;
    CGRect btnLookingGenderF = self.m_btnLookingGender.frame;
    btnLookingGenderF.origin.x = 24+oneWidth;
    btnLookingGenderF.size.width = oneWidth;
    self.m_btnLookingGender.frame = btnLookingGenderF;
    
    
    self.m_btnMyAge.layer.cornerRadius = 3;
    self.m_btnMyAge.layer.masksToBounds = YES;
    [self buttonImgAndTitleAdjust:self.m_btnMyAge andWidth:oneWidth];
    self.m_btnLookingAge.layer.cornerRadius = 3;
    self.m_btnLookingAge.layer.masksToBounds = YES;
    [self buttonImgAndTitleAdjust:self.m_btnLookingAge andWidth:oneWidth];
    
    CGRect lblLookingAgeF = self.m_lblLookingAge.frame;
    lblLookingAgeF.origin.x = 24+oneWidth;
    self.m_lblLookingAge.frame = lblLookingAgeF;
    CGRect btnMyAgeF = self.m_btnMyAge.frame;
    btnMyAgeF.size.width = oneWidth;
    self.m_btnMyAge.frame = btnMyAgeF;
    CGRect btnLookingAgeF = self.m_btnLookingAge.frame;
    btnLookingAgeF.origin.x = 24+oneWidth;
    btnLookingAgeF.size.width = oneWidth;
    self.m_btnLookingAge.frame = btnLookingAgeF;
    
    self.m_btnMyCareer.layer.cornerRadius = 3;
    self.m_btnMyCareer.layer.masksToBounds = YES;
    [self buttonImgAndTitleAdjust:self.m_btnMyCareer andWidth:oneWidth];
    self.m_btnLookingCareer.layer.cornerRadius = 3;
    self.m_btnLookingCareer.layer.masksToBounds = YES;
    [self buttonImgAndTitleAdjust:self.m_btnLookingCareer andWidth:oneWidth];
    
    CGRect lblLookingCarrerF = self.m_lblLookingCareer.frame;
    lblLookingCarrerF.origin.x = 24+oneWidth;
    self.m_lblLookingCareer.frame = lblLookingCarrerF;
    CGRect btnMyCarrerF = self.m_btnMyCareer.frame;
    btnMyCarrerF.size.width = oneWidth;
    self.m_btnMyCareer.frame = btnMyCarrerF;
    CGRect btnLookingCarrerF = self.m_btnLookingCareer.frame;
    btnLookingCarrerF.origin.x = 24+oneWidth;
    btnLookingCarrerF.size.width = oneWidth;
    self.m_btnLookingCareer.frame = btnLookingCarrerF;

    self.m_btnMeeting1.layer.cornerRadius = 3;
    self.m_btnMeeting1.layer.masksToBounds = YES;
    [self buttonImgAndTitleAdjust:self.m_btnMeeting1 andWidth:oneWidth];
    self.m_btnMeeting2.layer.cornerRadius = 3;
    self.m_btnMeeting2.layer.masksToBounds = YES;
    [self buttonImgAndTitleAdjust:self.m_btnMeeting2 andWidth:oneWidth];

    CGRect lblMeeting1F = self.m_lblMeeting2.frame;
    lblMeeting1F.origin.x = 24+oneWidth;
    self.m_lblMeeting2.frame = lblMeeting1F;
    CGRect btnMeeting1 = self.m_btnMeeting1.frame;
    btnMeeting1.size.width = oneWidth;
    self.m_btnMeeting1.frame = btnMeeting1;
    CGRect btnMeeting2 = self.m_btnMeeting2.frame;
    btnMeeting2.origin.x = 24+oneWidth;
    btnMeeting2.size.width = oneWidth;
    self.m_btnMeeting2.frame = btnMeeting2;
}

#pragma mark - Navigation
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"segueMeetMe2"]) {
        MeetMe2ViewController *target = (MeetMe2ViewController *)segue.destinationViewController;
        NSMutableDictionary *profile = [[NSMutableDictionary alloc] init];
        [profile setObject:[NSNumber numberWithInteger:_curIDOfMyGender] forKey:@"mygender"];
        [profile setObject:[NSNumber numberWithInteger:_curIDOfLookingGender] forKey:@"lookinggender"];
        [profile setObject:[NSNumber numberWithInteger:_curIDOfMyAge] forKey:@"myage"];
        [profile setObject:[NSNumber numberWithInteger:_curIDOfLookingAge] forKey:@"lookingage"];
        [profile setObject:[NSNumber numberWithInteger:_curIDOfMyCareer] forKey:@"mycareer"];
        [profile setObject:[NSNumber numberWithInteger:_curIDOfLookingCareer] forKey:@"lookingcareer"];
        [profile setObject:[NSNumber numberWithInteger:_curIDOfMeeting1] forKey:@"meeting1"];
        [profile setObject:[NSNumber numberWithInteger:_curIDOfMeeting2] forKey:@"meeting2"];
        target.m_MeetMeProfile = profile;
    }
}

#pragma mark - Actions
- (IBAction)actionBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)actionMyGender:(id)sender {
    if(_dropDown == nil) {
        CGFloat f = 40*2;
        _dropDown = [[NIDropDown alloc] showDropDown:sender :&f :_Genders :nil :@"down"];
        _dropDown.delegate = self;
        _stateOfView = def_OpenMyGender;
        _curCombo = sender;
        //[self.view addGestureRecognizer:_bgTapGesture];
    } else if (_curCombo != nil){
        [_dropDown hideDropDown:_curCombo];
        [self rel];
    }
}

- (IBAction)actionLookingGender:(id)sender {
    if(_dropDown == nil) {
        CGFloat f = 40*3;
        _dropDown = [[NIDropDown alloc] showDropDown:sender :&f :_LookingGenders :nil :@"down"];
        _dropDown.delegate = self;
        _stateOfView = def_OpenLookingGender;
        _curCombo = sender;
        //[self.view addGestureRecognizer:_bgTapGesture];
    } else if (_curCombo != nil){
        [_dropDown hideDropDown:_curCombo];
        [self rel];
    }
}

- (IBAction)actionMyAge:(id)sender {
    if(_dropDown == nil) {
        CGFloat f = 40*3;
        _dropDown = [[NIDropDown alloc] showDropDown:sender :&f :_Ages :nil :@"down"];
        _dropDown.delegate = self;
        _stateOfView = def_OpenMyAge;
        _curCombo = sender;
        //[self.view addGestureRecognizer:_bgTapGesture];
    } else if (_curCombo != nil){
        [_dropDown hideDropDown:_curCombo];
        [self rel];
    }
}

- (IBAction)actionLookingAge:(id)sender {
    if(_dropDown == nil) {
        CGFloat f = 40*3;
        _dropDown = [[NIDropDown alloc] showDropDown:sender :&f :_Ages :nil :@"down"];
        _dropDown.delegate = self;
        _stateOfView = def_OpenLookingAge;
        _curCombo = sender;
        //[self.view addGestureRecognizer:_bgTapGesture];
    } else if (_curCombo != nil){
        [_dropDown hideDropDown:_curCombo];
        [self rel];
    }
}

- (IBAction)actionMyCareer:(id)sender {
    if(_dropDown == nil) {
        CGFloat f = 40*3;
        _dropDown = [[NIDropDown alloc] showDropDown:sender :&f :_Careers :nil :@"down"];
        _dropDown.delegate = self;
        _stateOfView = def_OpenMyCareer;
        _curCombo = sender;
        //[self.view addGestureRecognizer:_bgTapGesture];
    } else if (_curCombo != nil){
        [_dropDown hideDropDown:_curCombo];
        [self rel];
    }
}

- (IBAction)actionLookingCareer:(id)sender {
    if(_dropDown == nil) {
        CGFloat f = 40*3;
        _dropDown = [[NIDropDown alloc] showDropDown:sender :&f :_Careers :nil :@"down"];
        _dropDown.delegate = self;
        _stateOfView = def_OpenLookingCareer;
        _curCombo = sender;
        //[self.view addGestureRecognizer:_bgTapGesture];
    } else if (_curCombo != nil){
        [_dropDown hideDropDown:_curCombo];
        [self rel];
    }
}

- (IBAction)actionMeeting1:(id)sender {
    if(_dropDown == nil) {
        CGFloat f = 40*3;
        _dropDown = [[NIDropDown alloc] showDropDown:sender :&f :_Meeting1s :nil :@"down"];
        _dropDown.delegate = self;
        _stateOfView = def_OpenMeeting1;
        _curCombo = sender;
        //[self.view addGestureRecognizer:_bgTapGesture];
    } else if (_curCombo != nil){
        [_dropDown hideDropDown:_curCombo];
        [self rel];
    }
}

- (IBAction)actionMeeting2:(id)sender {
    if(_dropDown == nil) {
        CGFloat f = 40*3;
        _dropDown = [[NIDropDown alloc] showDropDown:sender :&f :_Meeting2s :nil :@"down"];
        _dropDown.delegate = self;
        _stateOfView = def_OpenMeeting2;
        _curCombo = sender;
        //[self.view addGestureRecognizer:_bgTapGesture];
    } else if (_curCombo != nil){
        [_dropDown hideDropDown:_curCombo];
        [self rel];
    }
}

- (IBAction)actionContinue:(id)sender {
    if (![self checkValid]) {
        return;
    }
    if ([PFUser currentUser]) {
        [self performSegueWithIdentifier:@"segueMeetMe2" sender:self];
    } else
        [self performSegueWithIdentifier:@"segueSigninFromMeet" sender:self];
}

#pragma mark - NIDropDownDelegate
- (void) niDropDownDelegateMethod: (NIDropDown *) sender selectedIndex:(NSIndexPath *)selectedIndex {
    
    if (_curCombo == self.m_btnMyGender) {
        _curIDOfMyGender = selectedIndex.row;
        
    } else if (_curCombo == self.m_btnLookingGender) {
        _curIDOfLookingGender = selectedIndex.row;
        
    } else if (_curCombo == self.m_btnMyAge) {
        _curIDOfMyAge = selectedIndex.row;
        
    } else if (_curCombo == self.m_btnLookingAge) {
        _curIDOfLookingAge = selectedIndex.row;
        
    } else if (_curCombo == self.m_btnMyCareer) {
        _curIDOfMyCareer = selectedIndex.row;
        
    } else if (_curCombo == self.m_btnLookingCareer) {
        _curIDOfLookingCareer = selectedIndex.row;
        
    } else if (_curCombo == self.m_btnMeeting1) {
        _curIDOfMeeting1 = selectedIndex.row;
        
    } else if (_curCombo == self.m_btnMeeting2) {
        _curIDOfMeeting2 = selectedIndex.row;
        
    }
    
    [self rel];
}

-(void)rel{
    _dropDown = nil;
    [self.view removeGestureRecognizer:_bgTapGesture];
    //self.m_backgroundView.userInteractionEnabled = NO;
}

#pragma mark - Tap Gesture Recognizer Delegate
-(void)bgTappedAction:(UITapGestureRecognizer *)tap {
    [_dropDown hideDropDown:_curCombo];
    [self rel];
    [self.view removeGestureRecognizer:_bgTapGesture];
}

#pragma mark - Observer
- (void)didCreateMeetMe:(NSNotification *)notification {
    [self.navigationController popViewControllerAnimated:NO];
}

#pragma mark - Common
- (void)initialUIAtLaunch {
    _curIDOfMyGender = -1;
    _curIDOfLookingGender = -1;
    _curIDOfMyAge = -1;
    _curIDOfLookingAge = -1;
    _curIDOfMyCareer = -1;
    _curIDOfLookingCareer = -1;
    _curIDOfMeeting1 = -1;
    _curIDOfMeeting2 = -1;

    _Genders = @[@"male", @"female"];
    _LookingGenders = @[@"male", @"female", @"either"];
    _Ages = @[@"18-23", @"24-29", @"30-45", @"45-60", @"60+"];
    _Meeting1s = @[@"Dinner", @"Drinks", @"either"];
    _Meeting2s = @[@"Casual conversation", @"Date", @"either"];
    _Careers = @[@"Accounting", @"Admin & Clerical", @"Automotive", @"Banking", @"Biotech", @"Broadcast - Journalism", @"Business Development", @"Construction", @"Consultant", @"Customer Service", @"Design", @"Distribution - Shipping", @"Education - Teaching", @"Engineering", @"Entry Level - New Grad", @"Executive", @"Facilities", @"Finance", @"Franchise", @"General Business", @"General Labor", @"Government", @"Grocery", @"Health Care", @"Hotel - Hospitality", @"Human Resources", @"Information Technology", @"Installation - Maint - Repair", @"Insurance", @"Inventory", @"Legal", @"Legal Admin", @"Management", @"Manufacturing", @"Marketing", @"Media - Journalism - Newspaper", @"Nonprofit - Social Services", @"Nurse", @"Other", @"Pharmaceutical", @"Professional Services", @"Purchasing - Procurement", @"QA - Quality Control", @"Real Estate", @"Research", @"Restaurant - Food Service", @"Retail", @"Sales", @"Science", @"Skilled Labor - Trades", @"Strategy - Planning", @"Supply Chain", @"Telecommunications", @"Training", @"Transportation", @"Warehouse"];

    if (self.view.frame.size.height < 568) {
        CGRect frame = self.m_scrollView.frame;
        frame.size.height = 620;
        self.m_scrollView.contentSize = frame.size;
    } else if (self.view.frame.size.height < 667) {
        CGRect frame = self.m_scrollView.frame;
        frame.size.height = 620;
        self.m_scrollView.contentSize = frame.size;
    } else if (self.view.frame.size.height < 736) {
        CGRect frame = self.m_scrollView.frame;
        frame.size.height = 620;
        self.m_scrollView.contentSize = frame.size;
    }
}

- (void)fetchMyMeetMeProfile {
    if ([PFUser currentUser] == nil) return;
    if ([PFUser currentUser][@"mygender"] == nil) return;
    PFUser *me = [PFUser currentUser];

    _curIDOfMyGender = [me[@"mygender"] intValue];
    [self.m_btnMyGender setTitle:_Genders[_curIDOfMyGender] forState:UIControlStateNormal];
    _curIDOfLookingGender = [me[@"lookinggender"] intValue];
    [self.m_btnLookingGender setTitle:_LookingGenders[_curIDOfLookingGender] forState:UIControlStateNormal];
    _curIDOfMyAge = [me[@"myage"] intValue];
    [self.m_btnMyAge setTitle:_Ages[_curIDOfMyAge] forState:UIControlStateNormal];
    _curIDOfLookingAge = [me[@"lookingage"] intValue];
    [self.m_btnLookingAge setTitle:_Ages[_curIDOfLookingAge] forState:UIControlStateNormal];
    _curIDOfMyCareer = [me[@"mycareer"] intValue];
    [self.m_btnMyCareer setTitle:_Careers[_curIDOfMyCareer] forState:UIControlStateNormal];
    _curIDOfLookingCareer = [me[@"lookingcareer"] intValue];
    [self.m_btnLookingCareer setTitle:_Careers[_curIDOfLookingCareer] forState:UIControlStateNormal];
    _curIDOfMeeting1 = [me[@"meeting1"] intValue];
    [self.m_btnMeeting1 setTitle:_Meeting1s[_curIDOfMeeting1] forState:UIControlStateNormal];
    _curIDOfMeeting2 = [me[@"meeting2"] intValue];
    [self.m_btnMeeting2 setTitle:_Meeting2s[_curIDOfMeeting2] forState:UIControlStateNormal];
}

- (void)buttonImgAndTitleAdjust:(UIButton *)button andWidth:(CGFloat)width{
    button.imageEdgeInsets = UIEdgeInsetsMake(14, width-10-14, 14, 10);
    button.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 20);
}

- (BOOL)checkValid{
    if (_curIDOfMyGender == -1) {
        [self showAlertWithTitle:@"" message:@"Please select your gender."];
        return NO;
    }
    if (_curIDOfLookingGender == -1) {
        [self showAlertWithTitle:@"" message:@"Please select looking gender."];
        return NO;
    }
    if (_curIDOfMyAge == -1) {
        [self showAlertWithTitle:@"" message:@"Please select your age."];
        return NO;
    }
    if (_curIDOfLookingAge == -1) {
        [self showAlertWithTitle:@"" message:@"Please select looking age."];
        return NO;
    }
    if (_curIDOfMyCareer == -1) {
        [self showAlertWithTitle:@"" message:@"Please select your career."];
        return NO;
    }
    if (_curIDOfLookingCareer == -1) {
        [self showAlertWithTitle:@"" message:@"Please select your career."];
        return NO;
    }
    if (_curIDOfMeeting1 == -1) {
        [self showAlertWithTitle:@"" message:@"Please select your meeting1."];
        return NO;
    }
    if (_curIDOfMeeting2 == -1) {
        [self showAlertWithTitle:@"" message:@"Please select your meeting2."];
        return NO;
    }
    
    return YES;
}

- (void)showAlertWithTitle:(NSString *)title message:(NSString *)message {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    
    [alertView show];
}

@end
