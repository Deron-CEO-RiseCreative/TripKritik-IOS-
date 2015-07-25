//
//  AuditReviewsViewController.h
//  TripKritik
//
//  Created by youandme on 15/07/15.
//  Copyright (c) 2015 youandme. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "RateView.h"

@interface AuditReviewsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate> {
    NSMutableArray *_arrayReviews;
    NSIndexPath *_curIndexPath;
}


@property (weak, nonatomic) IBOutlet UILabel *m_lblBusinessName;
@property (weak, nonatomic) IBOutlet RateView *m_viewBusinessRate;
@property (weak, nonatomic) IBOutlet UITableView *m_tableView;

- (IBAction)actionBack:(id)sender;

@end
