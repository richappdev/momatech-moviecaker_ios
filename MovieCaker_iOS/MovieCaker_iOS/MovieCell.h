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
@property (strong, nonatomic) IBOutlet UILabel *title;
@property (strong, nonatomic) IBOutlet CircleView *Circle;
@property (strong, nonatomic) IBOutlet UILabel *percentageLabel;
@property (strong, nonatomic) IBOutlet UILabel *finishLabel;
@property (strong, nonatomic) IBOutlet UIView *likeBtn;
@property (strong, nonatomic) IBOutlet UIView *shareBtn;
@property NSArray *labelArray;
-(void)setCirclePercentage:(float) percent;
@end
