//
//  MovieCell.h
//  MovieCaker_iOS
//
//  Created by Albert Hsu on 5/1/16.
//  Copyright © 2016 Albert Hsu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CircleView.h"
@interface MovieCell : UITableViewCell
@property NSString *Id;
@property (strong, nonatomic) IBOutlet UILabel *title;
@property (strong, nonatomic) IBOutlet UILabel *Author;
@property (strong, nonatomic) IBOutlet CircleView *Circle;
@property (strong, nonatomic) IBOutlet UILabel *percentageLabel;
@property (strong, nonatomic) IBOutlet UILabel *finishLabel;
@property (strong, nonatomic) IBOutlet UIView *likeBtn;
@property (strong, nonatomic) IBOutlet UIView *shareBtn;
@property (strong, nonatomic) IBOutlet UILabel *Content;
@property (strong, nonatomic) IBOutlet UILabel *Date;
@property (strong, nonatomic) IBOutlet UIImageView *AvatarPic;
@property (strong, nonatomic) IBOutlet UIImageView *one;
@property (strong, nonatomic) IBOutlet UIImageView *two;
@property (strong, nonatomic) IBOutlet UIImageView *three;
@property (strong, nonatomic) IBOutlet UIImageView *four;
@property (strong, nonatomic) IBOutlet UIImageView *five;
@property (strong, nonatomic) IBOutlet UILabel *viewCount;
@property NSArray *imageArray;
@property NSArray *labelArray;
-(void)setCirclePercentage:(float) percent;
-(void)setLikeState:(BOOL)state;
-(void)setShareState:(BOOL)state;
@end
