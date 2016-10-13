//
//  AustinApi.m
//  MovieCaker_iOS
//
//  Created by Albert Hsu on 4/20/16.
//  Copyright © 2016 Albert Hsu. All rights reserved.
//

#import "AustinApi.h"
#import "AFNetworking.h"
#define SERVERAPI @"http://moviecaker.com"
#define SERVERAPI2 @"http://moviecaker.com:8082"

@interface AustinApi()
@property NSDate *date;
@end
@implementation AustinApi
+ (instancetype)sharedInstance{
    static dispatch_once_t once;
    static id sharedInstance;
    
    dispatch_once(&once, ^
                  {
                      sharedInstance = [self new];
                     });
    
    return sharedInstance;
}

-(void)apiRegisterPost:(NSString*)unionId completion:(void (^)(NSMutableDictionary *returnData))completion error:(void (^)(NSError *error))error
{
    
    NSDictionary *parameter = @{@"ProviderUserId": unionId,
                                @"Provider": @"wechat"
                                };
    NSString *postString = [NSString stringWithFormat:@"api/Account/ExternalLogin"];
    
    [self apiPostMethod:postString parameter:parameter addTokenHeader:nil completion:^(id response) { NSLog(@"response%@",response);
        if ([response isKindOfClass:[NSDictionary class]]) {
            completion(response);
        }
    } error:^(NSError *err) {
        NSLog(@"ERR");
        error(err);
    }];
}

-(void)apiPatchMethod:(NSString *)postUrl parameter:parameters addTokenHeader:(NSString*)addToken completion:(void (^)(id response))completion error:(void (^)(NSError *error))error
{
    //[[LoadingView sharedView] open];
    NSURL *baseURL = [NSURL URLWithString:SERVERAPI];
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:baseURL];
    
    //test- manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer]; //test+
    
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"application/json"];
    
    //test - [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [manager.requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"]; //test+
    
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    [manager.requestSerializer setValue:@"zh_tw" forHTTPHeaderField:@"language"];
    
    /* if (addToken != nil) {
     NSString * access_token_s = (NSString*)[[Api sharedInstance] loadSetting:@"access_token_s"];
     NSString *token = [NSString stringWithFormat:@"Bearer %@",access_token_s];
     [manager.requestSerializer setValue:token forHTTPHeaderField:@"Authorization"];
     }*/
    
    [manager PATCH:postUrl parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        //[[LoadingView sharedView] close];
        
        completion(responseObject);
        
    } failure:^(NSURLSessionDataTask *task, NSError *err) {
        //[[LoadingView sharedView] close];
        
        error(err);
    }];
}

-(void)apiPostMethod:(NSString *)postUrl parameter:parameters addTokenHeader:(NSString*)addToken completion:(void (^)(id response))completion error:(void (^)(NSError *error))error
{
    //[[LoadingView sharedView] open];
    NSURL *baseURL = [NSURL URLWithString:SERVERAPI];
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:baseURL];
    
    //test- manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer]; //test+
    
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"application/json"];
    
    //test - [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [manager.requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"]; //test+
    
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    [manager.requestSerializer setValue:@"zh_tw" forHTTPHeaderField:@"language"];
    
   /* if (addToken != nil) {
        NSString * access_token_s = (NSString*)[[Api sharedInstance] loadSetting:@"access_token_s"];
        NSString *token = [NSString stringWithFormat:@"Bearer %@",access_token_s];
        [manager.requestSerializer setValue:token forHTTPHeaderField:@"Authorization"];
    }*/
    
    [manager POST:postUrl parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        //[[LoadingView sharedView] close];
        
        completion(responseObject);
        
    } failure:^(NSURLSessionDataTask *task, NSError *err) {
        //[[LoadingView sharedView] close];
        
        error(err);
    }];
}

-(void)apiGetMethod:(NSString *)getUrl parameter:parameters addTokenHeader:(NSString*)addToken completion:(void (^)(id response))completion error:(void (^)(NSError *error))error
{
    //[[LoadingView sharedView] open];

    NSURL *baseURL = [NSURL URLWithString:SERVERAPI];

    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:baseURL];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"application/json"];
    
  /*  if (addToken != nil) {
        NSString * access_token_s = (NSString*)[[Api sharedInstance] loadSetting:@"access_token_s"];
        NSString *token = [NSString stringWithFormat:@"Bearer %@",access_token_s];
        [manager.requestSerializer setValue:token forHTTPHeaderField:@"Authorization"];
    }*/
    
    [manager GET:getUrl parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        //[[LoadingView sharedView] close];
        completion(responseObject);
        
    } failure:^(NSURLSessionDataTask *task, NSError *err) {
        //[[LoadingView sharedView] close];
        error(err);
    }];
}

