//
//  SearchViewController.h
//  TripKritik
//
//  Created by youandme on 13/07/15.
//  Copyright (c) 2015 youandme. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NIDropDown.h"
#import "YelpAPIService.h"
#import "AppDelegate.h"

@interface SearchViewController : UIViewController <UIScrollViewDelegate, UITextFieldDelegate, NIDropDownDelegate, YelpAPIServiceDelegate> {
    NIDropDown *_dropDown;
    UITapGestureRecognizer *_bgTapGesture;

    NSInteger _curIDOfFilter;
    NSArray *_Filters;
    NSInteger _curIDOfMiles;
    NSArray *_Miles;

    UIButton *_curCombo;
    int _stateOfView;
    UIEdgeInsets _contentInsets;
    int _scrollOffset;

    YelpAPIService *_yelpService;
    NSDictionary *_results;
    
    AppDelegate *_appDelegate;
}

@property (nonatomic, assign) NSInteger m_searchType;

@property (weak, nonatomic) IBOutlet UIScrollView *m_scrollView;
@property (weak, nonatomic) IBOutlet UIButton *m_btnSelectFilter;
@property (weak, nonatomic) IBOutlet UIButton *m_btnSelectMile;
@property (weak, nonatomic) IBOutlet UITextField *m_txtMilesFrom;
@property (weak, nonatomic) IBOutlet UITextField *m_txtFromLocation;

- (IBAction)actionBack:(id)sender;
- (IBAction)actionSelectFilter:(id)sender;
- (IBAction)actionSelectMile:(id)sender;
- (IBAction)actionSearch:(id)sender;
- (IBAction)actionGoNext:(id)sender;

@end
