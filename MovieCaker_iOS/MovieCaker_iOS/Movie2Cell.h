//
//  Movie2Cell.h
//  MovieCaker_iOS
//
//  Created by Albert Hsu on 5/2/16.
//  Copyright © 2016 Albert Hsu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Movie2Cell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIView *likeBtn;
@property (strong, nonatomic) IBOutlet UIView *shareBtn;
@property (strong, nonatomic) IBOutlet UIImageView *star1;
@property (strong, nonatomic) IBOutlet UIImageView *star2;
@property (strong, nonatomic) IBOutlet UIImageView *star3;
@property (strong, nonatomic) IBOutlet UIImageView *star4;
@property (strong, nonatomic) IBOutlet UIImageView *star5;
@property NSArray *starArray;
-(void)setStars:(int)rating;
@end