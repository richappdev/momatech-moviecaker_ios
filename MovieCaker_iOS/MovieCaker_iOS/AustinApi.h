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

-(void)movieList:(void (^)(NSArray *returnData))completion error:(void (^)(NSError *error))error;
-(void)locationList:(void (^)(NSArray *returnData))completion error:(void (^)(NSError *error))error;
-(void)movieDetail:(NSString*)vid function:(void (^)(NSMutableDictionary *returnData))completion error:(void (^)(NSError *error))error;
-(void)getTopic:(NSString*)type vid:(NSString *)vid page:(NSString*)page function:(void (^)(NSArray *returnData))completion error:(void (^)(NSError *error))error;
-(void)getReview:(NSString*)order page:(NSString*)page function:(void (^)(NSArray *returnData))completion error:(void (^)(NSError *error))error;
-(void)getCircleCompletion:(NSString*)topicId userId:(NSString*)userId function:(void (^)(NSDictionary *returnData))completion error:(void (^)(NSError *error))error;
-(NSString*)getBaseUrl;
-(void)movieListCustom:(NSString*)type location:(NSString*)locationId year:(NSString*)year month:(NSString*)month page:(NSString*)page topicId:(NSString*)topicId function:(void (^)(NSArray *returnData))completion error:(void (^)(NSError *error))error;
-(void)getReviewByVid:(NSString *)vid function:(void (^)(NSArray *))completion error:(void (^)(NSError *))error;
- (void)loginWithAccount:(NSString *)account
            withPassword:(NSString *)password
            withRemember:(BOOL)remember
                function:(void (^)(NSDictionary *returnData))completion error:(void (^)(NSError *error))error;
-(void)socialAction:(NSString*)Id act:(NSString*)act obj:(NSString*)obj function:(void (^)(NSString *returnData))completion error:(void (^)(NSError *error))error;
-(void)getReviewByrid:(NSString *)rid function:(void (^)(NSDictionary *))completion error:(void (^)(NSError *))error;
-(void)reviewChange:(NSString*)Id videoId:(NSString *)videoId score:(NSString*)score review:(NSString*)review function:(void (^)(NSDictionary *returnData))completion error:(void (^)(NSError *error))error;
-(void)reviewReplyTable:(NSString*)Id function:(void (^)(NSArray *returnData))completion error:(void (^)(NSError *error))error;
-(void)reviewReply:(NSString*)ReviewId message:(NSString *)message function:(void (^)(NSString *returnData))completion error:(void (^)(NSError *error))error;
-(void)getFriends:(NSString*)uid function:(void (^)(NSString *returnData))completion refresh:(BOOL)refresh;
-(int)testFriend:(NSString*)uid;
-(void)addFriend:(NSNumber*)uid;
-(void)getNotice:(void (^)(NSArray *returnData))completion error:(void (^)(NSError *error))error;

@property NSMutableArray* friendList;
@property NSMutableArray* friendWaitList;
@end
