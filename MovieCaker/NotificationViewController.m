//
//  NotificationViewController.m
//  MovieCaker
//
//  Created by iKevin on 2014/5/4.
//  Copyright (c) 2014年 iKevin. All rights reserved.
//

#import "NotificationViewController.h"
#import "ActivityCell.h"

@interface NotificationViewController ()
    @property(strong, nonatomic) NSMutableArray *dataArray;
    @property (assign,nonatomic) BOOL isLoading;
    @property (assign,nonatomic) BOOL isLast;
    @property (strong, nonatomic) NSNumber *page;
@end

@implementation NotificationViewController

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
    self.title=@"通知";
    [self setupDefaultNavBarButtons];
    
    
    self.page=[NSNumber numberWithInt:1];
    self.dataArray=[[NSMutableArray alloc] init];
    self.isLast=NO;
    self.isLoading=NO;
    
    self.topButton.hidden=YES;
    
    self.myTableView.tableFooterView=nil;
    [self.myTableView registerNib:[UINib nibWithNibName:@"ActivityCell" bundle:nil] forCellReuseIdentifier:@"ActivityCell"];
    
    [self.manager resetNotice:@"Notification" success:^(BOOL showLocalNotification, NSString *errorMsg, NSError *error) {
       
    }];
    
    [self loadData];
    // Do any additional setup after loading the view from its nib.
}

- (void)loadData{
    self.isLoading=YES;
    [self.manager notification:self.page success:^(NSArray *dataArray, NSString *errorMsg, NSError *error) {
        self.isLoading=NO;
        self.myTableView.tableFooterView=nil;
        if (dataArray.count>0) {
            [self.dataArray addObjectsFromArray:dataArray];
            [self.myTableView reloadData];
        }else{
            self.isLast=YES;
            self.myTableView.tableFooterView=nil;
        }
    }];
    
}



#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *dic=self.dataArray[indexPath.row];
    
    NSString *type=dic[@"Message2ndType"];
    NSString *str;
    
    if ([type isEqualToString:@"System"]) {
        str=[NSString stringWithFormat:@"%@",[self replaceNullString:dic[@"Message"]]];
    }
    if ([type isEqualToString:@"Birthday"]) {
        str=[NSString stringWithFormat:@"%@",[self replaceNullString:dic[@"Message"]]];
    }
    if ([type isEqualToString:@"Review"]) {
        str=[NSString stringWithFormat:@"%@：%@",[self replaceNullString:dic[@"Title"]],[self replaceNullString:dic[@"Message"]]];
    }
    
    if ([type isEqualToString:@"ClubTopic"]) {
        str=[NSString stringWithFormat:@"%@：%@。來自『%@社團』",[self replaceNullString:dic[@"Title"]],[self replaceNullString:dic[@"Message"]],[self replaceNullString:dic[@"ClubName"]]];
    }
    
    
    if ([type isEqualToString:@"LikeReview"]) {
        str=[NSString stringWithFormat:@"%@：%@",[self replaceNullString:dic[@"Title"]],[self replaceNullString:dic[@"Message"]]];
    }
    
    if ([type isEqualToString:@"LikeTopic"]) {
        str=[NSString stringWithFormat:@"%@：%@",[self replaceNullString:dic[@"Title"]],[self replaceNullString:dic[@"Message"]]];
    }
    
    if ([type isEqualToString:@"JoinClubGreeting"]) {
        str=[NSString stringWithFormat:@"你已被批準加入社團，快來看看吧。%@",[self replaceNullString:dic[@"Message"]]];
    }
    
    if ([type isEqualToString:@"BeClubManager"]) {
        str=[NSString stringWithFormat:@"%@：%@",[self replaceNullString:dic[@"Title"]],[self replaceNullString:dic[@"Message"]]];
    }
    
    if ([type isEqualToString:@"ClubNotification"]) {
        str=[NSString stringWithFormat:@"%@：%@",[self replaceNullString:dic[@"Title"]],[self replaceNullString:dic[@"Message"]]];
    }
    
    if ([type isEqualToString:@"ClubInvitation"]) {
        str=[NSString stringWithFormat:@"%@：%@",[self replaceNullString:dic[@"Title"]],[self replaceNullString:dic[@"Message"]]];
    }
    
    if ([type isEqualToString:@"PushTopic"]) {
        str=[NSString stringWithFormat:@"%@：%@",[self replaceNullString:dic[@"Title"]],[self replaceNullString:dic[@"Message"]]];
    }
    
    if ([type isEqualToString:@"LikeClubTopic"]) {
        str=[NSString stringWithFormat:@"%@%@。來自『%@社團』",[self replaceNullString:dic[@"Title"]],[self replaceNullString:dic[@"Message"]],[self replaceNullString:dic[@"ClubName"]]];
    }
    
    if ([type isEqualToString:@"DeleteClubTopic"]) {
        str=[NSString stringWithFormat:@"%@：%@",[self replaceNullString:dic[@"Title"]],[self replaceNullString:dic[@"Message"]]];
    }
    
    if ([type isEqualToString:@"LikeReviewMessage"]) {
        str=[NSString stringWithFormat:@"%@：%@",[self replaceNullString:dic[@"Title"]],[self replaceNullString:dic[@"Message"]]];
    }
    
    if ([type isEqualToString:@"LikeTopicMessage"]) {
        str=[NSString stringWithFormat:@"%@：%@",[self replaceNullString:dic[@"Title"]],[self replaceNullString:dic[@"Message"]]];
    }
    
    if ([type isEqualToString:@"LikeClubTopicMessage"]) {
        str=[NSString stringWithFormat:@"%@：%@",[self replaceNullString:dic[@"Title"]],[self replaceNullString:dic[@"Message"]]];
    }
    
    if ([type isEqualToString:@"AgreedToBeFriend"]) {
        str=[NSString stringWithFormat:@"%@",[self replaceNullString:dic[@"Message"]]];
    }
    
    if ([type isEqualToString:@"Topic"]) {
        str=[NSString stringWithFormat:@"%@：%@",[self replaceNullString:dic[@"Title"]],[self replaceNullString:dic[@"Message"]]];
    }
    
    
    if ([type isEqualToString:@"Feedback"]) {
        str=[NSString stringWithFormat:@"%@：%@",[self replaceNullString:dic[@"Title"]],[self replaceNullString:dic[@"Message"]]];
    }
    
    if ([type isEqualToString:@"ApplyForJoinClub"]) {
        str=[NSString stringWithFormat:@"%@：%@",[self replaceNullString:dic[@"Title"]],[self replaceNullString:dic[@"Message"]]];
    }
    
    str=[self removeHTMLTag:str];
    
    float reviewHeight=[self getContentHeight:str width:300 fontSize:13];
    return 55+reviewHeight;
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
    /*
     FriendObj *friend=self.friendArray[indexPath.row];
     MyViewController *mvc=[[MyViewController alloc] initWithNibName:@"MyViewController" bundle:nil];
     mvc.friend=friend;
     [self.navigationController pushViewController:mvc animated:YES];
     */
    
}

