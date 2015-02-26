//
//  Topic.h
//  MovieCaker
//
//  Created by iKevin on 2014/2/19.
//  Copyright (c) 2014年 iKevin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Topic : NSManagedObject

@property (nonatomic, retain) NSNumber * authorID;
@property (nonatomic, retain) NSString * avatar;
@property (nonatomic, retain) NSString * banner;
@property (nonatomic, retain) NSString * channel;
@property (nonatomic, retain) NSNumber * commentNum;
@property (nonatomic, retain) NSString * content;
@property (nonatomic, retain) NSDate * createdOn;
@property (nonatomic, retain) NSNumber * likeNum;
@property (nonatomic, retain) NSString * nickName;
@property (nonatomic, retain) NSString * picture;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSNumber * topicID;
@property (nonatomic, retain) NSNumber * total;
@property (nonatomic, retain) NSDate * update;
@property (nonatomic, retain) NSNumber * videoCount;
@property (nonatomic, retain) NSNumber * viewNum;
@property (nonatomic, retain) NSNumber * isLiked;

@end
