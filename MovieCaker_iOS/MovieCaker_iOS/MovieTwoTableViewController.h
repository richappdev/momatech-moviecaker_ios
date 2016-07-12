//
//  MovieTwoTableViewController.h
//  MovieCaker_iOS
//
//  Created by Albert Hsu on 5/19/16.
//  Copyright © 2016 Albert Hsu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MovieViewController.h"

@interface MovieTwoTableViewController : UITableViewController
@property int type;
@property NSArray *data;
-(void)ParentController:(MovieViewController *)movie;
@property int selectIndex;
@property int page;
@end
