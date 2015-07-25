//
//  PossibilitiesCell.m
//  TripKritik
//
//  Created by youandme on 23/07/15.
//  Copyright (c) 2015 youandme. All rights reserved.
//

#import "PossibilitiesCell.h"

@implementation PossibilitiesCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)layoutSubviews {
    CGRect frame = self.contentView.frame;
    self.m_backgroundView.frame = frame;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
