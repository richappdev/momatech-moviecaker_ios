//
//  FilmReviewViewController.h
//  MovieCaker
//
//  Created by iKevin on 2013/11/23.
//  Copyright (c) 2013年 iKevin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "VideoObj.h"
#import "MovieListCell.h"

@interface FilmReviewViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate,MovieCellDelegate>
@property (strong, nonatomic) IBOutlet UITableView *myTableView;
@property (strong, nonatomic) VideoObj *video;

@end
