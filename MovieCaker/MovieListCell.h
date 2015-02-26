//
//  MovieListCell.h
//  MovieCaker
//
//  Created by iKevin on 2013/11/17.
//  Copyright (c) 2013年 iKevin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VideoObj.h"


@protocol MovieCellDelegate <NSObject>
@optional
    - (void)joinTopic:(VideoObj *)video;
@end


@interface MovieListCell : UITableViewCell <UIAlertViewDelegate>
@property (strong, nonatomic) IBOutlet UIImageView *videoImageView;
@property (strong, nonatomic) IBOutlet UIView *friendView;
@property (strong, nonatomic) IBOutlet UIView *videoView;
@property (strong, nonatomic) IBOutlet UILabel *name;
@property (strong, nonatomic) IBOutlet UILabel *socialLabel;
@property (strong, nonatomic) IBOutlet UILabel *enName;
@property (strong, nonatomic) VideoObj *video;

@property (strong, nonatomic) IBOutlet UIButton *likeButton;
@property (strong, nonatomic) IBOutlet UIButton *seenButton;
@property (strong, nonatomic) IBOutlet UIButton *watchButton;
//@property (strong, nonatomic) IBOutlet UIButton *gradeButton;
//@property (strong, nonatomic) IBOutlet UIButton *reviewButton;
//@property (strong, nonatomic) IBOutlet UIButton *addTopicButton;
@property (weak, nonatomic) id<MovieCellDelegate> delegate;

- (IBAction)likeButtonPressed:(id)sender;
- (IBAction)seenButtonPressed:(id)sender;
- (IBAction)watchButtonPressed:(id)sender;
//- (IBAction)gradeButtonPressed:(id)sender;
//- (IBAction)reviewButtonPressed:(id)sender;
//- (IBAction)addTopicButtonPressed:(id)sender;

-(void)updateVideoInfo;
-(NSDate *)stringToDate:(NSString *)string;

@end
