//
//  PersistentManager.m
//  MovieCaker
//
//  Created by iKevin on 2013/11/15.
//  Copyright (c) 2013年 iKevin. All rights reserved.
//

#import "PersistentManager.h"
#import "AppDelegate.h"
#import "Topic.h"
#import "VideoReview.h"
#import "Activity.h"
#import "ActivityObj.h"

@interface PersistentManager()

@property (nonatomic, strong) NSManagedObjectContext *mainContext;
@property (nonatomic, strong) NSManagedObjectContext *backgroundContext;
@property (nonatomic, weak) NSUserDefaults *userDef;

@end

@implementation PersistentManager

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
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    self.mainContext = delegate.managedObjectContext;
    //self.userDef = [NSUserDefaults standardUserDefaults];
}

#pragma mark - 專題
-(void)topicToDB:(NSData *)data channel:(NSString *) channel withPage:(NSNumber *)page{
    
    
    if (page.intValue==1) {
        [self deleteTopicWithChannel:channel];
    }
    
    
    NSDictionary *JSON = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    
    for(NSDictionary *dict in JSON[@"Data"])
    {
        Topic *topic = [NSEntityDescription insertNewObjectForEntityForName:@"Topic"
                                                       inManagedObjectContext:self.mainContext];
        
        topic.total=JSON[@"Total"];
        
        NSLog(@"topic.total=:%d",topic.total.intValue);
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
        topic.channel=channel;
        topic.isLiked=dict[@"IsLiked"];
        

        topic.update=[NSDate date];
        NSInteger sec=[dict[@"CreatedOn"] integerValue]-28800; //補正伺服器時間 -8
        topic.createdOn=[NSDate dateWithTimeIntervalSince1970:sec];;
    }
    
    [self.mainContext save:nil];
}

-(NSArray *)getTopicWithChannel:(NSString *)channel{
    
    NSArray *topicArray = nil;
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
	request.entity = [NSEntityDescription entityForName:@"Topic"
                                 inManagedObjectContext:self.mainContext];
    request.predicate = [NSPredicate predicateWithFormat:@"channel = %@", channel];
    request.includesPendingChanges = YES;
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"update" ascending:YES]];
    //request.fetchLimit = 10;
    NSError *error = nil;
    
    NSLog(@"1");
    topicArray = [self.mainContext executeFetchRequest:request error:&error];
    NSLog(@"2");
    return topicArray;
}

-(void)deleteTopicWithChannel:(NSString *)channel{
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    request.entity = [NSEntityDescription entityForName:@"Topic" inManagedObjectContext:self.mainContext];
    request.predicate = [NSPredicate predicateWithFormat:@"channel = %@", channel];
    //request.includesPendingChanges = YES;
    
    NSError *error = nil;
	NSArray *deleteArray = [self.mainContext executeFetchRequest:request error:&error];
    
    for (Topic* topic in deleteArray) {
        
        [self.mainContext deleteObject:topic];
    }

    [self.mainContext save:nil];

}
#pragma mark - 專題回應
-(void) topicReplyToDB:(NSData *)data topicID:(NSNumber *)topicID{
    
    [self deleteTopicReplyWithID:topicID];
    
    NSArray *JSON = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    //NSMutableArray *array = [NSMutableArray array];
    for(NSDictionary *dict in JSON)
    {
        TopicReply *topicReply = [NSEntityDescription insertNewObjectForEntityForName:@"TopicReply"
                                                     inManagedObjectContext:self.mainContext];
        
        topicReply.replyID=dict[@"Id"];
        
        topicReply.topicID=dict[@"TopicId"];
        
        NSString *parentID=[NSString stringWithFormat:@"%@",dict[@"ParentId"]];

        if (![parentID isEqualToString:@"<null>"]) {
            topicReply.parentID=dict[@"ParentId"];
        }

        topicReply.message=dict[@"Message"];

        topicReply.authorID=dict[@"Author"][@"Id"];
        topicReply.nickName=dict[@"Author"][@"NickName"];
        
        
        NSString *avatar=[NSString stringWithFormat:@"%@",dict[@"Author"][@"Avatar"]];
        if (![avatar isEqualToString:@"<null>"]) {
            topicReply.avatar=avatar;
        }
        
        NSInteger sec=[dict[@"CreatedOn"] integerValue]-28800; //補正伺服器時間 -8
        topicReply.createdOn=[NSDate dateWithTimeIntervalSince1970:sec];
    }
    [self.mainContext save:nil];
}
//取得專題回應
-(NSArray *)getTopicReplyWithID:(NSNumber *)topicID{
    
    NSArray *replyArray = nil;
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
	request.entity = [NSEntityDescription entityForName:@"TopicReply"
                                 inManagedObjectContext:self.mainContext];
    request.predicate = [NSPredicate predicateWithFormat:@"topicID = %@", topicID.stringValue];
    request.includesPendingChanges = YES;
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"createdOn" ascending:YES]];
    
    NSError *error = nil;
    
    replyArray = [self.mainContext executeFetchRequest:request error:&error];
    
    return replyArray;
}
//取得專題回應的第一筆
-(NSArray *)getFristTopicReplyWithID:(NSNumber *)topicID{
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
	request.entity = [NSEntityDescription entityForName:@"TopicReply"
                                 inManagedObjectContext:self.mainContext];
    request.predicate = [NSPredicate predicateWithFormat:@"topicID = %@", topicID.stringValue];
    request.includesPendingChanges = YES;
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"createdOn" ascending:YES]];
    
    NSError *error = nil;
    
    NSArray *ary=[self.mainContext executeFetchRequest:request error:&error];
    
    return ary;
}

