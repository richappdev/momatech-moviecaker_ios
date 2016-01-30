//
//  TopicDetailViewController.m
//  MovieCaker
//
//  Created by iKevin on 2013/11/17.
//  Copyright (c) 2013年 iKevin. All rights reserved.
//

#import "TopicDetailViewController.h"
#import "ReplyViewController.h"
#import "UIImageView+WebCache.h"
#import "ReplyMoreCell.h"
#import "VideoContentViewController.h"
#import "JoinTopicViewController.h"
#import "SIAlertView.h"

@interface TopicDetailViewController ()
    @property (nonatomic, strong) NSDateFormatter *df;
    @property (nonatomic, assign) float txtHeight;
    @property (nonatomic, strong) NSArray *videoArray;
    @property (strong, nonatomic) NSNumber *uid;
    @property (nonatomic,strong) NSDictionary *userInfo;
    @property (nonatomic,assign) NSInteger replySum;
    @property(assign,nonatomic) BOOL isLoading;
    @property(assign,nonatomic) BOOL isLast;
    @property(assign,nonatomic) BOOL isPreview;
    -(void)loadTopicReply:(NSNumber *)topicID;
    -(void)loadVideo;
@end

@implementation TopicDetailViewController

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
    //self.myTableView.rowHeight = 460;
    NSLog(@"%@asdsdasd",self.channel);
    self.df = [[NSDateFormatter alloc] init];
    
    self.page=[NSNumber numberWithInt:1];
    
    self.isPreview=YES;
    self.isLoading=NO;
    
    if ([self.manager isLogined]) {
        self.userInfo=[self.manager getLoginUnfo];
        self.uid=self.userInfo[@"UserId"];
    }else{
        self.uid=[NSNumber numberWithInt:0];
    }
    
    self.myTableView.tableFooterView=nil;
    self.topButton.hidden=YES;
    
    [self.myTableView registerNib:[UINib nibWithNibName:@"TopicDetailCell" bundle:nil] forCellReuseIdentifier:@"TopicDetailCell"];
    [self.myTableView registerNib:[UINib nibWithNibName:@"ReplyMoreCell" bundle:nil] forCellReuseIdentifier:@"ReplyMoreCell"];
    [self.myTableView registerNib:[UINib nibWithNibName:@"MovieListCell" bundle:nil] forCellReuseIdentifier:@"MovieListCell"];
    
        if ([self.channel isEqualToString:@"InTopic"]) {
            self.title=self.topic.title;
            UIButton *left = [UIButton buttonWithType:UIButtonTypeCustom];
            [left setImage:[UIImage imageNamed:@"Arrow"] forState:UIControlStateNormal];
            left.frame = CGRectMake(0, 0, 32, 32);
            left.showsTouchWhenHighlighted = YES;
            [left addTarget:self
                     action:@selector(back:)
           forControlEvents:UIControlEventTouchUpInside];
            self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:left];
            //[self loadTopicReply:self.topic.topicID];
            
        }else if([self.channel isEqualToString:@"Actor"]){
            
            self.title=self.actorName;
            
            UIButton *left = [UIButton buttonWithType:UIButtonTypeCustom];
            [left setImage:[UIImage imageNamed:@"Arrow"] forState:UIControlStateNormal];
            left.frame = CGRectMake(0, 0, 32, 32);
            left.showsTouchWhenHighlighted = YES;
            [left addTarget:self
                     action:@selector(back:)
           forControlEvents:UIControlEventTouchUpInside];
            self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:left];
            //[self loadVideo];
            
        }else if([self.channel isEqualToString:@"Activity"]){
            
            UIButton *left = [UIButton buttonWithType:UIButtonTypeCustom];
            [left setImage:[UIImage imageNamed:@"Arrow"] forState:UIControlStateNormal];
            left.frame = CGRectMake(0, 0, 32, 32);
            left.showsTouchWhenHighlighted = YES;
            [left addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
            self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:left];
        }else{
            [self setupDefaultNavBarButtons];
            if ([self.channel isEqualToString:@"Week"]) {
                self.title=NSLocalizedStringFromTable(@"一週電影熱點",@"InfoPlist",nil);
            }else if([self.channel isEqualToString:@"Friend"]){
                self.title=NSLocalizedStringFromTable(@"朋友電影熱點",@"InfoPlist",nil);
            }else if([self.channel isEqualToString:@"Global"]){
                self.title=NSLocalizedStringFromTable(@"全球新片",@"InfoPlist",nil);
            }
            //[self loadVideo];
        }
    
    if ([self.channel isEqualToString:@"InTopic"]) {
        
        [self loadTopicReply:self.topic.topicID];
        
    }else if([self.channel isEqualToString:@"Actor"]){
        
        [self loadData];
        
    }else if([self.channel isEqualToString:@"Activity"]){
        
        [self.manager getTopicWithTopicID:self.topicId callback:^(TopicObj *topic, NSString *errorMsg, NSError *error) {
            self.topic=topic;
            self.title=self.topic.title;
            [self loadTopicReply:self.topic.topicID];
        }];
    }else{
        [self loadData];
    }
   
}

