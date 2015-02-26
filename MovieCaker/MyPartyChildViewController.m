//
//  MyPartyChildViewController.m
//  MovieCaker
//
//  Created by iKevin on 2014/2/24.
//  Copyright (c) 2014年 iKevin. All rights reserved.
//

#import "MyPartyChildViewController.h"

#import "SchoolPartyObj.h"
#import "SchoolPartyDetailViewController.h"
#import "SIAlertView.h"
#import "PertyContentViewController.h"

@interface MyPartyChildViewController ()
    @property(nonatomic,strong) NSArray *partyArray;
    @property (strong, nonatomic) NSNumber *page;
    @property (strong, nonatomic) NSNumber *uid;
    @property(assign,nonatomic) BOOL isLoading;
    @property(assign,nonatomic) BOOL isLast;
    @property(assign,nonatomic) BOOL isPreview;
    @property (nonatomic, strong) NSDictionary *userInfo;

@end

@implementation MyPartyChildViewController

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
        self.title=NSLocalizedStringFromTable(@"我的社團",@"InfoPlist",nil);
    }else{
        self.title=[NSString stringWithFormat:@"%@的%@",self.friend.nickName,NSLocalizedStringFromTable(@"社團",@"InfoPlist",nil)];
    }
    
    self.page=[NSNumber numberWithInt:1];
    self.isLast=NO;
    
    [self.myTableView registerNib:[UINib nibWithNibName:@"MyHeaderCell" bundle:nil] forCellReuseIdentifier:@"MyHeaderCell"];
    [self.myTableView registerNib:[UINib nibWithNibName:@"SchoolPartyCell" bundle:nil] forCellReuseIdentifier:@"SchoolPartyCell"];
    /*
    if ([self.manager isLogined]) {
        NSDictionary *userInfo=[self.manager getLoginUnfo];
        self.uid=userInfo[@"UserId"];
    }
     */
    
    [self loadData:self.page];
    // Do any additional setup after loading the view from its nib.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (self.partyArray.count>0) {
        NSIndexPath *indexPath=[NSIndexPath indexPathForRow:0 inSection:0];
        [self.myTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
    
}

-(void)loadData:(NSNumber *)page{
    
    self.isLoading=YES;
    [WaitingAlert presentWithText:NSLocalizedStringFromTable(@"請稍後...",@"InfoPlist",nil) withTimeOut:30];
    
    
    [self.manager getSchoolPartyWithChannel:self.channel withPage:self.page withUid:self.friend.userId.stringValue callback:^(NSArray *partyArray, NSString *errorMsg, NSError *error) {
        self.isLoading=NO;
        self.partyArray=partyArray;
        self.myTableView.tableFooterView=nil;
        
        if (self.partyArray.count>0) {
            SchoolPartyObj *schoolParty=self.partyArray[0];
            if (self.partyArray.count==schoolParty.total.intValue) {
                self.isLast=YES;
            }
        }else{
            self.isLast=YES;
            [self alertShow:NSLocalizedStringFromTable(@"目前沒有資料！",@"InfoPlist",nil)];
   
        }

        
        [WaitingAlert dismiss];
        
        [self.myTableView reloadData];
    }];
    
}

- (void)reloadData{
    [self loadData:self.page];
}





#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.partyArray.count+1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        if ([self.title isEqualToString:@"我的社團"]) {
            return 116;
        }
        if (self.friend.isBeingInviting.boolValue || self.friend.isInviting.boolValue) {
            return 162;
        }
        return 116;
    }
    return 267;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row==0) {
        static NSString *cellIdentifier = @"MyHeaderCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        [self configureMyHeaderCell:(MyHeaderCell *)cell atIndexPath:indexPath];
        return cell;
    }else{
        static NSString *cellIdentifier = @"SchoolPartyCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        [self configureSchoolPartyCell:(SchoolPartyCell *)cell atIndexPath:indexPath];
        return cell;
        
    }
    
    
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row>=1) {
        PertyContentViewController *pcvc=[[PertyContentViewController alloc] initWithNibName:@"PertyContentViewController" bundle:nil];
        pcvc.party=self.partyArray[indexPath.row-1];
        [self.navigationController pushViewController:pcvc animated:YES];
    }

    
    
}

