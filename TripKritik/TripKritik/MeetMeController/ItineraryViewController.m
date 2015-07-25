//
//  ItineraryViewController.m
//  TripKritik
//
//  Created by youandme on 18/07/15.
//  Copyright (c) 2015 youandme. All rights reserved.
//

#import "ItineraryViewController.h"
#import "ItineraryCell.h"
#import "AddItineraryViewController.h"

@interface ItineraryViewController ()

@end

@implementation ItineraryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _curIndexPath = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [self fetchItineraries];
}

#pragma mark - Navigation
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"segueAddItinerary"]) {
        AddItineraryViewController *target = (AddItineraryViewController *)segue.destinationViewController;
        if (_curIndexPath) {
            target._itinerary = _arrayItinerary[_curIndexPath.row];
            _curIndexPath = nil;
        }
    }
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return _arrayItinerary.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ItineraryCell *cell = (ItineraryCell *)[tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    // Configure the cell...
    cell.m_lblPlaces.text = _arrayItinerary[indexPath.row][@"city"];
    NSString *strDateRange = [NSString stringWithFormat:@"Date: %@ - %@", _arrayItinerary[indexPath.row][@"startdate"], _arrayItinerary[indexPath.row][@"enddate"]];
    cell.m_lblDate.text = strDateRange;
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    _curIndexPath = indexPath;
    [self showAlertWithQuestion:@"" message:@"Would you change this Itinerary?" tag:102];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        _curIndexPath = indexPath;
        [self showAlertWithQuestion:@"" message:@"Would you delete this Itinerary?" tag:101];
        
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
}

#pragma -mark Actions
- (IBAction)actionBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)actionAdd:(id)sender {
    if ([PFUser currentUser]) {
        [self performSegueWithIdentifier:@"segueAddItinerary" sender:self];
    } else {
        [self performSegueWithIdentifier:@"segueLoginFromItinerary" sender:self];
    }
}

#pragma mark - AlertView delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 101) { // delete
        if (buttonIndex == 1) {
            [self deleteOneReview:_curIndexPath];
            _curIndexPath = nil;
        }
    } else if (alertView.tag == 102) { // accept
        if (buttonIndex == 1) {
            [self performSegueWithIdentifier:@"segueAddItinerary" sender:self];
        }
        
    }
}

#pragma mark - Common
- (void)deleteOneReview:(NSIndexPath *)indexPath {
    [CATransaction begin];
    
    [self.m_tableView beginUpdates];
    
    [CATransaction setCompletionBlock: ^{
        [self.m_tableView reloadData];
    }];
    
    PFObject *object = _arrayItinerary[indexPath.row];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [object deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [_arrayItinerary removeObjectAtIndex:indexPath.row];
        [self.m_tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }];
    
    [self.m_tableView endUpdates];
    
    [CATransaction commit];
}

- (void)showAlertWithQuestion:(NSString *)title message:(NSString *)message tag:(NSInteger)tag {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
    alertView.tag = tag;
    alertView.delegate = self;
    
    [alertView show];
}

- (void)fetchItineraries {
    if ([PFUser currentUser] == nil) {
        return;
    }
    PFQuery *query = [PFQuery queryWithClassName:@"Itinerary"];
    [query whereKey:@"username" equalTo:[[PFUser currentUser] username]];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error){
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        if (!error) { //remove note
            _arrayItinerary = [objects mutableCopy];
            [self.m_tableView reloadData];
        } else {
            [self showAlertWithTitle:@"" message:@"Connection Error."];
        }
    }];

}

- (void)showAlertWithTitle:(NSString *)title message:(NSString *)message {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    
    [alertView show];
}

@end
