//
//  ReplyPartyTalkViewController.m
//  MovieCaker
//
//  Created by iKevin on 2014/5/2.
//  Copyright (c) 2014年 iKevin. All rights reserved.
//

#import "ReplyPartyTalkViewController.h"
#import "SIAlertView.h"
#import "ActivityCell.h"


@interface ReplyPartyTalkViewController ()
    @property(nonatomic, strong) NSNumber *uid;
    @property (nonatomic, strong) NSDictionary *userInfo;
    @property(nonatomic,strong) NSMutableArray *ary;
    @property (assign,nonatomic) BOOL isLoading;
    @property (assign,nonatomic) BOOL isLast;
    @property (strong, nonatomic) NSNumber *page;
    @property (assign, nonatomic) BOOL joined;
@end

@implementation ReplyPartyTalkViewController

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
    
    self.title=self.partyName;
    
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
    self.myTableView.tableFooterView=nil;
    self.ary=[[NSMutableArray alloc] init];
    
    //是否加入社團
    self.joined=NO;
    
    UIButton *left = [UIButton buttonWithType:UIButtonTypeCustom];
    [left setImage:[UIImage imageNamed:@"Arrow"] forState:UIControlStateNormal];
    left.frame = CGRectMake(0, 0, 32, 32);
    left.showsTouchWhenHighlighted = YES;
    [left addTarget:self
             action:@selector(back:)
   forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:left];
    
    
    [self.myTableView registerNib:[UINib nibWithNibName:@"TalkCell" bundle:nil] forCellReuseIdentifier:@"TalkCell"];
    [self.myTableView registerNib:[UINib nibWithNibName:@"ActivityCell" bundle:nil] forCellReuseIdentifier:@"ActivityCell"];
    
    if (self.talkId==nil) {
        self.talkId=self.talkObj.talkId;
    }
    [self loadClub];
    
    
}

-(void)loadClub{
    [self.manager clubWithId:self.partyId callback:^(SchoolPartyObj *party, NSString *errorMsg, NSError *error) {
        self.joined=party.isJoined.boolValue;
        [self loadTalk];
    }];
}

-(void)loadTalk{
    
    [WaitingAlert presentWithText:NSLocalizedStringFromTable(@"請稍後...",@"InfoPlist",nil) withTimeOut:30];
    
    [self.manager getTalkWithId:self.partyId withTalkId:self.talkId page:@(1) callback:^(NSMutableArray *talkArray, NSString *errorMsg, NSError *error) {
        
        self.talkObj=talkArray[0];
        
        [self loadData];
    }];
}

-(void)loadData{
    self.isLoading=YES;
    [self.manager clubTopicMessageWithId:self.talkObj.talkId page:self.page
                                callback:^(NSArray *talkArray, NSString *errorMsg, NSError *error) {
                                     [WaitingAlert dismiss];
                                    self.isLoading=NO;
                                    if(self.page.intValue==1){
                                        [self.ary removeAllObjects];
                                    }
                                    if (talkArray.count>0) {
                                        [self.ary addObjectsFromArray:talkArray];
                                    }else{
                                        self.isLast=NO;
                                    }
                                    self.myTableView.tableFooterView=nil;
                                    //self.talkObj.clubTopicMessageAmount=[NSNumber numberWithInt:self.ary.count];
                                    [self.myTableView reloadData];
                                    
                                }];
}

#pragma mark - WriteReplyDelegate
- (void)refreshData {
    [self.ary removeAllObjects];
    self.page=@(1);
    [self loadTalk];
    //[self loadData];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0) {
        return 1;
    }
    return self.ary.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section==0) {
        if (self.talkObj.clubTopicDesc) {
            float reviewHeight=[self getContentHeight:self.talkObj.clubTopicDesc width:302 fontSize:13];
            NSLog(@"reviewHeight:%f",reviewHeight);
            return reviewHeight+75+50+123;
        }
    }else{
       return 102;
    }
    
    
   return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    if (indexPath.section==0) {
        TalkCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TalkCell"];
        [self configureTalkCell:(TalkCell *)cell atIndexPath:indexPath];
        return cell;
    }

    static NSString *cellIdentifier = @"ActivityCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    [self configureActivityCell:(ActivityCell *)cell atIndexPath:indexPath];
    return cell;
    

}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    

    
}