-(void)configureActivityCell:(ActivityCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *dic=self.dataArray[indexPath.row];
    cell.content.text=@"";
    
    cell.nickName.text=[self replaceNullString:dic[@"User"][@"NickName"]];
    NSString *type=dic[@"Message2ndType"];
    
    if ([type isEqualToString:@"System"]) {
        cell.content.text=[NSString stringWithFormat:@"%@",[self replaceNullString:dic[@"Message"]]];
    }
    if ([type isEqualToString:@"Birthday"]) {
        cell.content.text=[NSString stringWithFormat:@"%@",[self replaceNullString:dic[@"Message"]]];
    }
    if ([type isEqualToString:@"Review"]) {
       cell.content.text=[NSString stringWithFormat:@"%@：%@",[self replaceNullString:dic[@"Title"]],[self replaceNullString:dic[@"Message"]]];
    }
    
    if ([type isEqualToString:@"ClubTopic"]) {
        if ([self.lang isEqualToString:@"zh-Hant"]) {
            cell.content.text=[NSString stringWithFormat:@"%@：%@。來自『%@社團』",[self replaceNullString:dic[@"Title"]],[self replaceNullString:dic[@"Message"]],[self replaceNullString:dic[@"ClubName"]]];
        }else{
           cell.content.text=[NSString stringWithFormat:@"%@：%@。来自『%@群组』",[self replaceNullString:dic[@"Title"]],[self replaceNullString:dic[@"Message"]],[self replaceNullString:dic[@"ClubName"]]];
        }
    }
    

    
    if ([type isEqualToString:@"LikeReview"]) {
        cell.content.text=[NSString stringWithFormat:@"%@：%@",[self replaceNullString:dic[@"Title"]],[self replaceNullString:dic[@"Message"]]];
    }
    
    if ([type isEqualToString:@"LikeTopic"]) {
        cell.content.text=[NSString stringWithFormat:@"%@：%@",[self replaceNullString:dic[@"Title"]],[self replaceNullString:dic[@"Message"]]];
    }
    
    if ([type isEqualToString:@"JoinClubGreeting"]) {
        if ([self.lang isEqualToString:@"zh-Hant"]) {
            cell.content.text=[NSString stringWithFormat:@"你已被批準加入社團，快來看看吧。%@",[self replaceNullString:dic[@"Message"]]];
        }else{
            cell.content.text=[NSString stringWithFormat:@"你已被批准加入群组，快来看看吧。%@",[self replaceNullString:dic[@"Message"]]];
        }
    }
    
    if ([type isEqualToString:@"BeClubManager"]) {
        cell.content.text=[NSString stringWithFormat:@"%@：%@",[self replaceNullString:dic[@"Title"]],[self replaceNullString:dic[@"Message"]]];
    }
    
    if ([type isEqualToString:@"ClubNotification"]) {
        cell.content.text=[NSString stringWithFormat:@"%@：%@",[self replaceNullString:dic[@"Title"]],[self replaceNullString:dic[@"Message"]]];
    }
    
    if ([type isEqualToString:@"ClubInvitation"]) {
        cell.content.text=[NSString stringWithFormat:@"%@：%@",[self replaceNullString:dic[@"Title"]],[self replaceNullString:dic[@"Message"]]];
    }
    
    if ([type isEqualToString:@"PushTopic"]) {
        cell.content.text=[NSString stringWithFormat:@"%@：%@",[self replaceNullString:dic[@"Title"]],[self replaceNullString:dic[@"Message"]]];
    }
    
    if ([type isEqualToString:@"LikeClubTopic"]) {
        if ([self.lang isEqualToString:@"zh-Hant"]) {
            cell.content.text=[NSString stringWithFormat:@"%@%@。來自『%@社團』",[self replaceNullString:dic[@"Title"]],[self replaceNullString:dic[@"Message"]],[self replaceNullString:dic[@"ClubName"]]];
        }else{
            cell.content.text=[NSString stringWithFormat:@"%@%@。来自『%@群组』",[self replaceNullString:dic[@"Title"]],[self replaceNullString:dic[@"Message"]],[self replaceNullString:dic[@"ClubName"]]];
        }
    }
    
    if ([type isEqualToString:@"DeleteClubTopic"]) {
        cell.content.text=[NSString stringWithFormat:@"%@：%@",[self replaceNullString:dic[@"Title"]],[self replaceNullString:dic[@"Message"]]];
    }
    
    if ([type isEqualToString:@"LikeReviewMessage"]) {
        cell.content.text=[NSString stringWithFormat:@"%@：%@",[self replaceNullString:dic[@"Title"]],[self replaceNullString:dic[@"Message"]]];
    }
    
    if ([type isEqualToString:@"LikeTopicMessage"]) {
        cell.content.text=[NSString stringWithFormat:@"%@：%@",[self replaceNullString:dic[@"Title"]],[self replaceNullString:dic[@"Message"]]];
    }
    
    if ([type isEqualToString:@"LikeClubTopicMessage"]) {
        cell.content.text=[NSString stringWithFormat:@"%@：%@",[self replaceNullString:dic[@"Title"]],[self replaceNullString:dic[@"Message"]]];
    }
    
    if ([type isEqualToString:@"AgreedToBeFriend"]) {
        cell.content.text=[NSString stringWithFormat:@"%@",[self replaceNullString:dic[@"Message"]]];
    }
    
    if ([type isEqualToString:@"Topic"]) {
        cell.content.text=[NSString stringWithFormat:@"%@：%@",[self replaceNullString:dic[@"Title"]],[self replaceNullString:dic[@"Message"]]];
    }
    
    
    if ([type isEqualToString:@"Feedback"]) {
        cell.content.text=[NSString stringWithFormat:@"%@：%@",[self replaceNullString:dic[@"Title"]],[self replaceNullString:dic[@"Message"]]];
    }
    
    if ([type isEqualToString:@"ApplyForJoinClub"]) {
        cell.content.text=[NSString stringWithFormat:@"%@：%@",[self replaceNullString:dic[@"Title"]],[self replaceNullString:dic[@"Message"]]];
    }
    
    
    
    cell.content.text=[self removeHTMLTag:cell.content.text];


    float reviewHeight=[self getContentHeight:cell.content.text width:300 fontSize:13];
    cell.content.frame=CGRectMake(10, 43, 300, reviewHeight+10);
    
    NSString *path=[NSString stringWithFormat:@"%@/Uploads/UserAvatar/%@",PROPUCTION_API_DOMAIN,dic[@"User"][@"Avatar"]];

    [cell.avatarImageView setImageWithURL:[NSURL URLWithString:path] placeholderImage:[UIImage imageNamed:@"nobody.jpg"]];
    
    NSString *createdOn=dic[@"CreatedOn"];
    cell.createdOn.text=[self convertDateStringforClubReply:createdOn];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    float pointY=scrollView.contentOffset.y;
    NSLog(@"pointY:%f",pointY);
    
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
        [self loadData];
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
- (IBAction)topButtonPressed:(id)sender {
    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:0 inSection:0];
    [self.myTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
}
@end
