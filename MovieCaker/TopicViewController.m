//
//  TopicViewController.m
//  MovieCaker
//
//  Created by iKevin on 2013/11/13.
//  Copyright (c) 2013年 iKevin. All rights reserved.
//

#import "TopicViewController.h"
#import "UIImageView+WebCache.h"
#import "TopicDetailViewController.h"
#import "SignUpViewController.h"
#import "SIAlertView.h"
#import "AppDelegate.h"
#import "TopicObj.h"
#import "LoginViewController.h"


@interface TopicViewController ()
    @property (nonatomic, strong) NSArray *topicArray;
    @property (nonatomic, strong) NSDateFormatter *df;
    @property (nonatomic, strong) NSNumber *uid;
    @property (nonatomic, strong) NSDictionary *userInfo;
    @property (assign,nonatomic) BOOL isLoading;
    @property (assign,nonatomic) BOOL isLast;
    @property (assign,nonatomic) BOOL isPreview;
    @property (strong, nonatomic) NSNumber *page;
    @property (assign, nonatomic) BOOL loadDataAgain;
    - (void)loadData;
@end

@implementation TopicViewController

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
    
   // [SVProgressHUD show];

    self.isPreview=YES;
    self.page=[NSNumber numberWithInt:1];
    
    [self setupDefaultNavBarButtons];
    
    if (!self.channel) {
        self.channel=@"Ten";
    }
    
    self.loadDataAgain=NO;
    self.topButton.hidden=YES;
    
    //=@"Ten";
    
    if ([self.channel isEqualToString:@"Ten"]) {
        self.title=NSLocalizedStringFromTable(@"專題十大",@"InfoPlist",nil);
    }else if([self.channel isEqualToString:@"Week"]){
        self.title=NSLocalizedStringFromTable(@"一週專題榜",@"InfoPlist",nil);
    }else if([self.channel isEqualToString:@"Friend"]){
        self.title=NSLocalizedStringFromTable(@"朋友專題",@"InfoPlist",nil);
    }

    self.myTableView.rowHeight = 310;
    self.df = [[NSDateFormatter alloc] init];
    self.df.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    
    [self.myTableView registerNib:[UINib nibWithNibName:@"TopicCell" bundle:nil] forCellReuseIdentifier:@"TopicCell"];
    
    [[MovieCakerManager sharedInstance] changeLang:^(NSNumber *count, NSString *errorMsg, NSError *error) {
        //
    }];
    
    if (self.appDelegate.autoLogin && [self.channel isEqualToString:@"Ten"]) {
        BOOL loagined=[[NSUserDefaults standardUserDefaults] boolForKey:@"logined"];
        
        if(loagined){
            
            NSString *account=[[NSUserDefaults standardUserDefaults] stringForKey:@"account"];
            NSString *password=[[NSUserDefaults standardUserDefaults] stringForKey:@"password"];
            [self.manager getLoginWithAccount:account withPassword:password withRemember:YES callback:^(NSDictionary *loginInfo, NSString *errorMsg, NSError *error) {
                
                BOOL success=[[loginInfo valueForKey:@"success"] boolValue];
                
                if (success) {
                    [WaitingAlert presentWithText:NSLocalizedStringFromTable(@"自動登入成功！",@"InfoPlist",nil) withTimeOut:2];
                    NSDictionary *dic=[self checkLoginInfo:loginInfo];
                    [self.manager saveLoginInfo:dic];
                    [self.manager saveLoginAccount:account withPwd:password];
                    
                    self.userInfo=[self.manager getLoginUnfo];
                    self.uid=self.userInfo[@"UserId"];
                    [self loadClientDB];
                    
                }else{
                    
                    [self showLoginView];
                    self.uid=[NSNumber numberWithInt:0];
                }
                
            }];
            
        }else{
            [self showLoginView];

        }
        
    }else{
        if ([self.manager isLogined]) {
            self.userInfo=[self.manager getLoginUnfo];
            self.uid=self.userInfo[@"UserId"];
        }else{
            self.uid=[NSNumber numberWithInt:0];
        }
        
        [self loadClientDB];
    }
    
    self.appDelegate.autoLogin=NO;
    

    
}

