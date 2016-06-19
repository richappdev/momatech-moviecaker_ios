//
//  AustinApi.m
//  MovieCaker_iOS
//
//  Created by Albert Hsu on 4/20/16.
//  Copyright © 2016 Albert Hsu. All rights reserved.
//

#import "AustinApi.h"
#import "AFNetworking.h"
#define SERVERAPI @"http://test.moviecaker.com"
#define SERVERAPI2 @"http://test.moviecaker.com:8082"


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
    
    [self apiPostMethod:postString parameter:parameter addTokenHeader:nil completion:^(id response) {
        if ([response isKindOfClass:[NSDictionary class]]) {
            completion(response);
        }
    } error:^(NSError *err) {
        NSLog(@"ERR");
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
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
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

-(void)movieList:(void (^)(NSMutableDictionary *returnData))completion error:(void (^)(NSError *error))error{
    [self apiGetMethod:@"api/video" parameter:nil addTokenHeader:@"1" completion:^(id response) {
       
        completion([response objectForKey:@"Data"]);
    } error:^(NSError *error2) {
        error(error2);
    }];
}

-(void)movieListCustom:(NSString*)type location:(NSString*)locationId year:(NSString*)year month:(NSString*)month function:(void (^)(NSArray*returnData))completion error:(void (^)(NSError *error))error{
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
-(void)getTopic:(NSString*)type vid:(NSString *)vid function:(void (^)(NSArray *returnData))completion error:(void (^)(NSError *error))error{
    NSMutableDictionary *parameter =[[NSMutableDictionary alloc]initWithDictionary: @{@"type":type}];
    if(vid!=nil){
        [parameter setObject:vid forKey:@"vid"];
    }
    NSLog(@"%@",parameter);
    [self apiGetMethod:@"api/topic" parameter:parameter addTokenHeader:@"1" completion:^(id response) {
        
        completion([response objectForKey:@"Data"]);
    } error:^(NSError *error2) {
        error(error2);
    }];
}

-(void)getReview:(NSString*)order function:(void (^)(NSArray *returnData))completion error:(void (^)(NSError *error))error{
    NSDictionary *parameter = @{@"order":order,@"limit":@"10"};
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
    [self apiPostMethod:[NSString stringWithFormat:@"api/Social?id=%@&act=%@&obj=%@",Id,act,obj] parameter:nil addTokenHeader:@"1" completion:^(id response) {
        NSString *string = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
        completion(string);
    } error:^(NSError *error2) {
        error(error2);
    }];
}
@end