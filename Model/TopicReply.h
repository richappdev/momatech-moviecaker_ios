//
//  TopicReply.h
//  MovieCaker
//
//  Created by iKevin on 2013/11/18.
//  Copyright (c) 2013年 iKevin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface TopicReply : NSManagedObject

@property (nonatomic, retain) NSNumber * replyID;
@property (nonatomic, retain) NSNumber * parentID;
@property (nonatomic, retain) NSNumber * topicID;
@property (nonatomic, retain) NSNumber * authorID;
@property (nonatomic, retain) NSString * nickName;
@property (nonatomic, retain) NSString * avatar;
@property (nonatomic, retain) NSString * message;
@property (nonatomic, retain) NSDate * createdOn;

@end
