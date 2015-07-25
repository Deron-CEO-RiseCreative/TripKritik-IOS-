//
//  PossiblitiesViewController.h
//  TripKritik
//
//  Created by youandme on 18/07/15.
//  Copyright (c) 2015 youandme. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "MBProgressHUD.h"

@interface PossiblitiesViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
    NSMutableArray *_arrayPossibilities;
    NSIndexPath *_curIndexPath;
}

@property (weak, nonatomic) IBOutlet UITableView *m_tableView;

- (IBAction)actionBack:(id)sender;
@end
