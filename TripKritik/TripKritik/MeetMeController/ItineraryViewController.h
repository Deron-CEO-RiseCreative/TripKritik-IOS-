//
//  ItineraryViewController.h
//  TripKritik
//
//  Created by youandme on 18/07/15.
//  Copyright (c) 2015 youandme. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "MBProgressHUD.h"

@interface ItineraryViewController : UIViewController <UITableViewDataSource, UITableViewDelegate> {
    NSIndexPath *_curIndexPath;
    NSMutableArray *_arrayItinerary;
}


@property (weak, nonatomic) IBOutlet UITableView *m_tableView;
@property (weak, nonatomic) IBOutlet UIButton *m_btnAdd;

- (IBAction)actionBack:(id)sender;
- (IBAction)actionAdd:(id)sender;

@end
