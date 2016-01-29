//
//  MovieCakerManager.m
//  MovieCaker
//
//  Created by iKevin on 2013/11/14.
//  Copyright (c) 2013年 iKevin. All rights reserved.
//

#import "MovieCakerManager.h"
#import "APIManager.h"
#import "PersistentManager.h"
#import "UtilityManager.h"
#import "Constant.h"
#import "SearchObj.h"
#import "TalkObj.h"
#import "ActorObj.h"



@interface MovieCakerManager()
@property (nonatomic, strong) APIManager *apiManager;
@property (nonatomic, strong) PersistentManager *persistentManager;
@property (nonatomic, strong) NSMutableDictionary *imagePool;
@property (nonatomic, strong) NSUserDefaults *userDefaults;
@end

@implementation MovieCakerManager

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
    self.persistentManager = [PersistentManager sharedInstance];
    self.apiManager  = [APIManager sharedInstance];
    self.userDefaults=[NSUserDefaults standardUserDefaults];
    
}


#pragma mark - misc

- (BOOL)isFirstTimeLaunched
{
    NSLog(@"isFirstTimeLaunched");
    
    //return YES;
    BOOL launchedBefore = [self.userDefaults boolForKey:@"appLaunched"];
    
    if(launchedBefore)
        return NO;
    else
    {
        [self.userDefaults setBool:YES forKey:@"appLaunched"];
        [self.userDefaults synchronize];
        return YES;
    }
}

- (void)savePushToken:(NSString *)token
{
    [self.userDefaults setObject:token forKey:@"pushToken"];
    [self.userDefaults synchronize];
}

- (NSString *)getPushToken
{
    return [self.userDefaults stringForKey:@"pushToken"];
}

-(void)saveLoginInfo:(NSDictionary *)dic{
    [self.userDefaults setObject:dic forKey:@"loginInfo"];
    [self.userDefaults setBool:YES forKey:@"logined"];
    [self.userDefaults synchronize];
}

-(void)saveLoginAccount:(NSString *)account withPwd:(NSString *)password{
    [self.userDefaults setObject:account forKey:@"account"];
    [self.userDefaults setObject:password forKey:@"password"];
    [self.userDefaults synchronize];
}

-(void)logout{
    
    
    [self.apiManager logout:^(NSData *data) {
        //
    } failure:^(NSString *errorMsg, NSError *error) {
        //
    }];
    
    [self.userDefaults setObject:nil forKey:@"loginInfo"];
    [self.userDefaults setBool:NO forKey:@"logined"];
    [self.userDefaults synchronize];
}

-(NSDictionary *)getLoginUnfo{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"loginInfo"];
}

-(BOOL)isLogined{
    
    BOOL isLogin=[[NSUserDefaults standardUserDefaults] boolForKey:@"logined"];
    if (isLogin==YES) {
        return YES;
    }
    return NO;
}



//

-(BOOL)saveInviting:(NSInteger)inviteCount{
    BOOL showLocalNotification=NO;
    
    NSInteger ItemCount=[self.userDefaults integerForKey:@"inviting"];
    if (inviteCount>ItemCount) {
        showLocalNotification=YES;
    }
    [self.userDefaults setInteger:inviteCount forKey:@"inviting"];
    [self.userDefaults synchronize];
    
    return showLocalNotification;
}

-(NSString *)invitingCount{
    return [NSString stringWithFormat:@"%d",[self.userDefaults integerForKey:@"inviting"]];
}

-(BOOL)saveNotification:(NSInteger)notiCount{
    
    BOOL showLocalNotification=NO;
    
    NSInteger ItemCount=[self.userDefaults integerForKey:@"notification"];
    if (notiCount>ItemCount) {
        showLocalNotification=YES;
    }
    
    [self.userDefaults setInteger:notiCount forKey:@"notification"];
    [self.userDefaults synchronize];
    
    return showLocalNotification;

}

-(NSString *)notificationCount{
    return [NSString stringWithFormat:@"%d",[self.userDefaults integerForKey:@"notification"]];
}


-(BOOL)saveInbox:(NSInteger)inCount{
    
    BOOL showLocalNotification=NO;
    
    NSInteger ItemCount=[self.userDefaults integerForKey:@"inbox"];
    if (inCount>ItemCount) {
        showLocalNotification=YES;
    }
    [self.userDefaults setInteger:inCount forKey:@"inbox"];
    [self.userDefaults synchronize];
     return showLocalNotification;
}

-(NSString *)inboxCount{
    return [NSString stringWithFormat:@"%d",[self.userDefaults integerForKey:@"inbox"]];
}



#pragma mark - 即時通知

