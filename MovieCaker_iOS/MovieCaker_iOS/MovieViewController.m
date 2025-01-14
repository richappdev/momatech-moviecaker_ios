//
//  SecondViewController.m
//  MovieCaker_iOS
//
//  Created by Albert Hsu on 3/31/16.
//  Copyright © 2016 Albert Hsu. All rights reserved.
//

#import "MovieViewController.h"
#import "AustinApi.h"
#import "MovieTwoTableViewController.h"
#import "MovieDetailController.h"
#import "reviewController.h"
#import "buttonHelper.h"
#import "MBProgressHUD.h"

@interface MovieViewController ()
@property (strong, nonatomic) IBOutlet UILabel *firstLabel;
@property (strong, nonatomic) IBOutlet UIView *lowerBar;
@property (strong, nonatomic) IBOutlet UILabel *secondLabel;
@property (strong, nonatomic) IBOutlet UILabel *thirdLabel;
@property (strong, nonatomic) IBOutlet UILabel *fourthLabel;
@property (strong, nonatomic) IBOutlet UIView *firstFilter;
@property (strong, nonatomic) IBOutlet UIView *secondFilter;
@property (strong, nonatomic) IBOutlet UIView *thirdFilter;
@property (strong, nonatomic) IBOutlet UIView *locationBtn;
@property (strong, nonatomic) IBOutlet UIView *locationFilter;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *locationConstrant;
@property UIView *currentFilter;
@property int filterIndex;
@property NSArray *labelArray;
@property NSArray *locationArray;
@property NSArray *locationBackend;
@property int locationIndex;
@property int index;
@property (strong, nonatomic) IBOutlet UILabel *locationLabel;
@property (strong, nonatomic) IBOutlet UITableView *movieTable;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *topMargin;
@property MovieTwoTableViewController *movieTableController;
@property (strong, nonatomic) IBOutlet UILabel *oneOneL;
@property (strong, nonatomic) IBOutlet UILabel *oneTwoL;
@property (strong, nonatomic) IBOutlet UILabel *oneThreeL;
@property (strong, nonatomic) IBOutlet UILabel *twoOneL;
@property (strong, nonatomic) IBOutlet UILabel *twoTwoL;
@property (strong, nonatomic) IBOutlet UILabel *twoThreeL;
@property (strong, nonatomic) IBOutlet UILabel *threeOneL;
@property (strong, nonatomic) IBOutlet UILabel *threeTwoL;
@property (strong, nonatomic) IBOutlet UILabel *threeThreeL;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *layerFilterHeight;

@property NSArray *tabOneData;
@property NSArray *tabTwoData;
@property NSArray *tabThreeData;
@property NSArray *tabFourData;

@property UILabel* fOneIndex;
@property UILabel* fTwoIndex;
@property UILabel* fFourIndex;

@property BOOL loaded;
@property BOOL locked;
@end

