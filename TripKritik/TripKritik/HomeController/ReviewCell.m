//
//  ReviewCell.m
//  TripKritik
//
//  Created by youandme on 14/07/15.
//  Copyright (c) 2015 youandme. All rights reserved.
//

#import "ReviewCell.h"

@implementation ReviewCell

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
    
    CGRect backgroundFrame = self.m_backgroundView.frame;
    backgroundFrame.origin.x = 10;
    backgroundFrame.origin.y = 5;
    backgroundFrame.size.width = frame.size.width-20;
    backgroundFrame.size.height = frame.size.height-10;
    self.m_backgroundView.frame = backgroundFrame;
}

#pragma mark - Global
- (void)setupUserRate:(NSInteger)Rate {
    if (Rate == 0) {
        self.m_imgRate_1.image = [UIImage imageNamed:@"Blank.png"];
        self.m_imgRate_2.image = [UIImage imageNamed:@"Blank.png"];
        self.m_imgRate_3.image = [UIImage imageNamed:@"Blank.png"];
        self.m_imgRate_4.image = [UIImage imageNamed:@"Blank.png"];
        self.m_imgRate_5.image = [UIImage imageNamed:@"Blank.png"];
    } else if (Rate == 1) {
        self.m_imgRate_1.image = [UIImage imageNamed:@"icon_rate_full.png"];
        self.m_imgRate_2.image = [UIImage imageNamed:@"Blank.png"];
        self.m_imgRate_3.image = [UIImage imageNamed:@"Blank.png"];
        self.m_imgRate_4.image = [UIImage imageNamed:@"Blank.png"];
        self.m_imgRate_5.image = [UIImage imageNamed:@"Blank.png"];
    } else if (Rate == 2) {
        self.m_imgRate_1.image = [UIImage imageNamed:@"icon_rate_full.png"];
        self.m_imgRate_2.image = [UIImage imageNamed:@"icon_rate_full.png"];
        self.m_imgRate_3.image = [UIImage imageNamed:@"Blank.png"];
        self.m_imgRate_4.image = [UIImage imageNamed:@"Blank.png"];
        self.m_imgRate_5.image = [UIImage imageNamed:@"Blank.png"];
    } else if (Rate == 3) {
        self.m_imgRate_1.image = [UIImage imageNamed:@"icon_rate_full.png"];
        self.m_imgRate_2.image = [UIImage imageNamed:@"icon_rate_full.png"];
        self.m_imgRate_3.image = [UIImage imageNamed:@"icon_rate_full.png"];
        self.m_imgRate_4.image = [UIImage imageNamed:@"Blank.png"];
        self.m_imgRate_5.image = [UIImage imageNamed:@"Blank.png"];
    } else if (Rate == 4) {
        self.m_imgRate_1.image = [UIImage imageNamed:@"icon_rate_full.png"];
        self.m_imgRate_2.image = [UIImage imageNamed:@"icon_rate_full.png"];
        self.m_imgRate_3.image = [UIImage imageNamed:@"icon_rate_full.png"];
        self.m_imgRate_4.image = [UIImage imageNamed:@"icon_rate_full.png"];
        self.m_imgRate_5.image = [UIImage imageNamed:@"Blank.png"];
    } else if (Rate == 5) {
        self.m_imgRate_1.image = [UIImage imageNamed:@"icon_rate_full.png"];
        self.m_imgRate_2.image = [UIImage imageNamed:@"icon_rate_full.png"];
        self.m_imgRate_3.image = [UIImage imageNamed:@"icon_rate_full.png"];
        self.m_imgRate_4.image = [UIImage imageNamed:@"icon_rate_full.png"];
        self.m_imgRate_5.image = [UIImage imageNamed:@"icon_rate_full.png"];
    }
}

@end
