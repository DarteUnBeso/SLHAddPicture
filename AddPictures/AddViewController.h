//
//  AddViewController.h
//  AddPictures
//
//  Created by 863hy on 16/1/7.
//  Copyright (c) 2016年 com.863soft.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShowPicViewController.h"


@interface AddViewController : UIViewController<UITextViewDelegate, UIActionSheetDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,YunFengDelegate>
{
    UIActionSheet *myActionSheet;
    NSString *filePath;
    UICollectionView *collectionview;

    UIScrollView *ScrollView;
    
    BOOL select;
    UIButton *button;
    NSMutableArray *ImageArr;//添加数组  保存选择的所有图片
    NSMutableArray *arr;
    
}


@end
