//
//  TalkObj.h
//  MovieCaker
//
//  Created by iKevin on 2014/4/9.
//  Copyright (c) 2014年 iKevin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TalkObj : NSObject

@property (nonatomic, strong) NSNumber * creatorId;
@property (nonatomic, strong) NSNumber * clubId;
@property (nonatomic, strong) NSNumber * talkId;
@property (nonatomic, strong) NSString * clubTopicName;
@property (nonatomic, strong) NSString * clubTopicDesc;
@property (nonatomic, strong) NSString * createdOn;
@property (nonatomic, strong) NSString * modifiedOn;
@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSNumber * clubBanner;
@property (nonatomic, strong) NSNumber * clubTopicMessageAmount;
@property (nonatomic, strong) NSString * nickName;
@property (nonatomic, strong) NSString * avatar;
@property (nonatomic, strong) NSNumber * isPublic;
@property (nonatomic, strong) NSString *clubTopicMessageAmountInOneWeek;
@property (nonatomic, strong) NSNumber * IsTop;
@property (nonatomic, strong) NSNumber * pageViews;
@property (nonatomic, strong) NSNumber * likedAmount;
@property (nonatomic, strong) NSNumber * isLike;
@end