-(void) configureMyHeaderCell:(MyHeaderCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    
    NSString *gender =(self.friend.gender.boolValue)? NSLocalizedStringFromTable(@"男",@"InfoPlist",nil):NSLocalizedStringFromTable(@"女",@"InfoPlist",nil);

    cell.inviteView.hidden=YES;
    cell.delegate=self;
    
    cell.friend=self.friend;
    
    
    if ([self.title isEqualToString:@"我的社團"]) {
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
            [cell.agreeButton setTitle:NSLocalizedStringFromTable(@"取消",@"InfoPlist",nil)forState:UIControlStateNormal];
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
    
    [cell.userBanner setImageWithURL:bannerUrl placeholderImage:nil];
    [cell.avatarImageView setImageWithURL:[NSURL URLWithString:path] placeholderImage:[UIImage imageNamed:@"nobody.jpg"]];
    
    //cell.addFriendButton.hidden=YES;
    
}
-(void)configureSchoolPartyCell:(SchoolPartyCell *)cell atIndexPath:(NSIndexPath *)indexPath{
    SchoolPartyObj *party=self.partyArray[indexPath.row-1];
    cell.partyName.text=party.name;
    cell.party=party;
    cell.creator.text=[NSString stringWithFormat:@"%@:%@",NSLocalizedStringFromTable(@"創辦人",@"InfoPlist",nil),party.nickName];
    cell.memberCount.text=[NSString stringWithFormat:@"%@ %@",party.memberCount.stringValue,NSLocalizedStringFromTable(@"會員",@"InfoPlist",nil)];
    cell.content.text=party.desc;
    
    cell.publicLabel.text= party.isPublic.boolValue ? NSLocalizedStringFromTable(@"公開",@"InfoPlist",nil):NSLocalizedStringFromTable(@"不公開",@"InfoPlist",nil);
    NSString *publicImage=party.isPublic.boolValue ? @"publicBg.png":@"noPublicBg.png";
    [cell.publicImageView setImage:[UIImage imageNamed:publicImage]];
    
    self.userInfo=[self.manager getLoginUnfo];
    NSNumber *userID=self.userInfo[@"UserId"];
    
    cell.isCreator= (userID.intValue==party.founderID.intValue) ? YES : NO;
    
    if (party.needAuth.boolValue) {
        //已加入
        if (party.isJoined.boolValue) {
            //審核過
            if (party.isPassAudit.boolValue) {
                //退出社團
                if ([self.lang isEqualToString:@"zh-Hant"]) {
                    [cell.joinButton setImage:[UIImage imageNamed:@"Exit-Societies.png"] forState:UIControlStateNormal];
                }else{
                    [cell.joinButton setImage:[UIImage imageNamed:@"退出社團.png"] forState:UIControlStateNormal];
                }
            }else{
                //審核中
                if ([self.lang isEqualToString:@"zh-Hant"]) {
                    [cell.joinButton setImage:[UIImage imageNamed:@"Audit_small.png"] forState:UIControlStateNormal];
                }else{
                    [cell.joinButton setImage:[UIImage imageNamed:@"審核中.png"] forState:UIControlStateNormal];
                }
            }
        }else{
            //加入社團
            if ([self.lang isEqualToString:@"zh-Hant"]) {
                [cell.joinButton setImage:[UIImage imageNamed:@"Societies_small.png"] forState:UIControlStateNormal];
            }else{
                [cell.joinButton setImage:[UIImage imageNamed:@"加入社團.png"] forState:UIControlStateNormal];
            }
            
        }
    }else{
        if (party.isJoined.boolValue) {
            //退出社團
            if ([self.lang isEqualToString:@"zh-Hant"]) {
                [cell.joinButton setImage:[UIImage imageNamed:@"Exit-Societies.png"] forState:UIControlStateNormal];
            }else{
                [cell.joinButton setImage:[UIImage imageNamed:@"退出社團.png"] forState:UIControlStateNormal];
            }
        }else{
            //加入社團
            if ([self.lang isEqualToString:@"zh-Hant"]) {
                [cell.joinButton setImage:[UIImage imageNamed:@"Societies_small.png"] forState:UIControlStateNormal];
            }else{
                [cell.joinButton setImage:[UIImage imageNamed:@"加入社團.png"] forState:UIControlStateNormal];
            }
        }
    }
    
    NSString *bannerPath=[NSString stringWithFormat:@"%@/Uploads/ClubBanner/Club_%d.jpg?width=320",PROPUCTION_API_DOMAIN,party.partyID.intValue];
    NSLog(@"bannerPath:%@",bannerPath);
    [cell.partyBanner setImageWithURL:[NSURL URLWithString:bannerPath] placeholderImage:[UIImage imageNamed:@"ngbg-1185.png"]];
    
    
    NSString *path=[NSString stringWithFormat:@"%@/Uploads/UserAvatar/%@",PROPUCTION_API_DOMAIN,party.avatar];
    [cell.avatar setImageWithURL:[NSURL URLWithString:path] placeholderImage:[UIImage imageNamed:@"nobody.jpg"]];
    cell.delegate=self;
    cell.indexPath=indexPath;
    
}

#pragma mark - TopicCellDelegate
- (void)shareButtonPressed:(NSIndexPath *)indexPath WithImage:(UIImage *)image{
    
    SchoolPartyObj *party=self.partyArray[indexPath.row-1];
    NSString *path=[NSString stringWithFormat:@"%@/Social/ClubTopicList/%@",PROPUCTION_API_DOMAIN,party.partyID.stringValue];
    
    SIAlertView *alertView = [[SIAlertView alloc] initWithTitle:party.name andMessage:nil];
    [alertView addButtonWithTitle:@"        Facebook"
                             type:SIAlertViewButtonTypeDefault
                          handler:^(SIAlertView *alertView) {
                              
                              
                              NSString *name = @"MovieCaker";
                              NSString *description =party.desc;
                              NSString *title=party.name;
                              NSString *fbPicture =[NSString stringWithFormat:@"%@/Uploads/ClubBanner/Club_%d.jpg",PROPUCTION_API_DOMAIN,party.partyID.intValue];
                              NSURL *link=[NSURL URLWithString:path];
                              
                              NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                                             description, @"description",
                                                             link.absoluteString, @"link",
                                                             title, @"name",
                                                             name, @"caption",
                                                             @"touch", @"display",
                                                             @"type", @"user_agent",
                                                             fbPicture, @"picture",
                                                             nil];
                              
                              [FBWebDialogs presentFeedDialogModallyWithSession:nil
                                                                     parameters:params
                                                                        handler:^(FBWebDialogResult result, NSURL *resultURL, NSError *error) {
                                                                            NSString *urlparams = [resultURL absoluteString];
                                                                            NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
                                                                            if(result == FBWebDialogResultDialogNotCompleted){
                                                                                [params setObject:@"0" forKey:@"didComplete"];
                                                                                [params setObject:@"cancel" forKey:@"completionGesture"];
                                                                                [params setObject:@"" forKey:@"postId"];
                                                                            }else{
                                                                                if([urlparams isEqualToString:@"fbconnect://success"]){
                                                                                    [params setObject:@"0" forKey:@"didComplete"];
                                                                                    [params setObject:@"cancel" forKey:@"completionGesture"];
                                                                                    [params setObject:@"" forKey:@"postId"];
                                                                                }else{
                                                                                    NSArray *param= [urlparams componentsSeparatedByString:@"post_id="];
                                                                                    [params setObject:[param objectAtIndex:1] forKey:@"postId"];
                                                                                    if(result == FBWebDialogResultDialogCompleted){
                                                                                        [params setObject:@"1" forKey:@"didComplete"];
                                                                                    }else {
                                                                                        [params setObject:@"0" forKey:@"didComplete"];
                                                                                    }
                                                                                    [params setObject:@"post" forKey:@"completionGesture"];
                                                                                }
                                                                            }
                                                                            //[self showAlert:nil result:params error:error];
                                                                        }];
                              NSLog(@"Button1 Clicked");
                          }];
    [alertView addButtonWithTitle:@"        微信 WeChat"
                             type:SIAlertViewButtonTypeDefault
     
                          handler:^(SIAlertView *alertView) {
                              WXMediaMessage *message = [WXMediaMessage message];
                              message.title = party.name;
                              message.description = party.desc;
                              //[NSURL URLWithString:[NSString stringWithFormat:@"http://www.funmovie.tv/Content/pictures/banners/%@",self.topic.banner]];
                              UIImage *weChatImage=[self image:image cropInSize:CGSizeMake(100, 100)];
                              [message setThumbImage:weChatImage];
                              
                              WXWebpageObject *ext = [WXWebpageObject object];
                              ext.webpageUrl = path;
                              
                              message.mediaObject = ext;
                              SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
                              req.bText = NO;
                              req.message = message;
                              req.scene = WXSceneSession;
                              
                              [WXApi sendReq:req];
                              
                          }];
    [alertView addButtonWithTitle:@"        新浪微博 weibo"
                             type:SIAlertViewButtonTypeDefault
                          handler:^(SIAlertView *alertView) {
                              NSLog(@"新浪微博 weibo");
                              
                              WBMessageObject *message = [WBMessageObject message];
                              
                              message.text = party.name;
                              
                              
                              WBImageObject *shareImage = [WBImageObject object];
                              shareImage.imageData = UIImageJPEGRepresentation(image,0.1);
                              message.imageObject = shareImage;
                              
                              WBSendMessageToWeiboRequest *request = [WBSendMessageToWeiboRequest requestWithMessage:message];
                              request.shouldOpenWeiboAppInstallPageIfNotInstalled = NO;
                              
                              [WeiboSDK sendRequest:request];
                              
                          }];
    [alertView addButtonWithTitle:@"取消"
                             type:SIAlertViewButtonTypeDestructive
                          handler:^(SIAlertView *alertView) {
                              NSLog(@"Button3 Clicked");
                          }];
    
    alertView.willShowHandler = ^(SIAlertView *alertView) {
        NSLog(@"%@, willShowHandler", alertView);
    };
    alertView.didShowHandler = ^(SIAlertView *alertView) {
        NSLog(@"%@, didShowHandler", alertView);
    };
    alertView.willDismissHandler = ^(SIAlertView *alertView) {
        NSLog(@"%@, willDismissHandler", alertView);
    };
    alertView.didDismissHandler = ^(SIAlertView *alertView) {
        NSLog(@"%@, didDismissHandler", alertView);
    };
    
    [alertView show];
    
    
    //alertView.title = @"3";
    
}
- (NSDictionary*)parseURLParams:(NSString *)query {
    NSArray *pairs = [query componentsSeparatedByString:@"&"];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    for (NSString *pair in pairs) {
        NSArray *kv = [pair componentsSeparatedByString:@"="];
        NSString *val =
        [kv[1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        params[kv[0]] = val;
    }
    return params;
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
