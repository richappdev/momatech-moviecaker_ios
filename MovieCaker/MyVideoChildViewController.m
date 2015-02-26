//
//  MyVideoChildViewController.m
//  MovieCaker
//
//  Created by iKevin on 2014/3/9.
//  Copyright (c) 2014年 iKevin. All rights reserved.
//

#import "MyVideoChildViewController.h"

#import "MyContentListCell.h"
#import "VideoObj.h"
#import "VideoContentViewController.h"

@interface MyVideoChildViewController ()
    @property (nonatomic,strong ) NSArray *videoArray;
    @property(nonatomic,strong) NSNumber *page;
    @property(assign,nonatomic) BOOL isLoading;
    @property(assign,nonatomic) BOOL isLast;
    @property(assign,nonatomic) BOOL isPreview;
    @property (nonatomic,strong ) NSMutableArray *viewArray;
    @property (nonatomic, strong) NSDictionary *userInfo;
@end

@implementation MyVideoChildViewController

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
        self.title=NSLocalizedStringFromTable(@"我的電影",@"InfoPlist",nil);
    }else{
        self.title=[NSString stringWithFormat:@"%@的%@",self.friend.nickName,NSLocalizedStringFromTable(@"電影",@"InfoPlist",nil)];
    }
    
    [self.myTableView registerNib:[UINib nibWithNibName:@"MyHeaderCell" bundle:nil] forCellReuseIdentifier:@"MyHeaderCell"];
    [self.myTableView registerNib:[UINib nibWithNibName:@"MyContentListCell" bundle:nil] forCellReuseIdentifier:@"MyContentListCell"];
    
    self.viewArray=[[NSMutableArray alloc] init];
   // self.videoArray=[[NSMutableArray alloc] init];
    
    self.page=[NSNumber numberWithInt:1];
    self.isLoading=NO;
    
    self.myTableView.tableFooterView=nil;
    
    [WaitingAlert presentWithText:NSLocalizedStringFromTable(@"請稍後...",@"InfoPlist",nil) withTimeOut:30];
    [self loadData:self.page];
    
    // Do any additional setup after loading the view from its nib.
}

-(void)loadData:(NSNumber *)page{
    self.isLoading=YES;
    [self.manager getVideoWithTopicID:nil channel:@"My" withUID:self.friend.userId.stringValue withYear:nil withMonth:nil withPage:self.page withMyType:self.myType withActorID:nil callback:^(NSArray *videoArray, NSString *errorMsg, NSError *error) {
        
        
        [WaitingAlert dismiss];
        self.isLoading=NO;
        self.myTableView.tableFooterView=nil;
        
        if (videoArray.count>0) {
            VideoObj *video=self.videoArray[0];
            self.videoArray=videoArray;
            if (videoArray.count==video.total.intValue) {
                self.isLast=YES;
            }
            [self.myTableView reloadData];
        }else{
            self.isLast=YES;
            [self alertShow:NSLocalizedStringFromTable(@"目前無資料！",@"InfoPlist",nil)];
        }
       
    }];
    
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        if ([self.title isEqualToString:NSLocalizedStringFromTable(@"我的電影",@"InfoPlist",nil)]) {
            return 116;
        }
        if (self.friend.isBeingInviting.boolValue || self.friend.isInviting.boolValue) {
            return 162;
        }
        return 116;
    }else{
        return ceilf(self.videoArray.count/3.0)*160;
    }
    
    return 116;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(indexPath.row == 0)
    {
        static NSString *cellIdentifier = @"MyHeaderCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        [self configureMyHeaderCell:(MyHeaderCell *)cell atIndexPath:indexPath];
        return cell;
    }else{
        static NSString *cellIdentifier = @"MyContentListCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        [self configureMyContentListCell:(MyContentListCell *)cell atIndexPath:indexPath];
        return cell;
    }
    
    return nil;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //MyVideoViewController *mvvc=[[MyVideoViewController alloc] initWithNibName:@"MyVideoViewController" bundle:nil];
    //[self.navigationController pushViewController:mvvc animated:YES];
    
    
}

