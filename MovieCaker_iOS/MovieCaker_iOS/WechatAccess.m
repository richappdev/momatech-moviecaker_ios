//
//  WechatAccess.m
//  MovieCaker_iOS
//
//  Created by Albert Hsu on 4/18/16.
//  Copyright © 2016 Albert Hsu. All rights reserved.
//

#import "WechatAccess.h"
#import "AFNetworking.h"

#define WECHAT_APP_ID         @"wxd0d7b13dff0c2d5e" //WXD0D7B13DFF0C2D5E
#define WECHAT_MCH_ID         @"1272035301"
#define WECHAT_KEY            @"AOGAKNHPNOJSZRA10KQDEJY5OGAYQYC5" //@"aogaknhpnojszra10kqdejy5ogayqyc5" //AOGAKNHPNOJSZRA10KQDEJY5OGAYQYC5
#define WECHAT_APP_SECRET     @"b509f23d24440efe31fff96c476d4761" //@"b509f23d24440efe31fff96c476d4761"B509F23D24440EFE31FFF96C476D4761

@interface WechatAccess ()<WXApiDelegate>{
    void(^_result)(BOOL,id);
    void(^_shareResult)(BOOL,id);
}
@end
@implementation WechatAccess

+ (instancetype)sharedInstance{
    static dispatch_once_t once;
    static id sharedInstance;
    
    dispatch_once(&once, ^
                  {
                      sharedInstance = [self new];
                  });
    
    return sharedInstance;
}
- (WechatAccess *)defaultAccess{
    static WechatAccess * __access = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __access = [[WechatAccess alloc] init];
    });
    return __access;
}	

- (BOOL)handleOpenURL:(NSURL *)url{
    return [WXApi handleOpenURL:url delegate:[self defaultAccess]];
}

- (void)login:(void(^)(BOOL succeeded, id object))result viewController:(UIViewController*)controller{
    _result = result;
    [WXApi registerApp:WECHAT_APP_ID];
    SendAuthReq *req = [[SendAuthReq alloc] init];
    [req setScope:@"snsapi_userinfo"];
    [WXApi sendAuthReq:req viewController:controller delegate:self];
}

- (void)onResp:(BaseResp *)resp{
    if (0 == [resp errCode]) {
        [self getUserInfoWith:[(SendAuthResp*)resp code]];
    } else {
        id desc = [NSNull null];
        if (-2 == [resp errCode]) {
            desc = @"ERR_USER_CANCEL";
        } else if (-4 == [resp errCode]) {
            desc = @"ERR_AUTH_DENIED";
        }
        _result(NO, [NSError errorWithDomain:@"kWechatOAuthErrorDomain" code:resp.errCode userInfo:@{NSLocalizedDescriptionKey:desc}]);
    }
}

- (void)getUserInfoWith:(NSString *)code{
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] init];
    [manager setResponseSerializer:[AFHTTPResponseSerializer serializer]];
    [manager POST:@"https://api.weixin.qq.com/sns/oauth2/access_token"
       parameters:@{@"appid" : WECHAT_APP_ID,
                    @"secret" : WECHAT_APP_SECRET,
                    @"grant_type" : @"authorization_code",
                    @"code" : code}
          success:^(AFHTTPRequestOperation *operation,id responseObject) {
              if ([responseObject isKindOfClass:[NSData class]]) {
                  responseObject = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:nil];
                  NSLog(@"resp1 : %@", responseObject);
              }
              NSString *openid = [responseObject objectForKey:@"openid"];
              NSString *access_token_w = [responseObject objectForKey:@"access_token"];
              
              NSString *refresh_token_w = [responseObject objectForKey:@"refresh_token"];
              
              NSLog(@"openid : %@, access_token : %@, refresh_token : %@", openid, access_token_w, refresh_token_w);
              
              [[NSUserDefaults standardUserDefaults] setObject:openid forKey:@"openid"];
              [[NSUserDefaults standardUserDefaults] setObject:access_token_w forKey:@"access_token_w"];
              [[NSUserDefaults standardUserDefaults] setObject:refresh_token_w forKey:@"refresh_token_w"];
              
              [manager GET:@"https://api.weixin.qq.com/sns/userinfo"
                parameters:responseObject
                   success:^(AFHTTPRequestOperation *operation,id responseObject) {
                       if ([responseObject isKindOfClass:[NSData class]]) {
                           responseObject = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:nil];
                       }
                       _result(YES, responseObject);
                   } failure:^(AFHTTPRequestOperation *operation,NSError *error) {
                       NSLog(@"error:%@",error);
                   }];
          } failure:^(AFHTTPRequestOperation *operation,NSError *error) {
              NSLog(@"%@",error);
          }];
}

- (BOOL)isWechatAppInstalled{
    return [[UIApplication sharedApplication]canOpenURL:[NSURL URLWithString:[NSString stringWithFormat:@"weixin://%@",WECHAT_APP_ID]]];
}
@end
