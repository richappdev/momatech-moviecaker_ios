//
//  starView.h
//  MovieCaker_iOS
//
//  Created by Albert Hsu on 6/29/16.
//  Copyright © 2016 Albert Hsu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface starView : UIView
@property NSArray *starArray;
@property IBOutlet UIImageView *star1;
@property IBOutlet UIImageView *star2;
@property IBOutlet UIImageView *star3;
@property IBOutlet UIImageView *star4;
@property IBOutlet UIImageView *star5;
@property int rating;
@property BOOL edit;
-(void)setStars:(int)rating;
@end
