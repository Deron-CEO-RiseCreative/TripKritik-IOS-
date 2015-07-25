//
//  AuditReviewsViewController.m
//  TripKritik
//
//  Created by youandme on 15/07/15.
//  Copyright (c) 2015 youandme. All rights reserved.
//

#import "AuditReviewsViewController.h"
#import "MBProgressHUD.h"
#import <Parse/Parse.h>
#import "ReviewCell.h"
#import "UIImageView+AFNetworking.h"
#import <ParseUI/ParseUI.h>

@interface AuditReviewsViewController ()

@end

@implementation AuditReviewsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self fetchReviewsForAllUsers];
    //self.m_lblBusinessName.text = [self.m_BusinessSummary objectForKey:@"name"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return _arrayReviews.count;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 40)];
    headerview.backgroundColor = [UIColor clearColor];
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, CGRectGetWidth(self.view.frame)-20, 40)];
    title.backgroundColor = [UIColor clearColor];
    title.textColor = [UIColor yellowColor];
    title.text = _arrayReviews[section][0][@"businessname"];
    [headerview addSubview:title];
    
    return headerview;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [_arrayReviews[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ReviewCell *cell = (ReviewCell *)[tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    // Configure the cell...
    NSString *path;
    cell.m_txtReview.text = [_arrayReviews[indexPath.section][indexPath.row] objectForKey:@"review"];
    float rate = [[_arrayReviews[indexPath.section][indexPath.row] objectForKey:@"rating"] floatValue];
    [cell setupUserRate:rate];
    PFFile *file = [[_arrayReviews[indexPath.section][indexPath.row] objectForKey:@"user"] objectForKey:@"profilepic"];
    path = file.url;
    
    cell.m_imgUserProfile.image = [UIImage imageNamed:@"Default-User-Photo.png"];
    if(file!=nil)
    {
        [file getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
            if (!error) {
                [cell.m_imgUserProfile setImage:[UIImage imageWithData:imageData]];
            }
        }];
    }
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    _curIndexPath = indexPath;
    [self showAlertWithQuestion:@"" message:@"Would you accept this review?" tag:102];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        _curIndexPath = indexPath;
        [self showAlertWithQuestion:@"" message:@"Would you delete this review?" tag:101];
        
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
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

#pragma mark - AlertView delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 101) { // delete
        if (buttonIndex == 1) {
            [self deleteOneReview:_curIndexPath];
        }
    } else if (alertView.tag == 102) { // accept
        if (buttonIndex == 1) {
            [self acceptOneReview:_curIndexPath];
        }

    }
}

#pragma mark - Common
- (void)fetchReviewsForAllUsers {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    PFQuery *query = [PFQuery queryWithClassName:@"Comment"];
    [query whereKey:@"status" equalTo:@"hold"];
    [query orderByAscending:@"businessid"];
    [query includeKey:@"user"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error){
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (!error) { //remove note
            NSString *businessid = objects[0][@"businessid"];
            _arrayReviews = [[NSMutableArray alloc] init];
            NSMutableArray *array;
            array = [[NSMutableArray alloc] init];
            for (PFObject *object in objects) {
                if ([businessid isEqualToString:object[@"businessid"]]) {
                    [array addObject:object];
                } else {
                    [_arrayReviews addObject:array];
                    businessid = object[@"businessid"];
                    array = [[NSMutableArray alloc] init];
                    [array addObject:object];
                }
            }
            if (array) {
                [_arrayReviews addObject:array];
            }
            [self.m_tableView reloadData];
        } else {
            [self showAlertWithTitle:@"" message:@"Connection Error."];
        }
    }];
}

- (void)deleteOneReview:(NSIndexPath *)indexPath {
    [CATransaction begin];
    
    [self.m_tableView beginUpdates];
    
    [CATransaction setCompletionBlock: ^{
        [self.m_tableView reloadData];
    }];
    
    PFObject *object = _arrayReviews[indexPath.section][indexPath.row];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [object deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [_arrayReviews[indexPath.section] removeObjectAtIndex:indexPath.row];
        [self.m_tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }];
    
    [self.m_tableView endUpdates];
    
    [CATransaction commit];
}

- (void)acceptOneReview:(NSIndexPath *)indexPath {
    [CATransaction begin];
    
    [self.m_tableView beginUpdates];
    
    [CATransaction setCompletionBlock: ^{
        [self.m_tableView reloadData];
    }];
    
    PFObject *object = _arrayReviews[indexPath.section][indexPath.row];
    object[@"status"] = @"live";
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [object saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [_arrayReviews[indexPath.section] removeObjectAtIndex:indexPath.row];
        [self.m_tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }];

    [self.m_tableView endUpdates];
    
    [CATransaction commit];
}

- (void)showAlertWithTitle:(NSString *)title message:(NSString *)message {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    
    [alertView show];
}

- (void)showAlertWithQuestion:(NSString *)title message:(NSString *)message tag:(NSInteger)tag {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
    alertView.tag = tag;
    alertView.delegate = self;
    
    [alertView show];
}

@end
