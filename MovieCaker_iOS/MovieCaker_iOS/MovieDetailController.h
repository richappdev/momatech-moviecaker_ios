//
//  MovieDetailControllerViewController.h
//  MovieCaker_iOS
//
//  Created by Albert Hsu on 4/14/16.
//  Copyright © 2016 Albert Hsu. All rights reserved.
//

#import "MovieController.h"

@interface MovieDetailController : MovieController
@property NSDictionary *movieDetailInfo;
-(IBAction)readMore:(id)sender;
@property BOOL loadLater;
@end