// 提醒歸零
- (void)resetNotice:(NSString *)type success:(void (^)(BOOL showLocalNotification, NSString *errorMsg, NSError *error))callback{
    
    [self.apiManager resetNotice:type success:^(NSData *data) {
        //NSDictionary *JSON = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        
        BOOL showLocalNotification=NO;
        if ([type isEqualToString:@"Message"]) {
            showLocalNotification=[self saveInbox:0];
        }
        
        if ([type isEqualToString:@"Notification"]) {
            showLocalNotification=[self saveNotification:0];
        }
        
        /*
        if ([type isEqualToString:@"Reminder"]) {
            showLocalNotification=[self saveInviting:0];
        }
        */
        
        if(callback)
            callback(showLocalNotification, nil,nil);
        
    } failure:^(NSString *errorMsg, NSError *error) {
        //
    }];
}
// 提醒
- (void)notice:(NSString *)type success:(void (^)(BOOL showLocalNotification, NSString *errorMsg, NSError *error))callback{
    
    [self.apiManager notice:type success:^(NSData *data) {
        NSDictionary *JSON = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        
        BOOL showLocalNotification=NO;
        
        //消息 --> 訊息,即時通...
        if ([type isEqualToString:@"Message"]) {
            showLocalNotification=[self saveInbox:[JSON[@"Data"] integerValue]];
        }
        
        //通知 --> 系統通知 -->
        if ([type isEqualToString:@"NotificationAndReminder"]) {
            showLocalNotification=[self saveNotification:[JSON[@"Data"] integerValue]];
        }
        
        //交友邀請 --> 改成 api/Inviting

        
        if ([type isEqualToString:@"Inviting"]) {
            NSArray *ary=JSON[@"Data"];
            showLocalNotification=[self saveInviting:ary.count];
        }
        
        
        if(callback)
            callback(showLocalNotification, nil,nil);
        
    } failure:^(NSString *errorMsg, NSError *error) {
        //
    }];
}

// 邀請
- (void)inviting:(void (^)(NSArray *dataArray, NSString *errorMsg, NSError *error))callback{
    
    [self.apiManager inviting:^(NSData *data) {
        NSDictionary *JSON = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        
        NSArray *dataArray=JSON[@"Data"];
        
        if(callback)
            callback(dataArray, nil,nil);
        
    } failure:^(NSString *errorMsg, NSError *error) {
        //
    }];
}

// 通知
- (void)notification:(NSNumber *)page success:(void (^)(NSArray *dataArray, NSString *errorMsg, NSError *error))callback{
    
    [self.apiManager notification:page success:^(NSData *data) {
        NSArray *JSON = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        NSArray *dataArray=JSON;

        
        if(callback)
            callback(dataArray, nil,nil);
        
    } failure:^(NSString *errorMsg, NSError *error) {
        //
    }];
    
}
// 消息
- (void)inbox:(NSNumber *)page success:(void (^)(NSArray *dataArray, NSString *errorMsg, NSError *error))callback{
    [self.apiManager inbox:page success:^(NSData *data) {
        
        NSArray *JSON = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        
        NSArray *dataArray=JSON;
        if (!dataArray) {
            dataArray=@[];
        }
        
        if(callback)
            callback(dataArray, nil,nil);
        
    } failure:^(NSString *errorMsg, NSError *error) {
        //
    }];
    
}
#pragma mark - 專題十大相關

- (void)getTopicWithId:(NSString *)uid channel:(NSString *)channel withPage:(NSNumber *)page callback:(void (^)(NSArray *topicArray, NSString *errorMsg, NSError *error))callback
{
    //NSString *cacheType = DATA_TYPE_TOPIC_LIST;
    //NSDictionary *cacheInfo = [[UtilityManager sharedInstance] getLocalCacheMeta:cacheType];
    
    BOOL connect=[self.apiManager connectedToInternet];
    
    if (connect) {
        
        NSLog(@"有連線");
        
        [self.apiManager downloadTopicWithId:uid
                                     channel:channel
                                    withPage:(NSNumber *)page
                                     success:^(NSData *data) {

            dispatch_async(dispatch_get_global_queue(0, 0), ^(void) {
                
                [self.persistentManager topicToDB:data channel:channel withPage:page];
                
                dispatch_async(dispatch_get_main_queue(), ^(void) {
                    
                NSArray *topicArray = [self.persistentManager getTopicWithChannel:channel];
                    if(callback)
                        callback(topicArray, nil,nil);
                
                    });
                });
        
        } failure:^(NSString *errorMsg, NSError *error) {
            if(callback)
                callback(nil, errorMsg, error);
        }];
        
    }else{
        
        dispatch_async(dispatch_get_global_queue(0, 0), ^(void) {
            
            NSArray *topicArray = [self.persistentManager getTopicWithChannel:channel];
            
            dispatch_async(dispatch_get_main_queue(), ^(void) {
                
                if(callback)
                    callback(topicArray, nil,nil);
                
            });
        });
    }
    
}
- (void)getTopicFromDbWithId:(NSString *)uid channel:(NSString *)channel withPage:(NSNumber *)page callback:(void (^)(NSArray *topicArray, NSString *errorMsg, NSError *error))callback
{
        //dispatch_async(dispatch_get_global_queue(0, 0), ^(void) {
            
            NSArray *topicArray = [self.persistentManager getTopicWithChannel:channel];
            
           // dispatch_async(dispatch_get_main_queue(), ^(void) {
                
                if(callback)
                    callback(topicArray, nil,nil);
                
           // });
       // });
}

