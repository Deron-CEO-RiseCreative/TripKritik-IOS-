//
//  ContactViewController.m
//  TripKritik
//
//  Created by youandme on 18/07/15.
//  Copyright (c) 2015 youandme. All rights reserved.
//

#import "ContactViewController.h"

@interface ContactViewController ()

@end

@implementation ContactViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.m_lblName.text = self.m_possiblity[@"username"];
    self.m_lblPlace.text = self.m_possiblity[@"city"];
    NSString *strDateRange = [NSString stringWithFormat:@"%@ - %@", self.m_possiblity[@"startdate"], self.m_possiblity[@"enddate"]];
    self.m_lblDate.text = strDateRange;
    
    PFFile *file = [[self.m_possiblity objectForKey:@"user"] objectForKey:@"profilepic"];
    self.m_imgProfilePic.image = [UIImage imageNamed:@"Default-User-Photo.png"];
    if(file!=nil)
    {
        [file getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
            if (!error) {
                [self.m_imgProfilePic setImage:[UIImage imageWithData:imageData]];
            }
        }];
    }
    NSString *strlike = [NSString stringWithFormat:@"LIKES:\n\n%@\n\n\nDISLIKES:\n\n%@", self.m_possiblity[@"user"][@"like"], self.m_possiblity[@"user"][@"dislike"]];
    self.m_txtLikeDislike.text = strlike;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

@end
