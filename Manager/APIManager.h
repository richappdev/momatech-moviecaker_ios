//
//  APIManager.h
//  MovieCaker
//
//  Created by iKevin on 2013/11/14.
//  Copyright (c) 2013年 iKevin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface APIManager : NSObject
+ (APIManager *)sharedInstance;

//邀請歸零
- (void)resetNotice:(NSString *)type success:(void (^)(NSData *data))success failure:(void (^)(NSString *errorMsg, NSError *error))failure;
//提醒
- (void)notice:(NSString *)type success:(void (^)(NSData *data))success failure:(void (^)(NSString *errorMsg, NSError *error))failure;

// 邀請
- (void)inviting:(void (^)(NSData *data))success failure:(void (^)(NSString *errorMsg, NSError *error))failure;

// 通知
- (void)notification:(NSNumber *)page success:(void (^)(NSData *data))success failure:(void (^)(NSString *errorMsg, NSError *error))failure;

// 消息
- (void)inbox:(NSNumber *)page success:(void (^)(NSData *data))success failure:(void (^)(NSString *errorMsg, NSError *error))failure;


// 專題相關
- (void)downloadTopicWithId:(NSString *)uid
                    channel:(NSString *)type
                   withPage:(NSNumber *)page
                    success:(void (^)(NSData *data))success
                    failure:(void (^)(NSString *errorMsg, NSError *error))failure;
// 專題回應相關
- (void)downloadTopicReplyWithId:(NSNumber *)topicID
                         success:(void (^)(NSData *data))success
                         failure:(void (^)(NSString *errorMsg, NSError *error))failure;
// 影片
- (void)downloadVideoWithTopicID:(NSNumber *)topicID
                         channel:(NSString *)type
                         withUID:(NSString *)uid
                        withYear:(NSNumber *)year
                       withMonth:(NSNumber *)month
                        withPage:(NSNumber *)page
                      withMyType:(NSNumber *)myType
                     withActorID:(NSNumber *)actorId
                         success:(void (^)(NSData *data))success
                         failure:(void (^)(NSString *errorMsg, NSError *error))failure;

//單一影片
- (void)downloadVideoWithVideoID:(NSString *)videoId
                          success:(void (^)(NSData *data))success
                          failure:(void (^)(NSString *errorMsg, NSError *error))failure;
//單一專題
- (void)downloadTopicWithTopicID:(NSNumber *)topicId
                          success:(void (^)(NSData *data))success
                          failure:(void (^)(NSString *errorMsg, NSError *error))failure;

// 影評
- (void)downloadVideoReviewWithId:(NSString *)videoID
                         success:(void (^)(NSData *data))success
                         failure:(void (^)(NSString *errorMsg, NSError *error))failure;

// 社團列表
- (void)downloadSchoolPartyWithChannel:(NSString *)channel
                              withPage:(NSNumber *)page
                               withUid:(NSString *)uid
                               success:(void (^)(NSData *data))success
                               failure:(void (^)(NSString *errorMsg, NSError *error))failure;

// 單一社團
- (void)downloadClubWithId:(NSNumber *)clubID
                   success:(void (^)(NSData *data))success
                   failure:(void (^)(NSString *errorMsg, NSError *error))failure;

// 社團話題
- (void)downloadTalkWithId:(NSNumber *)clubID
                withTalkId:(NSNumber *)talkId
                      page:(NSNumber *)page
                   success:(void (^)(NSData *data))success
                   failure:(void (^)(NSString *errorMsg, NSError *error))failure;

// 社團話題回應列表
- (void)downloadClubTopicMessageWithId:(NSNumber *)ID
                                  page:(NSNumber *)page
                               success:(void (^)(NSData *data))success
                               failure:(void (^)(NSString *errorMsg, NSError *error))failure;