@implementation MovieViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UISwipeGestureRecognizer * swipeleft=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeLeft:)];
    swipeleft.direction=UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:swipeleft];
    
    UISwipeGestureRecognizer * swiperight=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeRight:)];
    swiperight.direction=UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:swiperight];
    self.labelArray = [[NSArray alloc]initWithObjects:self.firstLabel,self.secondLabel,self.thirdLabel,self.fourthLabel, nil];
    
    for (UILabel *label in self.labelArray) {
        label.userInteractionEnabled = YES;
        UITapGestureRecognizer *singleFingerTap =
        [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
        [label addGestureRecognizer:singleFingerTap];
    }
    self.index = 0;
    self.filterIndex = 0;
    self.currentFilter = self.firstFilter;
    
    self.locationBtn.clipsToBounds = YES;
    CALayer *rightBorder = [CALayer layer];
    rightBorder.borderColor = [UIColor colorWithRed:(221.0f/255.0f) green:(221.0f/255.0f) blue:(221.0f/255.0f) alpha:1].CGColor;
    rightBorder.borderWidth = 1;
    rightBorder.frame = CGRectMake(-1, -1, CGRectGetWidth(self.locationBtn.frame), CGRectGetHeight(self.locationBtn.frame)+2);
    
    [self.locationBtn.layer addSublayer:rightBorder];

    CALayer *top = [CALayer layer];
    top.borderColor = [UIColor colorWithRed:(221.0f/255.0f) green:(221.0f/255.0f) blue:(221.0f/255.0f) alpha:1].CGColor;
    top.borderWidth = 1;
    top.frame = CGRectMake(0,0, CGRectGetWidth(self.view.frame), 1.0f);
    
    
    self.locationFilter.clipsToBounds = YES;
    [self.locationFilter.layer addSublayer:top];
    
    UITapGestureRecognizer *showLocation =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showLocation:)];
    
    [self.locationBtn addGestureRecognizer:showLocation];

    self.locationIndex = 0;
    [self createLocationIcons];
    
    self.movieTableController = [[MovieTwoTableViewController alloc] init];
    self.movieTableController.tableView = self.movieTable;
    self.movieTable.delegate =self.movieTableController;
    [self.movieTableController ParentController:self];
    self.movieTableController.hideRating = YES;
    
    self.view.backgroundColor = [UIColor blackColor];
    UITapGestureRecognizer *cancel = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancelLocation)];
    [cancel setCancelsTouchesInView:NO];
    [self.movieTable addGestureRecognizer:cancel];
    
    [self setupFilterBtns];
}
-(void)addLabelTap:(UILabel*)label{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(filterClick:)];
    [label setUserInteractionEnabled:YES];
    [label addGestureRecognizer:tap];

}
-(void)setupFilterBtns{
    self.fOneIndex = self.oneOneL;
    self.fTwoIndex = self.twoOneL;
    self.fFourIndex = self.threeOneL;
    
    
    [self addLabelTap:self.oneOneL];
    [self addLabelTap:self.oneTwoL];
    [self addLabelTap:self.oneThreeL];
    
    [self addLabelTap:self.twoOneL];
    [self addLabelTap:self.twoTwoL];
    [self addLabelTap:self.twoThreeL];
    
    [self addLabelTap:self.threeOneL];
    [self addLabelTap:self.threeTwoL];
    [self addLabelTap:self.threeThreeL];

}
-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = YES;
    if(self.loaded) {
        [self doJump];}
    [self.movieTable reloadData];
    [self.movieTable setContentOffset:CGPointZero animated:YES];
}
-(void)refresh{
    self.view = nil;
    self.tabOneData = nil;
    self.tabTwoData = nil;
    self.tabThreeData = nil;
    self.tabFourData = nil;
}
-(void)doJump{
    if(self.jump==1){
        // 熱映 Movie-New
        self.index =0;
        [self moveBar:self.firstLabel];
        [self setFilter];
    }
    if(self.jump==2){
        // 熱門 Movie-Hot
        self.index =1;
        [self moveBar:self.secondLabel];
        [self setFilter];
    }
    if(self.jump==3){
        // 影評
        self.index = 3;
        [self moveBar:self.fourthLabel];
        [self setFilter];
    }
    self.jump =0;
}

