//
//  APIManager.m
//  MovieCaker
//
//  Created by iKevin on 2013/11/14.
//  Copyright (c) 2013年 iKevin. All rights reserved.
//

#import "APIManager.h"
#import "AFNetworking.h"
#import "AFDownloadRequestOperation.h"
#import "Reachability.h"

@interface APIManager()
@property (nonatomic, strong) AFHTTPClient *storeClient;
@property (nonatomic, assign) UIBackgroundTaskIdentifier *backgroundTaskIdentifier;
@property (nonatomic, strong) NSOperationQueue *operationQueue;
@property (nonatomic, strong) AFDownloadRequestOperation *currentDownloadOp;
@property (nonatomic, assign) BOOL shouldPause;
@end


@implementation APIManager


#pragma mark - init and setup

- (id)init
{
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup
{

    self.storeClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:PROPUCTION_API_DOMAIN]];
    [self.storeClient setParameterEncoding:AFJSONParameterEncoding];
    //[self.storeClient registerHTTPOperationClass:[AFJSONRequestOperation class]];
    
    self.operationQueue = [[NSOperationQueue alloc] init];
    
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    
    [center addObserverForName:UIApplicationDidEnterBackgroundNotification
                        object:nil
                         queue:[NSOperationQueue mainQueue]
                    usingBlock:^(NSNotification *note) {
                        
                        if(self.shouldPause)
                            [self.currentDownloadOp pause];
                        
                    }];
    
    [center addObserverForName:UIApplicationWillEnterForegroundNotification
                        object:nil
                         queue:[NSOperationQueue mainQueue]
                    usingBlock:^(NSNotification *note) {
                        
                        if(self.shouldPause)
                        {
                            [self.currentDownloadOp resume];
                            self.shouldPause = NO;
                        }
                        
                    }];
    
    [self.storeClient setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        
        if(status == AFNetworkReachabilityStatusNotReachable)
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:NETWORK_DISCONNECTED_NOTIF object:nil];
        }
        else
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:NETWORK_CONNECTED_NOTIF object:nil];
        }
        
    }];
    
}
#pragma mark - 提醒

- (void)notice:(NSString *)type success:(void (^)(NSData *data))success failure:(void (^)(NSString *errorMsg, NSError *error))failure
{
    NSDictionary *param=nil;
    NSString *path=@"api/Notice";
    
    if ([type isEqualToString:@"Inviting"]) {
        path=@"api/Inviting";
    }else{
        path=@"api/Notice";
        param=@{@"type":type};
    }
    
    [self.storeClient getPath:path
                   parameters:param
                      success:^(AFHTTPRequestOperation *operation, id responseObject) {
                          
                          NSLog(@"%@：%@",type,operation.responseString);
                          
                          if(success)
                              success(responseObject);
                          
                      } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                          
                          if(failure)
                              failure(@"目前無法取得資料", error);
                          
                      }
     ];
    
}


#pragma mark - 邀請歸零
- (void)resetNotice:(NSString *)type success:(void (^)(NSData *data))success failure:(void (^)(NSString *errorMsg, NSError *error))failure
{
    NSDictionary *param=@{@"type":type};
    
    [self.storeClient postPath:@"api/Notice"
                   parameters:param
                      success:^(AFHTTPRequestOperation *operation, id responseObject) {
                          
                           NSLog(@"%@：%@",type,operation.responseString);
                          
                          if(success)
                              success(responseObject);
                          
                      } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                          
                          NSLog(@"%@：%@",type,operation.responseString);
                          
                          if(failure)
                              failure(@"目前無法取得資料", error);
                          
                      }
     ];
    
}
#pragma mark - 邀請

