//
//  MainVerticalScroller.h
//  MovieCaker_iOS
//
//  Created by Albert Hsu on 4/25/16.
//  Copyright © 2016 Albert Hsu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "MovieController.h"
@interface MainVerticalScroller : NSObject<UIScrollViewDelegate>
@property MovieController *movieView;
@end