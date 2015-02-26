//
//  ActorObj.h
//  MovieCaker
//
//  Created by iKevin on 2014/4/18.
//  Copyright (c) 2014年 iKevin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ActorObj : NSObject
    @property (nonatomic, strong) NSString * videoID;
    @property (nonatomic, strong) NSNumber * actorID;
    @property (nonatomic, strong) NSString * name;
    @property (nonatomic, strong) NSString * enName;
    @property (nonatomic, strong) NSString * cnName;
    @property (nonatomic, strong) NSString * roleType;
@end