-(void) configureMyHeaderCell:(MyHeaderCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    
    NSString *gender =(self.friend.gender.boolValue)? NSLocalizedStringFromTable(@"男",@"InfoPlist",nil):NSLocalizedStringFromTable(@"女",@"InfoPlist",nil);
    //cell.addFriendButton.hidden=YES;
    cell.inviteView.hidden=YES;
    cell.delegate=self;
    
    cell.friend=self.friend;
    
    if ([self.title isEqualToString:NSLocalizedStringFromTable(@"我的電影",@"InfoPlist",nil)]) {
        cell.inviteView.hidden=YES;
        cell.addFriendButton.hidden=YES;
    }else{
        if (self.friend.isBeingInviting.boolValue) {
            cell.inviteView.hidden=NO;
            cell.inviteWord.text=NSLocalizedStringFromTable(@"寄給你一則交友邀請",@"InfoPlist",nil);
            cell.rejectButton.hidden=NO;
            [cell.agreeButton setTitle:NSLocalizedStringFromTable(@"確認",@"InfoPlist",nil) forState:UIControlStateNormal];
        }else if(self.friend.isInviting.boolValue){
            cell.inviteView.hidden=NO;
            cell.inviteWord.text=NSLocalizedStringFromTable(@"你已寄出交友邀請",@"InfoPlist",nil);
            cell.rejectButton.hidden=YES;
            [cell.agreeButton setTitle:NSLocalizedStringFromTable(@"取消",@"InfoPlist",nil) forState:UIControlStateNormal];
        }else{
            cell.inviteView.hidden=YES;
        }
        
        if (self.friend.isBeingInviting.boolValue || self.friend.isInviting.boolValue ) {
            cell.addFriendButton.hidden=YES;
            
        }else{
            if (self.friend.isFriend.boolValue) {
                cell.addFriendButton.hidden=NO;
                cell.addFriendButton.enabled=NO;
                [cell.addFriendButton setTitle:NSLocalizedStringFromTable(@"朋友",@"InfoPlist",nil) forState:UIControlStateDisabled];
            }else{
                cell.addFriendButton.hidden=NO;
                cell.addFriendButton.enabled=YES;
                [cell.addFriendButton setTitle:NSLocalizedStringFromTable(@"加入朋友",@"InfoPlist",nil) forState:UIControlStateNormal];
            }
            
        }
    }
     

    
    cell.userName.text=[NSString stringWithFormat:@" %@ %@ %@",self.friend.nickName,self.friend.locationName,gender];
    NSString *path=[NSString stringWithFormat:@"%@/Uploads/UserAvatar/%@",PROPUCTION_API_DOMAIN,self.friend.avatar];
    
    NSURL *bannerUrl=[self getUesrBannerUrl:self.friend.userId];
    
    [cell.userBanner setImageWithURL:bannerUrl placeholderImage:[UIImage imageNamed:@"noMoviePoster.jpg"]];
    [cell.avatarImageView setImageWithURL:[NSURL URLWithString:path] placeholderImage:[UIImage imageNamed:@"nobody.jpg"]];
}

-(void)configureMyContentListCell:(MyContentListCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    
    
    
    for (int i=0; i<self.videoArray.count; i++) {
        VideoObj *video=self.videoArray[i];
        int m=i%3;
        int n=floor(i/3.0);
        MyContentView *myContentView=[[MyContentView alloc] initWithFrame:CGRectMake(103*m+11, 160*n+13, 92, 150)];
        myContentView.delegate=self;
        [myContentView setVideoFaceImage:video];
        [cell addSubview:myContentView];
        [self.viewArray addObject:myContentView];
    }
}

- (void)videoFacePressed:(VideoObj *)video{
    VideoContentViewController *vcvc=[[VideoContentViewController alloc] initWithNibName:@"VideoContentViewController" bundle:nil];
    vcvc.video=video;
    [self.navigationController pushViewController:vcvc animated:YES];
}


 -(void)clearVideoFace{
 
     for (int j=0; j<self.viewArray.count; j++) {
         MyContentView *myContentView=self.viewArray[j];
         [myContentView removeFromSuperview];
     }
     [self.viewArray removeAllObjects];
 }
 
 - (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
 {
     if (self.isLoading) {
         return;
     }
     if (self.isLast) {
         return;
     }
 
     float pointY=scrollView.contentOffset.y;
     float startLoadY=scrollView.contentSize.height-self.view.frame.size.height;
     
     if (pointY>startLoadY) {
         self.page=@(self.page.intValue+1);
         self.myTableView.tableFooterView=self.footView;
        self.moreLabel.text=NSLocalizedStringFromTable(@"載入更多",@"InfoPlist",nil);
         [self loadData:self.page];
     }
 }
 
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
