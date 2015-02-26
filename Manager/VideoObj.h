//
//  VideoObj.h
//  MovieCaker
//
//  Created by iKevin on 2014/2/11.
//  Copyright (c) 2014年 iKevin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VideoObj : NSObject

@property (nonatomic, strong) NSNumber * actorId;
@property (nonatomic, strong) NSString * channel;
@property (nonatomic, strong) NSString * cnIntro;
@property (nonatomic, strong) NSString * cnName;
@property (nonatomic, strong) NSDate * createdOn;
@property (nonatomic, strong) NSString * enIntro;
@property (nonatomic, strong) NSString * enName;
@property (nonatomic, strong) NSString * intro;
@property (nonatomic, strong) NSNumber * likeNum;
@property (nonatomic, strong) NSNumber * month;
@property (nonatomic, strong) NSNumber * myType;
@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSNumber * page;
@property (nonatomic, strong) NSString * picture;
@property (nonatomic, strong) NSString * releaseDate;
@property (nonatomic, strong) NSNumber * reviewNum;
@property (nonatomic, strong) NSNumber * topicID;
@property (nonatomic, strong) NSNumber * total;
@property (nonatomic, strong) NSString * uid;
@property (nonatomic, strong) NSDate * update;
@property (nonatomic, strong) NSString * videoID;
@property (nonatomic, strong) NSNumber * viewNum;
@property (nonatomic, strong) NSNumber * wantViewNum;
@property (nonatomic, strong) NSNumber * year;
@property (nonatomic, strong) NSNumber * isLiked;
@property (nonatomic, strong) NSNumber * isViewed;
@property (nonatomic, strong) NSNumber * isWantView;

@end