- (void)inviting:(void (^)(NSData *data))success failure:(void (^)(NSString *errorMsg, NSError *error))failure
{
    
    [self.storeClient getPath:@"api/Inviting"
                   parameters:nil
                      success:^(AFHTTPRequestOperation *operation, id responseObject) {
                          NSLog(@"取得邀請：%@",operation.responseString);
                          if(success)
                              success(responseObject);
                          
                      } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                          NSLog(@"取得邀請：%@",operation.responseString);
                          if(failure)
                              failure(@"目前無法取得資料", error);
                          
                      }
     ];
    
}

#pragma mark - 通知
- (void)notification:(NSNumber *)page success:(void (^)(NSData *data))success failure:(void (^)(NSString *errorMsg, NSError *error))failure
{
    
    NSDictionary *param=@{@"page":page};
    NSLog(@"%@",param);
    
    [self.storeClient getPath:@"api/Notification"
                   parameters:param
                      success:^(AFHTTPRequestOperation *operation, id responseObject) {
                        
                          NSLog(@"取得通知：%@",operation.responseString);
                          if(success)
                              success(responseObject);
                          
                      } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                          //NSLog(@"取得通知：%@",operation.responseString);
                          if(failure)
                              failure(@"目前無法取得資料", error);
                          
                      }
     ];
    
}

#pragma mark - 消息
- (void)inbox:(NSNumber *)page success:(void (^)(NSData *data))success failure:(void (^)(NSString *errorMsg, NSError *error))failure
{
    NSDictionary *param=@{@"page":page};
    NSLog(@"%@",param);
    [self.storeClient getPath:@"api/Inbox"
                   parameters:param
                      success:^(AFHTTPRequestOperation *operation, id responseObject) {
                          
                          NSLog(@"取得消息：%@",operation.responseString);
                          
                          if(success)
                              success(responseObject);
                          
                      } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                          NSLog(@"取得消息：%@",operation.responseString);
                          if(failure)
                              failure(@"目前無法取得資料", error);
                          
                      }
     ];
    
}

#pragma mark - 專題相關
- (void)downloadTopicWithId:(NSString *)uid
                    channel:(NSString *)type
                   withPage:(NSNumber *)page
                    success:(void (^)(NSData *data))success
                    failure:(void (^)(NSString *errorMsg, NSError *error))failure
{
    
    NSDictionary *param=@{@"type":type,@"uid":uid,@"page":page};
                          
    [self.storeClient getPath:@"api/topic"
                   parameters:param
                      success:^(AFHTTPRequestOperation *operation, id responseObject) {
                          
                          NSLog(@"%@",operation.responseString);
                          if(success)
                              success(responseObject);
                          
                      } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                          
                          NSLog(@"%@",operation.responseString);
                          
                          if(failure)
                              failure(@"目前無法取得資料", error);
                          
                      }
     ];

}

#pragma mark - 專題回應相關

- (void)downloadTopicReplyWithId:(NSNumber *)topicID
                         success:(void (^)(NSData *data))success
                         failure:(void (^)(NSString *errorMsg, NSError *error))failure
{
    NSDictionary *param=@{@"topicID":topicID.stringValue};
    
    NSLog(@"%@",param);
    
    [self.storeClient getPath:@"api/TopicMessage"
                   parameters:param
                      success:^(AFHTTPRequestOperation *operation, id responseObject) {
                          
                          NSLog(@"%@",operation.responseString);
                          if(success)
                              success(responseObject);
                          
                      } failure:^(AFHTTPRequestOperation *operation, NSError *error) {

                          if(failure)
                              failure(@"目前無法取得資料", error);
                          
                      }
     ];

    
}