-(void)deleteTopicReplyWithID:(NSNumber *)topicID{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    request.entity = [NSEntityDescription entityForName:@"TopicReply" inManagedObjectContext:self.mainContext];
    request.predicate = [NSPredicate predicateWithFormat:@"topicID = %@", topicID.stringValue];
    request.includesPendingChanges = YES;
    //request.fetchLimit = 1;
    
    NSError *error = nil;
	NSArray *deleteArray = [self.mainContext executeFetchRequest:request error:&error];
    
    for (TopicReply *reply in deleteArray) {
        
        [self.mainContext deleteObject:reply];
    }
    
    [self.mainContext save:nil];
   
}
#pragma mark - 影片

-(void) videoToDB:(NSData *)data TopicID:(NSNumber *)topicID UID:(NSString *)uid Year:(NSNumber *)year Month:(NSNumber *)month channel:(NSString *)channel Page:(NSNumber *)page withMyType:(NSNumber *)myType withActID:(NSNumber *)actorId{
    
    if (page.intValue==1) {
        [self deleteVideoWithTopicID:topicID UID:uid Year:year Month:month channel:channel Page:page myType:myType withActID:actorId];
    }

    
    NSDictionary *JSON = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    
    //NSNumber *total=JSON[@"Total"];
    //NSLog(@"%@",JSON);
    //NSMutableArray *array = [NSMutableArray array];
    
    for(NSDictionary *dict in JSON[@"Data"])
    {
        Video *video = [NSEntityDescription insertNewObjectForEntityForName:@"Video"
                                                               inManagedObjectContext:self.mainContext];
        video.total=JSON[@"Total"];
        
        video.topicID=topicID;
        video.uid=uid;

        video.year=year;
        video.month=month;
        video.channel=channel;
        video.page=page;
        video.myType=myType;
        video.actorId=actorId;
        
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
        
        //NSLog(@"CreatedOn:%@",dict[@"CreatedOn"]);
        
        //NSInteger sec=[dict[@"CreatedOn"] integerValue]-28800; //補正伺服器時間 -8
        //video.createdOn=[NSDate dateWithTimeIntervalSince1970:sec];
        
        video.releaseDate=[self replaceNullString:dict[@"ReleaseDate"]];
        [self actorToDB:dict[@"Actor"] videoID:dict[@"Id"]];
        
        video.update=[NSDate date];
    }
    [self.mainContext save:nil];
}

