//
//  MovieTableViewController.h
//  MovieCaker_iOS
//
//  Created by Albert Hsu on 4/28/16.
//  Copyright © 2016 Albert Hsu. All rights reserved.
//

#import "MovieController.h"

@interface MovieTableViewController : UITableViewController
@property NSLayoutConstraint *tableHeight;
- (id)init:(int)type;
-(int)returnTotalHeight;
-(void)ParentController:(MovieController *)movie;
@property int type;
@property NSArray *data;
@property NSMutableArray *circlePercentage;
@property int selectIndex;
-(void)sync;
-(void)setNewCircleArray:(int)count;
-(void)addCircleEntry;
@property int page;
@end
