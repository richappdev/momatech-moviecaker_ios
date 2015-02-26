//
//  ProfileViewController.h
//  MovieCaker
//
//  Created by iKevin on 2014/3/10.
//  Copyright (c) 2014年 iKevin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "FriendObj.h"

@interface ProfileViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *myTableView;
@property (strong, nonatomic) FriendObj *friend;
@property (strong, nonatomic) IBOutlet UITextField *nickNameFiled;
@property (strong, nonatomic) IBOutlet UILabel *brithday;
@property (strong, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
- (IBAction)didChangeSegmentControl:(id)sender;
@property (strong, nonatomic) IBOutlet UIDatePicker *datePicker;
- (IBAction)valueChanged:(id)sender;
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *tap;
- (IBAction)tapGesture:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *brithButton;
- (IBAction)brithButtonPressed:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *sendButton;
- (IBAction)sendButtonPressed:(id)sender;

@end
