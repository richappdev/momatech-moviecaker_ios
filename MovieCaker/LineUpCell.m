//
//  LineUpCell.m
//  MovieCaker
//
//  Created by iKevin on 2013/11/23.
//  Copyright (c) 2013年 iKevin. All rights reserved.
//

#import "LineUpCell.h"
#import "Actor.h"

@interface LineUpCell()
    @property (strong, nonatomic) NSMutableArray *buttons;
@end

@implementation LineUpCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(NSNumber *)lineSet:(NSArray *)lineArray{
    self.actorArray=lineArray;
    
    [self clearButtons];
    
    NSArray *languages = [NSLocale preferredLanguages];
    NSString *lang = [languages objectAtIndex:0];
    
    
    
    int row=0;
    
    self.buttons=[[NSMutableArray alloc] init];
    UIFont *font=[UIFont systemFontOfSize:14];
    
    for (int i=0; i<lineArray.count; i++) {
        Actor *actor=(Actor *)[lineArray objectAtIndex:i];
        ;
        CGSize stringsize;
        if ([lang isEqualToString:@"zh-Hant"]) {
            stringsize = [actor.name sizeWithFont:font];
        }else{
            stringsize = [actor.cnName sizeWithFont:font];
        }
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.titleLabel.adjustsFontSizeToFitWidth = NO;
        button.titleLabel.adjustsLetterSpacingToFitWidth = YES;
        
        if (self.buttons.count>0) {
            UIButton *preButton=[self.buttons lastObject];
            [button setFrame:CGRectMake(preButton.frame.origin.x+preButton.frame.size.width+10,preButton.frame.origin.y,stringsize.width+10, stringsize.height+10)];
            float rightMargin=button.frame.origin.x+button.frame.size.width;
            if (rightMargin>310) {
                row+=1;
                [button setFrame:CGRectMake(10,40+row*40,stringsize.width+10, stringsize.height+10)];
            }
            
        }else{
            [button setFrame:CGRectMake(10,40,stringsize.width+10, stringsize.height+10)];
        }
        
        button.titleLabel.font = font;
        if ([lang isEqualToString:@"zh-Hant"]) {
            [button setTitle:actor.name forState:UIControlStateNormal];
        }else{
           [button setTitle:actor.cnName forState:UIControlStateNormal];
        }
        button.layer.cornerRadius = 5;
        button.layer.borderWidth = 1;
        button.layer.borderColor = [UIColor lightGrayColor].CGColor;
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button setBackgroundColor:[UIColor whiteColor]];
        
        button.tag=actor.actorID.intValue;
        
        [self.contentView addSubview:button];
        [self.buttons insertObject:button atIndex:i];
        [button addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    
    return [NSNumber numberWithFloat:80+row*40];
}

-(void)click:(id)sender{
       UIButton *clickButton=sender;
    /*
 
    if (clickButton.backgroundColor==[UIColor whiteColor]) {
        [clickButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [clickButton setBackgroundColor:[UIColor blackColor]];
    }else{
        [clickButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [clickButton setBackgroundColor:[UIColor whiteColor]];
    }
     */
    
    if([self.delegate respondsToSelector:@selector(clickActor: withActorName:)]){
       // Actor *actor=self.actorArray[clickButton.tag];
        //NSLog(@"clickButton:%d",clickButton.tag);
        
        NSNumber *tag=[NSNumber numberWithInt:clickButton.tag];

        [self.delegate clickActor:tag withActorName:clickButton.titleLabel.text];
    }
    /*
    
    if([self.delegate respondsToSelector:@selector(searchWord:)]){
        NSDictionary *itemDic=self.itemAry[clickButton.tag];
        
        NSString *keyWord=[NSString stringWithFormat:@"tagMap.%@=%@",self.keyWordDic[@"articleCategoryTagId"],itemDic[@"name"]];
        [self.delegate searchWord:keyWord];
    }
     */
    
    
}



-(void)clearButtons{
    for (int i=0; i<self.buttons.count; i++) {
        UIButton *button=self.buttons[i];
        [button removeFromSuperview];
    }
    [self.buttons removeAllObjects];
    
}

@end
