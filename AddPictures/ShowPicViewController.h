//
//  ShowPicViewController.h
//  AddPictures
//
//  Created by 863hy on 16/1/7.
//  Copyright (c) 2016年 com.863soft.com. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol YunFengDelegate <NSObject>

-(void)deleteArr:(NSMutableArray *)arr;
-(void)passImgTag:(NSString * )ImgTag;

@end

@interface ShowPicViewController : UIViewController<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>{
    
    UICollectionView *DetailCollectionview;
    NSMutableArray *addselectPicArr;
    UIView *HeaderView;
    UILabel *HeaderLabel;
    
    BOOL TapTag;//图片点击标记

    int  selectTag;
}


@property(assign, nonatomic)int  selectTag;
@property(strong, nonatomic)NSMutableArray *dataArr;

@property(assign, nonatomic)id<YunFengDelegate> delegate;


@end
