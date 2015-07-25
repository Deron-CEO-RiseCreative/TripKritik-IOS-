//
//  PossibilitiesCell.h
//  TripKritik
//
//  Created by youandme on 23/07/15.
//  Copyright (c) 2015 youandme. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PossibilitiesCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *m_backgroundView;
@property (weak, nonatomic) IBOutlet UIImageView *m_imgProfilePic;
@property (weak, nonatomic) IBOutlet UILabel *m_lblName;
@property (weak, nonatomic) IBOutlet UILabel *m_lblPlace;
@property (weak, nonatomic) IBOutlet UILabel *m_lblDate;
@end
