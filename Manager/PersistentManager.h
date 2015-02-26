//
//  PersistentManager.h
//  MovieCaker
//
//  Created by iKevin on 2013/11/15.
//  Copyright (c) 2013年 iKevin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TopicReply.h"
#import "Video.h"
#import "Actor.h"
#import "SchoolParty.h"
#import "Friends.h"

@interface PersistentManager : NSObject
+ (PersistentManager *)sharedInstance;
//專題
-(void)topicToDB:(NSData *)data channel:(NSString *) channel withPage:(NSNumber *)page;
-(NSArray *) getTopicWithChannel:(NSString *)channel;
-(void) deleteTopicWithChannel:(NSString *)channel;
//專題回應
-(void) topicReplyToDB:(NSData *)data topicID:(NSNumber *)topicID;
-(NSArray *)getTopicReplyWithID:(NSNumber *)topicID;
-(NSArray *)getFristTopicReplyWithID:(NSNumber *)topicID;
-(void)deleteTopicReplyWithID:(NSNumber *)topicID;

//影片
-(void) videoToDB:(NSData *)data TopicID:(NSNumber *)topicID UID:(NSString *)uid Year:(NSNumber *)year Month:(NSNumber *)month channel:(NSString *)channel Page:(NSNumber *)page withMyType:(NSNumber *)myType withActID:(NSNumber *)actorId;
//取得影片陣列
-(NSArray *)getVideoWithTopicID:(NSNumber *)topicID UID:(NSString *)uid Year:(NSNumber *)year Month:(NSNumber *)month channel:(NSString *)channel Page:(NSNumber *)page withMyType:(NSNumber *)myType withActID:(NSNumber *)actorId;
//取得全球新片更新日期
-(NSDate *)getGlobalVideoLastUpdateTime:(NSNumber *)year month:(NSNumber *)month page:(NSNumber *)page;
-(void)deleteVideoWithTopicID:(NSNumber *)topicID UID:(NSString *)uid Year:(NSNumber *)year Month:(NSNumber *)month channel:(NSString *)channel Page:(NSNumber *)page myType:(NSNumber *)myType withActID:(NSNumber *)actorId;
//影片陣容
-(void) actorToDB:(NSArray *)actorArray videoID:(NSString *)videoID;
-(void)deleteActorWithVideoID:(NSString *)videoID;
-(NSArray *)getActorWithVideoID:(NSString *)videoID;
//影評
-(void)videoReviewToDB:(NSData *)data videoID:(NSString *)videoID;
-(NSArray *)getVideoReviewWithVideoID:(NSString *)videoID;
//童鞋會
-(void)schoolPartyToDB:(NSData *)data withChannel:(NSString *)channel withPage:(NSNumber *)page;
-(NSArray *)getSchoolPartyWithChannel:(NSString *)channel;

//我的朋友
-(void)FriendToDB:(NSData *)data withUserID:(NSNumber *)ownerId withPage:(NSNumber *)page;
-(NSArray *)getMyFriends:(NSNumber *)ownerId;
-(Friends *)getEmptyFriend;

//我的動態
-(void)activityToDB:(NSData *)data withUserID:(NSNumber *)userId withPage:(NSNumber *)page withStatus:(NSString *)status;
-(NSArray *)getActivity:(NSNumber *)userId withStatus:(NSString *)status;

@end
