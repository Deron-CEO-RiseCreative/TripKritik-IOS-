//
//  ReviewsViewController.m
//  TripKritik
//
//  Created by youandme on 14/07/15.
//  Copyright (c) 2015 youandme. All rights reserved.
//

#import "ReviewsViewController.h"
#import "ReviewCell.h"
#import "MBProgressHUD.h"
#import <Parse/Parse.h>
#import "UIImageView+AFNetworking.h"
#import "NSString+HTML.h"
#import "WriteReviewViewController.h"

@interface ReviewsViewController ()

@end

@implementation ReviewsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self fetchReviewsOfBusiness];
    self.m_lblBusinessName.text = [self.m_BusinessSummary objectForKey:@"name"];
    self.m_viewBusinessRate.notSelectedImage = [UIImage imageNamed:@"icon_rate_fullempty.png"];
    self.m_viewBusinessRate.halfSelectedImage = [UIImage imageNamed:@"icon_rate_full.png"];
    self.m_viewBusinessRate.fullSelectedImage = [UIImage imageNamed:@"icon_rate_full.png"];
    self.m_viewBusinessRate.editable = NO;
    self.m_viewBusinessRate.maxRating = 5;
    self.m_viewBusinessRate.midMargin = 0;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if ([PFUser currentUser] && [[[PFUser currentUser] objectForKey:@"admin"] isEqualToString:@"Yes"]) {
        self.m_btnWriteReview.hidden = YES;
    } else {
        self.m_btnWriteReview.hidden = NO;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Actions
- (IBAction)actionBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)actionWriteReview:(id)sender {
    if ([PFUser currentUser]) {
        [self performSegueWithIdentifier:@"segueWriteReview" sender:self];
    } else
        [self performSegueWithIdentifier:@"segueSignin" sender:self];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return _arrayReviews.count+_arrayReviewsOfApp.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    int height = 0.0;
    NSString *strComment;
    if (indexPath.row < _arrayReviewsOfApp.count) {
        strComment = [_arrayReviewsOfApp[indexPath.row] objectForKey:@"review"];
    } else {
        NSInteger indexOfReview = indexPath.row - _arrayReviewsOfApp.count;
        strComment = [_arrayReviews[indexOfReview] objectForKey:@"review"];
    }
    UITextView *tempView = [[UITextView alloc] initWithFrame:CGRectMake(78, 27, tableView.frame.size.width-88, 9999.99)];
    tempView.text = strComment;
    tempView.font = [UIFont systemFontOfSize:14];
    [tempView sizeToFit];
    height = 62 + tempView.frame.size.height;
    
    if (height < 100) {
        return 100;
    } else {
        return height;
    }
    return height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"indexpath : %ld", (long)indexPath.row);
    ReviewCell *cell = (ReviewCell *)[tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    // Configure the cell...
    NSString *path;
    if (indexPath.row < _arrayReviewsOfApp.count) {
        cell.m_txtReview.text = [_arrayReviewsOfApp[indexPath.row] objectForKey:@"review"];
        
        PFFile *file = [[_arrayReviewsOfApp[indexPath.row] objectForKey:@"user"] objectForKey:@"profilepic"];
        cell.m_imgUserProfile.image = [UIImage imageNamed:@"Default-User-Photo.png"];
        if(file!=nil)
        {
            [file getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
                if (!error) {
                    [cell.m_imgUserProfile setImage:[UIImage imageWithData:imageData]];
                }
            }];
        }
    } else {
        NSInteger indexOfReview = indexPath.row - _arrayReviewsOfApp.count;
        cell.m_txtReview.text = [_arrayReviews[indexOfReview] objectForKey:@"review"];
        [cell setupUserRate:[[_arrayReviews[indexOfReview] objectForKey:@"rating"] integerValue]];
        path = [_arrayReviews[indexOfReview] objectForKey:@"profilepic"];
        path = [path stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
        NSLog(@"image path = %@\n", path);
        NSURLRequest* urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:path]];
        
        __weak typeof(cell.m_imgUserProfile ) weakImgRef = cell.m_imgUserProfile;
        UIImage* imgPlaceholder = [UIImage imageNamed:@"Default-User-Photo.png"];
        
        [cell.m_imgUserProfile setImageWithURLRequest:urlRequest
                                     placeholderImage:imgPlaceholder
                                              success:^(NSURLRequest* request, NSHTTPURLResponse* response, UIImage* image) {
                                                  
                                                  CGSize size = weakImgRef.frame.size;
                                                  weakImgRef.image = image;
                                                  
                                              } failure:^(NSURLRequest* request, NSHTTPURLResponse* response, NSError* error) {
                                                  
                                              }];
    }
    
    return cell;
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

# pragma mark - Yelp API Delegate Method
-(void)loadResultWithDataDictionary:(NSDictionary *)resultDictionary {
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    _businessDetailDic = resultDictionary;
    _arrayReviews = [resultDictionary objectForKey:@"reviews"];

    [self.m_tableView reloadData];
}

- (void)failedConnection {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"segueWriteReview"]) {
        WriteReviewViewController *target = (WriteReviewViewController *)segue.destinationViewController;
        target.m_BusinessSummary = self.m_BusinessSummary;
    }
}

