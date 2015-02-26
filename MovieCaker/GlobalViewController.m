//
//  GlobalViewController.m
//  MovieCaker
//
//  Created by iKevin on 2013/11/19.
//  Copyright (c) 2013年 iKevin. All rights reserved.
//

#import "GlobalViewController.h"
#import "VideoContentViewController.h"
#import "UIImageView+WebCache.h"
#import "VideoObj.h"

@interface GlobalViewController ()
    //@property (nonatomic, strong) NSMutableArray *videoArray;
    @property (nonatomic, strong) NSMutableArray *videoArray;
    @property (nonatomic, strong) NSMutableArray *titleArray;
    @property (nonatomic, strong) NSMutableArray *sectionArray;
    @property(assign,nonatomic) BOOL isLoading;
    @property(assign,nonatomic) BOOL isLast;
    @property (nonatomic, strong) NSArray *btns;
    @property (nonatomic,strong)  NSNumber *page;

    @property (nonatomic,strong) NSMutableArray *years;
    @property (nonatomic,strong) NSMutableArray *months;
    @property (nonatomic,strong) NSNumber *y;
    @property (nonatomic,strong) NSNumber *m;

    //- (TopicDetailViewController *)viewControllerAtIndex:(NSUInteger)index atYear:(NSUInteger)year atMonth:(NSUInteger)month;
@end

@implementation GlobalViewController

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
    self.title=@"全球新片";
    [self.myTableView registerNib:[UINib nibWithNibName:@"MovieListCell" bundle:nil] forCellReuseIdentifier:@"MovieListCell"];
    
    self.titleArray=[[NSMutableArray alloc] init];
    self.videoArray=[[NSMutableArray alloc] init];
    self.sectionArray=[[NSMutableArray alloc] init];
    
    self.years=[[NSMutableArray alloc] init];
    self.months=[[NSMutableArray alloc] init];
    
    self.page=@(1);
    
    self.topButton.hidden=YES;
    
    NSDate *dt=[NSDate date];
    NSInteger theYear=[self yearAtDate:dt];
    NSInteger theMonth=[self monthAtDate:dt];
    [self monthAtDot:theMonth];
    
    NSLog(@"%d %d",theYear,theMonth);
    
    NSInteger tm=theMonth-2;
    NSInteger ty=theYear;
    if (tm<=0) {
        tm=12;
        ty=ty-1;
    }
    
    
    for (int i=0; i<5; i++) {
        int _tm=tm+i;
        int _ty=ty;
        if (_tm>12) {
            _tm=_tm%12;
            _ty=_ty+1;
        }
        
        
//        tm=tm+i;
//        if (tm>12) {
//            tm=1;
//            ty=ty+1;
//        }
//        if (tm>i) {
//            tm=tm-i+1;
//            if (tm>=13) {
//                tm=tm-1;
//            }
//        }
        NSLog(@"%d %d",_tm,_ty);
        
        
        [self.years addObject:[NSNumber numberWithInt:_ty]];
        [self.months addObject:[NSNumber numberWithInt:_tm]];
    }
    
    
    
    [self b3Pressed:nil];
    
    
    //[self loadData:@(ty) withMonth:@(tm)];
    
    

    /*
    self.pageController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    
    self.pageController.dataSource = self;
    self.pageController.delegate = self;
    
    self.pageController.view.autoresizingMask = UIViewAutoresizingNone;
    self.pageController.view.frame = CGRectMake(0, 44, 320, 460);
   // [[self.pageController view] setFrame:[[self view] bounds]];
    
    
    

    
    TopicDetailViewController *initialViewController = [self viewControllerAtIndex:2 atYear:theYear atMonth:theMonth];
    
    NSArray *viewControllers = [NSArray arrayWithObject:initialViewController];
    
    [self.pageController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    [self addChildViewController:self.pageController];
    [[self view] addSubview:[self.pageController view]];
    [self.pageController didMoveToParentViewController:self];
     */
}

