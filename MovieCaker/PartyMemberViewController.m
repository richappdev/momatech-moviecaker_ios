//
//  PartyMemberViewController.m
//  MovieCaker
//
//  Created by iKevin on 2014/4/10.
//  Copyright (c) 2014年 iKevin. All rights reserved.
//

#import "PartyMemberViewController.h"
#import "SchoolPartyIntroCell.h"
#import "PartyMemberCell.h"
#import "SIAlertView.h"
#import "MyViewController.h"

@interface PartyMemberViewController ()
    @property(nonatomic, strong) NSNumber *uid;
    @property (nonatomic, strong) NSDictionary *userInfo;
    @property (nonatomic, assign) float txtHeight;
    @property (nonatomic, strong) NSMutableArray *managerAry;
    @property (nonatomic, strong) NSMutableArray *friendAry;
    @property (nonatomic, strong) NSMutableArray *otherAry;
    @property(nonatomic,strong)NSNumber *page;
@end

@implementation PartyMemberViewController

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
    
    
    if ([self.manager isLogined]) {
        self.userInfo=[self.manager getLoginUnfo];
        self.uid=self.userInfo[@"UserId"];
    }else{
        self.uid=[NSNumber numberWithInt:0];
    }
    
    self.managerAry=[[NSMutableArray alloc] init];
    self.friendAry=[[NSMutableArray alloc] init];
    self.otherAry=[[NSMutableArray alloc] init];
    //self.talkAry=[[NSMutableArray alloc] init];
    
    [self.myTableView registerNib:[UINib nibWithNibName:@"SchoolPartyHeaderCell" bundle:nil] forCellReuseIdentifier:@"SchoolPartyHeaderCell"];
    [self.myTableView registerNib:[UINib nibWithNibName:@"SchoolPartyIntroCell" bundle:nil] forCellReuseIdentifier:@"SchoolPartyIntroCell"];
    
    [self.myTableView registerNib:[UINib nibWithNibName:@"PartyMemberCell" bundle:nil] forCellReuseIdentifier:@"PartyMemberCell"];
    self.txtHeight=[self getContentHeight:self.party.desc width:301 fontSize:14];
    
    [self loadManager];
}

-(void)viewWillAppear:(BOOL)animated{
    [self.myTableView reloadData];
}

-(void)loadManager{
    [self.manager getMemberWithId:self.party.partyID withtType:@"Manager" withtPage:@(1) callback:^(NSMutableArray *memberArray, NSString *errorMsg, NSError *error) {
        [self.managerAry addObjectsFromArray:memberArray];
        //[self.myTableView reloadData];
        [self loadFriend];
    }];
    
}
-(void)loadFriend{
    [self.manager getMemberWithId:self.party.partyID withtType:@"Friend" withtPage:@(1) callback:^(NSMutableArray *memberArray, NSString *errorMsg, NSError *error) {
        [self.friendAry addObjectsFromArray:memberArray];
        //[self.myTableView reloadData];
        [self loadOther];
    }];
    
}
-(void)loadOther{
    [self.manager getMemberWithId:self.party.partyID withtType:@"Other" withtPage:@(1) callback:^(NSMutableArray *memberArray, NSString *errorMsg, NSError *error) {
        [self.otherAry addObjectsFromArray:memberArray];
        [self.myTableView reloadData];
    }];
    
}
#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0) {
        return 1;
    }else if(section==1){
        return self.managerAry.count;
    }else if(section==2){
        return self.friendAry.count;
    }else if(section==3){
        return self.otherAry.count;
    }

    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==0) {
        return 0;
    }else if(section==1){
        return (self.managerAry.count>0) ? 22:0;
    }else if(section==2){
        return (self.friendAry.count>0) ? 22:0;
    }else if(section==3){
        return (self.otherAry.count>0) ? 22:0;
    }

    return 22;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    
    if (section==0) {
        return @"";
    }else if(section==1){
        return NSLocalizedStringFromTable(@"管理員",@"InfoPlist",nil);
    }else if(section==2){
        return NSLocalizedStringFromTable(@"朋友會員",@"InfoPlist",nil);
    }else if(section==3){
        return NSLocalizedStringFromTable(@"其他會員",@"InfoPlist",nil);
    }
    return @"";
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        self.txtHeight=[self getContentHeight:self.party.desc width:301 fontSize:14];
        return self.txtHeight+250;
    }else{
        return 56;
    }
    
    return 250;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
            static NSString *cellIdentifier = @"SchoolPartyHeaderCell";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            [self configureSchoolPartyHeaderCell:(SchoolPartyHeaderCell *)cell atIndexPath:indexPath];
            return cell;
       
    }else{

        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PartyMemberCell"];
        [self configurePartyMemberCell:(PartyMemberCell *)cell atIndexPath:indexPath];
        return cell;
    }
    
    return nil;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section>0) {
        FriendObj *friend;
        if(indexPath.section==1){
            friend=self.managerAry[indexPath.row];
        }else if(indexPath.section==2){
            friend=self.friendAry[indexPath.row];
        }else if(indexPath.section==3){
            friend=self.otherAry[indexPath.row];
        }
        
        //NSLog(@"xxx:%d",frien.userId.intValue);
        
        MyViewController *mvc=[[MyViewController alloc] initWithNibName:@"MyViewController" bundle:nil];
        mvc.userId= friend.userId;
        [self.navigationController pushViewController:mvc animated:YES];
    }

     
};


