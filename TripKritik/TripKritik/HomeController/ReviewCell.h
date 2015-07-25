//
//  ReviewCell.h
//  TripKritik
//
//  Created by youandme on 14/07/15.
//  Copyright (c) 2015 youandme. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReviewCell : UITableViewCell {
}

@property (weak, nonatomic) IBOutlet UIImageView *m_imgUserProfile;
@property (weak, nonatomic) IBOutlet UIView *m_backgroundView;
@property (weak, nonatomic) IBOutlet UITextView *m_txtReview;
@property (weak, nonatomic) IBOutlet UIImageView *m_imgRate_1;
@property (weak, nonatomic) IBOutlet UIImageView *m_imgRate_2;
@property (weak, nonatomic) IBOutlet UIImageView *m_imgRate_3;
@property (weak, nonatomic) IBOutlet UIImageView *m_imgRate_4;
@property (weak, nonatomic) IBOutlet UIImageView *m_imgRate_5;

- (void)setupUserRate:(NSInteger)Rate;

@end
