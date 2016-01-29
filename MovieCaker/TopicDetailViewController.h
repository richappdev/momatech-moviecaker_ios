//
//  TopicDetailViewController.h
//  MovieCaker
//
//  Created by iKevin on 2013/11/17.
//  Copyright (c) 2013年 iKevin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "TopicObj.h"
#import "TopicReply.h"
#import "VideoObj.h"
#import "MovieListCell.h"
#import "TopicDetailCell.h"

@interface TopicDetailViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate,MovieCellDelegate,TopicDetailCellDelegate>
@property (strong, nonatomic) IBOutlet UITableView *myTableView;
@property (strong, nonatomic) TopicObj *topic;
@property (strong, nonatomic) NSNumber *topicId;
@property (strong, nonatomic) NSString *channel;
@property (strong, nonatomic) NSNumber *year;
@property (strong, nonatomic) NSNumber *month;
@property (strong, nonatomic) NSNumber *page;
@property (strong, nonatomic) NSNumber *actorId;
@property (strong, nonatomic) TopicReply *reply;
@property (strong, nonatomic) NSString *actorName;
@property (assign, nonatomic) NSInteger index;
@property (strong, nonatomic) IBOutlet UIView *footView;
@property (strong, nonatomic) IBOutlet UILabel *moreLabel;
@property (strong, nonatomic) IBOutlet UIButton *topButton;
- (IBAction)topButtonPressed:(id)sender;
-(void)goToMovieDetail:(NSString*)videoID;
@end
