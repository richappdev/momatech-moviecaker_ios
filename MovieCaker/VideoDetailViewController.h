//
//  VideoDetailViewController.h
//  MovieCaker
//
//  Created by iKevin on 2013/11/22.
//  Copyright (c) 2013年 iKevin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "VideoObj.h"
#import "Actor.h"
#import "LineUpCell.h"
#import "MovieListCell.h"

@interface VideoDetailViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate,LineUpCellDelegate,MovieCellDelegate>
@property (strong, nonatomic) IBOutlet UITableView *myTableView;
@property (strong, nonatomic) VideoObj *video;
@end
