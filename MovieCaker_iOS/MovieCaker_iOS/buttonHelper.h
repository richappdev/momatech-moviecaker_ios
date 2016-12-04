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
+(BOOL)likeShareClick:(UIView*)view;
+(void)adjustLike:(UIView*)view;
+(void)adjustShare:(UIView*)view;
+(void)gradientBg:(UIView*)imageView width:(int)width;
+ (BOOL)isLabelTruncated:(UILabel *)label;
+(NSMutableDictionary*)reviewNewData:(NSDictionary*)vData User:(NSDictionary*)User;
+(void)v2AdjustWatch:(UIView*)view state:(BOOL)state;
+(void)v2AdjustLike:(UIView*)view state:(BOOL)state;
+(void)v2AdjustWanna:(UIView*)view state:(BOOL)state;
+(UIColor*)circleColor:(float)percent;
+(void)v2AdjustShare:(UIView*)view state:(BOOL)state;
+(void)adjustFriendStatus:(UIView*)view state:(int)state;
+ (UIImage*)blurImage:(UIImage*)image withBottomInset:(CGFloat)inset blurRadius:(CGFloat)radius;
@end