-(void)loadData:(NSNumber *)year withMonth:(NSNumber *)month{
    
    NSString *str=[NSString stringWithFormat:@"%d年%d月全球新片",year.intValue,month.intValue];
    [self.titleArray addObject:str];
    [WaitingAlert presentWithText:[NSString stringWithFormat:@"%@%@",NSLocalizedStringFromTable(@"正在載入",@"InfoPlist",nil),str] withTimeOut:60];
    
    [self.manager getVideoWithTopicID:nil channel:@"Global" withUID:nil withYear:year withMonth:month withPage:self.page withMyType:nil withActorID:nil callback:^(NSArray *videoArray, NSString *errorMsg, NSError *error) {
        
        //[self.videoArray addObjectsFromArray:videoArray];
        self.myTableView.tableFooterView=nil;
        [self.videoArray removeAllObjects];
        [self.videoArray addObjectsFromArray:videoArray];
        [self.sectionArray addObject:@(self.videoArray.count)];
        [self.myTableView reloadData];
        [WaitingAlert dismiss];
//        
//        if (self.titleArray.count==5) {
//            [self.myTableView reloadData];
//            NSNumber *row=self.sectionArray[1];
//            NSIndexPath *indexPath=[NSIndexPath indexPathForRow:row.integerValue inSection:0];
//            [self.myTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
//            [self setButtonStatus:2];
//            [WaitingAlert dismiss];
//        }else{
//            [self.myTableView reloadData];
//            NSInteger tm=month.intValue+1;
//            NSInteger ty=year.intValue;
//            if (tm>12) {
//                tm=1;
//                ty=ty+1;
//            }
//            [self setButtonStatus:self.sectionArray.count-1];
//            [self loadData:@(ty) withMonth:@(tm)];
//        }
    }];

}

#pragma mark - UITableViewDataSource
/*
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return self.monthArray.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return self.titleArray[section];
}

 */
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section;{
    return self.headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 44;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //NSArray *ary=self.monthArray[section];
    return self.videoArray.count;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 220;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MovieListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MovieListCell"];
    [self configureMovieListCell:(MovieListCell *)cell atIndexPath:indexPath];
    return cell;

    
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    VideoObj *video=self.videoArray[indexPath.row];
    VideoContentViewController *vcvc=[[VideoContentViewController alloc] initWithNibName:@"VideoContentViewController" bundle:nil];
    vcvc.video=video;
    [self.navigationController pushViewController:vcvc animated:YES];

    
}

