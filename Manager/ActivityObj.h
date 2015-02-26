//
//  ActivityObj.h
//  MovieCaker
//
//  Created by iKevin on 2014/3/9.
//  Copyright (c) 2014年 iKevin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ActivityObj : NSObject

@property (nonatomic, strong) NSString * content;
@property (nonatomic, strong) NSDate * createdOn;
@property (nonatomic, strong) NSString * title;
@property (nonatomic, strong) NSString * type;
@property (nonatomic, strong) NSNumber * typeId;
@property (nonatomic, strong) NSNumber * userId;
@property (nonatomic, strong) NSString * videoId;
@property (nonatomic, strong) NSString * nickName;
@property (nonatomic, strong) NSString * avatar;
@property (nonatomic, strong) NSString * status;
@property (nonatomic, strong) NSString * remark;

@end
