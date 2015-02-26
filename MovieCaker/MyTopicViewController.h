//
//  MyTopicViewController.h
//  MovieCaker
//
//  Created by iKevin on 2013/12/16.
//  Copyright (c) 2013年 iKevin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "FriendObj.h"

@interface MyTopicViewController : BaseViewController
@property (strong, nonatomic) FriendObj *friend;
@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (strong, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
- (IBAction)didChangeSegmentControl:(id)sender;
@end
