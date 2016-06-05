//
//  AustinApi.m
//  MovieCaker_iOS
//
//  Created by Albert Hsu on 4/20/16.
//  Copyright © 2016 Albert Hsu. All rights reserved.
//

#import "AustinApi.h"
#import "AFNetworking.h"
#define SERVERAPI @"http://112.124.24.14"
#define SERVERAPI2 @"http://112.124.24.14:8082"


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

    if([getUrl containsString:@"topic"]){
        baseURL = [NSURL URLWithString:SERVERAPI2];
    }
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

-(void)movieDetail:(NSString*)vid function:(void (^)(NSMutableDictionary *returnData))completion error:(void (^)(NSError *error))error{
    NSDictionary *parameter = @{@"vid":vid};
    [self apiGetMethod:@"api/video" parameter:parameter addTokenHeader:@"1" completion:^(id response) {
        
        completion([[response objectForKey:@"Data"]objectAtIndex:0]);
    } error:^(NSError *error2) {
        error(error2);	
    }];
}
-(void)getTopic:(NSString*)type function:(void (^)(NSArray *returnData))completion error:(void (^)(NSError *error))error{
    NSDictionary *parameter = @{@"type":type};
    [self apiGetMethod:@"v1/topic" parameter:parameter addTokenHeader:@"1" completion:^(id response) {
        
        completion([response objectForKey:@"Data"]);
    } error:^(NSError *error2) {
        error(error2);
    }];
}

-(void)locationList:(void (^)(NSMutableDictionary *returnData))completion error:(void (^)(NSError *error))error{
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
@end