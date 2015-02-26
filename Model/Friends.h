//
//  Friends.h
//  MovieCaker
//
//  Created by iKevin on 2014/5/17.
//  Copyright (c) 2014年 iKevin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Friends : NSManagedObject

@property (nonatomic, retain) NSString * avatar;
@property (nonatomic, retain) NSString * banner;
@property (nonatomic, retain) NSNumber * bannerType;
@property (nonatomic, retain) NSString * brithDay;
@property (nonatomic, retain) NSNumber * editStage;
@property (nonatomic, retain) NSString * fristName;
@property (nonatomic, retain) NSNumber * gender;
@property (nonatomic, retain) NSString * intro;
@property (nonatomic, retain) NSNumber * isCompleteEditProfile;
@property (nonatomic, retain) NSNumber * isFriend;
@property (nonatomic, retain) NSString * lastName;
@property (nonatomic, retain) NSNumber * location;
@property (nonatomic, retain) NSString * locationName;
@property (nonatomic, retain) NSNumber * masterLocation;
@property (nonatomic, retain) NSString * nickName;
@property (nonatomic, retain) NSNumber * ownerId;
@property (nonatomic, retain) NSNumber * userId;
@property (nonatomic, retain) NSString * userName;
@property (nonatomic, retain) NSNumber * isBeingInviting;
@property (nonatomic, retain) NSNumber * isInviting;

@end
