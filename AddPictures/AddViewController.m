//
//  AddViewController.m
//  AddPictures
//
//  Created by 863hy on 16/1/7.
//  Copyright (c) 2016年 com.863soft.com. All rights reserved.
//

#import "AddViewController.h"
#import "PicCollectionViewCell.h"
#import "ShowPicViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "LilyLayout.h"

#define Identifier @"identifier"
//判断当前的设备系统版本
#define UIDEVICE(v) [[[UIDevice currentDevice] systemVersion] floatValue]>=(v)

@interface AddViewController ()


@end

@implementation AddViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    ImageArr=[[NSMutableArray alloc]init];//初始化数组
    [ImageArr addObject:[UIImage imageNamed:@"add.jpg"]];
    
    LilyLayout *flowlayout = [[LilyLayout alloc] init];
    
    flowlayout.itemSize = CGSizeMake((KScreenWidth-150) / 3, (KScreenWidth-150) / 3);
    
    collectionview=[[UICollectionView alloc]initWithFrame:CGRectMake(0, 140, KScreenWidth,350) collectionViewLayout:flowlayout];
    collectionview.delegate=self;
    collectionview.dataSource=self;
    collectionview.backgroundColor=[UIColor redColor];
    [collectionview registerClass:[PicCollectionViewCell class] forCellWithReuseIdentifier:Identifier];
    [self.view addSubview:collectionview];
    
    select=YES;
    
    self.navigationItem.title = @"拍照";

    button = [[UIButton alloc] initWithFrame:CGRectMake(0, 64, 40, 40)];
    button.backgroundColor = [UIColor redColor];
    [button setTitle:@"发送" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(sendClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
}

- (void)openMenu
{
    if (select==YES) {
        //在这里呼出下方菜单按钮项
        myActionSheet = [[UIActionSheet alloc]
                         initWithTitle:nil
                         delegate:self
                         cancelButtonTitle:@"取消"
                         destructiveButtonTitle:nil
                         otherButtonTitles:@"打开照相机", @"从手机相册获取", nil];
        [myActionSheet showInView:self.view];
    }else{
        
        UIAlertView *av=[[UIAlertView alloc]initWithTitle:@"最多只能放五张图片" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [av show];
        
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == myActionSheet.cancelButtonIndex) {
        NSLog(@"取消");
    }
    
    switch (buttonIndex) {
        case 0:   //开始拍照
            [self takePhoto];
            break;
            
        case 1:   //打开本地相册
            [self openLocalPhoto];
            break;
    }
}

//拍照
- (void)takePhoto
{
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIImagePickerController *picker = [[UIImagePickerController alloc]init];
        picker.delegate = self;
        picker.sourceType = sourceType;

        [self presentViewController:picker animated:YES completion:^{
            NSLog(@"OK");
        }];
        
    }
    else {
        NSLog(@"模拟其中无法打开照相机，请在真机中使用");
    }
}

//打开相册
- (void)openLocalPhoto
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    picker.delegate = self;
    
    [self presentViewController:picker animated:YES completion:^{
        
    }];
}


