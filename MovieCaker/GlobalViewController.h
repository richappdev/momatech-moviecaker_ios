//
//  GlobalViewController.h
//  MovieCaker
//
//  Created by iKevin on 2013/11/19.
//  Copyright (c) 2013年 iKevin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "MovieListCell.h"

@interface GlobalViewController : BaseViewController <UITableViewDataSource,UITableViewDelegate,MovieCellDelegate>
//@property (strong, nonatomic) UIPageViewController *pageController;
@property (strong, nonatomic) IBOutlet UIButton *b1;
@property (strong, nonatomic) IBOutlet UIButton *b2;
@property (strong, nonatomic) IBOutlet UIButton *b3;
@property (strong, nonatomic) IBOutlet UIButton *b4;
@property (strong, nonatomic) IBOutlet UIButton *b5;
@property (strong, nonatomic) IBOutlet UITableView *myTableView;
@property (strong, nonatomic) IBOutlet UIView *headerView;
@property (strong, nonatomic) IBOutlet UIView *footView;
@property (strong, nonatomic) IBOutlet UILabel *moreLabel;

- (IBAction)b1Pressed:(id)sender;
- (IBAction)b2Pressed:(id)sender;
- (IBAction)b3Pressed:(id)sender;
- (IBAction)b4Pressed:(id)sender;
- (IBAction)b5Pressed:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *topButton;
- (IBAction)topButtonPressed:(id)sender;


@end