#pragma mark - 專題回應
- (void)getTopicReplyWithId:(NSNumber *)topicID
                   callback:(void (^)(NSArray *replys, NSString *errorMsg, NSError *error))callback{
    
    BOOL connect=[self.apiManager connectedToInternet];
    
    if (connect) {
        
        NSLog(@"有連線");
        
        [self.apiManager downloadTopicReplyWithId:topicID
                                          success:^(NSData *data) {
                                            dispatch_async(dispatch_get_global_queue(0, 0), ^(void) {
                                                
                                              [self.persistentManager topicReplyToDB:data topicID:topicID];
                                                
                                              NSArray *replys = [self.persistentManager getFristTopicReplyWithID:topicID];
                                                
                                                NSLog(@"TopicReplyTopicReplyTopicReply");
                                            dispatch_async(dispatch_get_main_queue(), ^(void) {
                                                
                                                if(callback)
                                                    callback(replys, nil,nil);
                                                });
                                            });
                                          }
                                          failure:^(NSString *errorMsg, NSError *error) {
                                              if(callback)
                                                  callback(nil, errorMsg, error);
                                          }];
        
    }else{

        
        NSLog(@"無連線");
        
        dispatch_async(dispatch_get_global_queue(0, 0), ^(void) {
            
            NSArray *replys  = [self.persistentManager getFristTopicReplyWithID:topicID];
            
            dispatch_async(dispatch_get_main_queue(), ^(void) {
                
                if(callback)
                    callback(replys, nil,nil);
                
            });
        });
        
        
        
    }
    
}

- (NSArray *)getTopicReplyWithTopicID:(NSNumber *)topicID{
    return [self.persistentManager getTopicReplyWithID:topicID];
}

#pragma mark - 影片
- (void)getVideoWithTopicID:(NSNumber *)topicID
                    channel:(NSString *)channel
                    withUID:(NSString *)uid
                   withYear:(NSNumber *)year
                  withMonth:(NSNumber *)month
                   withPage:(NSNumber *)page
                 withMyType:(NSNumber *)myType
                withActorID:(NSNumber *)actorId
              callback:(void (^)(NSArray *videoArray, NSString *errorMsg, NSError *error))callback{
    
    BOOL connect=[self.apiManager connectedToInternet];
    
    if (connect) {
        
        NSLog(@"有連線");
        
        [self.apiManager downloadVideoWithTopicID:topicID
                                          channel:channel
                                          withUID:uid
                                         withYear:year
                                        withMonth:month
                                         withPage:page
                                       withMyType:myType
                                      withActorID:actorId
                                          success:^(NSData *data) {
                                         dispatch_async(dispatch_get_global_queue(0, 0), ^(void) {
                                             
                                         [self.persistentManager videoToDB:data TopicID:topicID UID:uid Year:year Month:month channel:channel Page:page withMyType:myType withActID:actorId];
                                             
                                         NSArray *videoArray=[self.persistentManager getVideoWithTopicID:topicID UID:uid Year:year Month:month channel:channel Page:page withMyType:myType withActID:actorId];
                        
                                            dispatch_async(dispatch_get_main_queue(), ^(void) {
                                                 if(callback)
                                                     callback(videoArray, nil,nil);
                                             });
                                         });

                                     } failure:^(NSString *errorMsg, NSError *error) {
                                         if(callback)
                                             callback(nil, errorMsg, error);
                                     }
         ];
         
    }else{
        
        
        NSLog(@"無連線");
        
        dispatch_async(dispatch_get_global_queue(0, 0), ^(void) {
            
        NSArray *videoArray=[self.persistentManager getVideoWithTopicID:topicID UID:uid Year:year Month:month channel:channel Page:page withMyType:myType withActID:actorId];
            
            dispatch_async(dispatch_get_main_queue(), ^(void) {
                
                if(callback)
                    callback(videoArray, nil,nil);
                
            });
        });
    }
}

