//
//  MovieCakerManager.h
//  MovieCaker
//
//  Created by iKevin on 2013/11/14.
//  Copyright (c) 2013年 iKevin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TopicReply.h"
#import "VideoObj.h"
#import "TopicObj.h"
#import "FriendObj.h"
#import "SchoolPartyObj.h"


@interface MovieCakerManager : NSObject

+ (MovieCakerManager *)sharedInstance;

// misc
- (BOOL)isFirstTimeLaunched;
- (void)savePushToken:(NSString *)token;
- (NSString *)getPushToken;

-(void)saveLoginInfo:(NSDictionary *)dic;
-(void)saveLoginAccount:(NSString *)account withPwd:(NSString *)password;
//登出
-(void)logout;
-(NSDictionary *)getLoginUnfo;
-(BOOL)isLogined;



-(NSString *)invitingCount;
-(NSString *)notificationCount;
-(NSString *)inboxCount;
-(BOOL)saveInviting:(NSInteger)inviteCount;

// 提醒
- (void)resetNotice:(NSString *)type success:(void (^)(BOOL showLocalNotification, NSString *errorMsg, NSError *error))callback;

// 提醒
- (void)notice:(NSString *)type success:(void (^)(BOOL showLocalNotification, NSString *errorMsg, NSError *error))callback;

// 邀請
- (void)inviting:(void (^)(NSArray *dataArray, NSString *errorMsg, NSError *error))callback;
// 通知
- (void)notification:(NSNumber *)page success:(void (^)(NSArray *dataArray, NSString *errorMsg, NSError *error))callback;
// 消息
- (void)inbox:(NSNumber *)page success:(void (^)(NSArray *dataArray, NSString *errorMsg, NSError *error))callback;

//專題從網路
- (void)getTopicWithId:(NSString *)uid
               channel:(NSString *)channel
              withPage:(NSNumber *)page
              callback:(void (^)(NSArray *topicArray, NSString *errorMsg, NSError *error))callback;
//專題從資料庫
- (void)getTopicFromDbWithId:(NSString *)uid channel:(NSString *)channel withPage:(NSNumber *)page callback:(void (^)(NSArray *topicArray, NSString *errorMsg, NSError *error))callback;

//專題回應
- (void)getTopicReplyWithId:(NSNumber *)topicID
                   callback:(void (^)(NSArray *replys, NSString *errorMsg, NSError *error))callback;

- (NSArray *)getTopicReplyWithTopicID:(NSNumber *)topicID;

//影片從網路
- (void)getVideoWithTopicID:(NSNumber *)topicID
                    channel:(NSString *)channel
                    withUID:(NSString *)uid
                   withYear:(NSNumber *)year
                  withMonth:(NSNumber *)month
                   withPage:(NSNumber *)page
                 withMyType:(NSNumber *)myType
                withActorID:(NSNumber *)actorId
                   callback:(void (^)(NSArray *videoArray, NSString *errorMsg, NSError *error))callback;

//單一影片
- (void)getVideoWithVideoID:(NSString *)videoId
                    callback:(void (^)(VideoObj *video,NSMutableArray *actorArray,NSString *errorMsg, NSError *error))callback;

//單一專題
- (void)getTopicWithTopicID:(NSNumber *)topicId
                   callback:(void (^)(TopicObj *topic, NSString *errorMsg, NSError *error))callback;
//影片從資料庫
- (void)getVideoFromDbWithTopicID:(NSNumber *)topicID
                          channel:(NSString *)channel
                          withUID:(NSString *)uid
                         withYear:(NSNumber *)year
                        withMonth:(NSNumber *)month
                         withPage:(NSNumber *)page
                       withMyType:(NSNumber *)myType
                      withActorID:(NSNumber *)actorId
                         callback:(void (^)(NSArray *videoArray, NSString *errorMsg, NSError *error))callback;
//影評
- (void)getVideoReviewWithId:(NSString *)videoID
              callback:(void (^)(NSArray *reviewArray, NSString *errorMsg, NSError *error))callback;

//影片陣容
- (NSArray *)getActorWithVideoId:(NSString *)videoId;

