//
//  LineUpViewController.h
//  MovieCaker
//
//  Created by iKevin on 2014/2/12.
//  Copyright (c) 2014年 iKevin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "LineUpCell.h"
#import "VideoObj.h"
#import "MovieListCell.h"

@interface LineUpViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate,LineUpCellDelegate,MovieCellDelegate>
    @property (strong, nonatomic) IBOutlet UITableView *myTableView;
    @property (strong, nonatomic) VideoObj *video;
    @property(strong, nonatomic) NSArray *actorArray;
@end
