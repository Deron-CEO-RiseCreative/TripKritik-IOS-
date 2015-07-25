//
//  ItineraryCell.m
//  TripKritik
//
//  Created by youandme on 23/07/15.
//  Copyright (c) 2015 youandme. All rights reserved.
//

#import "ItineraryCell.h"

@implementation ItineraryCell

- (void)awakeFromNib {
    // Initialization code
    self.m_backgroundView.layer.cornerRadius = 3;
    self.m_TitleView.layer.cornerRadius = 3;
}

- (void)layoutSubviews {
    CGRect frame = self.contentView.frame;
    CGRect backFrame = self.m_backgroundView.frame;
    backFrame.origin.y = 5;
    backFrame.size.width = frame.size.width - 20;
    backFrame.size.height = frame.size.height - 10;
    self.m_backgroundView.frame = backFrame;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
