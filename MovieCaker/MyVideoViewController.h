//
//  MyVideoViewController.h
//  MovieCaker
//
//  Created by iKevin on 2013/12/8.
//  Copyright (c) 2013年 iKevin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "FriendObj.h"

@interface MyVideoViewController : BaseViewController
@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (strong, nonatomic) FriendObj *friend;
- (IBAction)didChangeSegmentControl:(id)sender;
@property (strong, nonatomic) IBOutlet UISegmentedControl *segmentedControl;

@end