// 社團話題回應
- (void)postLeaveMessageWithId:(NSNumber *)culbId
                   withMessage:(NSString *)message
                   withReplyId:(NSNumber *)replyId
                       success:(void (^)(NSData *data))success
                       failure:(void (^)(NSString *errorMsg, NSError *error))failure;

// 社團新增話題
- (void)postCreateTopicWithId:(NSNumber *)culbId
                withTopicName:(NSString *)topicName
                withTopicDesc:(NSString *)topicDesc
                      success:(void (^)(NSData *data))success
                      failure:(void (^)(NSString *errorMsg, NSError *error))failure;

// 社團成員
- (void)downloadMemberWithId:(NSNumber *)clubID
                   withtType:(NSString *)type
                   withtPage:(NSNumber *)page
                     success:(void (^)(NSData *data))success
                     failure:(void (^)(NSString *errorMsg, NSError *error))failure;
// 加入社團
- (void)joinParty:(NSNumber *)culbId
          success:(void (^)(NSData *data))success
          failure:(void (^)(NSString *errorMsg, NSError *error))failure;

// 退出社團
- (void)quitParty:(NSNumber *)culbId
          success:(void (^)(NSData *data))success
          failure:(void (^)(NSString *errorMsg, NSError *error))failure;

// 登入
- (void)loginWithAccount:(NSString *)account
            withPassword:(NSString *)password
            withRemember:(BOOL)remember
                 success:(void (^)(NSData *data))success
                 failure:(void (^)(NSString *errorMsg, NSError *error))failure;

// 登出
- (void)logout:(void (^)(NSData *data))success
       failure:(void (^)(NSString *errorMsg, NSError *error))failure;

//個人資料
- (void)userProfile:(NSNumber *)userId
            success:(void (^)(NSData *data))success
            failure:(void (^)(NSString *errorMsg, NSError *error))failure;

//修改個人資料
- (void)saveUserProfile:(NSDictionary *)userInfo
                success:(void (^)(NSData *data))success
                failure:(void (^)(NSString *errorMsg, NSError *error))failure;

//邀請朋友
-(void)invitFiend:(NSString *)userId
          success:(void (^)(NSData *data))success
          failure:(void (^)(NSString *errorMsg, NSError *error))failure;


//進階搜尋
-(void)search:(NSString *)term
         type:(NSString *)type
         page:(NSNumber *)page
      success:(void (^)(NSData *data))success
      failure:(void (^)(NSString *errorMsg, NSError *error))failure;

//我的朋友
- (void)myFriendsWithUserID:(NSNumber *)userId withPage:(NSNumber *)page
                    success:(void (^)(NSData *data))success
                    failure:(void (^)(NSString *errorMsg, NSError *error))failure;
//動態消息
- (void)myActivityWithUserId:(NSNumber *)userId withPage:(NSNumber *)page withStatus:(NSString *)status
                     success:(void (^)(NSData *data))success
                     failure:(void (^)(NSString *errorMsg, NSError *error))failure;
//喜歡 看過 想看 影片
- (void)like:(NSString *)videoId withCol:(NSString *)col
     success:(void (^)(NSData *data))success
     failure:(void (^)(NSString *errorMsg, NSError *error))failure;

//喜歡專題
- (void)likeTopic:(NSNumber *)TopicId
          success:(void (^)(NSData *data))success
          failure:(void (^)(NSString *errorMsg, NSError *error))failure;

//喜歡話題
- (void)likeClubTopic:(NSNumber *)talkId
              success:(void (^)(NSData *data))success
              failure:(void (^)(NSString *errorMsg, NSError *error))failure;

//交友邀請
- (void)invitingAction:(NSNumber *)userId
                  type:(NSString *)type
               success:(void (^)(NSData *data))success
               failure:(void (^)(NSString *errorMsg, NSError *error))failure;
//選擇語系
- (void)changeLang:(void (^)(NSData *data))success failure:(void (^)(NSString *errorMsg, NSError *error))failure;
// misc
- (BOOL)connectedToInternet;
@end
