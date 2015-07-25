//
//  ItineraryCell.h
//  TripKritik
//
//  Created by youandme on 23/07/15.
//  Copyright (c) 2015 youandme. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ItineraryCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *m_backgroundView;
@property (weak, nonatomic) IBOutlet UIView *m_TitleView;
@property (weak, nonatomic) IBOutlet UILabel *m_lblPlaces;
@property (weak, nonatomic) IBOutlet UILabel *m_lblDate;
@end