- (void)configureMovieListCell:(MovieListCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    VideoObj *video=self.videoArray[indexPath.row];
  
    
    cell.video=video;
    cell.delegate=self;
    
    if ([self.lang isEqualToString:@"zh-Hant"]) {
        cell.name.text=video.name;
    }else{
        cell.name.text=video.cnName;
    }
    
    cell.enName.text=video.enName;
    
    NSLog(@"");
    
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



-(void)monthAtDot:(NSInteger)month{
    [self.b3 setTitle:[NSString stringWithFormat:@"%02ld",(long)month] forState:UIControlStateNormal];
    
    NSInteger b2tilte=month-1;
    if (b2tilte<=0) {
        b2tilte=12+b2tilte;
    }
    
    NSInteger b1tilte=month-2;
    if (b1tilte<=0) {
        b1tilte=12+b1tilte;
    }
    
    NSInteger b4tilte=month+1;
    if (b4tilte>12) {
        b4tilte=b1tilte-12;
    }
    
    NSInteger b5tilte=month+2;
    if (b5tilte>12) {
        b5tilte=b5tilte-12;
    }
    [self.b2 setTitle:[NSString stringWithFormat:@"%02ld",(long)b2tilte] forState:UIControlStateNormal];
    [self.b1 setTitle:[NSString stringWithFormat:@"%02ld",(long)b1tilte] forState:UIControlStateNormal];
    [self.b4 setTitle:[NSString stringWithFormat:@"%02ld",(long)b4tilte] forState:UIControlStateNormal];
    [self.b5 setTitle:[NSString stringWithFormat:@"%02ld",(long)b5tilte] forState:UIControlStateNormal];
    self.btns=@[self.b1,self.b2,self.b3,self.b4,self.b5];

}

-(void)setButtonStatus:(NSInteger)sn{
    for (int i=0;i<self.btns.count; i++ ) {
        UIButton *btn=self.btns[i];
        if (sn==i) {
            btn.selected=NO;
        }else{
            btn.selected=YES;
        }
        
    }
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
//    NSArray *indexAry=[self.myTableView indexPathsForVisibleRows];
//    NSIndexPath *indexPath=indexAry[1];
//    [self setButtonStatus:[self getSectionNo:indexPath.row]];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate;{
    
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
        [self loadData:self.y withMonth:self.m];
        
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {

    float pointY=scrollView.contentOffset.y;
    if (pointY>150) {
        self.topButton.hidden=NO;
    }else{
        self.topButton.hidden=YES;
    }
        
    
//    NSArray *indexAry=[self.myTableView indexPathsForVisibleRows];
//    NSIndexPath *indexPath=indexAry[1];
//    [self setButtonStatus:[self getSectionNo:indexPath.row]];
}

-(NSInteger)getSectionNo:(NSInteger)row{
    for (int i=0; i<self.sectionArray.count; i++) {
        NSNumber *sectionNo=self.sectionArray[i];
        if (row <= sectionNo.integerValue-1) {
            return i;
        }
    }
    return 0;
}



#pragma mark - 取得日期的「年」數字
-(NSInteger)yearAtDate:(NSDate *)theDate{
    
    NSCalendar *initCalendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit;
    NSDateComponents *components = [initCalendar components:unitFlags fromDate:theDate];
    
    return [components year];
    
}

#pragma mark - 取得日期的「月」數字
-(NSInteger)monthAtDate:(NSDate *)theDate{
    
    NSCalendar *initCalendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit;
    NSDateComponents *components = [initCalendar components:unitFlags fromDate:theDate];
    
    return [components month];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)b1Pressed:(id)sender {
    [self setButtonStatus:0];
    self.y=self.years[0];
    self.m=self.months[0];
    
    [self loadData:self.y withMonth:self.m];
//    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:0 inSection:0];
//    [self.myTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
}

- (IBAction)b2Pressed:(id)sender {
    [self setButtonStatus:1];
    self.y=self.years[1];
    self.m=self.months[1];
    
    [self loadData:self.y withMonth:self.m];
//    self.row=self.sectionArray[0];
//    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:row.integerValue inSection:0];
//    [self.myTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];

}

- (IBAction)b3Pressed:(id)sender {
    [self setButtonStatus:2];
    self.y=self.years[2];
    self.m=self.months[2];
    
    [self loadData:self.y withMonth:self.m];
    
//    self.row=self.sectionArray[1];
//    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:row.integerValue inSection:0];
//    [self.myTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
    
    
}

- (IBAction)b4Pressed:(id)sender {
    [self setButtonStatus:3];
    
    self.y=self.years[3];
    self.m=self.months[3];
    
    [self loadData:self.y withMonth:self.m];
//    NSNumber *row=self.sectionArray[2];
//    NSNumber *row1=self.sectionArray[3];
//    if (row1.intValue>row.intValue) {
//        NSIndexPath *indexPath=[NSIndexPath indexPathForRow:row.integerValue inSection:0];
//        [self.myTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
//    }else{
//        [self alertShow:NSLocalizedStringFromTable(@"目前沒有資料！",@"InfoPlist",nil)];
//    }
}

- (IBAction)b5Pressed:(id)sender {
    [self setButtonStatus:4];
    
    self.y=self.years[4];
    self.m=self.months[4];
    
    [self loadData:self.y withMonth:self.m];
//    NSNumber *row=self.sectionArray[3];
//    NSNumber *row1=self.sectionArray[4];
//    if (row1.intValue>row.intValue) {
//        NSIndexPath *indexPath=[NSIndexPath indexPathForRow:row.integerValue inSection:0];
//        [self.myTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
//    }else{
//        [self alertShow:NSLocalizedStringFromTable(@"目前沒有資料！",@"InfoPlist",nil)];
//    }

    
}
- (IBAction)topButtonPressed:(id)sender {
    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:0 inSection:0];
    [self.myTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];

}



@end
