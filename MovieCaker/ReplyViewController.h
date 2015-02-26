//
//  ReplyViewController.h
//  MovieCaker
//
//  Created by iKevin on 2013/11/23.
//  Copyright (c) 2013年 iKevin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "TopicObj.h"

@interface ReplyViewController : BaseViewController<UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UITableView *myTableView;
@property (strong, nonatomic) TopicObj *topic;
@end
