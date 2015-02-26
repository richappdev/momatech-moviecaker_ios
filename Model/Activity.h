//
//  Activity.h
//  MovieCaker
//
//  Created by iKevin on 2014/7/3.
//  Copyright (c) 2014年 iKevin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Activity : NSManagedObject

@property (nonatomic, retain) NSNumber * actorId;
@property (nonatomic, retain) NSString * avatar;
@property (nonatomic, retain) NSString * content;
@property (nonatomic, retain) NSDate * createdOn;
@property (nonatomic, retain) NSString * nickName;
@property (nonatomic, retain) NSString * remark;
@property (nonatomic, retain) NSString * status;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * type;
@property (nonatomic, retain) NSNumber * typeId;
@property (nonatomic, retain) NSNumber * userId;
@property (nonatomic, retain) NSString * videoId;

@end
