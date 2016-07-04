//
//  Movie2Cell.h
//  MovieCaker_iOS
//
//  Created by Albert Hsu on 5/2/16.
//  Copyright © 2016 Albert Hsu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MovieTableViewController.h"

@interface Movie2Cell : UITableViewCell
@property NSString* Id;
@property NSString* videoId;
@property (strong, nonatomic) IBOutlet UIView *likeBtn;
@property (strong, nonatomic) IBOutlet UIView *shareBtn;
@property (strong, nonatomic) IBOutlet UIImageView *star1;
@property (strong, nonatomic) IBOutlet UIImageView *star2;
@property (strong, nonatomic) IBOutlet UIImageView *star3;
@property (strong, nonatomic) IBOutlet UIImageView *star4;
@property (strong, nonatomic) IBOutlet UIImageView *star5;
@property (strong, nonatomic) IBOutlet UIImageView *mainPic;
@property (strong, nonatomic) IBOutlet UILabel *Title;
@property (strong, nonatomic) IBOutlet UILabel *CreatedOn;
@property (strong, nonatomic) IBOutlet UIImageView *AvatarPic;
@property (strong, nonatomic) IBOutlet UILabel *Content;
@property (strong, nonatomic) IBOutlet UILabel *Messages;
@property (strong, nonatomic) IBOutlet UILabel *Views;
@property (strong, nonatomic) IBOutlet UILabel *Author;
@property (strong, nonatomic) IBOutlet UIImageView *Heart;
@property NSArray *starArray;
-(void)setStars:(int)rating;
-(void)setLikeState:(BOOL)state;
-(void)setShareState:(BOOL)state;
@property (weak)MovieTableViewController *parent;
@end
