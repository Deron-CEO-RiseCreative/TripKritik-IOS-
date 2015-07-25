//
//  SearchResultCell.m
//  TripKritik
//
//  Created by youandme on 14/07/15.
//  Copyright (c) 2015 youandme. All rights reserved.
//

#import "SearchResultCell.h"

@implementation SearchResultCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews {
    [super layoutSubviews];

    CGRect frame = self.contentView.frame;
    
    self.m_backgroundView.frame = frame;
    /*
    CGRect nameFrame = self.m_lblName.frame;
    nameFrame.size.width = frame.size.width-4;
    nameFrame.origin.y = 4;
    nameFrame.origin.x = 4;
    self.m_lblName.frame = nameFrame;
    
    CGRect addressFrame = self.m_lblStreet.frame;
    addressFrame.size.width = frame.size.width-4;
    addressFrame.origin.y = nameFrame.origin.y + nameFrame.size.height + 4;
    addressFrame.origin.x = 4;
    self.m_lblStreet.frame = addressFrame;
    
    CGRect phoneFrame = self.m_lblPhoneNumber.frame;
    phoneFrame.origin.y = addressFrame.origin.y + addressFrame.size.height + 4;
    phoneFrame.origin.x = 4;
    self.m_lblPhoneNumber.frame = phoneFrame;
    
    CGRect mileFrame = self.m_lblMileFrom.frame;
    mileFrame.origin.x = frame.size.width-mileFrame.size.width-4;
    mileFrame.origin.y = phoneFrame.origin.y;
    self.m_lblMileFrom.frame = mileFrame;
*/
}

@end
