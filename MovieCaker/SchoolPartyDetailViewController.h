//
//  SchoolPartyDetailViewController.h
//  MovieCaker
//
//  Created by iKevin on 2013/12/15.
//  Copyright (c) 2013年 iKevin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SchoolPartyObj.h"
#import "BaseViewController.h"

@interface SchoolPartyDetailViewController : BaseViewController<UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UITableView *myTableView;
@property (strong, nonatomic) SchoolPartyObj *party;
@end