-(NSArray *)getVideoWithTopicID:(NSNumber *)topicID UID:(NSString *)uid Year:(NSNumber *)year Month:(NSNumber *)month channel:(NSString *)channel Page:(NSNumber *)page withMyType:(NSNumber *)myType withActID:(NSNumber *)actorId{
    
    NSArray *videoArray = nil;
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
	request.entity = [NSEntityDescription entityForName:@"Video"
                                 inManagedObjectContext:self.mainContext];
    
    if ([channel isEqualToString:@"InTopic"]) {
        request.predicate = [NSPredicate predicateWithFormat:@"topicID = %@ && page<=%d", topicID.stringValue,page.intValue];
    }else if ([channel isEqualToString:@"Global"]){
        request.predicate = [NSPredicate predicateWithFormat:@"channel = %@ && month = %d && year= %d", channel, month.intValue,year.intValue];
    }else if([channel isEqualToString:@"Friend"]){
        request.predicate = [NSPredicate predicateWithFormat:@"channel = %@ && page<=%d", channel,page.intValue];
    }else if([channel isEqualToString:@"Week"]){
        request.predicate = [NSPredicate predicateWithFormat:@"channel = %@ && page<=%d", channel,page.intValue];
    }else if([channel isEqualToString:@"My"]){
        request.predicate = [NSPredicate predicateWithFormat:@"channel = %@ && myType=%d", channel,myType.intValue];
    }else if([channel isEqualToString:@"Actor"]){
        request.predicate = [NSPredicate predicateWithFormat:@"channel = %@ && actorId=%d", channel,actorId.intValue];
    }
    
    request.includesPendingChanges = YES;
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"update" ascending:YES]];
    
    NSError *error = nil;
    
    videoArray = [self.mainContext executeFetchRequest:request error:&error];
    
    NSLog(@"videoArray DB:%d",videoArray.count);
    
    return videoArray;
    
}

-(NSDate *)getGlobalVideoLastUpdateTime:(NSNumber *)year month:(NSNumber *)month page:(NSNumber *)page{
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
	request.entity = [NSEntityDescription entityForName:@"Video"
                                 inManagedObjectContext:self.mainContext];

    request.predicate = [NSPredicate predicateWithFormat:@"channel = %@ && year = %d && month = %d", @"Global",year.intValue, month.intValue];
    request.includesPendingChanges = YES;
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"update" ascending:NO]];
    
    NSError *error = nil;
    
    Video *video=[[self.mainContext executeFetchRequest:request error:&error] lastObject];
    
    if (video) {
        return video.update;
    }
    
    return nil;
}

-(void)deleteVideoWithTopicID:(NSNumber *)topicID UID:(NSString *)uid Year:(NSNumber *)year Month:(NSNumber *)month channel:(NSString *)channel Page:(NSNumber *)page myType:(NSNumber *)myType withActID:(NSNumber *)actorId{
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    request.entity = [NSEntityDescription entityForName:@"Video" inManagedObjectContext:self.mainContext];
    
    if ([channel isEqualToString:@"InTopic"]) {
        request.predicate = [NSPredicate predicateWithFormat:@"topicID = %@ && page=%d", topicID.stringValue,page.intValue];
    }else if ([channel isEqualToString:@"Global"]){
        request.predicate = [NSPredicate predicateWithFormat:@"channel = %@ && month = %d && year=%d", channel, month.intValue,year.intValue];
    }else if([channel isEqualToString:@"Friend"]){
        request.predicate = [NSPredicate predicateWithFormat:@"channel = %@ && page=%d", channel,page.intValue];
    }else if([channel isEqualToString:@"Week"]){
        request.predicate = [NSPredicate predicateWithFormat:@"channel = %@ && page=%d", channel,page.intValue];
    }if([channel isEqualToString:@"My"]){
        request.predicate = [NSPredicate predicateWithFormat:@"channel = %@ && myType=%d", channel,myType.intValue];
    }if ([channel isEqualToString:@"Actor"]) {
        request.predicate = [NSPredicate predicateWithFormat:@"channel = %@ && actorId=%d", channel,actorId.intValue];
    }


    request.includesPendingChanges = YES;
    //request.fetchLimit = 1;
    
    NSError *error = nil;
	NSArray *deleteArray = [self.mainContext executeFetchRequest:request error:&error];
    
    for (Video *video in deleteArray) {
        
        [self.mainContext deleteObject:video];
    }
    
    [self.mainContext save:nil];
    
}

#pragma mark - 影片陣容

