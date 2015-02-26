//
//  MyActivityViewController.m
//  MovieCaker
//
//  Created by iKevin on 2014/1/12.
//  Copyright (c) 2014年 iKevin. All rights reserved.
//

#import "MyActivityViewController.h"
#import "ActivityCell.h"
#import "ActivityObj.h"
#import "VideoContentViewController.h"
#import "TopicDetailViewController.h"
#import "PertyContentViewController.h"
#import "ReplyPartyTalkViewController.h"


@interface MyActivityViewController ()
    @property(nonatomic,strong) NSMutableArray *activityArray;
    @property (nonatomic, strong) NSDateFormatter *df;
    @property(nonatomic,strong) NSNumber *page;
    @property(assign,nonatomic) BOOL isLoading;
    @property(assign,nonatomic) BOOL isLast;
    @property (nonatomic, strong) NSDictionary *userInfo;
@end

@implementation MyActivityViewController

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
    
    
    self.userInfo=[self.manager getLoginUnfo];
    NSNumber *userID=self.userInfo[@"UserId"];
    if (userID.intValue==self.friend.userId.intValue) {
        self.title=NSLocalizedStringFromTable(@"我的動態",@"InfoPlist",nil);
    }else{
        self.title=[NSString stringWithFormat:@"%@%@%@",self.friend.nickName,NSLocalizedStringFromTable(@"的",@"InfoPlist",nil),NSLocalizedStringFromTable(@"動態",@"InfoPlist",nil)];
    }
    
    self.topButton.hidden=YES;
    
    UIButton *left = [UIButton buttonWithType:UIButtonTypeCustom];
    [left setImage:[UIImage imageNamed:@"Arrow"] forState:UIControlStateNormal];
    left.frame = CGRectMake(0, 0, 32, 32);
    left.showsTouchWhenHighlighted = YES;
    [left addTarget:self
             action:@selector(back:)
   forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:left];
    
    self.activityArray=[[NSMutableArray alloc] init];
    self.page=[NSNumber numberWithInt:1];
    
    self.df = [[NSDateFormatter alloc] init];
    self.df.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    
    [self.myTableView registerNib:[UINib nibWithNibName:@"ActivityCell" bundle:nil] forCellReuseIdentifier:@"ActivityCell"];
    
    
    
    
    [WaitingAlert presentWithText:NSLocalizedStringFromTable(@"請稍後...",@"InfoPlist",nil) withTimeOut:30];
    [self loadData:self.page];
    
    
    // Do any additional setup after loading the view from its nib.
}

-(void)back:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    

}
-(void)loadData:(NSNumber *)page{
    
    self.isLoading=YES;
    int sum=self.page.intValue*10;
    [self.manager activityWithUserId:self.friend.userId withPage:page withStatus:@"userStatus" callback:^(NSArray *activityArray, NSString *errorMsg, NSError *error) {
        
        [WaitingAlert dismiss];
        self.isLoading=NO;
        
        if (activityArray.count<sum) {
            self.isLast=YES;
        }
        
        if (activityArray.count>0) {
            [self.activityArray removeAllObjects];
            [self.activityArray addObjectsFromArray:activityArray];
            [self.myTableView reloadData];
        }

        self.myTableView.tableFooterView=nil;
        
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
    ActivityObj *activity=self.activityArray[indexPath.row];
    
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
    cell.content.text=@"";
    
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
        if ([self.lang isEqualToString:@"zh-Hant"]) {
            cell.content.text=[NSString stringWithFormat:@"在「%@」社團建立 話題:%@",activity.remark,activity.title];
        }else{
            cell.content.text=[NSString stringWithFormat:@"在「%@」群组建立 话题:%@",activity.remark,activity.title];
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
            
            cell.content.text=[NSString stringWithFormat:@"在「%@」社團回應「%@」話題：%@",activity.remark, activity.content,activity.title];
        }else{
            cell.content.text=[NSString stringWithFormat:@"在「%@」群组回应「%@」话题：%@",activity.remark, activity.content,activity.title];
            
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