#pragma mark - 影片
- (void)downloadVideoWithTopicID:(NSNumber *)topicID
                         channel:(NSString *)type
                         withUID:(NSString *)uid
                        withYear:(NSNumber *)year
                       withMonth:(NSNumber *)month
                        withPage:(NSNumber *)page
                        withMyType:(NSNumber *)myType
                     withActorID:(NSNumber *)actorId
                    success:(void (^)(NSData *data))success
                    failure:(void (^)(NSString *errorMsg, NSError *error))failure
{
    NSDictionary *param;
    
    if([type isEqualToString:@"InTopic"]){
        param=@{@"topicId":topicID.stringValue,@"type":type,@"page":page};
    }else if([type isEqualToString:@"Week"]){
        param=@{@"type":type,@"page":page};
    }else if([type isEqualToString:@"Friend"]){
        param=@{@"uid":uid,@"type":type,@"page":page};
    }else if([type isEqualToString:@"Global"]){
        param=@{@"y":year.stringValue,@"m":month.stringValue,@"type":type,@"page":page};
    }else if([type isEqualToString:@"My"]){
        param=@{@"uid":uid,@"type":type,@"page":page,@"myType":myType,@"limit":@(9)};
    }else if ([type isEqualToString:@"Actor"]){
        param=@{@"type":type,@"page":page,@"actorId":actorId};
    }else{
        param=@{@"topicId":topicID.stringValue,@"type":@"InTopic",@"page":page};
    }
    
    NSLog(@"api/video:%@",param);
    
    [self.storeClient getPath:@"api/video"
                   parameters:param
                      success:^(AFHTTPRequestOperation *operation, id responseObject) {
                          
                          NSLog(@"video:%@",operation.responseString);
                          
                          if(success)
                              success(responseObject);
                          
                      } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                          //NSLog(@"%@",operation.responseString);
                          if(failure)
                              failure(@"目前無法取得資料", error);
                          
                      }
     ];
    
}

#pragma mark - 單一影片
- (void)downloadVideoWithVideoID:(NSString *)videoId
                         success:(void (^)(NSData *data))success
                         failure:(void (^)(NSString *errorMsg, NSError *error))failure
{
    NSDictionary *param=@{@"vid":videoId};

    NSLog(@"%@",param);
    
    [self.storeClient getPath:@"api/video"
                   parameters:param
                      success:^(AFHTTPRequestOperation *operation, id responseObject) {
                          
                          //NSLog(@"%@",operation.responseString);
                          if(success)
                              success(responseObject);
                          
                      } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                          //NSLog(@"%@",operation.responseString);
                          if(failure)
                              failure(@"目前無法取得資料", error);
                          
                      }
     ];
    
}


#pragma mark - 單一專題
- (void)downloadTopicWithTopicID:(NSNumber *)topicId
                          success:(void (^)(NSData *data))success
                          failure:(void (^)(NSString *errorMsg, NSError *error))failure
{
    NSDictionary *param=@{@"tid":topicId.stringValue};
    NSLog(@"%@",param);
    
    [self.storeClient getPath:@"api/topic"
                   parameters:param
                      success:^(AFHTTPRequestOperation *operation, id responseObject) {
                          NSLog(@"單一專題:%@",operation.responseString);
                          if(success)
                              success(responseObject);
                          
                      } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                          //NSLog(@"%@",operation.responseString);
                          if(failure)
                              failure(@"目前無法取得資料", error);
                          
                      }
     ];
    
}

#pragma mark - 影評
- (void)downloadVideoReviewWithId:(NSString *)videoID
                          success:(void (^)(NSData *data))success
                          failure:(void (^)(NSString *errorMsg, NSError *error))failure {
    
    NSDictionary *param=@{@"videoId":videoID};
    
    [self.storeClient getPath:@"api/VideoReview"
                   parameters:param
                      success:^(AFHTTPRequestOperation *operation, id responseObject) {
                          
                          NSLog(@"%@",operation.responseString);
                          if(success)
                              success(responseObject);
                          
                      } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                          
                          if(failure)
                              failure(@"目前無法取得資料", error);
                          
                      }
     ];
    
}

