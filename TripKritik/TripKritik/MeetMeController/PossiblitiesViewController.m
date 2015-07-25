//
//  PossiblitiesViewController.m
//  TripKritik
//
//  Created by youandme on 18/07/15.
//  Copyright (c) 2015 youandme. All rights reserved.
//

#import "PossiblitiesViewController.h"
#import "PossibilitiesCell.h"
#import "UIImageView+AFNetworking.h"
#import "ContactViewController.h"

@interface PossiblitiesViewController ()

@end

@implementation PossiblitiesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self fetchPossibilities];
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
    if ([segue.identifier isEqualToString:@"segueContact"]) {
        ContactViewController *target = (ContactViewController *)segue.destinationViewController;
        target.m_possiblity = (PFObject *)_arrayPossibilities[_curIndexPath.row];
    }
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return _arrayPossibilities.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PossibilitiesCell *cell = (PossibilitiesCell *)[tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    // Configure the cell...
    cell.m_lblName.text = _arrayPossibilities[indexPath.row][@"username"];
    cell.m_lblPlace.text = _arrayPossibilities[indexPath.row][@"city"];
    NSString *strDateRange = [NSString stringWithFormat:@"%@ - %@", _arrayPossibilities[indexPath.row][@"startdate"], _arrayPossibilities[indexPath.row][@"enddate"]];
    cell.m_lblDate.text = strDateRange;
    
    PFFile *file = [[_arrayPossibilities[indexPath.row] objectForKey:@"user"] objectForKey:@"profilepic"];
    cell.m_imgProfilePic.image = [UIImage imageNamed:@"Default-User-Photo.png"];
    if(file!=nil)
    {
        [file getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
            if (!error) {
                [cell.m_imgProfilePic setImage:[UIImage imageWithData:imageData]];
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
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self performSegueWithIdentifier:@"segueContact" sender:self];
}

#pragma mark - Actions
- (IBAction)actionBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Commmon
- (void)fetchPossibilities {
    if (![PFUser currentUser]) return;
    if (![PFUser currentUser][@"mygender"]) return;

    PFQuery *query = [PFQuery queryWithClassName:@"Itinerary"];
    [query whereKey:@"username" equalTo:[[PFUser currentUser] username]];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error){
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        if (!error) { //remove note
            NSMutableArray *myItinerary = [objects mutableCopy];
            [self findPosibilities1stStep:myItinerary];
        } else {
            [self showAlertWithTitle:@"" message:@"Connection Error."];
        }
    }];
    
}

- (void)findPosibilities1stStep:(NSArray *)myItineraries {
    PFUser *user = [PFUser currentUser];

    PFQuery *nonBlockedUserInnerQuery = [PFUser query];
    if ([user[@"lookinggender"] intValue] == 2) {
        [nonBlockedUserInnerQuery whereKey:@"mygender" equalTo:[NSNumber numberWithInt:0]];
        [nonBlockedUserInnerQuery whereKey:@"mygender" equalTo:[NSNumber numberWithInt:1]];
    } else {
        [nonBlockedUserInnerQuery whereKey:@"mygender" equalTo:user[@"lookinggender"]];
    }
    [nonBlockedUserInnerQuery whereKey:@"myage" equalTo:user[@"lookingage"]];
    [nonBlockedUserInnerQuery whereKey:@"mycareer" equalTo:user[@"lookingcareer"]];
    [nonBlockedUserInnerQuery whereKey:@"meeting1" equalTo:user[@"meeting1"]];
    [nonBlockedUserInnerQuery whereKey:@"meeting2" equalTo:user[@"meeting2"]];

    PFQuery *query = [PFQuery queryWithClassName:@"Itinerary"];
    [query whereKey:@"user" matchesQuery:nonBlockedUserInnerQuery];
    [query whereKey:@"username" notEqualTo:[[PFUser currentUser] username]];
    [query includeKey:@"user"];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error){
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        if (!error) { //remove note
            NSMutableArray *otherItineraries = [objects mutableCopy];
            [self findPosibilities2ndStep:myItineraries otherItineraries:otherItineraries];
        } else {
            [self showAlertWithTitle:@"" message:@"Connection Error."];
        }
    }];
}

- (void)findPosibilities2ndStep:(NSArray *)myItineraries otherItineraries:(NSArray *)otherItineraries {
    _arrayPossibilities = [[NSMutableArray alloc] init];
    for (PFObject *myItinerary in myItineraries) {
        
        for (PFObject *otherItinerary in otherItineraries) {
            if ([myItinerary[@"city"] caseInsensitiveCompare:otherItinerary[@"city"]] == NSOrderedSame) {
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                [dateFormatter setDateFormat:@"dd/MM/yyyy"];
                NSDate *mystartDate = [dateFormatter dateFromString:myItinerary[@"startdate"]];
                NSDate *myendDate = [dateFormatter dateFromString:myItinerary[@"enddate"]];
                NSDate *otherstartDate = [dateFormatter dateFromString:otherItinerary[@"startdate"]];
                NSDate *otherendDate = [dateFormatter dateFromString:otherItinerary[@"enddate"]];

                if ([self isBetweenDate:otherstartDate beginDate:mystartDate andDate:myendDate] &&
                    ![self checkDuplicated:otherItinerary]) {
                    [_arrayPossibilities addObject:otherItinerary];
                } else if ([self isBetweenDate:otherendDate beginDate:mystartDate andDate:myendDate] &&
                           ![self checkDuplicated:otherItinerary]) {
                    [_arrayPossibilities addObject:otherItinerary];
                } else if ([self isBetweenDate:mystartDate beginDate:otherstartDate andDate:otherendDate] &&
                           ![self checkDuplicated:otherItinerary]) {
                    [_arrayPossibilities addObject:otherItinerary];
                } else if ([self isBetweenDate:myendDate beginDate:otherstartDate andDate:otherendDate] &&
                           ![self checkDuplicated:otherItinerary]) {
                    [_arrayPossibilities addObject:otherItinerary];
                }
            }
        }
    }
    [self.m_tableView reloadData];
}

- (BOOL)isBetweenDate:(NSDate*)date beginDate:(NSDate*)beginDate andDate:(NSDate*)endDate
{
    if ([date compare:beginDate] == NSOrderedAscending)
        return NO;
    
    if ([date compare:endDate] == NSOrderedDescending)
        return NO;
    
    return YES;
}

- (BOOL)checkDuplicated:(PFObject *)Itinerary {
    for (PFObject *item in _arrayPossibilities) {
        if ([item[@"username"] isEqualToString:[PFUser currentUser][@"username"]]) {
            //return YES;
            //break;
        } else if ([item[@"username"] isEqualToString:Itinerary[@"username"]] &&
            [item[@"startdate"] isEqualToString:Itinerary[@"startdate"]] &&
            [item[@"enddate"] isEqualToString:Itinerary[@"enddate"]]) {
            return YES;
            break;
        }
    }
    return NO;
}

- (void)showAlertWithTitle:(NSString *)title message:(NSString *)message {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    
    [alertView show];
}

@end
