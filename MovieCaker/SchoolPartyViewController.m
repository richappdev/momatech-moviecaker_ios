//
//  SchoolPartyViewController.m
//  MovieCaker
//
//  Created by iKevin on 2013/12/15.
//  Copyright (c) 2013年 iKevin. All rights reserved.
//

#import "SchoolPartyViewController.h"
#import "SchoolPartyObj.h"
#import "UIImageView+WebCache.h"
#import "SIAlertView.h"
#import "PertyContentViewController.h"

@interface SchoolPartyViewController ()
    @property(nonatomic, strong) NSNumber *uid;
    @property (nonatomic, strong) NSDictionary *userInfo;
    @property(nonatomic,strong) NSMutableArray *partyArray;
    @property (strong, nonatomic) NSNumber *page;
    @property(assign,nonatomic) BOOL isLoading;
    @property(assign,nonatomic) BOOL isLast;
@end

@implementation SchoolPartyViewController

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
    self.title=NSLocalizedStringFromTable(@"發現社團",@"InfoPlist",nil);

    
    self.page=[NSNumber numberWithInt:1];
    self.isLast=NO;
    self.isLoading=NO;
    self.topButton.hidden=YES;
    
    self.myTableView.tableFooterView=nil;
    
    self.partyArray=[[NSMutableArray alloc] init];
    
    if ([self.manager isLogined]) {
        self.userInfo=[self.manager getLoginUnfo];
        self.uid=self.userInfo[@"UserId"];
    }else{
        self.uid=[NSNumber numberWithInt:0];
    }
    
    [self.myTableView registerNib:[UINib nibWithNibName:@"SchoolPartyCell" bundle:nil] forCellReuseIdentifier:@"SchoolPartyCell"];
    

}



-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
//    if (self.partyArray.count>0) {
//        [self.myTableView reloadData];
//    }else{
//        [self loadData];
//    }
    [self loadData];
}

- (void)loadData{
    
    NSLog(@"loadData");
    
    [WaitingAlert presentWithText:NSLocalizedStringFromTable(@"請稍後...",@"InfoPlist",nil) withTimeOut:30];
    self.isLoading=YES;
    [self.manager getSchoolPartyWithChannel:@"discover" withPage:self.page withUid:nil
                                   callback:^(NSArray *partyArray, NSString *errorMsg, NSError *error) {
                                       [self.partyArray removeAllObjects];
                                       [self.partyArray addObjectsFromArray:partyArray];
                                       self.isLoading=NO;
                                       self.myTableView.tableFooterView=nil;
                                       SchoolPartyObj *schoolParty=self.partyArray[0];
                                       if (self.partyArray.count==schoolParty.total.intValue) {
                                           self.isLast=YES;
                                       }
                                       [self.myTableView reloadData];
                                       
                                       [WaitingAlert dismiss];
                                   }];
    
    
    
    
    
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.partyArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 267;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
        static NSString *cellIdentifier = @"SchoolPartyCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        [self configureSchoolPartyCell:(SchoolPartyCell *)cell atIndexPath:indexPath];
        return cell;

}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    PertyContentViewController *pcvc=[[PertyContentViewController alloc] initWithNibName:@"PertyContentViewController" bundle:nil];
    pcvc.party=self.partyArray[indexPath.row];
    [self.navigationController pushViewController:pcvc animated:YES];

    
}

-(void)configureSchoolPartyCell:(SchoolPartyCell *)cell atIndexPath:(NSIndexPath *)indexPath{
    
    SchoolPartyObj *party=self.partyArray[indexPath.row];
    cell.partyName.text=party.name;
    cell.party=party;
    cell.creator.text=[NSString stringWithFormat:@"%@:%@",NSLocalizedStringFromTable(@"創辦人",@"InfoPlist",nil),party.nickName];
    cell.memberCount.text=[NSString stringWithFormat:@"%@ %@",party.memberCount.stringValue,NSLocalizedStringFromTable(@"會員",@"InfoPlist",nil)];
    cell.content.text=party.desc;
    cell.publicLabel.text= party.isPublic.boolValue ? NSLocalizedStringFromTable(@"公開",@"InfoPlist",nil):NSLocalizedStringFromTable(@"不公開",@"InfoPlist",nil);
    NSString *publicImage=party.isPublic.boolValue ? @"publicBg.png":@"noPublicBg.png";
    
    [cell.publicImageView setImage:[UIImage imageNamed:publicImage]];
    
    cell.isCreator= (self.uid.intValue==party.founderID.intValue) ? YES : NO;

    
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
    [cell.partyBanner setImageWithURL:[NSURL URLWithString:bannerPath] placeholderImage:[UIImage imageNamed:@"ngbg-1185.png"]];
    NSString *path=[NSString stringWithFormat:@"%@/Uploads/UserAvatar/%@",PROPUCTION_API_DOMAIN,party.avatar];
    [cell.avatar setImageWithURL:[NSURL URLWithString:path] placeholderImage:[UIImage imageNamed:@"nobody.jpg"]];
    
    cell.delegate=self;
    cell.indexPath=indexPath;

}

#pragma mark - TopicCellDelegate
- (void)shareButtonPressed:(NSIndexPath *)indexPath WithImage:(UIImage *)image{
    
    SchoolPartyObj *party=self.partyArray[indexPath.row];
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
                              NSString *str;
                              if (party.desc.length>140) {
                                  str=[party.desc substringToIndex:140];
                              }else{
                                  str=party.desc;
                              }
                              
                              message.description=str;
                              
                              
                              //message.description = @"";
                              //[NSURL URLWithString:[NSString stringWithFormat:@"http://www.funmovie.tv/Content/pictures/banners/%@",self.topic.banner]];
                              //先取100*100
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