#pragma mark - 社團列表
- (void)downloadSchoolPartyWithChannel:(NSString *)channel
                              withPage:(NSNumber *)page
                               withUid:(NSString *)uid
                               success:(void (^)(NSData *data))success
                               failure:(void (^)(NSString *errorMsg, NSError *error))failure {
    
    NSDictionary *param=nil;
    
    if ([channel isEqualToString:@"discover"]) {
        param=@{@"page":page};
    }else{
        param=@{@"type":channel,@"uid":uid,@"page":page};
    }
    
    NSLog(@"%@",param);

    [self.storeClient getPath:@"api/club"
                   parameters:param
                      success:^(AFHTTPRequestOperation *operation, id responseObject) {
                          
                          NSLog(@"%@",operation.responseString);
                          
                          if(success)
                              success(responseObject);
                          
                      } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                          NSLog(@"%@",operation.responseString);
                          if(failure)
                              failure(@"目前無法取得資料", error);
                          
                      }
     ];
    
}

#pragma mark - 單一社團
- (void)downloadClubWithId:(NSNumber *)clubID
                   success:(void (^)(NSData *data))success
                   failure:(void (^)(NSString *errorMsg, NSError *error))failure{
    
    NSString *path=[NSString stringWithFormat:@"api/club/%@",clubID.stringValue];
    
    [self.storeClient getPath:path
                   parameters:nil
                      success:^(AFHTTPRequestOperation *operation, id responseObject) {
                          
                          if(success)
                              success(responseObject);
                          
                      } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                          
                          if(failure)
                              failure(@"目前無法取得資料", error);
                          
                      }
     ];
    
}

#pragma mark - 加入社團
- (void)joinParty:(NSNumber *)culbId
          success:(void (^)(NSData *data))success
          failure:(void (^)(NSString *errorMsg, NSError *error))failure {
    
    NSDictionary *param=@{@"id":culbId.stringValue};
    NSLog(@"加入社團:%@",param);
    
    [self.storeClient postPath:@"Social/JoinClub"
                    parameters:param
                       success:^(AFHTTPRequestOperation *operation, id responseObject) {
                           NSLog(@"%@",operation.responseString);
                           if(success)
                               success(responseObject);
                           
                       } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                           NSLog(@"%@",operation.responseString);
                           if(failure)
                               failure(@"目前無法取得資料", error);
                           
                       }
     ];
    
}

#pragma mark - 退出社團
- (void)quitParty:(NSNumber *)culbId
          success:(void (^)(NSData *data))success
          failure:(void (^)(NSString *errorMsg, NSError *error))failure {
    
    NSDictionary *param=@{@"id":culbId.stringValue};
    NSLog(@"退出社團:%@",param);
    [self.storeClient postPath:@"Social/QuitClub"
                    parameters:param
                       success:^(AFHTTPRequestOperation *operation, id responseObject) {
                           
                           NSLog(@"%@",operation.responseString);
                           
                           if(success)
                               success(responseObject);
                           
                       } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                           
                           NSLog(@"%@",operation.responseString);
                           
                           if(failure)
                               failure(@"目前無法取得資料", error);
                           
                       }
     ];
    
}



#pragma mark - 社團話題
- (void)downloadTalkWithId:(NSNumber *)clubID
                withTalkId:(NSNumber *)talkId
                      page:(NSNumber *)page
                   success:(void (^)(NSData *data))success
                   failure:(void (^)(NSString *errorMsg, NSError *error))failure {
    
    NSString *path=[NSString stringWithFormat:@"api/clubtopic/%@",clubID.stringValue];
    NSDictionary *param=nil;
    if (talkId) {
        param=@{@"ctid":talkId.stringValue};
    }else{
        param=@{@"page":page};
    }
    
    NSLog(@"path:%@",path);
    NSLog(@"param:%@",param);

    [self.storeClient getPath:path
                   parameters:param
                      success:^(AFHTTPRequestOperation *operation, id responseObject) {
                          NSLog(@"社團話題：%@",operation.responseString);
                          if(success)
                              success(responseObject);
                          
                      } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                          NSLog(@"社團話題：%@",operation.responseString);
                          if(failure)
                              failure(@"目前無法取得資料", error);
                          
                      }
     ];
    
}