-(void) actorToDB:(NSArray *)actorArray videoID:(NSString *)videoID{
    [self deleteActorWithVideoID:videoID];
    for (int i=0; i<actorArray.count; i++) {
        Actor *actor = [NSEntityDescription insertNewObjectForEntityForName:@"Actor"
                                                     inManagedObjectContext:self.mainContext];
        NSDictionary *dict=actorArray[i];
        actor.videoID=videoID;
        actor.actorID=dict[@"Id"];
        //NSString *name=dict[@"Name"];
        
        actor.name=[dict[@"Name"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
        NSString *enName=[NSString stringWithFormat:@"%@",dict[@"ENName"]];
        if (![enName isEqualToString:@"<null>"]) {
            actor.enName=enName;
        }
        
        NSString *cnName=[NSString stringWithFormat:@"%@",dict[@"CNName"]];
        if (![cnName isEqualToString:@"<null>"]) {
            actor.cnName=cnName;
        }
        
        actor.roleType=dict[@"RoleType"];
    }
    [self.mainContext save:nil];
}

-(void)deleteActorWithVideoID:(NSString *)videoID{
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    request.entity = [NSEntityDescription entityForName:@"Actor" inManagedObjectContext:self.mainContext];
    request.predicate = [NSPredicate predicateWithFormat:@"videoID = %@", videoID];
    request.includesPendingChanges = YES;
    //request.fetchLimit = 1;
    
    NSError *error = nil;
	NSArray *deleteArray = [self.mainContext executeFetchRequest:request error:&error];
    
    for (Actor *actor in deleteArray) {
        
        [self.mainContext deleteObject:actor];
    }
    
    [self.mainContext save:nil];
    
}

-(NSArray *)getActorWithVideoID:(NSString *)videoID{
    
    NSArray *actorArray = nil;
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
	request.entity = [NSEntityDescription entityForName:@"Actor"
                                 inManagedObjectContext:self.mainContext];
    request.predicate = [NSPredicate predicateWithFormat:@"videoID = %@", videoID];
    request.includesPendingChanges = YES;
    //request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"createdOn" ascending:NO]];
    
    NSError *error = nil;
    
    actorArray = [self.mainContext executeFetchRequest:request error:&error];
    
    return actorArray;
}



#pragma mark - 影評

-(void)videoReviewToDB:(NSData *)data videoID:(NSString *)videoID{

    [self deleteVideoReviewWithVideoID:videoID];
    NSArray *JSON = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    //NSMutableArray *array = [NSMutableArray array];
    for(NSDictionary *dict in JSON)
    {
        VideoReview *review = [NSEntityDescription insertNewObjectForEntityForName:@"VideoReview"
                                                               inManagedObjectContext:self.mainContext];
        review.reviewID=dict[@"Id"];
        review.videoID=videoID;
        review.authorID=dict[@"Author"][@"Id"];
        review.nickName=dict[@"Author"][@"NickName"];
        NSString *avatar=[NSString stringWithFormat:@"%@",dict[@"Author"][@"Avatar"]];
        if (![avatar isEqualToString:@"<null>"]) {
            review.avatar=avatar;
        }
        
        NSString *reviewContent=[NSString stringWithFormat:@"%@",dict[@"ReviewContent"]];
        if (![reviewContent isEqualToString:@"<null>"] && reviewContent.length>0) {
            review.reviewContent=[reviewContent stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        }
        NSInteger sec=[dict[@"CreatedOn"] integerValue]-28800; //補正伺服器時間 -8
        review.createdOn=[NSDate dateWithTimeIntervalSince1970:sec];
    }

    [self.mainContext save:nil];
}

-(NSArray *)getVideoReviewWithVideoID:(NSString *)videoID{
    NSArray *reviewArray = nil;
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
	request.entity = [NSEntityDescription entityForName:@"VideoReview"
                                 inManagedObjectContext:self.mainContext];
    request.predicate = [NSPredicate predicateWithFormat:@"videoID = %@", videoID];
    request.includesPendingChanges = YES;
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"createdOn" ascending:NO]];
    NSError *error = nil;
    reviewArray = [self.mainContext executeFetchRequest:request error:&error];
    return reviewArray;
}

-(void)deleteVideoReviewWithVideoID:(NSString *)videoID{
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    request.entity = [NSEntityDescription entityForName:@"VideoReview" inManagedObjectContext:self.mainContext];
    request.predicate = [NSPredicate predicateWithFormat:@"videoID = %@", videoID];
    request.includesPendingChanges = YES;
    //request.fetchLimit = 1;
    
    NSError *error = nil;
	NSArray *deleteArray = [self.mainContext executeFetchRequest:request error:&error];
    
    for (Actor *actor in deleteArray) {
        
        [self.mainContext deleteObject:actor];
    }
    
    [self.mainContext save:nil];
    
}

#pragma mark - 社團
-(void)schoolPartyToDB:(NSData *)data withChannel:(NSString *)channel withPage:(NSNumber *)page{
    if (page.intValue==1) {
         [self deleteSchoolPartyWithChannel:channel];
    }
   
    NSDictionary *JSON = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    
    NSLog(@"%@",JSON);
    
    for(NSDictionary *dict in JSON[@"Data"])
    {
        SchoolParty *schoolParty = [NSEntityDescription insertNewObjectForEntityForName:@"SchoolParty"
                                                            inManagedObjectContext:self.mainContext];
        schoolParty.partyID=dict[@"Id"];
        schoolParty.name=dict[@"Name"];
        schoolParty.memberCount=dict[@"MemberCount"];
        schoolParty.desc=[self replaceNullString:dict[@"Desc"]];

        schoolParty.founderID=dict[@"CreatedBy"][@"Id"];
        schoolParty.nickName=dict[@"CreatedBy"][@"NickName"];
        schoolParty.channel=channel;
        
        
        schoolParty.isJoined=dict[@"IsJoined"];
        schoolParty.isPublic=dict[@"IsPublic"];
        schoolParty.isPassAudit=dict[@"IsPassAudit"];
        schoolParty.needAuth=dict[@"NeedAuth"];
       // schoolParty.myType=myType;
        schoolParty.avatar=[self replaceNullString:dict[@"CreatedBy"][@"Avatar"]];
        
        schoolParty.total=JSON[@"Total"];
        schoolParty.update=[NSDate date];
        
        
    }
    
    [self.mainContext save:nil];
}

-(NSArray *)getSchoolPartyWithChannel:(NSString *)channel{
    
    NSArray *partyArray = nil;
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
	request.entity = [NSEntityDescription entityForName:@"SchoolParty"
                                 inManagedObjectContext:self.mainContext];
    

    request.predicate = [NSPredicate predicateWithFormat:@"channel = %@", channel];
 
    //request.includesPendingChanges = YES;
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"update" ascending:YES]];
    //request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"createdOn" ascending:NO]];
    NSError *error = nil;
    partyArray = [self.mainContext executeFetchRequest:request error:&error];
    return partyArray;
}

