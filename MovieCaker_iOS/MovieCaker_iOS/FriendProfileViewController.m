//
//  FriendProfileViewController.m
//  MovieCaker_iOS
//
//  Created by Albert Hsu on 11/29/16.
//  Copyright © 2016 Albert Hsu. All rights reserved.
//

#import "FriendProfileViewController.h"
#import "MainVerticalScroller.h"
#import "UIImageView+WebCache.h"
#import "UIImage+FontAwesome.h"
#import "AustinApi.h"

@interface FriendProfileViewController ()
@property MainVerticalScroller *helper;
@property (strong, nonatomic) IBOutlet UILabel *viewLabel;
@property (strong, nonatomic) IBOutlet UILabel *likeLabel;
@property (strong, nonatomic) IBOutlet UILabel *wantLabel;
@property (strong, nonatomic) IBOutlet UILabel *topicLabel;
@property (strong, nonatomic) IBOutlet UILabel *btnLabel;
@end

@implementation FriendProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.helper = [[MainVerticalScroller alloc]init];
    self.helper.nav = self.navigationController;
    [self.helper setupBackBtn2:self];
    [self.helper setupSinglePage:self.view];
    self.title = [self.data objectForKey:@"NickName"];
    NSLog(@"%@",self.data);

    [self.banner sd_setImageWithURL:[NSURL URLWithString:[self.data objectForKey:@"BannerUrl"]] placeholderImage:[UIImage imageNamed:@"img-placeholder.jpg"]];
    [self.avatar sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[self.data objectForKey:@"AvatarUrl"]]] placeholderImage:[UIImage imageNamed:@"img-placeholder.jpg"]];
    self.name.text = [self.data objectForKey:@"NickName"];
    self.location.text = [self.data objectForKey:@"LocationName"];
    if(![[self.data objectForKey:@"Gender"] isKindOfClass:[NSNull class]]&&[[self.data objectForKey:@"Gender"] integerValue]==1
       ){
        self.gender.image =[UIImage imageWithIcon:@"fa-male" backgroundColor:[UIColor clearColor] iconColor:[UIColor colorWithRed:(119/255.0f) green:(136/255.0f) blue:(153/255.0f) alpha:1.0] andSize:CGSizeMake(13, 18)];
    }else{
        self.gender.image =[UIImage imageWithIcon:@"fa-female" backgroundColor:[UIColor clearColor] iconColor:[UIColor colorWithRed:(255/255.0f) green:(136/255.0f) blue:(153/255.0f) alpha:1.0] andSize:CGSizeMake(13, 18)];
    }

    self.btnLabel.text = [NSString stringWithFormat:@"%@的電影",[self.data objectForKey:@"NickName"]];
    [[AustinApi sharedInstance] getStatistics:[self.data objectForKey:@"UserId"] function:^(NSDictionary *returnData) {
        self.viewLabel.text = [[returnData objectForKey:@"ViewCount"]stringValue];
        self.likeLabel.text = [[returnData objectForKey:@"LikeCount"] stringValue];
        self.wantLabel.text = [[returnData objectForKey:@"WantViewCount"] stringValue];
        self.topicLabel.text = [[returnData objectForKey:@"TopicCount"] stringValue];
        
        NSLog(@"%@",returnData);
    } error:^(NSError *error) {
        NSLog(@"%@",error);
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