-(void)configureSchoolPartyHeaderCell:(SchoolPartyHeaderCell *)cell atIndexPath:(NSIndexPath *)indexPath{
    
    cell.partyName.text=self.party.name;
    
    cell.party=self.party;
    cell.creator.text=[NSString stringWithFormat:@"%@:%@",NSLocalizedStringFromTable(@"創辦人",@"InfoPlist",nil),self.party.nickName];
    cell.memberCount.text=[NSString stringWithFormat:@"%@ %@",self.party.memberCount,NSLocalizedStringFromTable(@"會員",@"InfoPlist",nil)];
    cell.desc.text=self.party.desc;
    cell.desc.frame=CGRectMake(10, 42, 301, self.txtHeight+10);
    cell.introView.frame=CGRectMake(0, 165, 320, self.txtHeight+85);
    
    cell.isCreator= (self.uid.intValue==self.party.founderID.intValue) ? YES : NO;
    
    if (self.party.needAuth.boolValue) {
        //已加入
        if (self.party.isJoined.boolValue) {
            //審核過
            if (self.party.isPassAudit.boolValue) {
                
                //退出社團
                
                if ([self.lang isEqualToString:@"zh-Hant"]) {
                    [cell.joinButton setImage:[UIImage imageNamed:@"exit.png"] forState:UIControlStateNormal];
                }else{
                    [cell.joinButton setImage:[UIImage imageNamed:@"退出社團大.png"] forState:UIControlStateNormal];
                }
                
            }else{
                //審核中
                if ([self.lang isEqualToString:@"zh-Hant"]) {
                    [cell.joinButton setImage:[UIImage imageNamed:@"Audit.png"] forState:UIControlStateNormal];
                }else{
                    [cell.joinButton setImage:[UIImage imageNamed:@"審核中大.png"] forState:UIControlStateNormal];
                }
                
            }
        }else{
            //加入社團
            if ([self.lang isEqualToString:@"zh-Hant"]) {
                [cell.joinButton setImage:[UIImage imageNamed:@"Societies.png"] forState:UIControlStateNormal];
            }else{
                [cell.joinButton setImage:[UIImage imageNamed:@"加入社團大.png"] forState:UIControlStateNormal];
            }
        }
    }else{
        if (self.party.isJoined.boolValue) {
            if ([self.lang isEqualToString:@"zh-Hant"]) {
                [cell.joinButton setImage:[UIImage imageNamed:@"exit.png"] forState:UIControlStateNormal];
            }else{
                [cell.joinButton setImage:[UIImage imageNamed:@"退出社團大.png"] forState:UIControlStateNormal];
            }
        }else{
            if ([self.lang isEqualToString:@"zh-Hant"]) {
                [cell.joinButton setImage:[UIImage imageNamed:@"Societies.png"] forState:UIControlStateNormal];
            }else{
                [cell.joinButton setImage:[UIImage imageNamed:@"加入社團大.png"] forState:UIControlStateNormal];
            }
        }
    }
    
    
    
    NSString *path=[NSString stringWithFormat:@"%@/Uploads/UserAvatar/%@",PROPUCTION_API_DOMAIN,self.party.avatar];
    [cell.avatar setImageWithURL:[NSURL URLWithString:path] placeholderImage:[UIImage imageNamed:@"nobody.jpg"]];
    
    NSString *bannerPath=[NSString stringWithFormat:@"%@/Uploads/ClubBanner/Club_%d.jpg",PROPUCTION_API_DOMAIN,self.party.partyID.intValue];
    [cell.banner setImageWithURL:[NSURL URLWithString:bannerPath] placeholderImage:[UIImage imageNamed:@"ngbg-1185.png"]];
    
    cell.btnView3.hidden=YES;
    cell.delegate=self;
    
}
-(void)configurePartyMemberCell:(PartyMemberCell *)cell atIndexPath:(NSIndexPath *)indexPath{
    
    FriendObj *friend;
    if(indexPath.section==1){
        friend=self.managerAry[indexPath.row];
    }else if(indexPath.section==2){
        friend=self.friendAry[indexPath.row];
    }else if(indexPath.section==3){
        friend=self.otherAry[indexPath.row];
    }
    
    

    NSString *path=[NSString stringWithFormat:@"%@/Uploads/UserAvatar/%@",PROPUCTION_API_DOMAIN,friend.avatar];
    cell.nickName.text=friend.nickName;
    [cell.avatarImageView setImageWithURL:[NSURL URLWithString:path] placeholderImage:[UIImage imageNamed:@"nobody.jpg"]];
}


#pragma mark - SchoolPartyHeaderCellDelegate


- (void)shareButtonPressed:(UIImage *)image{
    SchoolPartyObj *party=self.party;
    NSString *path=[NSString stringWithFormat:@"%@/Social/ClubTopicList/%@",PROPUCTION_API_DOMAIN,party.partyID.stringValue];
    
    SIAlertView *alertView = [[SIAlertView alloc] initWithTitle:party.name andMessage:nil];
    [alertView addButtonWithTitle:@"        Facebook"
                             type:SIAlertViewButtonTypeDefault
                          handler:^(SIAlertView *alertView) {
                              
                              
                              NSString *name = @"MovieCaker";
                              NSString *description =party.desc;
                              NSString *title=party.name;
                              NSString *fbPicture =[NSString stringWithFormat:@"%@/Uploads/ClubBanner/Club_%d.jpg?width=320",PROPUCTION_API_DOMAIN,party.partyID.intValue];
                              
                              NSLog(@"%@",fbPicture);
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
                              
                              NSString *str;
                              if (party.desc.length>140) {
                                  str=[party.desc substringToIndex:140];
                              }else{
                                  str=party.desc;
                              }
                              
                              message.description=str;
                              
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
    [alertView addButtonWithTitle:NSLocalizedStringFromTable(@"取消",@"InfoPlist",nil)
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
    
    
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
