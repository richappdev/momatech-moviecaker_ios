//
//  VideoReview.h
//  MovieCaker
//
//  Created by iKevin on 2013/11/23.
//  Copyright (c) 2013年 iKevin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface VideoReview : NSManagedObject

@property (nonatomic, retain) NSNumber * reviewID;
@property (nonatomic, retain) NSString * videoID;
@property (nonatomic, retain) NSNumber * authorID;
@property (nonatomic, retain) NSString * nickName;
@property (nonatomic, retain) NSString * avatar;
@property (nonatomic, retain) NSString * reviewContent;
@property (nonatomic, retain) NSDate * createdOn;

@end
