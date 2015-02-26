//
//  MyContentView.h
//  MovieCaker
//
//  Created by iKevin on 2013/12/15.
//  Copyright (c) 2013年 iKevin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageView+WebCache.h"
#import "VideoObj.h"

@protocol MyContentViewDelegate <NSObject>
@optional
    - (void)videoFacePressed:(VideoObj *)video;
@end

@interface MyContentView : UIView
    @property (nonatomic, strong) SDWebImageManager *imageManager;
    @property (nonatomic,strong) UIImageView *imageView;
    @property (nonatomic,strong) UIView *rectView;
    @property (nonatomic,strong) UILabel *videoName;
    @property (nonatomic,weak) id<MyContentViewDelegate> delegate;
    @property (nonatomic,strong) VideoObj *video;
    -(void)setVideoFaceImage:(VideoObj *)video;
@end
