//
//  InviteViewController.h
//  MovieCaker
//
//  Created by iKevin on 2014/5/4.
//  Copyright (c) 2014年 iKevin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "InviteCell.h"

@interface InviteViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate,InviteCellDelegate>
@property (strong, nonatomic) IBOutlet UITableView *myTableView;
@property (strong, nonatomic) IBOutlet UILabel *moreLabel;

@end
