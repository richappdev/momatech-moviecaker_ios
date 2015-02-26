//
//  ActivityViewController.h
//  MovieCaker
//
//  Created by iKevin on 2014/1/13.
//  Copyright (c) 2014年 iKevin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface ActivityViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>
    @property (strong, nonatomic) IBOutlet UITableView *myTableView;
@property (strong, nonatomic) IBOutlet UIView *footView;
@property (strong, nonatomic) IBOutlet UIButton *topButton;
@property (strong, nonatomic) IBOutlet UILabel *moreLabel;
- (IBAction)topButtonPressed:(id)sender;

@end
