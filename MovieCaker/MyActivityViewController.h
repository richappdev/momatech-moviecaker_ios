//
//  MyActivityViewController.h
//  MovieCaker
//
//  Created by iKevin on 2014/1/12.
//  Copyright (c) 2014年 iKevin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "FriendObj.h"

@interface MyActivityViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *myTableView;
@property (strong, nonatomic) IBOutlet UIView *footView;
@property (strong, nonatomic) IBOutlet UILabel *moreLabel;
@property (strong, nonatomic) FriendObj *friend;
@property (strong, nonatomic) IBOutlet UIButton *topButton;
- (IBAction)topButtonPressed:(id)sender;
@end
