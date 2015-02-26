//
//  NotificationViewController.h
//  MovieCaker
//
//  Created by iKevin on 2014/5/4.
//  Copyright (c) 2014年 iKevin. All rights reserved.
//

#import "BaseViewController.h"

@interface NotificationViewController : BaseViewController
@property (strong, nonatomic) IBOutlet UITableView *myTableView;
@property (strong, nonatomic) IBOutlet UIButton *topButton;
- (IBAction)topButtonPressed:(id)sender;
@property (strong, nonatomic) IBOutlet UIView *footView;
@property (strong, nonatomic) IBOutlet UILabel *moreLabel;

@end
