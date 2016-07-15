//
//  MovieDetailControllerViewController.h
//  MovieCaker_iOS
//
//  Created by Albert Hsu on 4/14/16.
//  Copyright © 2016 Albert Hsu. All rights reserved.
//

#import "MovieController.h"
#import "movieModel.h"

@interface MovieDetailController : MovieController
@property NSMutableDictionary *movieDetailInfo;
@property movieModel *model;
-(IBAction)readMore:(id)sender;
@property BOOL loadLater;
@property BOOL syncReview;
@end