-(void)movieList:(void (^)(NSArray *returnData))completion error:(void (^)(NSError *error))error{
    [self apiGetMethod:@"api/video?type=released" parameter:nil addTokenHeader:@"1" completion:^(id response) {
       
        completion([response objectForKey:@"Data"]);
    } error:^(NSError *error2) {
        error(error2);
    }];
}

-(void)movieListCustom:(NSString*)type location:(NSString*)locationId year:(NSString*)year month:(NSString*)month page:(NSString*)page topicId:(NSString*)topicId function:(void (^)(NSArray*returnData))completion error:(void (^)(NSError *error))error{
    NSMutableDictionary *parameter =[[NSMutableDictionary alloc]initWithDictionary:@{@"type":type}];
    if(locationId!=nil){
        [parameter setObject:locationId forKey:@"locationId"];
    }
    if(year!=nil){
        [parameter setValue:year forKey:@"y"];
    }
    if(month!=nil){
        [parameter setValue:month forKey:@"m"];
    }
    if(page!=nil){
        [parameter setValue:page forKey:@"page"];
    }
    if(topicId!=nil){
        [parameter setValue:topicId forKey:@"topicId"];
    }
    NSLog(@"%@",parameter);
    [self apiGetMethod:@"api/video" parameter:parameter addTokenHeader:@"1" completion:^(id response) {
        if([type isEqualToString:@"1"]){
            NSLog(@"%@",response);
        }
        completion([response objectForKey:@"Data"]);
    } error:^(NSError *error2) {
        error(error2);
    }];
}

-(void)movieDetail:(NSString*)vid function:(void (^)(NSMutableDictionary *returnData))completion error:(void (^)(NSError *error))error{
    NSDictionary *parameter = @{@"vid":vid};
    [self apiGetMethod:@"api/video" parameter:parameter addTokenHeader:@"1" completion:^(id response) {
        
        completion([[response objectForKey:@"Data"]objectAtIndex:0]);
    } error:^(NSError *error2) {
        error(error2);	
    }];
}
-(void)getTopic:(NSString*)type vid:(NSString *)vid page:(NSString *)page uid:(NSString*)uid function:(void (^)(NSArray *returnData))completion error:(void (^)(NSError *error))error{
    NSMutableDictionary *parameter =[[NSMutableDictionary alloc]initWithDictionary: @{@"type":type}];
    if(vid!=nil){
        [parameter setObject:vid forKey:@"vid"];
    }
    if(page!=nil){
        [parameter setObject:page forKey:@"page"];
        [parameter setObject:@"10" forKey:@"limit"];
    }
    if(uid!=nil){
        [parameter setObject:uid forKey:@"uid"];
    }
    NSLog(@"%@",parameter);
    [self apiGetMethod:@"api/topic" parameter:parameter addTokenHeader:@"1" completion:^(id response) {
        
        completion([response objectForKey:@"Data"]);
    } error:^(NSError *error2) {
        error(error2);
    }];
}

-(void)getReview:(NSString*)order page:(NSString*)page function:(void (^)(NSArray *returnData))completion error:(void (^)(NSError *error))error{
    NSString *pageNo = @"1";
    if(page!=nil){
        pageNo = page;
    }
    NSDictionary *parameter = @{@"order":order,@"limit":@"10",@"page":pageNo};
    NSLog(@"%@",parameter);
    [self apiGetMethod:@"api/Review" parameter:parameter addTokenHeader:@"1" completion:^(id response) {
        
        completion([response objectForKey:@"Data"]);
    } error:^(NSError *error2) {
        error(error2);
    }];
}

-(void)getReviewByVid:(NSString *)vid function:(void (^)(NSArray *))completion error:(void (^)(NSError *))error{
    NSDictionary *parameter = @{@"vid":vid,@"limit":@"10"};
    [self apiGetMethod:@"api/Review" parameter:parameter addTokenHeader:@"1" completion:^(id response) {
        
        completion([response objectForKey:@"Data"]);
    } error:^(NSError *error2) {
        error(error2);
    }];
}