//單一影片
- (void)getVideoWithVideoID:(NSString *)videoId
                    callback:(void (^)(VideoObj *video, NSMutableArray *actorArray,NSString *errorMsg, NSError *error))callback{
    
    [self.apiManager downloadVideoWithVideoID:videoId success:^(NSData *data) {
        NSDictionary *JSON = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        
        VideoObj *video = nil;
        NSMutableArray *actorArray=[[NSMutableArray alloc] init];
        
        if([(NSArray *)[JSON objectForKey:@"Data"] count]!=0){
        
        video = [[VideoObj alloc] init];
        NSDictionary *dict=JSON[@"Data"][0];
        
        video.videoID=[self replaceNullString:dict[@"Id"]];
        video.viewNum=[self replaceNullNumber:dict[@"ViewNum"]];
        video.likeNum=[self replaceNullNumber:dict[@"LikeNum"]];
        video.wantViewNum=[self replaceNullNumber:dict[@"WantViewNum"]];
        video.reviewNum=[self replaceNullNumber:dict[@"ReviewNum"]];
        
        video.isLiked=[self replaceNullNumber:dict[@"IsLiked"]];
        video.isViewed=[self replaceNullNumber:dict[@"IsViewed"]];
        video.isWantView=[self replaceNullNumber:dict[@"IsWantView"]];
            
        video.picture=[self replaceNullString:dict[@"Picture"]];
        video.name=[self replaceNullString:dict[@"Name"]];
        video.enName=[self replaceNullString:dict[@"ENName"]];
            
            
        video.cnName=[self replaceNullString:dict[@"CNName"]];
        video.intro=[self replaceNullString:dict[@"Intro"]];
        video.enIntro=[self replaceNullString:dict[@"ENIntro"]];
        video.cnIntro=[self replaceNullString:dict[@"CNIntro"]];
        video.createdOn=[NSDate dateWithTimeIntervalSince1970:[dict[@"CreatedOn"] doubleValue]];
            
        video.releaseDate=[self replaceNullString:dict[@"ReleaseDate"]];
        video.update=[NSDate date];

        NSArray *ary=dict[@"Actor"];
        for (int i=0; i<ary.count; i++) {
            
            ActorObj *actor=[[ActorObj alloc] init];
            actor.videoID=[self replaceNullString:dict[@"Id"]];
            actor.actorID=ary[i][@"Id"];
            //NSString *name=dict[@"Name"];
            
            actor.name=[ary[i][@"Name"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            actor.enName=[self replaceNullString:ary[i][@"ENName"]];
            actor.cnName=[self replaceNullString:ary[i][@"CNName"]];
            actor.roleType=ary[i][@"RoleType"];
            [actorArray addObject:actor];
        }
        }
        if(callback)
            callback(video,actorArray, nil,nil);
        
    } failure:^(NSString *errorMsg, NSError *error) {
        if(callback)
            callback(nil,nil, nil,nil);
    }];
    
}

//單一專題
- (void)getTopicWithTopicID:(NSNumber *)topicId
                         callback:(void (^)(TopicObj *topic, NSString *errorMsg, NSError *error))callback{
    [self.apiManager downloadTopicWithTopicID:topicId success:^(NSData *data) {
        
        NSDictionary *JSON = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        
        TopicObj *topic=nil;
        
        if([(NSArray *)[JSON objectForKey:@"Data"] count]!=0){
        topic = [[TopicObj alloc] init];
        
        NSDictionary *dict=JSON[@"Data"][0];
        
        topic.total=JSON[@"Total"];
        topic.topicID=dict[@"Id"];
        topic.title=dict[@"Title"];
        topic.content=dict[@"Content"];
        
        NSArray *pictureCollection=dict[@"Picture"];
        topic.picture=[pictureCollection componentsJoinedByString:@","];
        
        topic.viewNum=dict[@"ViewNum"];
        topic.commentNum=dict[@"CommentNum"];
        topic.likeNum=dict[@"LikeNum"];
        topic.videoCount=dict[@"VideoCount"];
        topic.authorID=dict[@"Author"][@"Id"];
        topic.nickName=dict[@"Author"][@"NickName"];
        topic.banner=dict[@"Banner"];
        topic.avatar=dict[@"Author"][@"Avatar"];
        //topic.channel=channel;
        topic.isLiked=dict[@"IsLiked"];
        
        }
        
        if(callback)
            callback(topic, nil,nil);
    } failure:^(NSString *errorMsg, NSError *error) {
        if(callback)
            callback(nil, nil,nil);
    }];
}

- (void)getVideoFromDbWithTopicID:(NSNumber *)topicID
                    channel:(NSString *)channel
                    withUID:(NSString *)uid
                   withYear:(NSNumber *)year
                  withMonth:(NSNumber *)month
                   withPage:(NSNumber *)page
                 withMyType:(NSNumber *)myType
                withActorID:(NSNumber *)actorId
    callback:(void (^)(NSArray *videoArray, NSString *errorMsg, NSError *error))callback{
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^(void) {
        
        NSArray *videoArray=[self.persistentManager getVideoWithTopicID:topicID UID:uid Year:year Month:month channel:channel Page:page withMyType:myType withActID:actorId];
        
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            
            if(callback)
                callback(videoArray, nil,nil);
            
        });
    });
    
}

#pragma mark - 影評
- (void)getVideoReviewWithId:(NSString *)videoID
                    callback:(void (^)(NSArray *reviewArray, NSString *errorMsg, NSError *error))callback{
    BOOL connect=[self.apiManager connectedToInternet];
    
    if (connect) {
        
        NSLog(@"有連線");
        
        [self.apiManager downloadVideoReviewWithId:videoID
                                     success:^(NSData *data) {
                                         dispatch_async(dispatch_get_global_queue(0, 0), ^(void) {
                                             
                                             [self.persistentManager videoReviewToDB:data videoID:videoID];
                                             NSArray *reviewArray=[self.persistentManager getVideoReviewWithVideoID:videoID];
                                             dispatch_async(dispatch_get_main_queue(), ^(void) {
                                                 if(callback)
                                                     callback(reviewArray, nil,nil);
                                             });
                                         });
                                         
                                     } failure:^(NSString *errorMsg, NSError *error) {
                                         if(callback)
                                             callback(nil, errorMsg, error);
                                     }
         ];
        
    }else{
        
        
        NSLog(@"無連線");
        
        dispatch_async(dispatch_get_global_queue(0, 0), ^(void) {
            
            NSArray *reviewArray=[self.persistentManager getVideoReviewWithVideoID:videoID];
            
            dispatch_async(dispatch_get_main_queue(), ^(void) {
                
                if(callback)
                    callback(reviewArray, nil,nil);
                
            });
        });
        
        
        
    }
}