-(void)deleteSchoolPartyWithChannel:(NSString *)channel{
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    request.entity = [NSEntityDescription entityForName:@"SchoolParty" inManagedObjectContext:self.mainContext];

    request.predicate = [NSPredicate predicateWithFormat:@"channel = %@", channel];

    request.includesPendingChanges = YES;
    //request.fetchLimit = 1;
    
    NSError *error = nil;
	NSArray *deleteArray = [self.mainContext executeFetchRequest:request error:&error];
    
    for (Actor *actor in deleteArray) {
        
        [self.mainContext deleteObject:actor];
    }
    
    [self.mainContext save:nil];
    
}


#pragma mark - 我的朋友

-(void)FriendToDB:(NSData *)data withUserID:(NSNumber *)ownerId withPage:(NSNumber *)page{
    if (page.intValue==1) {
        [self deleteFriends:ownerId];
    }

    NSArray *JSON = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    
    NSLog(@"%@",JSON);
    
    for(NSDictionary *dict in JSON)
    {
        Friends *friend = [NSEntityDescription insertNewObjectForEntityForName:@"Friends"
                                                                 inManagedObjectContext:self.mainContext];
        friend.ownerId=ownerId;
        friend.userId=dict[@"UserId"];
        friend.nickName=dict[@"NickName"];
        friend.userName=dict[@"UserName"];
        friend.fristName=[self replaceNullString:dict[@"FristName"]];
        friend.lastName=[self replaceNullString:dict[@"lastName"]];
        friend.brithDay=dict[@"BrithDay"];
        friend.location=dict[@"Location"];
        friend.locationName=dict[@"LocationName"];
        friend.intro=[self replaceNullString:dict[@"Intro"]];
        
        friend.masterLocation=dict[@"MasterLocation"];
        friend.gender=[self replaceNullNumber:dict[@"Gender"]];
        friend.bannerType=[self replaceNullNumber:dict[@"BannerType"]];
        
        friend.isCompleteEditProfile=dict[@"IsCompleteEditProfile"];
        friend.editStage=dict[@"EditStage"];
        
        friend.banner=dict[@"Banner"];
        friend.isFriend=dict[@"IsFriend"];
        
        friend.avatar=[self replaceNullString:dict[@"Avatar"]];
        
        friend.isBeingInviting=[self replaceNullNumber:dict[@"IsBeingInviting"]];
        friend.isInviting=[self replaceNullNumber:dict[@"IsInviting"]];
    }
    
    [self.mainContext save:nil];
}

-(NSArray *)getMyFriends:(NSNumber *)ownerId{
    
    NSArray *friendArray = nil;
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
	request.entity = [NSEntityDescription entityForName:@"Friends"
                                 inManagedObjectContext:self.mainContext];
    
    request.predicate = [NSPredicate predicateWithFormat:@"ownerId = %d ", ownerId.intValue];

    request.includesPendingChanges = YES;
    //request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"createdOn" ascending:NO]];
    NSError *error = nil;
    friendArray = [self.mainContext executeFetchRequest:request error:&error];
    return friendArray;
}

