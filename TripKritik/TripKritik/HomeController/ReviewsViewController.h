//
//  ReviewsViewController.h
//  TripKritik
//
//  Created by youandme on 14/07/15.
//  Copyright (c) 2015 youandme. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YelpAPIService.h"
#import "TFHpple.h"
#import "RateView.h"

@interface ReviewsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, YelpAPIServiceDelegate> {
    NSMutableArray *_arrayReviews;
    NSMutableArray *_arrayReviewsOfApp;
    NSDictionary *_businessDetailDic;
    YelpAPIService *_yelpService;
    
    int _loadingCount;
}

@property (strong, nonatomic) NSDictionary *m_BusinessSummary;

@property (weak, nonatomic) IBOutlet UILabel *m_lblBusinessName;
@property (weak, nonatomic) IBOutlet RateView *m_viewBusinessRate;
@property (weak, nonatomic) IBOutlet UITableView *m_tableView;
@property (weak, nonatomic) IBOutlet UIButton *m_btnWriteReview;

- (IBAction)actionBack:(id)sender;
- (IBAction)actionWriteReview:(id)sender;

@end
