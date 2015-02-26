//
//  TalkViewController.m
//  MovieCaker
//
//  Created by iKevin on 2014/4/8.
//  Copyright (c) 2014年 iKevin. All rights reserved.
//

#import "TalkViewController.h"
#import "PartyTalkCell.h"
#import "FilmReviewCell.h"
#import "TalkObj.h"
#import "TalkCell.h"
#import "ReplyPartyTalkViewController.h"
#import "SIAlertView.h"



@interface TalkViewController ()
    @property(nonatomic, strong) NSNumber *uid;
    @property (nonatomic, strong) NSDictionary *userInfo;
    @property(nonatomic,strong) NSMutableArray *talkAry;
    @property (nonatomic, assign) float txtHeight;
    @property (assign,nonatomic) BOOL isLoading;
    @property (assign,nonatomic) BOOL isLast;
    @property (strong, nonatomic) NSNumber *page;
@end

@implementation TalkViewController

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
    
    self.isLoading=NO;
    self.isLast=NO;
    self.page=[NSNumber numberWithInt:1];
    self.topButton.hidden=YES;
    
    [self.myTableView registerNib:[UINib nibWithNibName:@"SchoolPartyHeaderCell" bundle:nil] forCellReuseIdentifier:@"SchoolPartyHeaderCell"];
    [self.myTableView registerNib:[UINib nibWithNibName:@"PartyTalkCell" bundle:nil] forCellReuseIdentifier:@"PartyTalkCell"];
    self.talkAry=[[NSMutableArray alloc] init];
    
    //[self reloadTalkList];
    [WaitingAlert presentWithText:NSLocalizedStringFromTable(@"請稍後...",@"InfoPlist",nil) withTimeOut:30];
}


-(void)reloadTalkList{
    
    
    self.isLoading=YES;
    
    [self.manager getTalkWithId:self.party.partyID withTalkId:nil page:self.page callback:^(NSMutableArray *talkArray, NSString *errorMsg, NSError *error) {
        [WaitingAlert dismiss];
        self.isLoading=NO;
        if(self.page.intValue==1){
            [self.talkAry removeAllObjects];
        }
        if (talkArray.count>0) {
            [self.talkAry addObjectsFromArray:talkArray];
        }else{
            self.isLast=NO;
        }
        
        
        self.myTableView.tableFooterView=nil;
        [self.myTableView reloadData];
    }];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [self reloadTalkList];
}
#pragma mark - WriteReplyDelegate
- (void)refreshData{
    [self reloadTalkList];
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.talkAry.count+1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==0) {
       // self.txtHeight=[self getContentHeight:self.party.desc width:301 fontSize:14];
        return 160;
    }
    if (indexPath.row>0) {
        TalkObj *talk=self.talkAry[indexPath.row-1];
        float textHeight=[self getContentHeight:talk.clubTopicName width:263 fontSize:13];
        NSLog(@"%f",textHeight);
        
        return textHeight+35;

    }
    
    return 250;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0) {
        static NSString *cellIdentifier = @"SchoolPartyHeaderCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        [self configureSchoolPartyHeaderCell:(SchoolPartyHeaderCell *)cell atIndexPath:indexPath];
        return cell;
    }
    
    if(indexPath.row > 0)
    {
        //static NSString *cellIdentifier = @"FilmReviewCell";
        TalkCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PartyTalkCell"];
        [self configurePartyTalkCell:(PartyTalkCell *)cell atIndexPath:indexPath];
        return cell;
    }
    
    
    return nil;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.row>0) {
        if (self.party.isJoined.boolValue || self.party.isPublic.boolValue ){
            TalkObj *talk=self.talkAry[indexPath.row-1];
            ReplyPartyTalkViewController *retv=[[ReplyPartyTalkViewController alloc] initWithNibName:@"ReplyPartyTalkViewController" bundle:nil];
            retv.talkObj=talk;
            retv.partyId=self.party.partyID;
            retv.partyName=self.party.name;
            [self.navigationController pushViewController:retv animated:YES];
        }
    }
    
  
}