// 點選第二層Tab, 也就是 Filter 所觸發
-(void)filterClick:(UIGestureRecognizer*)gesture{
    UILabel *previous;
    UILabel *current = (UILabel*)gesture.view;

    [self.movieTable setContentOffset:CGPointZero animated:YES];
    
    // View-First Filter 熱映
    if(self.currentFilter.tag==0){
        previous = self.fOneIndex;
        if(previous!=current){
            if(current.tag==0){         //本月
                self.movieTableController.hideRating = YES;
                [self getMovieList:@"6" location:[[self.locationBackend objectAtIndex:self.locationIndex]objectForKey:@"Id"] type:0 page:nil];
            }else if (current.tag==1){  //下月
                self.movieTableController.hideRating = YES;
                [self getMovieList:@"6" location:[[self.locationBackend objectAtIndex:self.locationIndex]objectForKey:@"Id"] type:1 page:nil];
            }else if (current.tag==2){  //週票房
                self.movieTableController.hideRating = NO;
                [self getMovieList:@"released" location:[[self.locationBackend objectAtIndex:self.locationIndex]objectForKey:@"Id"] type:2 page:nil];
            }
            
            self.fOneIndex = current;
        }
    }

    // View-Second Filter 熱門
    if (self.currentFilter.tag==1){
        previous = self.fTwoIndex;
        if(previous!=current){
            if(current.tag==0){
                [self getMovieList:@"month" location:nil type:3 page:nil];
            }else if (current.tag==1){
                [self getMovieList:@"week" location:nil type:3 page:nil];
            }else if (current.tag==2){
                [self getMovieList:@"year" location:nil type:3 page:nil];
            }
        }
        self.fTwoIndex = current;
    }
    
    // View-Third Filter 影評
    if (self.currentFilter.tag==2){
        previous = self.fFourIndex;
        if(previous!=current){
            if(current.tag==0){             // tag 0:最新影評 api/revire: ReviewReturnType=CreateOn
                [self loadReviews:nil reviewSort:API_REVIEW_ORDER_CREATEON];
            }else if(current.tag == 1){     // tag 1:本月(熱門)影評 api/revire: ReviewReturnType=Hot1M
                [self loadReviews:nil reviewSort:API_REVIEW_ORDER_LIKENUM];   ///////////等API新增並且更新到正式機之後，要改成 Hot1M
            }else if(current.tag == 2){     // tag 2:本週(熱門)影評 api/revire: ReviewReturnType=Hot1W
                [self loadReviews:nil reviewSort:API_REVIEW_ORDER_HOT1W];
            }

            self.movieTableController.page = (int)([self.movieTableController.data count]-1)/10+1;
            NSLog(@"ppp:%d",self.movieTableController.page);
            [self.movieTableController.tableView reloadData];
        }
        self.fFourIndex = current;
    }
    
    previous.textColor = [UIColor blackColor];
    current.textColor = [UIColor colorWithRed:(244.0f/255.0f) green:(154.0f/255.0f) blue:(68.0/255.0f) alpha:1];

}
-(BOOL)within7Days:(NSDate*)someDate{

    NSDate *currentDate = [NSDate date];
    NSDate *dateSevenDaysPrior = [currentDate dateByAddingTimeInterval:-(7 * 24 * 60 * 60)];

    if (([dateSevenDaysPrior compare:someDate] != NSOrderedDescending) &&
        ([someDate compare:currentDate] != NSOrderedDescending))
    {
        return YES;
    }
    else
    {
        return NO;
    }
}
-(void)createLocationIcons{
    
    
    [[AustinApi sharedInstance] locationList:^(NSArray *returnData) {
        self.locationBackend = returnData;
        NSMutableArray *tempArray = [[NSMutableArray alloc]init];
        int count = 0;
        for (NSDictionary *row in returnData) {
            if(count==0){
                self.locationLabel.text = [row objectForKey:@"Name"];
                [self getMovieList:@"6" location:[row objectForKey:@"Id"] type:0 page:nil];
            }
            UIView *view;
            if(self.view.frame.size.width>=375){
                view = [[UIView alloc]initWithFrame:CGRectMake(18+count*72, 30, 62, 28)];
                self.layerFilterHeight.constant = 70;
            }else{
                self.layerFilterHeight.constant = 90;
                if(count<4){
                view = [[UIView alloc]initWithFrame:CGRectMake(18+count*72, 25, 62, 28)];
                }else{
                view = [[UIView alloc]initWithFrame:CGRectMake(18, 57, 62, 28)];
                }
            }
            view.tag = count;
            view.layer.borderWidth = 1.0f;
            view.layer.borderColor = [UIColor colorWithRed:(244.0f/255.0f) green:(154.0f/255.0f) blue:(68.0f/255.0f) alpha:1].CGColor;
            view.layer.cornerRadius = 4;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(locationBtnClick:)];
            [view addGestureRecognizer:tap];
            
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 62, 28)];
            label.font = [UIFont fontWithName:@"Heiti SC" size:15.0f];
            label.textColor = [UIColor colorWithRed:(244.0f/255.0f) green:(154.0f/255.0f) blue:(68.0f/255.0f) alpha:1];
            label.text = [row objectForKey:@"Name"];
            label.textAlignment = NSTextAlignmentCenter;
            [view addSubview:label];
            [self.locationFilter addSubview:view];
            count++;
            NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:view,@"view",label,@"label", nil];
            [tempArray addObject:dict];
        }
        self.locationArray = tempArray;
        [self setLocationBtnColor:0];
        self.loaded=YES;
    } error:^(NSError *error) {
        NSLog(@"%@",error);
    }];


}