#pragma mark - 影片陣容
- (NSArray *)getActorWithVideoId:(NSString *)videoId{
    
    return [self.persistentManager getActorWithVideoID:videoId];

}

#pragma mark - 童鞋會
- (void)getSchoolPartyWithChannel:(NSString *)channel
                         withPage:(NSNumber *)page
                          withUid:(NSString *)uid
                         callback:(void (^)(NSArray *partyArray, NSString *errorMsg, NSError *error))callback {

    BOOL connect=[self.apiManager connectedToInternet];
    
    if (connect) {
        
        NSLog(@"有連線");
        
        [self.apiManager downloadSchoolPartyWithChannel:channel withPage:page withUid:uid success:^(NSData *data) {
            
             dispatch_async(dispatch_get_global_queue(0, 0), ^(void) {
            
                 [self.persistentManager schoolPartyToDB:data withChannel:channel withPage:page];
                 NSArray *partyArray=[self.persistentManager getSchoolPartyWithChannel:channel ];
                 
                 dispatch_async(dispatch_get_main_queue(), ^(void) {
                     if(callback)
                         callback(partyArray, nil,nil);
                 });
             });

            
        } failure:^(NSString *errorMsg, NSError *error) {
            if(callback)
                callback(nil, errorMsg, error);
        }];
        
    }else{
        
        
        NSLog(@"無連線");
        
        dispatch_async(dispatch_get_global_queue(0, 0), ^(void) {
            
            NSArray *partyArray=[self.persistentManager getSchoolPartyWithChannel:channel];
            
            dispatch_async(dispatch_get_main_queue(), ^(void) {
                
                if(callback)
                    callback(partyArray, nil,nil);
                
            });
        });
        
        
        
    }
}

#pragma mark - 單一社團
- (void)clubWithId:(NSNumber *)clubID
           callback:(void (^)(SchoolPartyObj *party, NSString *errorMsg, NSError *error))callback {
    
    [self.apiManager downloadClubWithId:clubID success:^(NSData *data) {
        NSDictionary *JSON = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        
        NSDictionary *dict=JSON[@"Data"][0];
        SchoolPartyObj *party =[[SchoolPartyObj alloc] init];
        party.partyID=dict[@"Id"];
        party.name=dict[@"Name"];
        party.memberCount=dict[@"MemberCount"];
        party.desc=[self replaceNullString:dict[@"Desc"]];
        party.founderID=dict[@"CreatedBy"][@"Id"];
        party.nickName=dict[@"CreatedBy"][@"NickName"];
        party.channel=@"";
        party.isJoined=dict[@"IsJoined"];
        party.isPublic=dict[@"IsPublic"];
        party.isPassAudit=dict[@"IsPassAudit"];
        party.needAuth=dict[@"NeedAuth"];
        party.avatar=[self replaceNullString:dict[@"CreatedBy"][@"Avatar"]];
        party.total=JSON[@"Total"];
        party.update=[NSDate date];
        if(callback)
            callback(party, nil,nil);
        
        
    } failure:^(NSString *errorMsg, NSError *error) {
        //
    }];
    
}

#pragma mark - 社團話題

- (void)getTalkWithId:(NSNumber *)clubID
           withTalkId:(NSNumber *)talkId
                 page:(NSNumber *)page
             callback:(void (^)(NSMutableArray *talkArray, NSString *errorMsg, NSError *error))callback{
    [self.apiManager downloadTalkWithId:clubID withTalkId:talkId page:(NSNumber *)page
                                success:^(NSData *data) {
    NSDictionary *JSON = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        
        NSMutableArray *talkArray=[[NSMutableArray alloc] init];
        
        for(NSDictionary *dict in JSON[@"Data"])
        {
            TalkObj *talk= [[TalkObj alloc] init];
            
            talk.creatorId=dict[@"CreatorId"];
            talk.clubId=dict[@"ClubId"];
            talk.talkId=dict[@"Id"];
            talk.clubTopicName=[self replaceNullString:dict[@"ClubTopicName"]];
            talk.clubTopicDesc=[self replaceNullString:dict[@"ClubTopicDesc"]];
            talk.createdOn=dict[@"CreatedOn"];
            talk.modifiedOn=dict[@"ModifiedOn"];
            talk.name=dict[@"ClubName"];

            talk.nickName=dict[@"UserNickName"];

            talk.clubBanner=dict[@"ClubBanner"];
            talk.clubTopicMessageAmount=dict[@"ClubTopicMessageAmount"];
            talk.avatar=dict[@"UserAvatar"];
            talk.isPublic=dict[@"IsPublic"];
            talk.clubTopicMessageAmountInOneWeek=dict[@"ClubTopicMessageAmountInOneWeek"];
            talk.IsTop=dict[@"IsTop"];
            talk.isLike=dict[@"IsLike"];
            
            talk.pageViews=dict[@"PageViews"];
            talk.likedAmount=dict[@"LikedAmount"];
            
            [talkArray addObject:talk];

            
            
        }
        
        if(callback)
            callback(talkArray, nil,nil);
        
    } failure:^(NSString *errorMsg, NSError *error) {
        //
    }];
}

