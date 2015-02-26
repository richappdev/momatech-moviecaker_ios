//
//  Actor.h
//  MovieCaker
//
//  Created by iKevin on 2013/11/23.
//  Copyright (c) 2013年 iKevin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Actor : NSManagedObject

@property (nonatomic, retain) NSString * videoID;
@property (nonatomic, retain) NSNumber * actorID;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * enName;
@property (nonatomic, retain) NSString * cnName;
@property (nonatomic, retain) NSString * roleType;

@end