-(void)getMovieList:(NSString*)type location:(NSString*)locationId type:(int)callType page:(NSString*)page {
    if(self.locked!=YES){
        self.locked = YES;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy"];
    NSString *yearString = [formatter stringFromDate:[NSDate date]];
    [formatter setDateFormat:@"MM"];
    NSString *monthString = [formatter stringFromDate:[NSDate date]];
    if(callType==1){
        int temp =[monthString intValue]+1;
        if(temp>12){
            temp=1;
        }
        monthString = [NSString stringWithFormat:@"%d",temp];
    }
    if(callType==2||callType==3){
        monthString =nil;
        yearString = nil;
    }
    
        [[AustinApi sharedInstance] movieListCustom:type myType:nil location:locationId year:yearString month:monthString page:page topicId:nil uid:nil function:^(NSArray *returnData) {
        //this jump is need for first time load, because viewwillappear jump isnt triggered
        [self doJump];
        NSMutableArray *array = [[NSMutableArray alloc]init];
        for (NSDictionary *row in returnData) {
            [array addObject:[[NSMutableDictionary alloc] initWithDictionary:row]];
        }
        if(page==nil){
        if(callType==3){
        self.tabTwoData = array;
        }
        else{
        self.tabOneData = array;
        }
        self.movieTableController.page = 1;
        
            self.movieTableController.data = array;}
        else{
            NSArray *new = [self.movieTableController.data arrayByAddingObjectsFromArray:array];
            self.movieTableController.data = new;
        }
        [self.movieTable reloadData];
        self.locked = NO;
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    } error:^(NSError *error) {
        self.locked = NO;
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSLog(@"%@",error);
    }];
    }
}
-(void)loadMore:(int)page{
    NSString *pageString = [NSString stringWithFormat:@"%d",page];
    if(self.filterIndex==0){
        if(self.fOneIndex.tag!=2){
            [self getMovieList:@"6" location:[[self.locationBackend objectAtIndex:self.locationIndex]objectForKey:@"Id"] type:(int)self.fOneIndex.tag page:pageString];}
        else{
            [self getMovieList:@"released" location:[[self.locationBackend objectAtIndex:self.locationIndex]objectForKey:@"Id"] type:2 page:pageString];
        }
    }else if (self.filterIndex==1){
        if(self.fTwoIndex.tag==0){
            [self getMovieList:@"month" location:nil type:3 page:pageString];
        }else if (self.fTwoIndex.tag==1){
            [self getMovieList:@"week" location:nil type:3 page:pageString];
        }else if (self.fTwoIndex.tag==2){
            [self getMovieList:@"year" location:nil type:3 page:pageString];
        }
    }else if (self.filterIndex==2){
        [self loadFriends:pageString];
    }else if(self.filterIndex==3){
        if (self.fFourIndex.tag==0)         //最新
            [self loadReviews:pageString reviewSort:API_REVIEW_ORDER_CREATEON];
        else if (self.fFourIndex.tag==1)    //本月熱門
            [self loadReviews:pageString reviewSort:API_REVIEW_ORDER_LIKENUM];
        else if (self.fFourIndex.tag==2)    //本週熱門
            [self loadReviews:pageString reviewSort:API_REVIEW_ORDER_HOT1W];
    }
}
-(void)setLocationBtnColor:(int)index{
    NSDictionary *temp = [self.locationArray objectAtIndex:self.locationIndex];
    UIView *view = [temp objectForKey:@"view"];
    UILabel *label = [temp objectForKey:@"label"];
    view.backgroundColor =[UIColor whiteColor];
    label.textColor = [UIColor colorWithRed:(244.0f/255.0f) green:(154.0f/255.0f) blue:(68.0f/255.0f) alpha:1];
    
    temp = [self.locationArray objectAtIndex:index];
    view = [temp objectForKey:@"view"];
    label = [temp objectForKey:@"label"];
    view.backgroundColor =[UIColor colorWithRed:(244.0f/255.0f) green:(154.0f/255.0f) blue:(68.0f/255.0f) alpha:1];
    label.textColor = [UIColor whiteColor];
    self.locationIndex = index;
}
-(void)locationBtnClick:(UITapGestureRecognizer*)gestureRecongnizer{
    [self setLocationBtnColor:(int)gestureRecongnizer.view.tag];
    if(self.fOneIndex.tag!=2){
        [self getMovieList:@"6" location:[[self.locationBackend objectAtIndex:(int)gestureRecongnizer.view.tag] objectForKey:@"Id"] type:(int)self.fOneIndex.tag page:nil];}
    else{
        [self getMovieList:@"released" location:[[self.locationBackend objectAtIndex:(int)gestureRecongnizer.view.tag] objectForKey:@"Id"] type:2 page:nil];
    }
    [self confirmLocation:gestureRecongnizer];
    double delayInSeconds = 0.2;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        self.movieTable.delegate =self.movieTableController;
    });
}
-(void)confirmLocation:(UITapGestureRecognizer*)gestureRecongnizer{
    [self.view layoutIfNeeded];
    
    self.locationConstrant.constant = -150;
    [UIView animateWithDuration:0.2
                     animations:^{
                         [self.view layoutIfNeeded]; // Called on parent view
                     }];
    NSDictionary *temp = [self.locationArray objectAtIndex:self.locationIndex];
    UILabel *label = [temp objectForKey:@"label"];
    self.locationLabel.text = label.text;
    self.locationLabel.tag = self.locationIndex;
    self.movieTable.alpha = 1;
}
-(void)cancelLocation{
    [self setLocationBtnColor:(int)self.locationLabel.tag];
    [self confirmLocation:nil];
    double delayInSeconds = 0.5;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        self.movieTable.delegate =self.movieTableController;
    });
}

