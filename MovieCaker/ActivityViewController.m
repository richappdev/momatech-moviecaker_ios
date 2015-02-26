//
//  ActivityViewController.m
//  MovieCaker
//
//  Created by iKevin on 2014/1/13.
//  Copyright (c) 2014年 iKevin. All rights reserved.
//

#import "ActivityViewController.h"
#import "ActivityCell.h"
#import "ActivityObj.h"
#import "VideoContentViewController.h"
#import "TopicDetailViewController.h"
#import "PertyContentViewController.h"
#import "ReplyPartyTalkViewController.h"

@interface ActivityViewController ()
    @property(nonatomic,strong) NSMutableArray *activityArray;
    @property (nonatomic,strong) NSDateFormatter *df;
    @property (nonatomic, strong) NSNumber *uid;
    @property (nonatomic, strong) NSDictionary *userInfo;
    @property(nonatomic,strong) NSNumber *page;
    @property(assign,nonatomic) BOOL isLoading;
    @property(assign,nonatomic) BOOL isLast;
@end

@implementation ActivityViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupDefaultNavBarButtons];
    self.title=NSLocalizedStringFromTable(@"動態消息",@"InfoPlist",nil);
    
    self.page=[NSNumber numberWithInt:1];
    self.activityArray=[[NSMutableArray alloc] init];
    
    self.df = [[NSDateFormatter alloc] init];
    
    self.df.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    
    self.topButton.hidden=YES;
    self.myTableView.tableFooterView=nil;
    
    if ([self.manager isLogined]) {
        self.userInfo=[self.manager getLoginUnfo];
        self.uid=self.userInfo[@"UserId"];
    }else{
        self.uid=[NSNumber numberWithInt:0];
    }

    [self.myTableView registerNib:[UINib nibWithNibName:@"ActivityCell" bundle:nil] forCellReuseIdentifier:@"ActivityCell"];
    
    [WaitingAlert presentWithText:[NSString stringWithFormat:@"請稍後..."] withTimeOut:30];
    [self loadData:self.page];
    
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}
-(void)loadData:(NSNumber *)page{
    
    self.isLoading=YES;
    int sum=self.page.intValue*10;
    
    [self.manager activityWithUserId:self.uid withPage:page withStatus:@"friendStatus" callback:^(NSArray *activityArray, NSString *errorMsg, NSError *error) {
        
        self.isLoading=NO;
        
        if (activityArray.count<sum) {
            self.isLast=YES;
        }
        
        if (self.activityArray.count<activityArray.count) {
            [self.activityArray removeAllObjects];
            [self.activityArray addObjectsFromArray:activityArray];
            [self.myTableView reloadData];
        }
        
        if (activityArray.count==0) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                            message:NSLocalizedStringFromTable(@"目前沒有動態消息！",@"InfoPlist",nil)
                                                           delegate:nil
                                                  cancelButtonTitle:NSLocalizedStringFromTable(@"確定",@"InfoPlist",nil)
                                                  otherButtonTitles:nil];
            [alert show];
        }
        self.myTableView.tableFooterView=nil;
        [WaitingAlert dismiss];
        
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.activityArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 102;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellIdentifier = @"ActivityCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    [self configureActivityCell:(ActivityCell *)cell atIndexPath:indexPath];
    return cell;
    
    
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ActivityObj *activity=(ActivityObj *)self.activityArray[indexPath.row];
    NSLog(@"activity.type:%@,indexPath:%d",activity.type,indexPath.row);
    
    
    /*
     [Type]                             [名稱]             [TypeId]
     liked_review                    // 喜歡影評         // 影評
     liked_topic                     // 喜歡專題         // 專題
     created_review                  // 寫影評           // 影評
     created_topic                   // 做專題           // 專題
     viewed_movie                    // 看過電影         // 電影
     liked_movie                     // 喜歡電影         // 電影
     wannna_view_movie               // 想看電影         // 電影
     joined_club                     // 加入社團         // 社團
     created_club                    // 建立社團         // 社團
     created_club_topic              // 新增社團話題     // 社團話題
     liked_club_topic                // 喜歡社團話題     // 社團話題
     created_club_topic_message      // 新增社團話題留言 // 社團話題
     */
    
    //喜歡影評
    if ([activity.type isEqualToString:@"liked_review"]) {
        VideoContentViewController *vcvc=[[VideoContentViewController alloc] initWithNibName:@"VideoContentViewController" bundle:nil];
        vcvc.videoId=activity.videoId;
        vcvc.landingNo=1;
        [self.navigationController pushViewController:vcvc animated:YES];
    }
    
    //喜歡專題
    if ([activity.type isEqualToString:@"liked_topic"]) {
        
        TopicDetailViewController *topicDetailVC=[[TopicDetailViewController alloc] initWithNibName:@"TopicDetailViewController" bundle:nil];
        topicDetailVC.topicId=activity.typeId;
        topicDetailVC.channel=@"Activity";
        [self.navigationController pushViewController:topicDetailVC animated:YES];
    }
    //寫影評
    if ([activity.type isEqualToString:@"created_review"]) {
        VideoContentViewController *vcvc=[[VideoContentViewController alloc] initWithNibName:@"VideoContentViewController" bundle:nil];
        vcvc.videoId=activity.videoId;
        vcvc.landingNo=1;
        [self.navigationController pushViewController:vcvc animated:YES];
    }
    
    //建立專題
    if ([activity.type isEqualToString:@"created_topic"]) {
        TopicDetailViewController *topicDetailVC=[[TopicDetailViewController alloc] initWithNibName:@"TopicDetailViewController" bundle:nil];
        topicDetailVC.topicId=activity.typeId;
        topicDetailVC.channel=@"Activity";
        [self.navigationController pushViewController:topicDetailVC animated:YES];
    }
    

    //喜歡電影
    if ([activity.type isEqualToString:@"liked_movie"]) {
        VideoContentViewController *vcvc=[[VideoContentViewController alloc] initWithNibName:@"VideoContentViewController" bundle:nil];
        vcvc.videoId=activity.videoId;
        vcvc.landingNo=0;
        [self.navigationController pushViewController:vcvc animated:YES];
    }

    
    //看過電影
    if ([activity.type isEqualToString:@"viewed_movie"]) {
        VideoContentViewController *vcvc=[[VideoContentViewController alloc] initWithNibName:@"VideoContentViewController" bundle:nil];
        vcvc.videoId=activity.videoId;
        vcvc.landingNo=0;
        [self.navigationController pushViewController:vcvc animated:YES];
    }
    
    //想看電影
    if([activity.type isEqualToString:@"wannna_view_movie"]){
        
        VideoContentViewController *vcvc=[[VideoContentViewController alloc] initWithNibName:@"VideoContentViewController" bundle:nil];
        vcvc.videoId=activity.videoId;
        vcvc.landingNo=0;
        [self.navigationController pushViewController:vcvc animated:YES];
    }
    
    //加入社團
    if ([activity.type isEqualToString:@"joined_club"]) {
        PertyContentViewController *pcvc=[[PertyContentViewController alloc] initWithNibName:@"PertyContentViewController" bundle:nil];
        pcvc.partyID=activity.typeId;
        //vcvc.landingNo=1;
        [self.navigationController pushViewController:pcvc animated:YES];
    }
    
    //建立社團
    if ([activity.type isEqualToString:@"created_club"]) {
        PertyContentViewController *pcvc=[[PertyContentViewController alloc] initWithNibName:@"PertyContentViewController" bundle:nil];
        pcvc.partyID=activity.typeId;
        //vcvc.landingNo=1;
        [self.navigationController pushViewController:pcvc animated:YES];
    }
    
    //新增社團話題
    if ([activity.type isEqualToString:@"created_club_topic"]) {
        ReplyPartyTalkViewController *rptvc=[[ReplyPartyTalkViewController alloc] initWithNibName:@"ReplyPartyTalkViewController" bundle:nil];
        rptvc.talkId=activity.typeId;
        rptvc.partyName=activity.remark;
        rptvc.partyId=[NSNumber numberWithInt:activity.videoId.intValue];
        [self.navigationController pushViewController:rptvc animated:YES];
    }
    
    //喜歡社團話題
    if ([activity.type isEqualToString:@"liked_club_topic"]) {
        ReplyPartyTalkViewController *rptvc=[[ReplyPartyTalkViewController alloc] initWithNibName:@"ReplyPartyTalkViewController" bundle:nil];
        rptvc.talkId=activity.typeId;
        rptvc.partyName=activity.remark;
        rptvc.partyId=[NSNumber numberWithInt:activity.videoId.intValue];
        [self.navigationController pushViewController:rptvc animated:YES];
    }
    
    //新增社團話題留言
    if ([activity.type isEqualToString:@"created_club_topic_message"]) {
        
        NSLog(@"rptvc.talkId:%d",activity.typeId.intValue);
        
        ReplyPartyTalkViewController *rptvc=[[ReplyPartyTalkViewController alloc] initWithNibName:@"ReplyPartyTalkViewController" bundle:nil];
        rptvc.talkId=activity.typeId;
        rptvc.partyName=activity.remark;
        rptvc.partyId=[NSNumber numberWithInt:activity.videoId.intValue];
        [self.navigationController pushViewController:rptvc animated:YES];
        
    }
    
    //新增社團話題留言回覆內容
    if ([activity.type isEqualToString:@"replied_club_topic_message"]) {
        ReplyPartyTalkViewController *rptvc=[[ReplyPartyTalkViewController alloc] initWithNibName:@"ReplyPartyTalkViewController" bundle:nil];
        rptvc.talkId=activity.typeId;
        rptvc.partyName=activity.remark;
        rptvc.partyId=[NSNumber numberWithInt:activity.videoId.intValue];
        [self.navigationController pushViewController:rptvc animated:YES];
    }
}