- (void)configureTalkCell:(TalkCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    
    //self.df.dateFormat = @"yyyy-MM-dd";
    cell.nickName.text=self.talkObj.nickName;
    cell.timeLabel.text=[self convertDateStringforClubReply:self.talkObj.createdOn];
    cell.titleLabel.text=self.talkObj.clubTopicName;
    
    cell.isCreator= (self.uid.intValue==self.talkObj.creatorId.intValue) ? YES : NO;
    
    if (![self.lang isEqualToString:@"zh-Hant"]) {
        [cell.likeButton setImage:[UIImage imageNamed:@"Love_b.png"] forState:UIControlStateDisabled];
        [cell.likeButton setImage:[UIImage imageNamed:@"love_d.png"] forState:UIControlStateSelected];
        [cell.likeButton setImage:[UIImage imageNamed:@"love_c.png"] forState:UIControlStateNormal];
        [cell.replyButton setImage:[UIImage imageNamed:@"回應簡.png"] forState:UIControlStateNormal];
        
    }
    
    if (self.talkObj.isLike.boolValue) {
        cell.likeButton.selected=YES;
    }else{
        cell.likeButton.selected=NO;
    }
    

    cell.replyButton.enabled=self.joined;
  
    
    NSString *bannerPath=[NSString stringWithFormat:@"%@/Uploads/ClubBanner/Club_%d.jpg?width=320",PROPUCTION_API_DOMAIN,self.talkObj.clubId.intValue];
    [cell.partyBanner setImageWithURL:[NSURL URLWithString:bannerPath] placeholderImage:[UIImage imageNamed:@"ngbg-1185.png"]];
    
    float reviewHeight=[self getContentHeight:self.talkObj.clubTopicDesc width:302 fontSize:13];
    cell.message.frame=CGRectMake(9, 178, 302, reviewHeight+15);
    cell.message.text=self.talkObj.clubTopicDesc;
    [cell.avatarView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/Uploads/UserAvatar/%@",PROPUCTION_API_DOMAIN,self.talkObj.avatar]] placeholderImage:[UIImage imageNamed:@"nobody.jpg"]];
    
    cell.socialLabel.text=[NSString stringWithFormat:@"%d%@  %d%@  %d%@",self.talkObj.pageViews.intValue,NSLocalizedStringFromTable(@"瀏覽",@"InfoPlist",nil),self.talkObj.clubTopicMessageAmount.intValue,NSLocalizedStringFromTable(@"回應",@"InfoPlist",nil),self.talkObj.likedAmount.intValue,NSLocalizedStringFromTable(@"喜歡",@"InfoPlist",nil)];
    
    cell.talkObj=self.talkObj;
    cell.delegate=self;
    
}
-(void) configureActivityCell:(ActivityCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *dict=self.ary[indexPath.row];
   
    cell.content.text=dict[@"Message"];
    NSString *path=[NSString stringWithFormat:@"%@/Uploads/UserAvatar/%@",PROPUCTION_API_DOMAIN,dict[@"User"][@"Avatar"]];
    cell.nickName.text=dict[@"User"][@"NickName"];
    
    cell.createdOn.text=[self convertDateStringforClubReply:dict[@"CreatedOn"]];
    [cell.avatarImageView setImageWithURL:[NSURL URLWithString:path] placeholderImage:[UIImage imageNamed:@"nobody.jpg"]];
}

#pragma mark - TalkCellDelegate
- (void)openReplyPanel{
    
    WriteReplyViewController *wrv=[[WriteReplyViewController alloc] initWithNibName:@"WriteReplyViewController" bundle:nil];
    UINavigationController *nav=[[UINavigationController alloc] initWithRootViewController:wrv];
    
    wrv.talkObj=self.talkObj;
    wrv.delegate=self;
    
    
    [self.navigationController presentViewController:nav animated:YES completion:nil];
    
}
- (void)shareButtonPressed:(UIImage *)image{
    
    NSString *path=[NSString stringWithFormat:@"%@/Social/ClubTopicPage/%@",PROPUCTION_API_DOMAIN,self.talkObj.talkId.stringValue];
    
    SIAlertView *alertView = [[SIAlertView alloc] initWithTitle:nil andMessage:nil];
    [alertView addButtonWithTitle:@"        Facebook"
                             type:SIAlertViewButtonTypeDefault
                          handler:^(SIAlertView *alertView) {

                              NSString *name = @"MovieCaker";
                              NSString *description =self.talkObj.clubTopicDesc;
                              NSString *title=self.talkObj.clubTopicName;
                              NSString *fbPicture =[NSString stringWithFormat:@"%@/Uploads/ClubBanner/Club_%d.jpg",PROPUCTION_API_DOMAIN,self.talkObj.clubId.intValue];
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
                              message.title = self.talkObj.clubTopicName;
                              message.description = self.talkObj.clubTopicDesc;
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
                              
                              message.text = self.talkObj.clubTopicName;
                              
                              
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
    
    
    //alertView.title = @"3";
    
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
    NSLog(@"pointY:%f",pointY);
    if (pointY>150) {
        self.topButton.hidden=NO;
    }else{
        self.topButton.hidden=YES;
    }
    
}

-(void)back:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
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