-(void)showLocation:(UISwipeGestureRecognizer*)gestureRecongnizer{
    self.movieTable.delegate =nil;
    self.movieTable.alpha = 0.5;
    [self.view layoutIfNeeded];
    
    self.locationConstrant.constant = 0;
    [UIView animateWithDuration:0.2
                     animations:^{
                         [self.view layoutIfNeeded]; // Called on parent view
                     }];
    
}

-(void)handleSingleTap:(UIGestureRecognizer*)gestureRecongnizer{
    self.index = (int)gestureRecongnizer.view.tag;
    [self moveBar:[self.labelArray objectAtIndex:gestureRecongnizer.view.tag]];
    [self setFilter];
}

-(void)swipeLeft:(UISwipeGestureRecognizer*)gestureRecongnizer{
    if(self.index>0){
        self.index--;
        [self moveBar:[self.labelArray objectAtIndex:self.index]];
    }
    [self setFilter];
}
-(void)swipeRight:(UISwipeGestureRecognizer*)gestureRecongnizer{
    if(self.index<[self.labelArray count]-1){
        self.index++;
        [self moveBar:[self.labelArray objectAtIndex:self.index]];
    }
    [self setFilter];
}
-(void)loadFriends:(NSString*)page{
    self.locked = YES;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[AustinApi sharedInstance]movieListCustom:@"1" myType:nil location:nil year:nil month:nil page:nil topicId:nil uid:nil function:^(NSArray *returnData) {
        if(page==nil){
            self.movieTableController.page = 1;
            self.tabThreeData =returnData;
            self.movieTableController.data = returnData;
        }else{
            NSArray *new = [self.movieTableController.data arrayByAddingObjectsFromArray:returnData];
            self.movieTableController.data = new;
        }
        [self.movieTableController.tableView reloadData];
        self.locked = NO;
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    } error:^(NSError *error) {
        self.locked = NO;
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSLog(@"%@",error);
    }];
}

