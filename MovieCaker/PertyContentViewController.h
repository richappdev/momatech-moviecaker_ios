//
//  PertyContentViewController.h
//  MovieCaker
//
//  Created by iKevin on 2014/4/8.
//  Copyright (c) 2014年 iKevin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "SchoolPartyObj.h"

@interface PertyContentViewController : BaseViewController
@property (strong, nonatomic) IBOutlet UIToolbar *toolbar;
@property (strong, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
- (IBAction)didChangeSegmentControl:(id)sender;
@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (strong, nonatomic) SchoolPartyObj *party;
@property (strong, nonatomic) NSNumber *partyID;
@end
