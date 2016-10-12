//
//  MainVerticalScroller.m
//  MovieCaker_iOS
//
//  Created by Albert Hsu on 4/25/16.
//  Copyright © 2016 Albert Hsu. All rights reserved.
//

#import "MainVerticalScroller.h"
#import "UIImage+FontAwesome.h"

@implementation MainVerticalScroller

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    //offset is -64 for some weird unknown reason
    float alpha;
    if(scrollView.contentOffset.y>=0){
        alpha = 1;
    }else{
    alpha = scrollView.contentOffset.y/64+1;
        
    }

    self.nav.navigationBar.backgroundColor = [UIColor colorWithRed:(128/255.0) green:(203/255.0) blue:(196/255.0) alpha:alpha];
    self.statusbar.backgroundColor = [UIColor colorWithRed:(77/255.0) green:(182/255.0) blue:(172/255.0) alpha:alpha];
    [self.nav.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor colorWithRed:(255/255.0) green:(255/255.0) blue:(255/255.0) alpha:alpha]}];
    
    /*if(scrollView.contentOffset.y>=363){
        self.movingButtons.frame = CGRectMake(self.movingButtons.frame.origin.x,19+scrollView.contentOffset.y - 363 , self.movingButtons.frame.size.width, self.movingButtons.frame.size.height);
    
    }else{
        self.movingButtons.frame = CGRectMake(self.movingButtons.frame.origin.x,12, self.movingButtons.frame.size.width, self.movingButtons.frame.size.height);
        
    }*/
}

-(void)setupBackBtn:(UIViewController*)view{
    
    UIBarButtonItem *barButtonItem =[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"iconPageBackNoheader.png"] style:UIBarButtonItemStylePlain target:self action:@selector(goBack)];
    barButtonItem.tintColor = [UIColor whiteColor];
    [view.navigationItem setLeftBarButtonItem:barButtonItem];
    
    [view.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                  forBarMetrics:UIBarMetricsDefault];
    view.navigationController.navigationBar.shadowImage = [UIImage new];
    view.navigationController.navigationBar.translucent = YES;
    view.navigationController.view.backgroundColor = [UIColor clearColor];
    view.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
}
-(void)setupBackBtn2:(UIViewController *)view{
    UIBarButtonItem *barButtonItem =[[UIBarButtonItem alloc]initWithImage:[UIImage imageWithIcon:@"fa-chevron-left" backgroundColor:[UIColor clearColor] iconColor:[UIColor colorWithRed:(172/255.0f) green:(189/255.0f) blue:(206/255.0f) alpha:1.0] andSize:CGSizeMake(10, 14)] style:UIBarButtonItemStylePlain target:self action:@selector(goBack)];
    barButtonItem.tintColor = [UIColor whiteColor];
    [view.navigationItem setLeftBarButtonItem:barButtonItem];
    
    [view.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                  forBarMetrics:UIBarMetricsDefault];
    view.navigationController.navigationBar.shadowImage = [UIImage new];
    view.navigationController.navigationBar.translucent = YES;
    view.navigationController.view.backgroundColor = [UIColor clearColor];
    view.navigationController.navigationBar.backgroundColor = [UIColor clearColor];

}
-(void)setupStatusbar:(UIView*)targetView{
    UIView *statusView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, targetView.frame.size.width, 20)];
    statusView.backgroundColor = [UIColor clearColor];
    [targetView addSubview:statusView];
    self.statusbar = statusView;
}

-(void)setupSinglePage:(UIView*)view{
    UIView *statusView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, view.frame.size.width, 20)];
    statusView.backgroundColor = [UIColor colorWithRed:(77/255.0) green:(182/255.0) blue:(172/255.0) alpha:1];
    [view addSubview:statusView];
    
    self.nav.navigationBar.backgroundColor = [UIColor colorWithRed:(128/255.0) green:(203/255.0) blue:(196/255.0) alpha:1];
    [self.nav.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor colorWithRed:(255/255.0) green:(255/255.0) blue:(255/255.0) alpha:1]}];

}
-(void)goBack{
    [self.nav popViewControllerAnimated:YES];
}
@end
