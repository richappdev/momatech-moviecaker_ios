//
//  FirstViewController.h
//  MovieCaker_iOS
//
//  Created by Albert Hsu on 3/31/16.
//  Copyright © 2016 Albert Hsu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MovieController : UIViewController<UIScrollViewDelegate>
@property (strong, nonatomic) IBOutlet UIView *statubarBg;
@property (strong, nonatomic) IBOutlet UIView *movingButtons;
@property (strong, nonatomic) IBOutlet UITableView *movieTable;
@property (strong, nonatomic) IBOutlet UITableView *movieTable2;
@end

