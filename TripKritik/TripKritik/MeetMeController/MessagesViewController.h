//
//  MessagesViewController.h
//  TripKritik
//
//  Created by youandme on 23/07/15.
//  Copyright (c) 2015 youandme. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessagesViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *m_lblTitle;
@property (weak, nonatomic) IBOutlet UIScrollView *m_scrollView;
@property (weak, nonatomic) IBOutlet UITextView *m_textView;

- (IBAction)actionBack:(id)sender;

@end
