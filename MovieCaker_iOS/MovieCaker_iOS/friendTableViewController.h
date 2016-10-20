//
//  friendTableViewController.h
//  MovieCaker_iOS
//
//  Created by Albert Hsu on 8/30/16.
//  Copyright © 2016 Albert Hsu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "friendsViewController.h"

@interface friendTableViewController : UITableViewController
@property int type;
@property NSMutableArray *data;
@property int page;
@property friendsViewController *parentController;
-(void)acceptFriend:(NSIndexPath*)path;
@end