// 點選第一層 Tab(filterIndex) 所觸發
-(void)setFilter{
    [self cancelLocation];
    [self.movieTable setContentOffset:CGPointZero animated:YES];
    
    if(self.index!=self.filterIndex){
        self.filterIndex = self.index;
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.2];
        
        self.currentFilter.alpha = 0;
        self.topMargin.constant = 0;
        BOOL change = false;
        
        self.movieTableController.type = self.filterIndex;

        // 熱映
        if(self.filterIndex ==0){
            if(self.tabOneData!=nil){
                self.movieTableController.data = self.tabOneData;
                self.movieTableController.page = 1;
                [self.movieTableController.tableView reloadData];
            }
            self.currentFilter = self.firstFilter;  // First Filter:本月/下月/週票房
            change = true;
        }

        // 熱門
        if(self.filterIndex==1){            
            if(self.tabTwoData!=nil){
                self.movieTableController.data= self.tabTwoData;
                self.movieTableController.page = 1;
                [self.movieTable reloadData];
            }else{
                [self getMovieList:@"month" location:nil type:3 page:nil];
            }
            self.currentFilter = self.secondFilter; // Second Filter:一月熱門/一週熱門/年度熱門
            change = true;
        }

        // 朋友在看
        if(self.filterIndex==2){
            if(self.tabThreeData!=nil){
                self.movieTableController.data =self.tabThreeData;
                self.movieTableController.page = 1;
                [self.movieTableController.tableView reloadData];
            }else{
                [self loadFriends:nil];
            }
            self.topMargin.constant = -36;
        }

        // 影評
        if(self.filterIndex==3){
            if(self.tabFourData!=nil){
                self.movieTableController.data =self.tabFourData;
                self.movieTableController.page = (int)([self.tabFourData count]-1)/10+1;
                [self.movieTableController.tableView reloadData];
            }else{
                [self loadReviews:nil reviewSort:@"CreateOn"];
            }
            self.currentFilter = self.thirdFilter;  // Third Filter:最新影評/本月(熱門)熱門/本週(熱門)熱門
            change = true;
        }

        if(change){
            self.currentFilter.alpha = 1;
        }

        [UIView commitAnimations];
    }
}
-(void)loadReviews:(NSString*)page reviewSort:(NSString*)sort{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.locked = YES;
    NSLog(@"loadReviews: page=%@, sort=%@", page, sort);
    [[AustinApi sharedInstance]getReview:API_REVIEW_ORDER_CREATEON page:page uid:nil function:^(NSArray *returnData) {
        if(page==nil){
            self.movieTableController.page=1;
            self.tabFourData =returnData;
            self.movieTableController.data = returnData;
        }else{
            NSArray *new = [self.movieTableController.data arrayByAddingObjectsFromArray:returnData];
            self.movieTableController.data = new;
            self.tabFourData = new;
        }
        [self.movieTableController.tableView reloadData];
        self.locked = NO;
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    } error:^(NSError *error) {
        self.locked = NO;
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSLog(@"%@",error);
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)moveBar:(UILabel*)label{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.2];
    
    self.lowerBar.frame = CGRectMake(label.frame.origin.x, label.frame.origin.y+30, label.frame.size.width, 4);
    
    [UIView commitAnimations];

}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([[segue identifier] isEqualToString:@"movieDetail"]){
    MovieDetailController *vc = segue.destinationViewController;
        vc.movieDetailInfo = [self.movieTableController.data objectAtIndex:self.movieTableController.selectIndex];
    }
    else if([[segue identifier] isEqualToString:@"reviewSegue"]){
        reviewController *vc = segue.destinationViewController;
        if(self.newReview){
            self.newReview=NO;
            vc.newReview = YES;
            NSDictionary *vData = [self.movieTableController.data objectAtIndex:self.movieTableController.selectIndex];
            NSDictionary *User = [[NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"userkey"]]objectForKey:@"Data"];
            vc.data = [buttonHelper reviewNewData:vData User:User];
        }else{
         vc.data = [[NSMutableDictionary alloc]initWithDictionary:[self.movieTableController.data objectAtIndex:self.movieTableController.selectIndex]];
        }
        NSLog(@"%@",vc.data);
    }
}


@end
