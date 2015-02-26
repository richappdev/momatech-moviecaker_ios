//
//  Video.h
//  MovieCaker
//
//  Created by iKevin on 2014/2/23.
//  Copyright (c) 2014年 iKevin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Video : NSManagedObject

@property (nonatomic, retain) NSNumber * actorId;
@property (nonatomic, retain) NSString * channel;
@property (nonatomic, retain) NSString * cnIntro;
@property (nonatomic, retain) NSString * cnName;
@property (nonatomic, retain) NSDate * createdOn;
@property (nonatomic, retain) NSString * enIntro;
@property (nonatomic, retain) NSString * enName;
@property (nonatomic, retain) NSString * intro;
@property (nonatomic, retain) NSNumber * likeNum;
@property (nonatomic, retain) NSNumber * month;
@property (nonatomic, retain) NSNumber * myType;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * page;
@property (nonatomic, retain) NSString * picture;
@property (nonatomic, retain) NSString * releaseDate;
@property (nonatomic, retain) NSNumber * reviewNum;
@property (nonatomic, retain) NSNumber * topicID;
@property (nonatomic, retain) NSNumber * total;
@property (nonatomic, retain) NSString * uid;
@property (nonatomic, retain) NSDate * update;
@property (nonatomic, retain) NSString * videoID;
@property (nonatomic, retain) NSNumber * viewNum;
@property (nonatomic, retain) NSNumber * wantViewNum;
@property (nonatomic, retain) NSNumber * year;
@property (nonatomic, retain) NSNumber * isLiked;
@property (nonatomic, retain) NSNumber * isViewed;
@property (nonatomic, retain) NSNumber * isWantView;

@end