#pragma mark - 社團話題回應列表
- (void)clubTopicMessageWithId:(NSNumber *)ID
                          page:(NSNumber *)page
                              callback:(void (^)(NSArray *talkArray, NSString *errorMsg, NSError *error))callback{
    
    [self.apiManager downloadClubTopicMessageWithId:ID page:page success:^(NSData *data) {
        NSDictionary *JSON = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        
        NSArray *talkArray=JSON[@"Data"];
        
        if(callback)
            callback(talkArray, nil,nil);
        
    } failure:^(NSString *errorMsg, NSError *error) {
        //
    }];
}
#pragma mark - 社團話題回應
- (void)leaveMessageWithId:(NSNumber *)culbId
                   withMessage:(NSString *)message
                   withReplyId:(NSNumber *)replyId
                       callback:(void (^)(NSDictionary *dict, NSString *errorMsg, NSError *error))callback{
    
    [self.apiManager postLeaveMessageWithId:culbId withMessage:message withReplyId:replyId success:^(NSData *data) {
        
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        if(callback)
            callback(dict, nil,nil);
        
    } failure:^(NSString *errorMsg, NSError *error) {
        //
    }];
    
    
}

// 社團新增話題
- (void)createTopicWithId:(NSNumber *)culbId
                withTopicName:(NSString *)topicName
                withTopicDesc:(NSString *)topicDesc
                     callback:(void (^)(NSDictionary *JSON, NSString *errorMsg, NSError *error))callback{
    [self.apiManager postCreateTopicWithId:culbId withTopicName:topicName withTopicDesc:topicDesc success:^(NSData *data) {
        
        NSDictionary *JSON = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        
        if(callback)
            callback(JSON, nil,nil);
        
    } failure:^(NSString *errorMsg, NSError *error) {
        //
    }];
    
}

#pragma mark - 社團成員
- (void)getMemberWithId:(NSNumber *)clubID
              withtType:(NSString *)type
              withtPage:(NSNumber *)page
               callback:(void (^)(NSMutableArray *memberArray, NSString *errorMsg, NSError *error))callback{
    
    [self.apiManager downloadMemberWithId:clubID withtType:type withtPage:page success:^(NSData *data) {
        NSDictionary *JSON = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        
        
        NSMutableArray *memberArray=[[NSMutableArray alloc] init];
        
        
        for(NSDictionary *dict in JSON[@"Data"])
        {
            FriendObj *friendObj= [[FriendObj alloc] init];
            
            friendObj.avatar=[self replaceNullString:dict[@"Avatar"]];
            friendObj.nickName=dict[@"NickName"];
            friendObj.userId=dict[@"Id"];
            
            
            [memberArray addObject:friendObj];
        }
        
        
        if(callback)
            callback(memberArray, nil,nil);
        
    } failure:^(NSString *errorMsg, NSError *error) {
        //
    }];
    
}


#pragma mark - 加入社團
- (void)joinParty:(NSNumber *)culbId
         callback:(void (^)(NSNumber *result, NSString *errorMsg, NSError *error))callback{
    [self.apiManager joinParty:culbId success:^(NSData *data) {
        
        NSNumber *result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        
        if(callback)
            callback(result, nil,nil);
    } failure:^(NSString *errorMsg, NSError *error) {
        if(callback)
            callback(nil, errorMsg, error);
    }];
}

#pragma mark - 退出社團
- (void)quitParty:(NSNumber *)culbId
         callback:(void (^)(NSNumber *result, NSString *errorMsg, NSError *error))callback{
    
    [self.apiManager quitParty:culbId success:^(NSData *data) {
        
        NSNumber *result = [NSNumber numberWithBool:YES];
        
        if(callback)
            callback(result, nil,nil);
    } failure:^(NSString *errorMsg, NSError *error) {
        if(callback)
            callback(nil, errorMsg, error);
    }];
}

#pragma mark - 登入
- (void)getLoginWithAccount:(NSString *)account
               withPassword:(NSString *)password
               withRemember:(BOOL)remember
                   callback:(void (^)(NSDictionary *loginInfo, NSString *errorMsg, NSError *error))callback {
    
    BOOL connect=[self.apiManager connectedToInternet];
    if (connect) {
        
        NSLog(@"有連線");
        
        [self.apiManager loginWithAccount:account withPassword:password withRemember:remember success:^(NSData *data){
            dispatch_async(dispatch_get_global_queue(0, 0), ^(void) {
                
                
                NSDictionary *loginInfo = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
                //[self.persistentManager schoolPartyToDB:data withChannel:channel withMyType:myType];
                //NSArray *partyArray=[self.persistentManager getSchoolPartyWithChannel:channel withMyType:myType];
                
                dispatch_async(dispatch_get_main_queue(), ^(void) {
                    if(callback)
                        callback(loginInfo, nil,nil);
                });
            });

        } failure:^(NSString *errorMsg, NSError *error) {
            if(callback)
                callback(nil, errorMsg, error);
            
        }];
        
    }else{
        
        
        NSLog(@"無連線");
        
        dispatch_async(dispatch_get_global_queue(0, 0), ^(void) {
            
           // NSArray *partyArray=[self.persistentManager getSchoolPartyWithChannel:channel withMyType:myType];
            
            dispatch_async(dispatch_get_main_queue(), ^(void) {
                
                if(callback)
                    callback(nil, nil,nil);
                
            });
        });
        
        
        
    }
}
#pragma mark - 個人資料

