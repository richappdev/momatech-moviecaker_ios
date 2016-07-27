//
//  MovieTabCell.h
//  MovieCaker_iOS
//
//  Created by Albert Hsu on 5/20/16.
//  Copyright © 2016 Albert Hsu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MovieTwoTableViewController.h"
@interface MovieTabCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *ratingLabel;
@property (strong, nonatomic) IBOutlet UIView *ratingBg;
@property (strong, nonatomic) IBOutlet UIImageView *image;
@property (strong, nonatomic) IBOutlet UILabel *date;
@property (strong, nonatomic) IBOutlet UILabel *title;
@property (strong, nonatomic) IBOutlet UILabel *imdb;
@property (strong, nonatomic) IBOutlet UILabel *dou;
@property (strong, nonatomic) IBOutlet UILabel *viewed;
@property (strong, nonatomic) IBOutlet UILabel *liked;
@property (strong, nonatomic) IBOutlet UILabel *reviewed;
@property (strong, nonatomic) IBOutlet UILabel *favored;
@property (strong, nonatomic) IBOutlet UIView *reviewBtn;
@property (strong, nonatomic) IBOutlet UIView *watchBtn;
@property (strong, nonatomic) IBOutlet UIView *likeBtn;
@property (strong, nonatomic) IBOutlet UIView *wannaBtn;
@property NSMutableDictionary *data;
@property NSNumber *watchBool;
@property NSNumber *likeBool;
@property NSNumber *wannaBool;
@property MovieTwoTableViewController *parent;
@property long index;
-(void)setWatchState:(BOOL)state;
-(void)setLikeState:(BOOL)state;
-(void)setWannaState:(BOOL)state;
@end
