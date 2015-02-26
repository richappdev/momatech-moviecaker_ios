//
//  SchoolPartyObj.h
//  MovieCaker
//
//  Created by iKevin on 2014/3/9.
//  Copyright (c) 2014年 iKevin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SchoolPartyObj : NSObject
@property (nonatomic, strong) NSNumber * partyID;
@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSString * desc;
@property (nonatomic, strong) NSNumber * isPublic;
@property (nonatomic, strong) NSNumber * memberCount;
@property (nonatomic, strong) NSNumber * isJoined;
@property (nonatomic, strong) NSNumber * isPassAudit;
@property (nonatomic, strong) NSNumber * needAuth;
@property (nonatomic, strong) NSNumber * founderID;
@property (nonatomic, strong) NSString * nickName;
@property (nonatomic, strong) NSString * avatar;
@property (nonatomic, strong) NSString * channel;
@property (nonatomic, strong) NSNumber * total;
@property (nonatomic, strong) NSDate * update;
@end