#pragma mark - 社團話題回應列表
- (void)downloadClubTopicMessageWithId:(NSNumber *)ID
                                  page:(NSNumber *)page
                   success:(void (^)(NSData *data))success
                   failure:(void (^)(NSString *errorMsg, NSError *error))failure {
    
    NSString *path=[NSString stringWithFormat:@"api/ClubTopicMessage/%@",ID.stringValue];
    NSDictionary *param=@{@"page":page};
    //ClubTopicId
    
    NSLog(@"%@",path);
    
    [self.storeClient getPath:path
                   parameters:param
                      success:^(AFHTTPRequestOperation *operation, id responseObject) {
                          
                          NSLog(@"社團話題回應列表：%@",operation.responseString);
                          
                          if(success)
                              success(responseObject);
                          
                      } failure:^(AFHTTPRequestOperation *operation, NSError *error) {

                          if(failure)
                              failure(@"目前無法取得資料", error);
                          
                      }
     ];
    
}
#pragma mark - 社團話題回應
- (void)postLeaveMessageWithId:(NSNumber *)culbId
                   withMessage:(NSString *)message
                   withReplyId:(NSNumber *)replyId
                       success:(void (^)(NSData *data))success
                       failure:(void (^)(NSString *errorMsg, NSError *error))failure {
    
    NSDictionary *param=@{@"id":culbId,@"message":message,@"isApi":@"true"};
    
     NSLog(@"%@",param);
    
    [self.storeClient postPath:@"Social/LeaveMessage"
                    parameters:param
                       success:^(AFHTTPRequestOperation *operation, id responseObject) {
                           
                           NSLog(@"%@",operation.responseString);
                           
                          if(success)
                              success(responseObject);
                          
                      } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                          if(failure)
                              failure(@"目前無法取得資料", error);
                          
                      }
     ];
    
}

#pragma mark - 社團新增話題
- (void)postCreateTopicWithId:(NSNumber *)culbId
                   withTopicName:(NSString *)topicName
                   withTopicDesc:(NSString *)topicDesc
                       success:(void (^)(NSData *data))success
                       failure:(void (^)(NSString *errorMsg, NSError *error))failure {
    
    NSDictionary *param=@{@"ClubId":culbId,@"ClubTopicName":topicName,@"ClubTopicDesc":topicDesc};
    
    NSLog(@"%@",param);
    
    [self.storeClient postPath:@"api/ClubTopic"
                    parameters:param
                       success:^(AFHTTPRequestOperation *operation, id responseObject) {
                             NSLog(@"%@",operation.responseString);
                           if(success)
                               success(responseObject);
                           
                       } failure:^(AFHTTPRequestOperation *operation, NSError *error) {

                           if(failure)
                               failure(@"目前無法取得資料", error);
                           
                       }
     ];
    
}


#pragma mark - 社團成員
- (void)downloadMemberWithId:(NSNumber *)clubID
                   withtType:(NSString *)type
                   withtPage:(NSNumber *)page
                     success:(void (^)(NSData *data))success
                     failure:(void (^)(NSString *errorMsg, NSError *error))failure {
    
    NSString *path=[NSString stringWithFormat:@"api/clubmember/%@",clubID.stringValue];
    NSDictionary *param=nil;
    
    param=@{@"type":type,@"page":page};
    NSLog(@"%@",param);
    
    [self.storeClient getPath:path
                   parameters:param
                      success:^(AFHTTPRequestOperation *operation, id responseObject) {

                          NSLog(@"社團成員：%@",operation.responseString);
                          
                          if(success)
                              success(responseObject);
                          
                      } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                          
                          if(failure)
                              failure(@"目前無法取得資料", error);
                          
                      }
     ];
    
}