-(void)back:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if (self.videoArray.count>0) {
        [self.myTableView reloadData];
    }
    
}

-(void)loadTopicReply:(NSNumber *)topicID
{
    [WaitingAlert presentWithText:NSLocalizedStringFromTable(@"請稍後...",@"InfoPlist",nil) withTimeOut:30];
    [self.manager getTopicReplyWithId:topicID callback:^(NSArray *replys, NSString *errorMsg, NSError *error) {
        
        if (replys.count) {
            self.reply=replys[0];
            self.replySum=replys.count;
        }else{
            self.replySum=0;
        }
        [self loadData];
    }];
}

-(void)loadVideo
{
    
    if (self.isPreview) {
        [WaitingAlert presentWithText:NSLocalizedStringFromTable(@"請稍後...",@"InfoPlist",nil) withTimeOut:30];
        [self.manager getVideoFromDbWithTopicID:self.topic.topicID channel:self.channel withUID:self.uid.stringValue withYear:self.year withMonth:self.month withPage:self.page withMyType:nil withActorID:self.actorId callback:^(NSArray *videoArray, NSString *errorMsg, NSError *error) {
            
            if (videoArray.count>0) {
                self.videoArray=videoArray;
                [self.myTableView reloadData];
                [WaitingAlert dismiss];
            }

            [self loadData];
        }];
    }
}

-(void)loadData{
    
    NSLog(@"loadData");

    self.isLoading=YES;
    [WaitingAlert presentWithText:NSLocalizedStringFromTable(@"請稍後...",@"InfoPlist",nil) withTimeOut:30];
    [self.manager getVideoWithTopicID:self.topic.topicID channel:self.channel withUID:self.uid.stringValue withYear:self.year withMonth:self.month withPage:self.page withMyType:nil withActorID:self.actorId callback:^(NSArray *videoArray, NSString *errorMsg, NSError *error) {
        
        [WaitingAlert dismiss];
        
        if (videoArray.count>0) {
            if (self.videoArray.count<videoArray.count  ) {
                self.isLoading=NO;
                //self.isPreview=NO;
                self.videoArray=videoArray;
                [self.myTableView reloadData];
                self.myTableView.tableFooterView=nil;
            }
        }
        
        VideoObj *video=self.videoArray[0];
        if (self.videoArray.count==video.total.intValue) {
            
            self.isLast=YES;
        }
        
        if (videoArray.count==0) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                            message:NSLocalizedStringFromTable(@"目前沒有朋友資料！",@"InfoPlist",nil)
                                                           delegate:nil
                                                  cancelButtonTitle:NSLocalizedStringFromTable(@"確定",@"InfoPlist",nil)
                                                  otherButtonTitles:nil];
            [alert show];
        }

    }];
}

#pragma mark - MovieCellDelegate