//顯示login畫面
-(void)showLoginView{
    self.loadDataAgain=YES;
    /*
    SignUpViewController *suvc= [[SignUpViewController alloc] initWithNibName:@"SignUpViewController" bundle:nil];
    UINavigationController *nav=[[UINavigationController alloc] initWithRootViewController:suvc];
    [self.navigationController presentViewController:nav animated:NO completion:^{}];
     */
    LoginViewController *lvc=[[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
   // UINavigationController *nav=[[UINavigationController alloc] initWithRootViewController:lvc];
    [self.navigationController presentViewController:lvc animated:NO completion:^{}];
}

//load 暫存在資料庫的資料
-(void)loadClientDB{
    
    [self.manager getTopicFromDbWithId:self.uid.stringValue channel:self.channel withPage:self.page callback:^(NSArray *topicArray, NSString *errorMsg, NSError *error) {
        
        //self.topicArray=topicArray;
        [self.myTableView reloadData];
        [self.myTableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:NO];
        
        [self loadData];
         
    }];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if ([self.manager isLogined]) {
        self.userInfo=[self.manager getLoginUnfo];
        self.uid=self.userInfo[@"UserId"];
    }else{
        self.uid=[NSNumber numberWithInt:0];
    }
    
    
    if (self.loadDataAgain) {
         [self loadClientDB];
        self.loadDataAgain=NO;
    }else{
        if (self.topicArray.count>0) {
            
            TopicObj *topic=self.topicArray[0];
            if (topic.picture) {
                [self.myTableView reloadData];
            }else{
               [self loadClientDB];
            }
            
            
        }
    }
    
    
}

- (void)loadData{
    
    [WaitingAlert presentWithText:NSLocalizedStringFromTable(@"請稍後...",@"InfoPlist",nil) withTimeOut:30];
    
    [self.manager getTopicWithId:self.uid.stringValue channel:self.channel withPage:self.page callback:^(NSArray *topicArray, NSString *errorMsg, NSError *error) {
        
        if (topicArray) {
            self.topicArray=topicArray;
            [self.myTableView reloadData];
            self.myTableView.tableFooterView=nil;
        }
        
        if (self.topicArray.count>0) {
            TopicObj *topic=(TopicObj *)self.topicArray[0];
            // NSNumber *total=topicArray[0][@"total"];
            if (self.topicArray.count==topic.total.intValue) {
                self.isLast=YES;
            }
        }else{
            self.isLast=YES;
            [self alertShow:NSLocalizedStringFromTable(@"目前沒有資料！",@"InfoPlist",nil)];
        }
 
        [WaitingAlert dismiss];
        
    }];
    
}
-(void)goToTopicDetail:(NSNumber *)topicId{
    NSMutableArray *array = [[NSMutableArray alloc]initWithArray: [[PersistentManager sharedInstance] getTopicWithChannel:@"Ten"]];
    [array addObjectsFromArray:[[PersistentManager sharedInstance] getTopicWithChannel:@"Week"]];
    TopicObj *test = nil;
    for (TopicObj *row in array) {
        if (row.topicID == topicId) {
            test = row;
        }
    }
    if(test!=nil){
        TopicDetailViewController *topicDetailVC=[[TopicDetailViewController alloc] initWithNibName:@"TopicDetailViewController" bundle:nil];
        topicDetailVC.topic = test;
        topicDetailVC.channel = @"InTopic";
        [self.navigationController pushViewController:topicDetailVC animated:YES];
    }else{
        
      [self.manager getTopicWithTopicID:topicId callback:^(TopicObj *topic, NSString *errorMsg, NSError *error) {
        TopicObj *test = topic;
          if (test==nil) {
              UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                              message:@"不存在的專題"
                                                             delegate:self
                                                    cancelButtonTitle:@"OK"
                                                    otherButtonTitles:nil];
              [alert show];
          }else{
        TopicDetailViewController *topicDetailVC=[[TopicDetailViewController alloc] initWithNibName:@"TopicDetailViewController" bundle:nil];
        topicDetailVC.topic = test;
        topicDetailVC.channel = @"InTopic";
        [self.navigationController pushViewController:topicDetailVC animated:YES];
          }
    }];}

}
#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return self.topicArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"TopicCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    [self configureCell:(TopicCell *)cell atIndexPath:indexPath];
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    TopicDetailViewController *topicDetailVC=[[TopicDetailViewController alloc] initWithNibName:@"TopicDetailViewController" bundle:nil];
    topicDetailVC.topic=self.topicArray[indexPath.row];
    topicDetailVC.channel=@"InTopic";
    [self.navigationController pushViewController:topicDetailVC animated:YES];
    
}
- (void)configureCell:(TopicCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    TopicObj *topic=self.topicArray[indexPath.row];
    cell.topic=topic;
    
    cell.header.text=[NSString stringWithFormat:@"%@(%d)",topic.title,topic.videoCount.intValue];
    
    cell.viewNumLabel.text=[NSString stringWithFormat:@"%@ %@",topic.viewNum.stringValue,NSLocalizedStringFromTable(@"瀏覽",@"InfoPlist",nil)];
    
    if (![self.lang isEqualToString:@"zh-Hant"]) {
        [cell.likeButton setImage:[UIImage imageNamed:@"Love_b.png"] forState:UIControlStateDisabled];
        [cell.likeButton setImage:[UIImage imageNamed:@"love_d.png"] forState:UIControlStateSelected];
        [cell.likeButton setImage:[UIImage imageNamed:@"love_c.png"] forState:UIControlStateNormal];
    }
    
    
    if ([self.manager isLogined]) {
        cell.likeButton.enabled=YES;
        cell.isCreator= (self.uid.intValue==topic.authorID.intValue) ? YES : NO;
        if (topic.isLiked.boolValue) {
            cell.likeButton.selected=YES;
        }else{
            cell.likeButton.selected=NO;
        }
        
    }else{
        if ([self.lang isEqualToString:@"zh-Hant"]) {
            [cell.likeButton setImage:[UIImage imageNamed:@"love_disable.png"] forState:UIControlStateNormal];
        }else{
            [cell.likeButton setImage:[UIImage imageNamed:@"Love_b.png"] forState:UIControlStateNormal];
        }
        
    }
    
    NSArray *jpgAry=[topic.picture componentsSeparatedByString:@","];
    
    NSArray *images=@[cell.imageView1,cell.imageView2,cell.imageView3,cell.imageView4,cell.imageView5];
    
    for (int i=0; i<jpgAry.count; i++) {
        
        UIImageView *imageView=images[i];
        [imageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.funmovie.tv/Content/pictures/files/%@?width=156",jpgAry[i]]] placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
        }];
        
        NSLog(@"%@",[NSString stringWithFormat:@"http://www.funmovie.tv/Content/pictures/files/%@?width=156",jpgAry[i]]);
    }
    cell.content.text=[topic.content stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    [cell.avatarView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/Uploads/UserAvatar/%@",PROPUCTION_API_DOMAIN,topic.avatar]] placeholderImage:[UIImage imageNamed:@"nobody.jpg"]];
    
    cell.nickName.text=topic.nickName;
    
    cell.createdOn.text=[self.df stringFromDate:topic.createdOn];
    cell.indexPath=indexPath;
    cell.delegate=self;
    
}

#pragma mark - TopicCellDelegate
- (void)shareButtonPressed:(NSIndexPath *)indexPath WithImage:(UIImage *)image{
    TopicObj *topic=(TopicObj *)self.topicArray[indexPath.row];
    
    NSString *path=[NSString stringWithFormat:@"%@/Topic/TopicPage/%@",PROPUCTION_API_DOMAIN,topic.topicID.stringValue];
    
    
    
    
    SIAlertView *alertView = [[SIAlertView alloc] initWithTitle:topic.title andMessage:nil];
    [alertView addButtonWithTitle:@"        Facebook"
                             type:SIAlertViewButtonTypeDefault
                          handler:^(SIAlertView *alertView) {
                              
                              
                              //NSMutableDictionary* pDictLink = [self.linkAry objectAtIndex:self.selNo];
                              //NSMutableDictionary* pDict=[[NSMutableDictionary alloc] initWithDictionary:self.articleArray[self.selNo]];
                              NSString *name = @"MovieCaker";
                              NSString *description =topic.content;
                              NSString *title=topic.title;
                              NSString *fbPicture =[NSString stringWithFormat:@"http://www.funmovie.tv/Content/pictures/banners/%@?width=320",topic.banner];
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
                              message.title = topic.title;

                              NSString *str;
                              if (topic.content.length>140) {
                                  str=[topic.content substringToIndex:140];
                              }else{
                                  str=topic.content;;
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
                              NSString *shareTxt=[NSString stringWithFormat:@"[%@]%@",topic.title,topic.content];
                              if (shareTxt.length>140) {
                                  shareTxt=[NSString stringWithFormat:@"%@...",[shareTxt substringToIndex:137]];
                              }
                              message.text =shareTxt;
                              
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
/*
// A function for parsing URL parameters returned by the Feed Dialog.
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
 */

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