#pragma mark - 登入
- (void)loginWithAccount:(NSString *)account
            withPassword:(NSString *)password
            withRemember:(BOOL)remember
                 success:(void (^)(NSData *data))success
                 failure:(void (^)(NSString *errorMsg, NSError *error))failure {
    
    NSDictionary *param=nil;
    param=@{@"Email":account,@"Password":password,@"RememberMe":@"true"};
    //NSLog(@"%@",param);
    
    [self.storeClient postPath:@"account/ajaxlogin"
                    parameters:param
                       success:^(AFHTTPRequestOperation *operation, id responseObject) {
                           
                           NSLog(@"%@",operation.responseString);
                           
                           /*
                           NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies];
                           for (NSHTTPCookie *cookie in cookies) {
                               // Here I see the correct rails session cookie
                               NSLog(@"cookie: %@", cookie);
                           }
                            */
                           
                           if(success)
                               success(responseObject);
                           
                       } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                           NSLog(@"%@",operation.responseString);
                           if(failure)
                               failure(@"目前無法取得資料", error);
                           
                       }
     ];
    
}

#pragma mark - 登出
- (void)logout:(void (^)(NSData *data))success
       failure:(void (^)(NSString *errorMsg, NSError *error))failure{
    
    [self.storeClient postPath:@"Account/AjaxLogoff"
                    parameters:nil
                       success:^(AFHTTPRequestOperation *operation, id responseObject) {
                           
                           //NSLog(@"%@",operation.responseString);
                           if(success)
                               success(responseObject);
                           
                       } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                          // NSLog(@"%@",operation.responseString);
                           if(failure)
                               failure(@"目前無法取得資料", error);
                           
                       }
     ];
    
}

#pragma mark - 個人資料

- (void)userProfile:(NSNumber *)userId
                 success:(void (^)(NSData *data))success
                 failure:(void (^)(NSString *errorMsg, NSError *error))failure{
    
    NSString *path=[NSString stringWithFormat:@"api/userprofile/%@",userId.stringValue];
   // NSString *path=[NSString stringWithFormat:@"api/Friend/%@",userId.stringValue];
    [self.storeClient getPath:path
                    parameters:nil
                       success:^(AFHTTPRequestOperation *operation, id responseObject) {
                           
                           if(success)
                               success(responseObject);
                           
                       } failure:^(AFHTTPRequestOperation *operation, NSError *error) {

                           if(failure)
                               failure(@"目前無法取得資料", error);
                           
                       }
     ];
    
}

#pragma mark - 修改個人資料

- (void)saveUserProfile:(NSDictionary *)userInfo
            success:(void (^)(NSData *data))success
            failure:(void (^)(NSString *errorMsg, NSError *error))failure{
    
   // NSString *path=[NSString stringWithFormat:@"api/userprofile/%@",userId.stringValue];

    [self.storeClient postPath:@"api/userprofile"
                   parameters:userInfo
                      success:^(AFHTTPRequestOperation *operation, id responseObject) {
                          

                          if(success)
                              success(responseObject);
                          
                      } failure:^(AFHTTPRequestOperation *operation, NSError *error) {

                          if(failure)
                              failure(@"目前無法取得資料", error);
                          
                      }
     ];
    
}


#pragma mark - 邀請朋友
-(void)invitFiend:(NSString *)userId
          success:(void (^)(NSData *data))success
          failure:(void (^)(NSString *errorMsg, NSError *error))failure {
    
    NSString *path=[NSString stringWithFormat:@"api/inviting/Invite/%@",userId];
    
    NSLog(@"%@",path);
    
    [self.storeClient postPath:path
                    parameters:nil
                       success:^(AFHTTPRequestOperation *operation, id responseObject) {
                           
                           NSLog(@"%@",operation.responseString);
                           if(success)
                               success(responseObject);
                           
                       } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                        NSLog(@"%@",operation.responseString);
                           if(failure)
                               failure(@"目前無法取得資料", error);
                           
                       }
     ];

}