- (void)joinTopic:(VideoObj *)video{
    JoinTopicViewController *jtvc=[[JoinTopicViewController alloc] initWithNibName:@"JoinTopicViewController" bundle:nil];
    UINavigationController *nav=[[UINavigationController alloc] initWithRootViewController:jtvc];
    [self.navigationController presentViewController:nav animated:YES completion:nil];
    
}
#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    if ([self.channel isEqualToString:@"InTopic"] || [self.channel isEqualToString:@"Activity"]) {
        if (self.replySum>0) {
            return self.videoArray.count+2;
        }else{
            return self.videoArray.count+1;
        }
        
    }else{
       return self.videoArray.count;
    }
    
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    if ([self.channel isEqualToString:@"InTopic"] || [self.channel isEqualToString:@"Activity"]) {
        if (indexPath.row==0) {
            self.txtHeight=[self getContentHeight:self.topic.content width:301 fontSize:14];
            return self.txtHeight+209+44;
        }
        if(indexPath.row==1 && self.replySum>0){
            return 44;
        }
    }
    
    return 220;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    /*
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.textLabel.text=@"123";
    return cell;
     */
    
    if ([self.channel isEqualToString:@"InTopic"] || [self.channel isEqualToString:@"Activity"]) {
        if(indexPath.row == 0)
        {
            TopicDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TopicDetailCell"];
            [self configureCell:(TopicDetailCell *)cell atIndexPath:indexPath];
            return cell;
        }
    
        if(indexPath.row == 1 && self.replySum>0)
        {
            ReplyMoreCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ReplyMoreCell"];
            [self configureReplyMoreCell:(ReplyMoreCell *)cell atIndexPath:indexPath];
            return cell;
        }else{
            
            MovieListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MovieListCell"];
            [self configureMovieListCell:(MovieListCell *)cell atIndexPath:indexPath];
            return cell;
        }
        
    
        if(indexPath.row > 1)
        {
            MovieListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MovieListCell"];
            [self configureMovieListCell:(MovieListCell *)cell atIndexPath:indexPath];
            return cell;
        }
    }else{

        MovieListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MovieListCell"];
        [self configureMovieListCell:(MovieListCell *)cell atIndexPath:indexPath];
        return cell;
    }
    return nil;
     
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell=[tableView cellForRowAtIndexPath:indexPath];
    if ([cell isKindOfClass:[MovieListCell class]]) {
        
        VideoObj *video;
        if ([self.channel isEqualToString:@"InTopic"] || [self.channel isEqualToString:@"Activity"]) {
            if (self.replySum>0) {
                video=self.videoArray[indexPath.row-2];
            }else{
                video=self.videoArray[indexPath.row-1];
            }
        }else{
            video=self.videoArray[indexPath.row];
        }
        
        VideoContentViewController *vcvc=[[VideoContentViewController alloc] initWithNibName:@"VideoContentViewController" bundle:nil];
        
        vcvc.video=video;
        
        
        
        [self.navigationController pushViewController:vcvc animated:YES];
    }
    
    if ([cell isKindOfClass:[ReplyMoreCell class]]) {
        ReplyViewController *rvc=[[ReplyViewController alloc] initWithNibName:@"ReplyViewController" bundle:nil];
        rvc.topic=self.topic;
        [self.navigationController pushViewController:rvc animated:YES];
    }
    
    
}
- (void)configureCell:(TopicDetailCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    
    cell.topic=self.topic;
    

    
    if (self.topic.title){
        cell.header.text=[NSString stringWithFormat:@"%@(%@)",self.topic.title,self.topic.videoCount];
    }else{
        cell.header.text=@"";
    }
    if (self.topic.content) {
        cell.content.text=self.topic.content;
    }else{
        cell.content.text=@"";
    }
    
    if (![self.lang isEqualToString:@"zh-Hant"]) {
        [cell.likeButton setImage:[UIImage imageNamed:@"Love_b.png"] forState:UIControlStateDisabled];
        [cell.likeButton setImage:[UIImage imageNamed:@"love_d.png"] forState:UIControlStateSelected];
        [cell.likeButton setImage:[UIImage imageNamed:@"love_c.png"] forState:UIControlStateNormal];
    }
    
    if ([self.manager isLogined]) {
        cell.likeButton.enabled=YES;
        cell.isCreator= (self.uid.intValue==self.topic.authorID.intValue) ? YES : NO;
        if (self.topic.isLiked.boolValue) {
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
    
    
    
    cell.content.frame=CGRectMake(9.0, 175.0, 301.0, self.txtHeight);
    cell.cellGrayBgView.frame=CGRectMake(0, 110, 320, self.txtHeight+100);
    cell.socialLabel.text=[NSString stringWithFormat:@"%d %@   %d %@   %d %@",self.topic.viewNum.intValue,NSLocalizedStringFromTable(@"瀏覽",@"InfoPlist",nil),self.topic.commentNum.intValue,NSLocalizedStringFromTable(@"回應",@"InfoPlist",nil),self.topic.likeNum.intValue,NSLocalizedStringFromTable(@"喜歡",@"InfoPlist",nil)];
    
    cell.viewNumLabel.text=[NSString stringWithFormat:@"%d %@",self.topic.viewNum.intValue,NSLocalizedStringFromTable(@"瀏覽",@"InfoPlist",nil)];
    
    
    cell.socialLabel.frame=CGRectMake(9, 70+self.txtHeight, 301.0, 21);
    
    if (self.topic.nickName) {
        cell.nickName.text=self.topic.nickName;
    }
    
    
    self.df.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    cell.createdOn.text=[self.df stringFromDate:self.topic.createdOn];
    
    [cell.avatarView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/Uploads/UserAvatar/%@",PROPUCTION_API_DOMAIN,self.topic.avatar]] placeholderImage:[UIImage imageNamed:@"nobody.jpg"]];
    [cell.banner setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.funmovie.tv/Content/pictures/banners/%@?width=320",self.topic.banner]]];
    
    cell.delegate=self;
    
}

- (void)configureReplyMoreCell:(ReplyMoreCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    if (self.reply) {
        cell.nickName.text=self.reply.nickName;
        cell.message.text=self.reply.message;
        [cell.moreButton setTitle:NSLocalizedStringFromTable(@"更多回應",@"InfoPlist",nil) forState:UIControlStateNormal];
        [cell.avatarView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/Uploads/UserAvatar/%@",PROPUCTION_API_DOMAIN,self.reply.avatar]]];
    }
}
- (void)configureMovieListCell:(MovieListCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    VideoObj *video;
    
    if ([self.channel isEqualToString:@"InTopic"] || [self.channel isEqualToString:@"Activity"]) {
        if (self.replySum>0) {
            video=self.videoArray[indexPath.row-2];
        }else{
            video=self.videoArray[indexPath.row-1];
        }
        
    }else{
        video=self.videoArray[indexPath.row];
    }
    
    cell.video=video;
    
    
    cell.delegate=self;
    

    
    if ([self.lang isEqualToString:@"zh-Hant"]) {
        cell.name.text=video.name;
    }else{
        cell.name.text=video.cnName;
    }
    
    //cell.name.text=video.name;
    
    cell.enName.text=video.enName;
    
    [cell updateVideoInfo];
    
    if (![self.manager isLogined]) {
        cell.likeButton.backgroundColor=[UIColor lightGrayColor];
        cell.seenButton.backgroundColor=[UIColor lightGrayColor];
        cell.watchButton.backgroundColor=[UIColor lightGrayColor];
       // cell.gradeButton.backgroundColor=[UIColor lightGrayColor];
       // cell.reviewButton.backgroundColor=[UIColor lightGrayColor];
       // cell.addTopicButton.backgroundColor=[UIColor lightGrayColor];
    }else{
        
        NSComparisonResult result=[[NSDate date] compare:[self stringToDate:video.releaseDate]];
        
        
        if (result==NSOrderedAscending) {
            cell.seenButton.backgroundColor=[UIColor lightGrayColor];
//            cell.gradeButton.backgroundColor=[UIColor lightGrayColor];
//            cell.reviewButton.backgroundColor=[UIColor lightGrayColor];
        }else{
            if (video.isViewed.boolValue) {
                
                cell.seenButton.backgroundColor=[UIColor colorWithRed:51.0/255.0 green:153.0/255.0 blue:204.0/255.0 alpha:1.0];
                cell.seenButton.selected=YES;
                
            }else{
                cell.seenButton.backgroundColor=[UIColor grayColor];
                cell.seenButton.selected=NO;
            }
        }
        
        if (video.isLiked.boolValue) {
            cell.likeButton.backgroundColor=[UIColor colorWithRed:255.0/255.0 green:51.0/255.0 blue:51.0/255.0 alpha:1.0];
            cell.likeButton.selected=YES;
            
        }else{
            cell.likeButton.backgroundColor=[UIColor grayColor];
            cell.likeButton.selected=NO;
        }

        
        if (video.isWantView.boolValue) {
            cell.watchButton.backgroundColor=[UIColor colorWithRed:254.0/255.0 green:195.0/255.0 blue:77.0/255.0 alpha:1.0];
            cell.watchButton.selected=YES;

        }else{
            cell.watchButton.backgroundColor=[UIColor grayColor];
            cell.watchButton.selected=NO;
        }

        
    }

    NSString *path=[NSString stringWithFormat:@"http://www.funmovie.tv/Content/pictures/files/%@?width=156",video.picture];
    
    [cell.videoImageView setImageWithURL:[NSURL URLWithString:path] placeholderImage:[UIImage imageNamed:@"noMoviePoster.jpg"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
    }];

}
#pragma mark - TopicDetailCellDelegate
- (void)shareButtonPressed:(UIImage *)image{

    NSString *path=[NSString stringWithFormat:@"%@/Topic/TopicPage/%@",PROPUCTION_API_DOMAIN,self.topic.topicID.stringValue];
    
    
    
    
    SIAlertView *alertView = [[SIAlertView alloc] initWithTitle:self.topic.title andMessage:nil];
    [alertView addButtonWithTitle:@"        Facebook"
                             type:SIAlertViewButtonTypeDefault
                          handler:^(SIAlertView *alertView) {
                              
                              NSString *name = @"MovieCaker";
                              NSString *description =self.topic.content;
                              NSString *title=self.topic.title;
                              NSString *fbPicture =[NSString stringWithFormat:@"http://www.funmovie.tv/Content/pictures/banners/%@?width=320",self.topic.banner];
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
                              message.title = self.topic.title;
                              message.description = self.topic.content;

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
                              
                              NSString *shareTxt=[NSString stringWithFormat:@"[%@]%@",self.topic.title,self.topic.content];
                              if (shareTxt.length>140) {
                                  shareTxt=[NSString stringWithFormat:@"%@...",[shareTxt substringToIndex:137]];
                              }
                              message.text =shareTxt;
                              
                              WBImageObject *shareImage = [WBImageObject object];
                              
                              UIImage *imageOK=[self image:image cropInSize:CGSizeMake(100, 100)];
                              shareImage.imageData = UIImageJPEGRepresentation(imageOK,1);
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


-(void)goToMovieDetail:(NSString *)videoID{
    [self.manager getVideoWithVideoID:videoID callback:^(VideoObj *video, NSMutableArray *actorArray, NSString *errorMsg, NSError *error) {
        
        if(video==nil){
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                            message:@"不存在的專題"
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];

        }else{
        
        VideoContentViewController *vcvc=[[VideoContentViewController alloc] initWithNibName:@"VideoContentViewController" bundle:nil];
        
        vcvc.video=video;
        vcvc.gotoMovieReview = YES;
        [self.navigationController pushViewController:vcvc animated:YES];
        [vcvc gotoMovieReview];
        }
    }];
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
