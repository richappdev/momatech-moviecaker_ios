//
//  AustinApi.h
//  MovieCaker_iOS
//
//  Created by Albert Hsu on 4/20/16.
//  Copyright © 2016 Albert Hsu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AustinApi : NSObject

+ (instancetype)sharedInstance;

-(void)apiRegisterPost:(NSString*)unionId completion:(void (^)(NSMutableDictionary *returnData))completion error:(void (^)(NSError *error))error;

-(void)movieList:(void (^)(NSMutableDictionary *returnData))completion error:(void (^)(NSError *error))error;
-(void)locationList:(void (^)(NSArray *returnData))completion error:(void (^)(NSError *error))error;
-(void)movieDetail:(NSString*)vid function:(void (^)(NSMutableDictionary *returnData))completion error:(void (^)(NSError *error))error;
-(void)getTopic:(NSString*)type vid:(NSString *)vid function:(void (^)(NSArray *returnData))completion error:(void (^)(NSError *error))error;
-(void)getReview:(NSString*)order function:(void (^)(NSArray *returnData))completion error:(void (^)(NSError *error))error;
-(void)getCircleCompletion:(NSString*)topicId userId:(NSString*)userId function:(void (^)(NSDictionary *returnData))completion error:(void (^)(NSError *error))error;
-(NSString*)getBaseUrl;
-(void)movieListCustom:(NSString*)type location:(NSString*)locationId year:(NSString*)year month:(NSString*)month function:(void (^)(NSArray *returnData))completion error:(void (^)(NSError *error))error;
-(void)getReviewByVid:(NSString *)vid function:(void (^)(NSArray *))completion error:(void (^)(NSError *))error;
- (void)loginWithAccount:(NSString *)account
            withPassword:(NSString *)password
            withRemember:(BOOL)remember
                function:(void (^)(NSDictionary *returnData))completion error:(void (^)(NSError *error))error;
-(void)socialAction:(NSString*)Id act:(NSString*)act obj:(NSString*)obj function:(void (^)(NSString *returnData))completion error:(void (^)(NSError *error))error;
-(void)getReviewByrid:(NSString *)rid function:(void (^)(NSDictionary *))completion error:(void (^)(NSError *))error;
@end