//当选择一张照片后进入这里
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    //当选择的类型是图片
    if ([type isEqualToString:@"public.image"]) {
  
        UIImage *image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        NSLog(@"111111");
        //将所选择的图片添加到imagearr数组中
        if (ImageArr.count<6) {
            [ImageArr insertObject:[info objectForKey:@"UIImagePickerControllerOriginalImage"] atIndex:ImageArr.count-1];
            if (ImageArr.count==6) {
                select=NO;
            }
        }
        NSLog(@"*******");
        //获取图片数据     先把图片转成NSData
        NSData *data = UIImageJPEGRepresentation(image, 1.0);

    
        NSLog(@"222222");
        ALAssetsLibrary *al = [[ALAssetsLibrary alloc] init];
        [al assetForURL:info[UIImagePickerControllerReferenceURL] resultBlock:^(ALAsset *asset) {
            
            //获取到信息
            //图片保存的路径
            //这里将图片放在沙盒的documents文件夹中
            NSString *DocumentsPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/images"];
            //文件管理器
            NSFileManager *fileManager = [NSFileManager defaultManager];
            //把刚刚图片转换的data对象拷贝至沙盒中 并保存为时间戳.png
            NSLog(@"333333");
            //获取图片上传时间，设置命名格式
            NSDate *sendDate = [NSDate date];
            NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
            [dateformatter setDateFormat:@"YYYYMMddHHmmss"];
            NSString *locationString = [dateformatter stringFromDate:sendDate];
            
            [fileManager createDirectoryAtPath:DocumentsPath withIntermediateDirectories:YES attributes:nil error:nil];
            [fileManager createFileAtPath:[DocumentsPath stringByAppendingString:[NSString stringWithFormat:@"/iOS_%@.png",locationString]] contents:data attributes:nil];
            
            filePath = [[NSString alloc]initWithFormat:@"%@%@",DocumentsPath,[NSString stringWithFormat:@"/iOS_%@.png", locationString]];
            //得到选择后沙盒中图片的完整路径
            NSLog(@"**********%@", filePath);
            
            //关闭相册界面
            [picker dismissViewControllerAnimated:YES completion:^{
                
            }];
            [collectionview reloadData];
            NSLog(@"4444444");
        } failureBlock:^(NSError *error) {
            NSLog(@"没有获取到图片信息");
            //关闭相册界面
            [picker dismissViewControllerAnimated:YES completion:^{
                
            }];
            [collectionview reloadData];
            
        }];
        
    }
}


-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    NSLog(@"%d",ImageArr.count);
    return ImageArr.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    PicCollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:Identifier forIndexPath:indexPath];
    cell.imageview.image=ImageArr[indexPath.row];
    cell.imageview.backgroundColor=[UIColor redColor];
    return cell;
    
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    NSLog(@"indexPath.row====%d",indexPath.row);
    
    if (indexPath.row==ImageArr.count-1) {
        [self openMenu];
    }else{
        
        ShowPicViewController *YFVC=[[ShowPicViewController alloc]init];
        YFVC.dataArr=ImageArr;
        int row = indexPath.row;
        YFVC.selectTag=row;
        YFVC.delegate=self;
        [self presentViewController:YFVC animated:YES completion:nil];
    }
}

-(void)deleteArr:(NSMutableArray *)arr1{
    
    [arr1 addObject:[UIImage imageNamed:@"add.jpg"]];
    ImageArr=arr1;
    if (ImageArr.count<6) {
        select=YES;
    }
    [collectionview reloadData];
}

-(void)passImgTag:(NSString * )ImgTag{
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *DocumentsPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/images/"];
    NSLog(@"DocumentsPath==%@",DocumentsPath);
    
    NSArray *filesNameArray = [fileManager subpathsAtPath:DocumentsPath];
    NSString *deletefileStr = [filesNameArray objectAtIndex:[ImgTag intValue]];
    NSLog(@"deletfileStr==%@",deletefileStr);
    
    NSString *DocumentsPath1 = [DocumentsPath stringByAppendingString:@"/"];
    NSString *deletefilePath = [DocumentsPath1 stringByAppendingString:deletefileStr];
    NSLog(@"deletefilePath＝=%@",deletefilePath);
    
    [fileManager removeItemAtPath:deletefilePath error:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    NSLog(@"您取消了选择图片");
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
}

//发送按钮点击
- (void)sendClick
{
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    //获取沙盒中所有文件
    NSString *DocumentsPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/images"];
    NSArray *files = [fileManager subpathsAtPath:DocumentsPath];
    
    NSLog(@"files===%@",files);
    
    //清空沙盒中照片
    [fileManager removeItemAtPath:DocumentsPath error:nil];
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return (toInterfaceOrientation == UIInterfaceOrientationPortrait);
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
