//
//  CardViewController.h
//  MovieCaker
//
//  Created by iKevin on 2014/2/18.
//  Copyright (c) 2014年 iKevin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "FriendObj.h"

@interface CardViewController : BaseViewController<UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UITableView *myTableView;
@property (strong, nonatomic) IBOutlet UIImageView *qrcodeImageView;
@property (strong, nonatomic) FriendObj *friend;
@property (strong, nonatomic) IBOutlet UIButton *scanButton;
- (IBAction)scanButtonPressed:(id)sender;

@end
