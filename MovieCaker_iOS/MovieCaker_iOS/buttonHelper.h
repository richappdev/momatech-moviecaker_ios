//
//  buttonHelper.h
//  MovieCaker_iOS
//
//  Created by Albert Hsu on 5/2/16.
//  Copyright © 2016 Albert Hsu. All rights reserved.
//

#import <Foundation/Foundation.h>
@import UIKit;
@interface buttonHelper : NSObject
+(void)likeShareClick:(UIView*)view;
+(void)adjustLike:(UIView*)view;
+(void)adjustShare:(UIView*)view;
@end
