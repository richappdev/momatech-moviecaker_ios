//
//  SchoolParty.h
//  MovieCaker
//
//  Created by iKevin on 2014/5/2.
//  Copyright (c) 2014年 iKevin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface SchoolParty : NSManagedObject

@property (nonatomic, retain) NSString * avatar;
@property (nonatomic, retain) NSString * channel;
@property (nonatomic, retain) NSString * desc;
@property (nonatomic, retain) NSNumber * founderID;
@property (nonatomic, retain) NSNumber * isJoined;
@property (nonatomic, retain) NSNumber * isPassAudit;
@property (nonatomic, retain) NSNumber * isPublic;
@property (nonatomic, retain) NSNumber * memberCount;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * needAuth;
@property (nonatomic, retain) NSString * nickName;
@property (nonatomic, retain) NSNumber * partyID;
@property (nonatomic, retain) NSNumber * total;
@property (nonatomic, retain) NSDate * update;

@end
