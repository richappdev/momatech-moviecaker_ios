//
//  MovieTableViewController.h
//  MovieCaker_iOS
//
//  Created by Albert Hsu on 4/28/16.
//  Copyright © 2016 Albert Hsu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MovieTableViewController : UITableViewController
@property NSLayoutConstraint *tableHeight;
- (id)init:(int)type;
-(int)returnTotalHeight;
@property int type;
@end