#pragma mark - Common
- (void)fetchReviewsOfBusiness {
    _loadingCount = 0;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    dispatch_async(dispatch_get_main_queue(),
                   ^{
                       [self loadWebSite];
                       [self loadAppUserReviews];
                   });
    
}

- (void)loadAppUserReviews {
    PFQuery *query = [PFQuery queryWithClassName:@"Comment"];
    [query whereKey:@"status" equalTo:@"live"];
    [query whereKey:@"businessid" equalTo:[self.m_BusinessSummary objectForKey:@"id"]];
    [query includeKey:@"user"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error){
        [MBProgressHUD hideHUDForView:self.view animated:YES];

        if (!error) { //remove note
            _arrayReviewsOfApp = [objects mutableCopy];
            [self.m_tableView reloadData];
        } else {
            [self showAlertWithTitle:@"" message:@"Connection Error."];
        }
    }];
}

- (void)loadWebSite {
    if ([[self.m_BusinessSummary objectForKey:@"url"] isEqualToString:@""]) return;
    
    _arrayReviews = [[NSMutableArray alloc] init];
    // 1
    NSURL *url = [NSURL URLWithString:[self.m_BusinessSummary objectForKey:@"url"]];
    NSData *htmlData = [NSData dataWithContentsOfURL:url];
    
    //1.1 html loading check.
    if (htmlData == nil) {
        [self showAlertWithTitle:@"" message:@"Connection Error.\nPlease try again later!"];
        return;
    }
    
    // 2
    TFHpple *parser = [TFHpple hppleWithHTMLData:htmlData];
    
    // 3
    NSString *xpathQueryString = @"//div[@class='review-list']/ul/li/div";
    NSArray *nodes = [parser searchWithXPathQuery:xpathQueryString];
    
    // 4
    
    float totalRating = 0;
    for (TFHppleElement *parent in nodes) {
        NSMutableDictionary *item = [[NSMutableDictionary alloc] init];
        for (TFHppleElement *element in parent.children) {
            if ([element.tagName isEqualToString:@"meta"]) { // Author Name
                NSString *name = element.content;
                [item setObject:name forKey:@"name"];
            } else if ([element.tagName isEqualToString:@"div"] && [[element objectForKey:@"class"] isEqualToString:@"review-sidebar"]) { // profile pic
                NSString *imgPath = [NSString stringWithFormat:@"http:%@", [self findImagePath:element]];
                NSLog(@"profilepic = %@\n", imgPath);
                [item setObject:imgPath forKey:@"profilepic"];
            } else if ([element.tagName isEqualToString:@"div"] && [[element objectForKey:@"class"] isEqualToString:@"review-wrapper"]) { // review content
                NSString *reviewText = [self findReviewText:element];
                NSLog(@"review = %@\n", reviewText);
                [item setObject:reviewText forKey:@"review"];
                
                NSString *rating = [self findRating:element];
                NSLog(@"rating = %@\n\n", rating);
                [item setObject:rating forKey:@"rating"];
                totalRating = totalRating + [rating floatValue];
            }
        }
        [_arrayReviews addObject:item];
    }
    
    [self.m_tableView reloadData];
    [self.m_viewBusinessRate setRating:(float)(totalRating/_arrayReviews.count)];

}

- (NSString *)findImagePath:(TFHppleElement *)element {
    if ([element.tagName isEqualToString:@"img"]) {
        NSLog(@"%@", [element objectForKey:@"src"]);
        NSString *path = [element objectForKey:@"src"];
        return path;
    } else {
        if (!element.hasChildren) return @"";
        else {
            for (TFHppleElement *obj in element.children) {
                NSString *path = [self findImagePath:obj];
                if (![path isEqualToString:@""]) {
                    return path;
                }
            }
        }
    }
    
    return @"";
}

- (NSString *)findReviewText:(TFHppleElement *)element {
    if ([element.tagName isEqualToString:@"p"] && [[element objectForKey:@"itemprop"] isEqualToString:@"description"]) {
        NSString *reviewText = element.content;
        return reviewText;
    } else {
        if (!element.hasChildren) return @"";
        else {
            for (TFHppleElement *obj in element.children) {
                NSString *reviewText = [self findReviewText:obj];
                if (![reviewText isEqualToString:@""]) {
                    return reviewText;
                }
            }
        }
    }
    
    return @"";
}

- (NSString *)findRating:(TFHppleElement *)element {
    if ([element.tagName isEqualToString:@"meta"] && [[element objectForKey:@"itemprop"] isEqualToString:@"ratingValue"]) {
        NSLog(@"rating value = %@", element.content);
        return [element objectForKey:@"content"];
    } else {
        if (!element.hasChildren) return @"";
        else {
            for (TFHppleElement *obj in element.children) {
                NSString *rating = [self findRating:obj];
                if (![rating isEqualToString:@""]) {
                    return rating;
                }
            }
        }
    }
    
    return @"";
}

- (void)showAlertWithTitle:(NSString *)title message:(NSString *)message {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    
    [alertView show];
}

@end
