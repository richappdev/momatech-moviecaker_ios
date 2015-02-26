//
//  FriendObj.h
//  MovieCaker
//
//  Created by iKevin on 2014/2/18.
//  Copyright (c) 2014年 iKevin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FriendObj : NSObject

@property (nonatomic, strong) NSString * avatar;
@property (nonatomic, strong) NSString * nickName;
@property (nonatomic, strong) NSNumber * userId;
@property (nonatomic, strong) NSString * userName;
@property (nonatomic, strong) NSString * fristName;
@property (nonatomic, strong) NSString * lastName;
@property (nonatomic, strong) NSString * brithDay;
@property (nonatomic, strong) NSNumber * location;
@property (nonatomic, strong) NSString * locationName;
@property (nonatomic, strong) NSString * intro;
@property (nonatomic, strong) NSNumber * masterLocation;
@property (nonatomic, strong) NSNumber * gender;
@property (nonatomic, strong) NSNumber * isCompleteEditProfile;
@property (nonatomic, strong) NSNumber * editStage;
@property (nonatomic, strong) NSNumber * bannerType;
@property (nonatomic, strong) NSString * banner;
@property (nonatomic, strong) NSNumber * ownerId;
@property (nonatomic, strong) NSNumber * isFriend;
@property (nonatomic, strong) NSNumber * isBeingInviting;
@property (nonatomic, strong) NSNumber * isInviting;
@end