- (void)userProfile:(NSNumber *)userId
           callback:(void (^)(FriendObj *friend, NSString *errorMsg, NSError *error))callback{
    [self.apiManager userProfile:userId success:^(NSData *data) {
        
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        
        NSLog(@"%@",dict);
        
        
        FriendObj *friend=[[FriendObj alloc] init];

        friend.userId=[self replaceNullNumber:dict[@"UserId"]];
        friend.nickName=[self replaceNullString:dict[@"NickName"]];
        friend.userName=[self replaceNullString:dict[@"UserName"]];
        friend.fristName=[self replaceNullString:dict[@"FristName"]];
        friend.lastName=[self replaceNullString:dict[@"LastName"]];
        friend.brithDay=[self replaceNullString:dict[@"BrithDay"]];
        friend.location=[self replaceNullNumber:dict[@"Location"]];
        friend.locationName=[self replaceNullString:dict[@"LocationName"]];
        friend.intro=[self replaceNullString:dict[@"Intro"]];
        friend.masterLocation=[self replaceNullNumber:dict[@"MasterLocation"]];
        friend.gender=[self replaceNullNumber:dict[@"Gender"]];
        friend.editStage=[self replaceNullNumber:dict[@"EditStage"]];
        friend.isCompleteEditProfile=[self replaceNullNumber:dict[@"IsCompleteEditProfile"]];
        friend.bannerType=[self replaceNullNumber:dict[@"BannerType"]];
        friend.banner=[self replaceNullString:dict[@"Banner"]];
        friend.avatar=[self replaceNullString:dict[@"Avatar"]];
        friend.isFriend=[self replaceNullNumber:dict[@"IsFriend"]];
        friend.isBeingInviting=[self replaceNullNumber:dict[@"IsBeingInviting"]];
        friend.isInviting=[self replaceNullNumber:dict[@"IsInviting"]];
        
        if(callback)
                callback(friend, nil,nil);

    } failure:^(NSString *errorMsg, NSError *error) {
        if(callback)
            callback(nil, errorMsg,error);
    }];
}

#pragma mark - 修改個人資料

- (void)saveUserProfile:(NSDictionary *)userInfo
                callback:(void (^)(NSDictionary *loginInfo, NSString *errorMsg, NSError *error))callback{
    [self.apiManager saveUserProfile:userInfo success:^(NSData *data) {
        
        NSDictionary *loginInfo = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        
        if(callback)
            callback(loginInfo, nil,nil);
    } failure:^(NSString *errorMsg, NSError *error) {
        if(callback)
            callback(nil, errorMsg,error);
    }];
    
}

#pragma mark - 邀請朋友

-(void)invitFiend:(NSString *)userId
         callback:(void (^)(NSDictionary *result, NSString *errorMsg, NSError *error))callback{
    
    [self.apiManager invitFiend:userId success:^(NSData *data) {
        
    NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        
        if(callback)
            callback(result, nil,nil);
        
    } failure:^(NSString *errorMsg, NSError *error) {
        if(callback)
            callback(nil, errorMsg,error);
    }];
}

#pragma mark - 進階搜尋
-(void)search:(NSString *)term
         type:(NSString *)type
         page:(NSNumber *)page
     callback:(void (^)(NSMutableArray *listArray,NSString *errorMsg, NSError *error))callback{
    
    [self.apiManager search:term type:type page:page success:^(NSData *data) {
        NSDictionary *JSON=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        
        NSMutableArray *listArray=[[NSMutableArray alloc] init];
        
        for(NSDictionary *dict in JSON[@"Data"])
        {
            SearchObj *searchObj =[[SearchObj alloc] init];
            searchObj.Id=[self replaceNullString:dict[@"id"]];
            searchObj.label=[self replaceNullString:dict[@"label"]];
            searchObj.lableCn=[self replaceNullString:dict[@"lableCn"]];
            searchObj.value=[self replaceNullString:dict[@"value"]];
            [listArray addObject:searchObj];
        }

        
        if(callback)
            callback(listArray, nil,nil);
        
    } failure:^(NSString *errorMsg, NSError *error) {
        if(callback)
            callback(nil, errorMsg,error);
    }];
    
    
}

#pragma mark - 我的朋友

