//
//  TopicViewController.h
//  MovieCaker
//
//  Created by iKevin on 2013/11/13.
//  Copyright (c) 2013年 iKevin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "TopicCell.h"
#import "WXApi.h"

@interface TopicViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate,TopicCellDelegate,WXApiDelegate>
@property (strong, nonatomic) IBOutlet UITableView *myTableView;
@property (strong, nonatomic) NSString *channel;
@property (strong, nonatomic) IBOutlet UIView *footView;
@property (assign, nonatomic) BOOL showLogin;
@property (strong, nonatomic) IBOutlet UIButton *topButton;
- (IBAction)topButtonPressed:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *moreLabel;

@end