//社團列表
- (void)getSchoolPartyWithChannel:(NSString *)channel
                         withPage:(NSNumber *)page
                          withUid:(NSString *)uid
                         callback:(void (^)(NSArray *partyArray, NSString *errorMsg, NSError *error))callback;

//單一社團
- (void)clubWithId:(NSNumber *)clubID
           callback:(void (^)(SchoolPartyObj *party, NSString *errorMsg, NSError *error))callback;

//社團話題
- (void)getTalkWithId:(NSNumber *)clubID
           withTalkId:(NSNumber *)talkId
                 page:(NSNumber *)page
             callback:(void (^)(NSMutableArray *talkArray, NSString *errorMsg, NSError *error))callback;

//社團話題回應列表
- (void)clubTopicMessageWithId:(NSNumber *)ID
                          page:(NSNumber *)page
                              callback:(void (^)(NSArray *talkArray, NSString *errorMsg, NSError *error))callback;

//社團話題回應
- (void)leaveMessageWithId:(NSNumber *)culbId
               withMessage:(NSString *)message
               withReplyId:(NSNumber *)replyId
                  callback:(void (^)(NSDictionary *dict, NSString *errorMsg, NSError *error))callback;

// 社團新增話題
- (void)createTopicWithId:(NSNumber *)culbId
                withTopicName:(NSString *)topicName
                withTopicDesc:(NSString *)topicDesc
                      callback:(void (^)(NSDictionary *JSON, NSString *errorMsg, NSError *error))callback;
//社團成員
- (void)getMemberWithId:(NSNumber *)clubID
              withtType:(NSString *)type
              withtPage:(NSNumber *)page
               callback:(void (^)(NSMutableArray *memberArray, NSString *errorMsg, NSError *error))callback;
//加入社團
- (void)joinParty:(NSNumber *)culbId
         callback:(void (^)(NSNumber *result, NSString *errorMsg, NSError *error))callback;
//退出社團
- (void)quitParty:(NSNumber *)culbId
         callback:(void (^)(NSNumber *result, NSString *errorMsg, NSError *error))callback;

//登入
- (void)getLoginWithAccount:(NSString *)account
               withPassword:(NSString *)password
               withRemember:(BOOL)remember
                   callback:(void (^)(NSDictionary *loginInfo, NSString *errorMsg, NSError *error))callback;

//個人資料
- (void)userProfile:(NSNumber *)userId
           callback:(void (^)(FriendObj *friend, NSString *errorMsg, NSError *error))callback;

//修改個人資料
- (void)saveUserProfile:(NSDictionary *)userInfo
               callback:(void (^)(NSDictionary *loginInfo, NSString *errorMsg, NSError *error))callback;
//邀請朋友
-(void)invitFiend:(NSString *)userId
         callback:(void (^)(NSDictionary *result, NSString *errorMsg, NSError *error))callback;

//進階搜尋
-(void)search:(NSString *)term
         type:(NSString *)type
         page:(NSNumber *)page
     callback:(void (^)(NSMutableArray *listArray, NSString *errorMsg, NSError *error))callback;

- (void)myFriendsWithUserID:(NSNumber *)userId withPage:(NSNumber *)page
                   callback:(void (^)(NSArray *friendArray, NSString *errorMsg, NSError *error))callback;

- (void)activityWithUserId:(NSNumber *)userId withPage:(NSNumber *)page withStatus:(NSString *)status
                    callback:(void (^)(NSArray *activityArray, NSString *errorMsg, NSError *error))callback;
//喜歡 看過 想看
- (void)like:(NSString *)videoId withCol:(NSString *)col
    callback:(void (^)(NSNumber *count, NSString *errorMsg, NSError *error))callback;

//喜歡專題
- (void)likeTopic:(NSNumber *)TopicId
         callback:(void (^)(NSNumber *count, NSString *errorMsg, NSError *error))callback;
//喜歡話題
- (void)likeClubTopic:(NSNumber *)talkId
             callback:(void (^)(NSNumber *count, NSString *errorMsg, NSError *error))callback;
//選擇語系
- (void)changeLang:(void (^)(NSNumber *count, NSString *errorMsg, NSError *error))callback;

// misc
- (BOOL)hasInternetConnection;
@end
