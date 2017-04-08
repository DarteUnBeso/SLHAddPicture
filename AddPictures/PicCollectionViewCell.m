//
//  PicCollectionViewCell.m
//  AddPictures
//
//  Created by 863hy on 16/1/7.
//  Copyright (c) 2016年 com.863soft.com. All rights reserved.
//

#import "PicCollectionViewCell.h"

@implementation PicCollectionViewCell

-(instancetype)initWithFrame:(CGRect)frame{
    
    if ([super initWithFrame:frame]) {
        NSLog(@"qqqqq");
        self.imageview=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
        [self.contentView addSubview:self.imageview];
        

    }
    return self;
}


@end