- (void)myFriendsWithUserID:(NSNumber *)userId withPage:(NSNumber *)page
                   callback:(void (^)(NSArray *friendArray, NSString *errorMsg, NSError *error))callback{
   
    BOOL connect=[self.apiManager connectedToInternet];
    if (connect) {
        
        NSLog(@"有連線");
        
        [self.apiManager myFriendsWithUserID:userId withPage:page success:^(NSData *data) {
            
            dispatch_async(dispatch_get_global_queue(0, 0), ^(void) {
            
            [self.persistentManager FriendToDB:data withUserID:userId withPage:page];
                
            NSArray *friendArray=[self.persistentManager getMyFriends:userId];
                
            dispatch_async(dispatch_get_main_queue(), ^(void) {
            if(callback)
                callback(friendArray, nil,nil);
                });
            });
        } failure:^(NSString *errorMsg, NSError *error) {
            if(callback)
                callback(nil, errorMsg, error);
        }];
        
    }else{

        NSLog(@"無連線");
        NSArray *friendArray=[self.persistentManager getMyFriends:userId];
        if(callback)
            callback(friendArray, nil,nil);
    }
}
#pragma mark - 我的動態

- (void)activityWithUserId:(NSNumber *)userId withPage:(NSNumber *)page withStatus:(NSString *)status
                    callback:(void (^)(NSArray *activityArray, NSString *errorMsg, NSError *error))callback {
    
    BOOL connect=[self.apiManager connectedToInternet];
    
    if (connect) {
        
        NSLog(@"有連線");
        
        [self.apiManager myActivityWithUserId:userId withPage:page withStatus:status
                                      success:^(NSData *data) {
            dispatch_async(dispatch_get_global_queue(0, 0), ^(void) {
                
                NSLog(@"status:%@",status);
                
                [self.persistentManager activityToDB:data withUserID:userId withPage:page withStatus:status];
                NSArray *activityArray=[self.persistentManager getActivity:userId withStatus:status];
                
                dispatch_async(dispatch_get_main_queue(), ^(void) {
                    if(callback)
                        callback(activityArray, nil,nil);
                });
            });
            
        } failure:^(NSString *errorMsg, NSError *error) {
            if(callback)
                callback(nil, errorMsg, error);
        }];
        
    }else{
        
        NSLog(@"無連線");
        NSArray *activityArray=[self.persistentManager getActivity:userId withStatus:status];
        if(callback)
            callback(activityArray, nil,nil);
    }
    
}


#pragma mark - 喜歡 看過 想看
- (void)like:(NSString *)videoId withCol:(NSString *)col
    callback:(void (^)(NSNumber *count, NSString *errorMsg, NSError *error))callback{
    BOOL connect=[self.apiManager connectedToInternet];
    
    if (connect) {
        [self.apiManager like:videoId withCol:col success:^(NSData *data) {
            NSNumber *count=@(0);
            NSLog(@"%@",data);
            
            if(callback)
                callback(count, nil,nil);
            
        } failure:^(NSString *errorMsg, NSError *error) {
            if(callback)
                callback(nil, nil,nil);
        }];
    }
}

#pragma mark -喜歡專題
- (void)likeTopic:(NSNumber *)TopicId
         callback:(void (^)(NSNumber *count, NSString *errorMsg, NSError *error))callback{
    
    BOOL connect=[self.apiManager connectedToInternet];
    
    if (connect) {
        [self.apiManager likeTopic:TopicId success:^(NSData *data) {
            NSNumber *count=@(0);
            NSLog(@"%@",data);
            
            if(callback)
                callback(count, nil,nil);
            
        } failure:^(NSString *errorMsg, NSError *error) {
            if(callback)
                callback(nil, nil,nil);
        }];
    }
}

#pragma mark -喜歡話題
- (void)likeClubTopic:(NSNumber *)talkId
             callback:(void (^)(NSNumber *count, NSString *errorMsg, NSError *error))callback{
    
    BOOL connect=[self.apiManager connectedToInternet];
    
    if (connect) {
        [self.apiManager likeClubTopic:talkId success:^(NSData *data) {
            NSNumber *count=@(0);
            NSLog(@"%@",data);
            
            if(callback)
                callback(count, nil,nil);
            
        } failure:^(NSString *errorMsg, NSError *error) {
            if(callback)
                callback(nil, nil,nil);
        }];
    }
}

#pragma mark -選擇語系
- (void)changeLang:(void (^)(NSNumber *count, NSString *errorMsg, NSError *error))callback{
    
    BOOL connect=[self.apiManager connectedToInternet];
    
    if (connect) {
        [self.apiManager changeLang:^(NSData *data) {
            if(callback)
                callback(nil, nil,nil);
        } failure:^(NSString *errorMsg, NSError *error) {
            if(callback)
                callback(nil, nil,nil);
        }];

    }
}

-(NSString *)replaceNullString:(id)string{
    NSString *str=[NSString stringWithFormat:@"%@",string];
    if ([str isEqualToString:@"<null>"]) {
        return @"";
    }
    return str;
    
}

-(NSNumber *)replaceNullNumber:(id)number{
    NSString *str=[NSString stringWithFormat:@"%@",number];
    if ([str isEqualToString:@"<null>"]) {
        return [NSNumber numberWithInt:0];
    }
    return number;
}




#pragma mark - helper methods

- (BOOL)hasInternetConnection
{
    return [self.apiManager connectedToInternet];
}


#pragma mark - singleton implementation code

+ (MovieCakerManager *)sharedInstance {
    
    static dispatch_once_t pred;
    static MovieCakerManager *manager;
    
    dispatch_once(&pred, ^{
        manager = [[self alloc] init];
    });
    return manager;
}


@end
