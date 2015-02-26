//
//  topicCell.h
//  MovieCaker
//
//  Created by iKevin on 2013/11/16.
//  Copyright (c) 2013年 iKevin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TopicObj.h"

@protocol TopicCellDelegate <NSObject>
@optional
    - (void)shareButtonPressed:(NSIndexPath *)indexPath WithImage:(UIImage *)image;;
@end

@interface TopicCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *header;
@property (strong, nonatomic) IBOutlet UIImageView *imageView1;
@property (strong, nonatomic) IBOutlet UIImageView *imageView2;
@property (strong, nonatomic) IBOutlet UIImageView *imageView3;
@property (strong, nonatomic) IBOutlet UIImageView *imageView4;
@property (strong, nonatomic) IBOutlet UIImageView *imageView5;
@property (strong, nonatomic) IBOutlet UILabel *content;
@property (strong, nonatomic) IBOutlet UIImageView *avatarView;
@property (strong, nonatomic) IBOutlet UILabel *nickName;
@property (strong, nonatomic) IBOutlet UILabel *createdOn;
@property (strong, nonatomic) NSIndexPath *indexPath;
@property (strong, nonatomic) id<TopicCellDelegate> delegate;
@property (strong, nonatomic) IBOutlet UIButton *shareButton;
@property (strong, nonatomic) IBOutlet UILabel *viewNumLabel;
@property (strong, nonatomic) IBOutlet UIButton *likeButton;
@property (strong, nonatomic) TopicObj *topic;
@property (assign,nonatomic) BOOL isCreator;

- (IBAction)shareButtonPressed:(id)sender;
- (IBAction)likeButtonPressed:(id)sender;
@property (strong, nonatomic) IBOutlet UIView *friendView;
@property (strong, nonatomic) IBOutlet UIView *topicView;
@property (strong, nonatomic) IBOutlet UIView *buttonView;

@end