-(void)deleteFriends:(NSNumber *)ownerId{
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    request.entity = [NSEntityDescription entityForName:@"Friends" inManagedObjectContext:self.mainContext];
    
    request.predicate = [NSPredicate predicateWithFormat:@"ownerId = %d ", ownerId.intValue];
    
    request.includesPendingChanges = YES;
    //request.fetchLimit = 1;
    
    NSError *error = nil;
	NSArray *deleteArray = [self.mainContext executeFetchRequest:request error:&error];
    
    for (Actor *actor in deleteArray) {
        
        [self.mainContext deleteObject:actor];
    }
    
    [self.mainContext save:nil];
    
}

-(Friends *)getEmptyFriend{
    Friends *friend = [NSEntityDescription insertNewObjectForEntityForName:@"Friends"
                                                    inManagedObjectContext:self.mainContext];
    return friend;
}


#pragma mark - 我的動態

-(void)activityToDB:(NSData *)data withUserID:(NSNumber *)userId withPage:(NSNumber *)page withStatus:(NSString *)status{
    //Activity.h
    if (page.intValue<=1) {
            [self deleteActivity:userId withStatus:status];
    }
    
    
    NSArray *JSON = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    

    
    for(NSDictionary *dict in JSON)
    {
        Activity *activity = [NSEntityDescription insertNewObjectForEntityForName:@"Activity"
                                                        inManagedObjectContext:self.mainContext];
        activity.userId=[self replaceNullNumber:dict[@"User"][@"Id"]];
        activity.nickName=[self replaceNullString:dict[@"User"][@"NickName"]];
        activity.avatar=[self replaceNullString:dict[@"User"][@"Avatar"]];

        //activity.avatar=dict[@"User"][@"Avatar"];
        activity.type=[self replaceNullString:dict[@"Type"]];
        activity.typeId=[self replaceNullNumber:dict[@"TypeId"]];
        activity.title=[self replaceNullString:dict[@"Title"]];
        activity.content=[self replaceNullString:dict[@"Content"]];
        
        NSInteger sec=[dict[@"CreatedOn"] integerValue];
        activity.createdOn=[NSDate dateWithTimeIntervalSince1970:sec];
        activity.videoId=[self replaceNullString:dict[@"VideoId"]];
        activity.status=status;
        activity.remark=[self replaceNullString:dict[@"Remark"]];
    }
    
    [self.mainContext save:nil];
}

-(void)deleteActivity:(NSNumber *)userId withStatus:(NSString *)status{
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    request.entity = [NSEntityDescription entityForName:@"Activity" inManagedObjectContext:self.mainContext];
    
    if ([status isEqualToString:@"userStatus"]) {
        request.predicate = [NSPredicate predicateWithFormat:@"userId = %d && status = %@", userId.intValue,status];
    }else{
        request.predicate = [NSPredicate predicateWithFormat:@"status = %@",status];
    }

    
    request.includesPendingChanges = YES;
    
    NSError *error = nil;
	NSArray *deleteArray = [self.mainContext executeFetchRequest:request error:&error];
    
    NSLog(@"deleteArray:%d",deleteArray.count);
    
    for (Activity *activity in deleteArray) {
        
        [self.mainContext deleteObject:activity];
    }
    
    [self.mainContext save:nil];
    
}

-(NSArray *)getActivity:(NSNumber *)userId withStatus:(NSString *)status{
    
    NSArray *activityArray = nil;
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
	request.entity = [NSEntityDescription entityForName:@"Activity"
                                 inManagedObjectContext:self.mainContext];
    
    if ([status isEqualToString:@"userStatus"]) {
        request.predicate = [NSPredicate predicateWithFormat:@"userId = %d && status = %@", userId.intValue,status];
    }else{
        request.predicate = [NSPredicate predicateWithFormat:@"status = %@",status];
    }
    
    request.includesPendingChanges = YES;
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"createdOn" ascending:NO]];
    NSError *error = nil;
    activityArray = [self.mainContext executeFetchRequest:request error:&error];
    
    return activityArray;
    
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

#pragma mark - singleton implementation code

//static APIManager *singletonManager = nil;
+ (PersistentManager *)sharedInstance {
    
    static dispatch_once_t pred;
    static PersistentManager *manager;
    
    dispatch_once(&pred, ^{
        manager = [[self alloc] init];
    });
    return manager;
}
@end
