//
//  SearchResultCell.h
//  TripKritik
//
//  Created by youandme on 14/07/15.
//  Copyright (c) 2015 youandme. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchResultCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UIView *m_backgroundView;
@property (weak, nonatomic) IBOutlet UILabel *m_lblNumber;
@property (weak, nonatomic) IBOutlet UILabel *m_lblName;
@property (weak, nonatomic) IBOutlet UILabel *m_lblStreet;
@property (weak, nonatomic) IBOutlet UILabel *m_lblPhoneNumber;
@property (weak, nonatomic) IBOutlet UILabel *m_lblMileFrom;
@property (weak, nonatomic) IBOutlet UILabel *m_lblWebsite;

@end