-(void)configureSchoolPartyHeaderCell:(SchoolPartyHeaderCell *)cell atIndexPath:(NSIndexPath *)indexPath{
    
    cell.partyName.text=self.party.name;
    
    cell.party=self.party;
    cell.creator.text=[NSString stringWithFormat:@"%@:%@",NSLocalizedStringFromTable(@"創辦人",@"InfoPlist",nil),self.party.nickName];
    cell.memberCount.text=[NSString stringWithFormat:@"%@ %@",self.party.memberCount,NSLocalizedStringFromTable(@"會員",@"InfoPlist",nil)];
    cell.desc.text=self.party.desc;
    cell.desc.frame=CGRectMake(10, 42, 301, self.txtHeight);
    cell.introView.hidden=YES;

    cell.isCreator= (self.uid.intValue==self.party.founderID.intValue) ? YES : NO;
    
    if (self.party.needAuth.boolValue) {
        //已加入
        if (self.party.isJoined.boolValue) {
            //審核過
            if (self.party.isPassAudit.boolValue) {
                //退出社團
                if ([self.lang isEqualToString:@"zh-Hant"]) {
                    [cell.join2Button setImage:[UIImage imageNamed:@"Exit-Societies.png"] forState:UIControlStateNormal];
                }else{
                    [cell.join2Button setImage:[UIImage imageNamed:@"退出社團.png"] forState:UIControlStateNormal];
                }
            }else{
                //審核中
                if ([self.lang isEqualToString:@"zh-Hant"]) {
                    [cell.join2Button setImage:[UIImage imageNamed:@"Audit_small.png"] forState:UIControlStateNormal];
                }else{
                    [cell.join2Button setImage:[UIImage imageNamed:@"審核中.png"] forState:UIControlStateNormal];
                }
            }
        }else{
            //加入社團
            if ([self.lang isEqualToString:@"zh-Hant"]) {
                [cell.join2Button setImage:[UIImage imageNamed:@"Societies_small.png"] forState:UIControlStateNormal];
            }else{
                [cell.join2Button setImage:[UIImage imageNamed:@"加入社團.png"] forState:UIControlStateNormal];
            }
        }
    }else{
        if (self.party.isJoined.boolValue) {
            //退出社團
            if ([self.lang isEqualToString:@"zh-Hant"]) {
                [cell.join2Button setImage:[UIImage imageNamed:@"Exit-Societies.png"] forState:UIControlStateNormal];
            }else{
                [cell.join2Button setImage:[UIImage imageNamed:@"退出社團.png"] forState:UIControlStateNormal];
            }
        }else{
            //加入社團
            if ([self.lang isEqualToString:@"zh-Hant"]) {
                [cell.join2Button setImage:[UIImage imageNamed:@"Societies_small.png"] forState:UIControlStateNormal];
            }else{
                [cell.join2Button setImage:[UIImage imageNamed:@"加入社團.png"] forState:UIControlStateNormal];
            }
        }
    }
    
    if (![self.lang isEqualToString:@"zh-Hant"]) {
        [cell.addTalkButton setImage:[UIImage imageNamed:@"發起話題簡.png"] forState:UIControlStateNormal];
    }
    
    //判斷是否加入社團
    if (!self.party.isJoined.boolValue){
        cell.addTalkButton.enabled=NO;
    }
    
    

    NSString *path=[NSString stringWithFormat:@"%@/Uploads/UserAvatar/%@",PROPUCTION_API_DOMAIN,self.party.avatar];
    [cell.avatar setImageWithURL:[NSURL URLWithString:path] placeholderImage:[UIImage imageNamed:@"nobody.jpg"]];
    
    NSString *bannerPath=[NSString stringWithFormat:@"%@/Uploads/ClubBanner/Club_%d.jpg?width=320",PROPUCTION_API_DOMAIN,self.party.partyID.intValue];
    [cell.banner setImageWithURL:[NSURL URLWithString:bannerPath] placeholderImage:[UIImage imageNamed:@"ngbg-1185.png"]];
    
    cell.btnView2.hidden=YES;
    cell.delegate=self;
    
}


- (void)configurePartyTalkCell:(PartyTalkCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    
    TalkObj *talk=self.talkAry[indexPath.row-1];
    
    float textHeight=[self getContentHeight:talk.clubTopicName width:263 fontSize:13];
    if (talk.IsTop.boolValue) {
        cell.titleLabel.text=[NSString stringWithFormat:@"[%@] %@" ,NSLocalizedStringFromTable(@"置頂",@"InfoPlist",nil),talk.clubTopicName];
    }else{
        cell.titleLabel.text=talk.clubTopicName;
    }
    cell.titleLabel.frame=CGRectMake(48, 4, 263, textHeight+3);
    cell.nickName.frame=CGRectMake(48, 4+textHeight+3, 263, 17);
    cell.nickName.text=[NSString stringWithFormat:@"%@ %@%@ %@(%d)",talk.nickName,NSLocalizedStringFromTable(@"寫於",@"InfoPlist",nil),[self convertDateStringforClubReply:talk.createdOn],NSLocalizedStringFromTable(@"回應人數",@"InfoPlist",nil),talk.clubTopicMessageAmount.intValue];

    [cell.avatarView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/Uploads/UserAvatar/%@",PROPUCTION_API_DOMAIN,talk.avatar]] placeholderImage:[UIImage imageNamed:@"nobody.jpg"]];
  
}

#pragma mark - SchoolPartyHeaderCellDelegate

- (void)openReplyPanel{
    WriteReplyViewController *wrv=[[WriteReplyViewController alloc] initWithNibName:@"WriteReplyViewController" bundle:nil];
    UINavigationController *nav=[[UINavigationController alloc] initWithRootViewController:wrv];
    wrv.party=self.party;
    wrv.delegate=self;
    [self.navigationController presentViewController:nav animated:YES completion:nil];
    
}

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
        [self reloadTalkList];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    float pointY=scrollView.contentOffset.y;
    NSLog(@"pointY:%f",pointY);
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