-(void)getReviewByrid:(NSString *)rid function:(void (^)(NSDictionary *))completion error:(void (^)(NSError *))error{
    NSDictionary *parameter = @{@"rid":rid,@"limit":@"10"};
    [self apiGetMethod:@"api/Review" parameter:parameter addTokenHeader:@"1" completion:^(id response) {
        
        completion([[response objectForKey:@"Data"]objectAtIndex:0]);
    } error:^(NSError *error2) {
        error(error2);
    }];
}
-(void)locationList:(void (^)(NSArray *returnData))completion error:(void (^)(NSError *error))error{
    NSDictionary *parameter = @{@"type": @"1"};
    [self apiGetMethod:@"api/location" parameter:parameter addTokenHeader:@"1" completion:^(id response) {
        
        completion([response objectForKey:@"Data"]);
    } error:^(NSError *error2) {
        error(error2);
    }];
}
-(NSString*)getBaseUrl{
    return SERVERAPI;
}
-(void)getCircleCompletion:(NSString*)topicId userId:(NSString*)userId function:(void (^)(NSDictionary *returnData))completion error:(void (^)(NSError *error))error{
    NSDictionary *parameter = @{@"userId": userId};
    [self apiGetMethod:[NSString stringWithFormat:@"api/topic/PercentComplete/%@",topicId] parameter:parameter addTokenHeader:@"1" completion:^(id response) {
        
        completion(response);
    } error:^(NSError *error2) {
        error(error2);
    }];
    
}
- (void)loginWithAccount:(NSString *)account
            withPassword:(NSString *)password
            withRemember:(BOOL)remember
                 function:(void (^)(NSDictionary *returnData))completion error:(void (^)(NSError *error))error {
    
    NSDictionary *param=nil;
    param=@{@"Email":account,@"Password":password,@"RememberMe":@"true"};
    //NSLog(@"%@",param);
    [self apiPostMethod:@"account/ajaxlogin" parameter:param addTokenHeader:@"1" completion:^(id response) {
        NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies];
        for (NSHTTPCookie *cookie in cookies) {
            // Here I see the correct rails session cookie
            NSLog(@"logincookie: %@", cookie);
        }
        completion(response);
    } error:^(NSError *error2) {
        error(error2);
    }];
    
}
-(void)socialAction:(NSString*)Id act:(NSString*)act obj:(NSString*)obj function:(void (^)(NSString *returnData))completion error:(void (^)(NSError *error))error{
//    NSLog(@"%@",[NSString stringWithFormat:@"api/Social?id=%@&act=%@&obj=%@",Id,act,obj]);

    NSURL *baseURL = [NSURL URLWithString:SERVERAPI];
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:baseURL];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager POST:[NSString stringWithFormat:@"api/Social?id=%@&act=%@&obj=%@",Id,act,obj] parameters:nil success:^(NSURLSessionDataTask *task, id response) {
        NSString *string = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
        completion(string);
        
    } failure:^(NSURLSessionDataTask *task, NSError *err) {

        error(err);
    }];
}
-(void)reviewChange:(NSString*)Id videoId:(NSString *)videoId score:(NSString*)score review:(NSString*)review function:(void (^)(NSDictionary *returnData))completion error:(void (^)(NSError *error))error{
    NSDictionary *param =@{@"Score":score,@"ReviewId":Id,@"VideoId":videoId,@"Review":review};
    [self apiPostMethod:@"api/Review" parameter:param addTokenHeader:@"1" completion:^(id response) {
        completion(response);
    } error:^(NSError *error2) {
        error(error2);
    }];
}
-(void)reviewReplyTable:(NSString*)Id function:(void (^)(NSArray *returnData))completion error:(void (^)(NSError *error))error{
    [self apiGetMethod:[NSString stringWithFormat:@"api/review/message/%@",Id] parameter:nil addTokenHeader:@"1" completion:^(id response) {
        completion(response);
    } error:^(NSError *error2) {
        error(error2);
    }];
}
-(void)reviewReply:(NSString*)ReviewId message:(NSString *)message function:(void (^)(NSString *returnData))completion error:(void (^)(NSError *error))error{
    NSDictionary *param = @{@"ReviewId":ReviewId,@"Message":message};
    [self apiPostMethod:@"api/review/message" parameter:param addTokenHeader:@"1" completion:^(id response) {
        completion(response);
    } error:^(NSError *error2) {
        error(error2);
    }];
}
-(void)getFriends:(NSString*)uid function:(void (^)(NSString *returnData))completion refresh:(BOOL)refresh{

    NSDate *now = [[NSDate alloc]init];
    if(self.date==nil||[now timeIntervalSinceDate:self.date]>180||refresh){
        self.date = now;
    [self apiGetMethod:[NSString stringWithFormat:@"api/friend/%@",uid] parameter:nil addTokenHeader:nil completion:^(id response) {
        self.friendList =response;
        NSLog(@"list%@",response);
        if(completion!=nil){
            completion(response);
        }
    } error:^(NSError *error) {
    NSLog(@"%@",error);
    }];
    [self apiGetMethod:[NSString stringWithFormat:@"api/friend/%@?invite=true",uid] parameter:nil addTokenHeader:nil completion:^(id response) {
        self.friendWaitList =[[NSMutableArray alloc] initWithArray:response];
        NSLog(@"inviting%@",response);
        if(completion!=nil){
            completion(response);
        }
    } error:^(NSError *error) {
        NSLog(@"%@",error);
    }];}
    
    if(self.date==nil){
        self.friendList = [[NSMutableArray alloc]init];
        self.friendWaitList = [[NSMutableArray alloc] init];
        self.date = [[NSDate alloc]init];
    }else{
        NSLog(@"%f",[now timeIntervalSinceDate:self.date]);
    }
}
-(int)testFriend:(NSString*)uid{

    for (NSDictionary *row in self.friendList) {
        if([[[row objectForKey:@"UserId"]stringValue]isEqualToString:uid]){
            return 2;
        }
    }
    for (NSDictionary *row in self.friendWaitList) {
        if([[[row objectForKey:@"UserId"]stringValue]isEqualToString:uid]&&[[row objectForKey:@"IsBeingInviting"]boolValue]==TRUE){
            return 1;
        }
    }
    return 0;
}
-(void)addFriend:(NSNumber *)uid{
    [self.friendWaitList addObject:[[NSDictionary alloc] initWithObjectsAndKeys:[NSNumber numberWithBool:TRUE],@"IsBeingInviting",uid,@"UserId", nil]];
    [self apiPostMethod:[NSString stringWithFormat:@"api/Inviting/Invite/%@",[uid stringValue]] parameter:@"nil" addTokenHeader:@"1" completion:^(id response) {
        NSLog(@"%@",response);
    } error:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

-(void)getNotice:(void (^)(NSArray *returnData))completion error:(void (^)(NSError *error))error{
    [self apiGetMethod:@"api/Notification" parameter:nil addTokenHeader:@"1" completion:^(id response) {
        completion(response);
    } error:^(NSError *error2) {
        error(error2);
    }];
}
-(void)acceptFriend:(NSString*)uid function:(void (^)(NSString *returnData))completion{
    [self apiPostMethod:[NSString stringWithFormat:@"api/Friend/Accept/%@",uid] parameter:nil addTokenHeader:@"1" completion:^(id response) {
        NSLog(@"%@",response);
        completion(response);
    } error:^(NSError *error2) {
        NSLog(@"%@",error2);
    }];
}

-(void)inviteFriend:(NSString*)uid function:(void (^)(NSString *returnData))completion{
    [self apiPostMethod:[NSString stringWithFormat:@"api/Friend/Invite/%@",uid] parameter:nil addTokenHeader:@"1" completion:^(id response) {
        NSLog(@"%@",response);
        completion(response);
    } error:^(NSError *error2) {
        NSLog(@"%@",error2);
    }];
}

-(void)getStatistics:(NSString *)uid function:(void (^)(NSDictionary *))completion error:(void (^)(NSError *))error{
    [self apiGetMethod:[NSString stringWithFormat:@"api/UserDashBoard/%@",uid] parameter:nil addTokenHeader:@"1" completion:^(id response) {
        completion([response objectForKey:@"Data"]);
    } error:^(NSError *error2) {
        error(error2);
    }];
}
-(void)changeProfile:(NSString*)nick gender:(BOOL)gender birthday:(NSString*)birthday function:(void (^)(NSDictionary *))completion error:(void (^)(NSError *))error{
    NSString *genderString;
    if(gender){
        genderString = @"TRUE";
    }else{
        genderString = @"FALSE";
    }
    
    NSDictionary *params = [[NSDictionary alloc]initWithObjectsAndKeys:nick,@"NickName",genderString,@"Gender",birthday,@"BirthDay", nil];
    NSLog(@"%@",params);
    [self apiPatchMethod:@"api/Account/UserInfo" parameter:params addTokenHeader:@"1" completion:^(id response) {
        NSLog(@"%@",response);
        completion(response);
    } error:^(NSError *error2) {
        NSLog(@"%@",error2);
    }];

}
@end