#pragma mark - 進階搜尋
-(void)search:(NSString *)term
         type:(NSString *)type
         page:(NSNumber *)page
      success:(void (^)(NSData *data))success
      failure:(void (^)(NSString *errorMsg, NSError *error))failure{
    
    NSDictionary *param=@{@"term":term,@"type":type,@"page":page,@"lableCn":@(1)};
    
    NSLog(@"search:%@",param);
    
    [self.storeClient getPath:@"api/Search"
                    parameters:param
                       success:^(AFHTTPRequestOperation *operation, id responseObject) {
                           
                           NSLog(@"搜尋：%@",operation.responseString);
                           
                           if(success)
                               success(responseObject);
                           
                       } failure:^(AFHTTPRequestOperation *operation, NSError *error) {

                           if(failure)
                               failure(@"目前無法取得資料", error);
                           
                       }
     ];
    
}

#pragma mark - 我的朋友

- (void)myFriendsWithUserID:(NSNumber *)userId withPage:(NSNumber *)page
                 success:(void (^)(NSData *data))success
                 failure:(void (^)(NSString *errorMsg, NSError *error))failure {
    
    NSString *path=[NSString stringWithFormat:@"api/Friend/%@",userId.stringValue];
    NSDictionary *param=nil;
    param=@{@"page":page};
    NSLog(@"%@",path);
    NSLog(@"%@",param);
    
    [self.storeClient getPath:path
                    parameters:param
                       success:^(AFHTTPRequestOperation *operation, id responseObject) {
                           NSLog(@"%@",operation.responseString);
                           
                           if(success)
                               success(responseObject);
                           
                       } failure:^(AFHTTPRequestOperation *operation, NSError *error) {

                           if(failure)
                               failure(@"目前無法取得資料", error);
                           
                       }
     ];
    
}

#pragma mark - 我的動態
- (void)myActivityWithUserId:(NSNumber *)userId withPage:(NSNumber *)page withStatus:(NSString *)status
                    success:(void (^)(NSData *data))success
                    failure:(void (^)(NSString *errorMsg, NSError *error))failure {
    
    NSString *path;
    
    if ([status isEqualToString:@"userStatus"]) {
        path=[NSString stringWithFormat:@"api/UserStatus/%@",userId.stringValue];
    }else{
        path=[NSString stringWithFormat:@"api/FriendStatus/%@",userId.stringValue];
    }

    NSLog(@"%@",path);
    NSDictionary *param=nil;
    param=@{@"page":page};
    
    [self.storeClient getPath:path
                   parameters:param
                      success:^(AFHTTPRequestOperation *operation, id responseObject) {
                          
                          NSLog(@"動態:%@",operation.responseString);
                          
                          if(success)
                              success(responseObject);
                          
                      } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                          
                          if(failure)
                              failure(@"目前無法取得資料", error);
                          
                      }
     ];
    
}

#pragma mark - 喜歡 看過 想看
- (void)like:(NSString *)videoId withCol:(NSString *)col
     success:(void (^)(NSData *data))success
     failure:(void (^)(NSString *errorMsg, NSError *error))failure {
    
    NSDictionary *param=nil;
    param=@{@"id":videoId,@"col":col};
    NSLog(@"%@",param);
    
    [self.storeClient postPath:@"data/addlinks"
                   parameters:param
                      success:^(AFHTTPRequestOperation *operation, id responseObject) {
                          
                          NSLog(@"xxx:%@",operation.responseString);
                          
                          if(success)
                              success(responseObject);
                          
                      } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                          
                          if(failure)
                              failure(@"目前無法取得資料", error);
                          
                      }
     ];
    
}

