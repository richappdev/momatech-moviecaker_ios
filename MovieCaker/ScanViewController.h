//
//  ScanViewController.h
//  MovieCaker
//
//  Created by iKevin on 2013/12/17.
//  Copyright (c) 2013年 iKevin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface ScanViewController : BaseViewController<ZBarReaderViewDelegate>
@property (strong, nonatomic) IBOutlet ZBarReaderView *myReaderView;

@end
