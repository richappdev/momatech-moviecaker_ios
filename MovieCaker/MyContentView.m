//
//  MyContentView.m
//  MovieCaker
//
//  Created by iKevin on 2013/12/15.
//  Copyright (c) 2013年 iKevin. All rights reserved.
//

#import "MyContentView.h"



@implementation MyContentView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.rectView=nil;
        self.imageView=nil;
        self.videoName.text=@"";
        if(self.imageManager == nil)
            self.imageManager = [SDWebImageManager sharedManager];
        
    }
    return self;
}


-(void)setVideoFaceImage:(VideoObj *)video{
    
    self.video=video;
    
    self.rectView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 92, 124)];
    self.rectView.backgroundColor=[UIColor lightGrayColor];
    [self addSubview:self.rectView];
    
    self.imageView=[[UIImageView alloc] initWithFrame:CGRectMake(1, 1, 90, 122)];
    [self addSubview:self.imageView];
    NSString *imagePath=[NSString stringWithFormat:@"http://www.funmovie.tv/Content/pictures/files/%@?width=156",video.picture];
    
    [self.imageView setImageWithURL:[NSURL URLWithString:imagePath] placeholderImage:[UIImage imageNamed:@"noMoviePoster.jpg"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
    }];
    /*
    [self.imageManager downloadWithURL:[NSURL URLWithString:imagePath]
                               options:0
                              progress:^(NSUInteger receivedSize, long long expectedSize) {
                                  
                                  //progress.progress = (float)receivedSize / (float)expectedSize;
                                  
                              }
                             completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished) {
                                 
                                 [self.imageView setImage:image];
                                 
                             }];
     */
    
    self.videoName=[[UILabel alloc] initWithFrame:CGRectMake(1, 125, 92, 16)];
    [self.videoName setFont:[UIFont systemFontOfSize:11]];
    NSArray *languages = [NSLocale preferredLanguages];
    NSString *lang = [languages objectAtIndex:0];
    if ([lang isEqualToString:@"zh-Hant"]) {
        self.videoName.text=video.name;
    }else{
        self.videoName.text=video.cnName;
    }
    [self addSubview:self.videoName];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:CGRectMake(0, 0, 92, 124)];
    [button addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
     [self addSubview:button];
}

-(void) click:(id)sender{
    if([self.delegate respondsToSelector:@selector(videoFacePressed:)]){
        [self.delegate videoFacePressed:self.video];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
