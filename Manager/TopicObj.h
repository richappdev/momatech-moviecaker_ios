//
//  TopicObj.h
//  MovieCaker
//
//  Created by iKevin on 2014/3/3.
//  Copyright (c) 2014年 iKevin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TopicObj : NSObject

@property (nonatomic, strong) NSNumber * authorID;
@property (nonatomic, strong) NSString * avatar;
@property (nonatomic, strong) NSString * banner;
@property (nonatomic, strong) NSString * channel;
@property (nonatomic, strong) NSNumber * commentNum;
@property (nonatomic, strong) NSString * content;
@property (nonatomic, strong) NSDate * createdOn;
@property (nonatomic, strong) NSNumber * likeNum;
@property (nonatomic, strong) NSString * nickName;
@property (nonatomic, strong) NSString * picture;
@property (nonatomic, strong) NSString * title;
@property (nonatomic, strong) NSNumber * topicID;
@property (nonatomic, strong) NSNumber * total;
@property (nonatomic, strong) NSDate * update;
@property (nonatomic, strong) NSNumber * videoCount;
@property (nonatomic, strong) NSNumber * viewNum;
@property (nonatomic, strong) NSNumber * isLiked;

@end
