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

// API Document http://moviecaker.com/Help

// Review
#define API_REVIEW_ORDER_HOT1W      @"Hot1W"
#define API_REVIEW_ORDER_HOT        @"Hot"
#define API_REVIEW_ORDER_CREATEON   @"CreateOn"
#define API_REVIEW_ORDER_MYFRIEND   @"MyFriend"
#define API_REVIEW_ORDER_MODIFIEDON @"ModifiedOn"
#define API_REVIEW_ORDER_RELEASEON  @"ReleaseOn"
#define API_REVIEW_ORDER_CLICKONNUM @"ClickOnNum"
#define API_REVIEW_ORDER_LIKENUM    @"LikeNum"
#define API_REVIEW_ORDER_MESSAGENUM @"MessageNum"
#define API_REVIEW_ORDER_MINE       @"Mine"
#define API_REVIEW_ORDER_NEW        @"New"
#define API_REVIEW_ORDER_VIEW       @"View"

// Video
#define API_VIDEO_TYPE_WEEK         @"Week"
#define API_VIDEO_TYPE_FRIEND       @"Friend"
#define API_VIDEO_TYPE_GLOBAL       @"Global"
#define API_VIDEO_TYPE_INTOPIC      @"InTopic"
#define API_VIDEO_TYPE_ACTOR        @"Actor"
#define API_VIDEO_TYPE_MY           @"My"
#define API_VIDEO_TYPE_RELEASE      @"Release"
#define API_VIDEO_TYPE_MONTH        @"Month"
#define API_VIDEO_TYPE_YEAR         @"Year"
#define API_VIDEO_TYPE_RELEASEON    @"ReleaseOn"
#define API_VIDEO_TYPE_NEW          @"New"
#define API_VIDEO_TYPE_POS          @"POS"
#define API_VIDEO_TYPE_TOPIC        @"Topic"
#define API_VIDEO_TYPE_TOP          @"TOP"
#define API_VIDEO_TYPE_AWARD        @"Award"


-(void)apiRegisterPost:(NSString*)unionId completion:(void (^)(NSMutableDictionary *returnData))completion error:(void (^)(NSError *error))error;

-(void)movieList:(void (^)(NSArray *returnData))completion error:(void (^)(NSError *error))error;
-(void)locationList:(void (^)(NSArray *returnData))completion error:(void (^)(NSError *error))error;
-(void)movieDetail:(NSString*)vid function:(void (^)(NSMutableDictionary *returnData))completion error:(void (^)(NSError *error))error;
-(void)getTopic:(NSString*)type vid:(NSString *)vid page:(NSString*)page  uid:(NSString*)uid function:(void (^)(NSArray *returnData))completion error:(void (^)(NSError *error))error;
-(void)getReview:(NSString*)order page:(NSString*)page function:(void (^)(NSArray *returnData))completion error:(void (^)(NSError *error))error;
-(void)getCircleCompletion:(NSString*)topicId userId:(NSString*)userId function:(void (^)(NSDictionary *returnData))completion error:(void (^)(NSError *error))error;
-(NSString*)getBaseUrl;
-(void)movieListCustom:(NSString*)type myType:(NSString*)myType location:(NSString*)locationId year:(NSString*)year month:(NSString*)month page:(NSString*)page topicId:(NSString*)topicId function:(void (^)(NSArray *returnData))completion error:(void (^)(NSError *error))error;
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
-(void)getFriends:(NSString*)uid page:(int)page function:(void (^)(NSString *returnData))completion refresh:(BOOL)refresh;
-(int)testFriend:(NSString*)uid;
-(void)addFriend:(NSNumber*)uid;
-(void)getNotice:(void (^)(NSArray *returnData))completion error:(void (^)(NSError *error))error;

@property NSMutableArray* friendList;
@property NSMutableArray* friendWaitList;
@property int friendPage;
-(void)acceptFriend:(NSString*)uid function:(void (^)(NSString *returnData))completion;
-(void)inviteFriend:(NSString*)uid function:(void (^)(NSString *returnData))completion;
-(void)getStatistics:(NSString *)uid function:(void (^)(NSDictionary *))completion error:(void (^)(NSError *))error;
-(void)changeProfile:(NSString*)nick gender:(BOOL)gender birthday:(NSString*)birthday function:(void (^)(NSDictionary *))completion error:(void (^)(NSError *))error;
-(void)searchMovie:(NSString*)term completion:(void (^)(NSArray *returnData))completion error:(void (^)(NSError *error))error;
@end