#pragma mark -喜歡專題
- (void)likeTopic:(NSNumber *)TopicId
          success:(void (^)(NSData *data))success
          failure:(void (^)(NSString *errorMsg, NSError *error))failure{
    
    NSDictionary *param=nil;
    param=@{@"id":TopicId.stringValue};
    NSLog(@"%@",param);
    
    [self.storeClient postPath:@"Topic/LikeThisTopic"
                    parameters:param
                       success:^(AFHTTPRequestOperation *operation, id responseObject) {
                           

                           
                           if(success)
                               success(responseObject);
                           
                       } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                           
                           if(failure)
                               failure(@"目前無法取得資料", error);
                           
                       }
     ];

    
}
#pragma mark -喜歡話題
- (void)likeClubTopic:(NSNumber *)talkId
          success:(void (^)(NSData *data))success
          failure:(void (^)(NSString *errorMsg, NSError *error))failure{
    
    NSDictionary *param=nil;
    param=@{@"Id":talkId.stringValue};
    
    
    NSString *path=[NSString stringWithFormat:@"api/ClubTopic/Like/%@",talkId.stringValue];
    NSLog(@"path:%@",path);
    
    [self.storeClient postPath:path
                    parameters:nil
                       success:^(AFHTTPRequestOperation *operation, id responseObject) {
                           
                           NSLog(@"%@",operation.responseString);
                           
                           if(success)
                               success(responseObject);
                           
                       } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                           NSLog(@"%@",operation.responseString);
                           if(failure)
                               failure(@"目前無法取得資料", error);
                           
                       }
     ];
    
    
}


#pragma mark -交友邀請
- (void)invitingAction:(NSNumber *)userId
                  type:(NSString *)type
          success:(void (^)(NSData *data))success
          failure:(void (^)(NSString *errorMsg, NSError *error))failure{
    

    NSString *path=[NSString stringWithFormat:@"api/Inviting/%@/%@",type,userId.stringValue];
    
    NSLog(@"%@",path);
    
    
    [self.storeClient postPath:path
                    parameters:nil
                       success:^(AFHTTPRequestOperation *operation, id responseObject) {
                           
                            NSLog(@"%@",operation.responseString);
                           
                           if(success)
                               success(responseObject);
                           
                       } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                            NSLog(@"%@",operation.responseString);
                           if(failure)
                               failure(@"目前無法取得資料", error);
                           
                       }
     ];
    
    
}

#pragma mark -選擇語系
- (void)changeLang:(void (^)(NSData *data))success failure:(void (^)(NSString *errorMsg, NSError *error))failure{
    NSArray *languages = [NSLocale preferredLanguages];
    NSString *lang = [languages objectAtIndex:0];
    NSString *path=@"/Home/ChangeLang/zh-CN?App=True";
    if ([lang isEqualToString:@"zh-Hant"]) {
        path=@"/Home/ChangeLang/zh-TW?App=True";
    }
    
    NSLog(@"lang:%@",path);
    
    [self.storeClient getPath:path
                    parameters:nil
                       success:^(AFHTTPRequestOperation *operation, id responseObject) {
                           
                           NSLog(@"%@",operation.description);
                           
                           NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies];
                           for (NSHTTPCookie *cookie in cookies) {
                               // Here I see the correct rails session cookie
                               NSLog(@"cookie: %@", cookie);
                           }

                           if(success)
                               success(responseObject);
                           
                       } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                           NSLog(@"%@",operation.responseString);
                           if(failure)
                               failure(@"目前無法取得資料", error);
                           
                       }
     ];
    
    
}

- (BOOL)connectedToInternet
{
    Reachability* reach = [Reachability reachabilityWithHostname:@"www.google.com"];
    if([reach isReachable]) {
         return YES;
    }
    return NO;
}

#pragma mark - singleton implementation code

//static APIManager *singletonManager = nil;
+ (APIManager *)sharedInstance {
    
    static dispatch_once_t pred;
    static APIManager *manager;
    
    dispatch_once(&pred, ^{
        manager = [[self alloc] init];
    });
    return manager;
}

@end