-(void) configureActivityCell:(ActivityCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    
    ActivityObj *activity=self.activityArray[indexPath.row];
    NSString *path=[NSString stringWithFormat:@"%@/Uploads/UserAvatar/%@",PROPUCTION_API_DOMAIN,activity.avatar];
    
    
    cell.nickName.text=activity.nickName;
    
    if ([activity.type isEqualToString:@"liked_review"]) {
        if ([self.lang isEqualToString:@"zh-Hant"]) {
            cell.content.text=[NSString stringWithFormat:@"喜歡一則「%@」的影評\n%@",activity.title,activity.content];
        }else{
            cell.content.text=[NSString stringWithFormat:@"喜欢一则「%@」的影评\n%@",activity.title,activity.content];
        }
    }
    if ([activity.type isEqualToString:@"liked_topic"]) {
        if ([self.lang isEqualToString:@"zh-Hant"]) {
            cell.content.text=[NSString stringWithFormat:@"喜歡「%@」的專題\n%@",activity.title,activity.content];
        }else{
            cell.content.text=[NSString stringWithFormat:@"喜欢「%@」的专题\n%@",activity.title,activity.content];
        }
    }
    
    if ([activity.type isEqualToString:@"created_review"]) {
        if ([self.lang isEqualToString:@"zh-Hant"]) {
            cell.content.text=[NSString stringWithFormat:@"寫了一則「%@」影評\n%@",activity.title,activity.content];
        }else{
            cell.content.text=[NSString stringWithFormat:@"写了一则「%@」影评\n%@",activity.title,activity.content];
        }
    }
    
    if ([activity.type isEqualToString:@"created_topic"]) {
        if ([self.lang isEqualToString:@"zh-Hant"]) {
            cell.content.text=[NSString stringWithFormat:@"建立「%@」專題\n%@",activity.title,activity.content];
        }else{
            cell.content.text=[NSString stringWithFormat:@"建立「%@」专题\n%@",activity.title,activity.content];

        }
    }
    
    if ([activity.type isEqualToString:@"viewed_movie"]) {
        if ([self.lang isEqualToString:@"zh-Hant"]) {
            cell.content.text=[NSString stringWithFormat:@"看過「%@」電影\n%@",activity.title,activity.content];
        }else{
            cell.content.text=[NSString stringWithFormat:@"看过「%@」电影\n%@",activity.title,activity.content];
        }
    }
    
    if ([activity.type isEqualToString:@"liked_movie"]) {
        if ([self.lang isEqualToString:@"zh-Hant"]) {
            cell.content.text=[NSString stringWithFormat:@"喜歡「%@」的電影\n%@",activity.title,activity.content];
        }else{
            cell.content.text=[NSString stringWithFormat:@"喜欢「%@」的电影\n%@",activity.title,activity.content];
        }
    }
    if ([activity.type isEqualToString:@"made_review"]) {
        if ([self.lang isEqualToString:@"zh-Hant"]) {
            cell.content.text=[NSString stringWithFormat:@"寫了一篇「%@」的影評\n%@",activity.title,activity.content];
        }else{
            cell.content.text=[NSString stringWithFormat:@"写了一篇「%@」的影评\n%@",activity.title,activity.content];
        }
    }
    
    if([activity.type isEqualToString:@"liked"]){
        if ([self.lang isEqualToString:@"zh-Hant"]) {
            cell.content.text=[NSString stringWithFormat:@"喜歡「%@」的電影\n%@",activity.title,activity.content];
        }else{
            cell.content.text=[NSString stringWithFormat:@"喜欢「%@」的电影\n%@",activity.title,activity.content];

        }
    }
    
    if([activity.type isEqualToString:@"wannna_view_movie"]){
        if ([self.lang isEqualToString:@"zh-Hant"]) {
            cell.content.text=[NSString stringWithFormat:@"想要看「%@」的電影\n%@",activity.title,activity.content];
        }else{
            cell.content.text=[NSString stringWithFormat:@"想要看「%@」的电影\n%@",activity.title,activity.content];
        }

    }
    
    if ([activity.type isEqualToString:@"joined_club"]) {
        if ([self.lang isEqualToString:@"zh-Hant"]) {
            cell.content.text=[NSString stringWithFormat:@"加入「%@」社團\n%@",activity.title,activity.content];
        }else{
            cell.content.text=[NSString stringWithFormat:@"加入「%@」群组\n%@",activity.title,activity.content];
        }
    }
    
    if ([activity.type isEqualToString:@"created_club"]) {
        if ([self.lang isEqualToString:@"zh-Hant"]) {
            cell.content.text=[NSString stringWithFormat:@"建立「%@」社團\n%@",activity.title,activity.content];
        }else{
            cell.content.text=[NSString stringWithFormat:@"建立「%@」群组\n%@",activity.title,activity.content];
        }
    }
    
    if ([activity.type isEqualToString:@"created_club_topic"]) {
        if ([activity.type isEqualToString:@"created_club_topic"]) {
            if ([self.lang isEqualToString:@"zh-Hant"]) {
                cell.content.text=[NSString stringWithFormat:@"在「%@」社團建立 話題:%@",activity.remark,activity.title];
            }else{
                cell.content.text=[NSString stringWithFormat:@"在「%@」群组建立 话题:%@",activity.remark,activity.title];
            }
        }
    }
    
    if ([activity.type isEqualToString:@"liked_club_topic"] ) {
        if ([self.lang isEqualToString:@"zh-Hant"]) {
            cell.content.text=[NSString stringWithFormat:@"在「%@」社團喜歡一則「%@」話題\n%@",activity.remark,activity.title,activity.content];
        }else{
            cell.content.text=[NSString stringWithFormat:@"在「%@」群组喜欢一则「%@」话题\n%@",activity.remark,activity.title,activity.content];
        }
    }
    
    if ([activity.type isEqualToString:@"created_club_topic_message"]) {
        
        NSLog(@"%@",activity.type);
        if ([self.lang isEqualToString:@"zh-Hant"]) {

            cell.content.text=[NSString stringWithFormat:@"在「%@」 社團回應「%@」話題：%@",activity.remark, activity.content,activity.title];
        }else{
            cell.content.text=[NSString stringWithFormat:@"在「%@」 群组回应「%@」话题：%@",activity.remark, activity.content,activity.title];

        }
    }
    
    if ([activity.type isEqualToString:@"replied_club_topic_message"]) {
        
        if ([self.lang isEqualToString:@"zh-Hant"]) {
            
            cell.content.text=[NSString stringWithFormat:@" 在「%@」社團回覆「%@」話題:%@",activity.remark, activity.content,activity.title];
        }else{
            cell.content.text=[NSString stringWithFormat:@"在「%@」 群组回覆「%@」话题：%@",activity.remark, activity.content,activity.title];
            
        }
        
    }
    
    
    cell.createdOn.text=[self.df stringFromDate:activity.createdOn];
    [cell.avatarImageView setImageWithURL:[NSURL URLWithString:path] placeholderImage:[UIImage imageNamed:@"nobody.jpg"]];

}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    
    float pointY=scrollView.contentOffset.y;
    
    if (!decelerate) {
        if (pointY>150) {
            self.topButton.hidden=NO;
        }else{
            self.topButton.hidden=YES;
        }
    }
    
    if (self.isLoading) {
        return;
    }
    if (self.isLast) {
        return;
    }
    
    float startLoadY=scrollView.contentSize.height-self.view.frame.size.height;
    
    if (pointY>startLoadY) {
        self.page=@(self.page.intValue+1);
        self.myTableView.tableFooterView=self.footView;
        self.moreLabel.text=NSLocalizedStringFromTable(@"載入更多",@"InfoPlist",nil);
        [self loadData:self.page];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    float pointY=scrollView.contentOffset.y;
    
    if (pointY>150) {
        self.topButton.hidden=NO;
    }else{
        self.topButton.hidden=YES;
    }
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)topButtonPressed:(id)sender {
    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:0 inSection:0];
    [self.myTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
}
@end
