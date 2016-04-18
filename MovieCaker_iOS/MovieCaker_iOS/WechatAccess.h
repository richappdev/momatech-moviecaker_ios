//
//  WechatAccess.h
//  MovieCaker_iOS
//
//  Created by Albert Hsu on 4/18/16.
//  Copyright © 2016 Albert Hsu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WXApi.h"
@interface WechatAccess : NSObject
- (WechatAccess *)defaultAccess;
+ (instancetype) sharedInstance;
- (BOOL)handleOpenURL:(NSURL *)url;
- (void)login:(void(^)(BOOL succeeded, id object))result viewController:(UIViewController*)controller;
@end
