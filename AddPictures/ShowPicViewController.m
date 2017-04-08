//
//  ShowPicViewController.m
//  AddPictures
//
//  Created by 863hy on 16/1/7.
//  Copyright (c) 2016年 com.863soft.com. All rights reserved.
//

#import "ShowPicViewController.h"
#import "PicCollectionViewCell.h"

#define Identifier @"identifier"

@interface ShowPicViewController ()

@end

@implementation ShowPicViewController

@synthesize selectTag,dataArr,delegate;

-(void)viewWillAppear:(BOOL)animated{
    
    [self.dataArr removeLastObject];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    TapTag=NO;
    
    addselectPicArr=[[NSMutableArray alloc]init];
    
    HeaderView=[[UIView alloc]initWithFrame:CGRectMake(0, 20, KScreenWidth, 40)];
    HeaderView.backgroundColor=[UIColor blackColor];
    HeaderView.alpha = 0.5;
    
    UIButton *DeleteBtn=[[UIButton alloc]initWithFrame:CGRectMake(KScreenWidth-40, 5, 30, 30)];
    [DeleteBtn setImage:[UIImage imageNamed:@"btn_dl"] forState:UIControlStateNormal];
    [DeleteBtn addTarget:self action:@selector(DeleteBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    DeleteBtn.contentMode=UIViewContentModeScaleAspectFit;
    [HeaderView addSubview:DeleteBtn];
    
    UIButton *BackBtn=[[UIButton alloc]initWithFrame:CGRectMake(5, 5, 30, 30)];
    [BackBtn setImage:[UIImage imageNamed:@"btn_quxiao"] forState:UIControlStateNormal];
    [BackBtn addTarget:self action:@selector(BackBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    BackBtn.contentMode=UIViewContentModeScaleAspectFit;
    [HeaderView addSubview:BackBtn];
    
    HeaderLabel=[[UILabel alloc]initWithFrame:CGRectMake(60, 5, 60, 30)];
    HeaderLabel.text=[NSString stringWithFormat:@"%d/%d",selectTag+1,(int)(self.dataArr.count-1)];
    HeaderLabel.textColor = [UIColor whiteColor];
    [HeaderView addSubview:HeaderLabel];
    
    
    UICollectionViewFlowLayout *flowlauout=[[UICollectionViewFlowLayout alloc]init];
    flowlauout.minimumLineSpacing = 0;
    flowlauout.minimumInteritemSpacing = 0;
    flowlauout.itemSize=CGSizeMake(KScreenWidth, KScreenHeight);
    flowlauout.scrollDirection=UICollectionViewScrollDirectionHorizontal;
    
    DetailCollectionview=[[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight) collectionViewLayout:flowlauout];
    DetailCollectionview.pagingEnabled=YES;
    DetailCollectionview.delegate=self;
    DetailCollectionview.dataSource=self;
    [DetailCollectionview setContentOffset:CGPointMake(selectTag*KScreenWidth, 0)];
    [DetailCollectionview registerClass:[PicCollectionViewCell class] forCellWithReuseIdentifier:Identifier];
    [self.view addSubview:DetailCollectionview];
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.dataArr.count;
}


-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    PicCollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:Identifier forIndexPath:indexPath];
    cell.imageview.contentMode=UIViewContentModeScaleAspectFit;
    cell.imageview.image=self.dataArr[indexPath.row];
    
    return cell;
    
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    //    NSLog(@"indexPath.row=**********%d",indexPath.row);
    TapTag=!TapTag;
    if (TapTag==YES) {
        [self.view addSubview:HeaderView];
    }else
        [HeaderView removeFromSuperview];
    
}

#pragma mark 删除按钮点击
-(void)DeleteBtnClick:(UIButton *)sender{
    
    if (self.dataArr.count==1) {
        [self.dataArr removeObjectAtIndex:selectTag];
        [DetailCollectionview reloadData];
        [self.delegate deleteArr:addselectPicArr];
        [self dismissViewControllerAnimated:YES completion:nil];
        NSLog(@"selectTag====%d",(int)(DetailCollectionview.contentOffset.x/KScreenWidth));
        
        [self.delegate performSelector:@selector(passImgTag:) withObject:  [NSString stringWithFormat:@"%d",(int)(DetailCollectionview.contentOffset.x/KScreenWidth)] ];
        return;
    }
    [self.dataArr removeObjectAtIndex:selectTag];
    if (selectTag==0) {
        HeaderLabel.text=[NSString stringWithFormat:@"%d/%d",1,(int)(self.dataArr.count)];
        [DetailCollectionview reloadData];
        NSLog(@"selectTag====%d",(int)(DetailCollectionview.contentOffset.x/KScreenWidth));
        [self.delegate performSelector:@selector(passImgTag:) withObject:  [NSString stringWithFormat:@"%d",(int)(DetailCollectionview.contentOffset.x/KScreenWidth)] ];
        return;
        
    }
    if (selectTag==self.dataArr.count) {
        selectTag=selectTag-1;
        HeaderLabel.text=[NSString stringWithFormat:@"%d/%d",selectTag+1,(int)(self.dataArr.count)];
        [DetailCollectionview reloadData];
        NSLog(@"selectTag====%d",(int)(DetailCollectionview.contentOffset.x/KScreenWidth));
        [self.delegate performSelector:@selector(passImgTag:) withObject:  [NSString stringWithFormat:@"%d",(int)(DetailCollectionview.contentOffset.x/KScreenWidth)] ];
        return;
    }
    
    HeaderLabel.text=[NSString stringWithFormat:@"%d/%d",selectTag+1,(int)(self.dataArr.count)];
    [DetailCollectionview reloadData];
    
}



#pragma mark 返回按钮点击
-(void)BackBtnClick:(UIButton *)sender{
    //      NSLog(@"%d",addselectPicArr.count);
    [self.delegate deleteArr:self.dataArr];
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark scrollview代理
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    selectTag=DetailCollectionview.contentOffset.x/KScreenWidth;
    NSLog(@"scrollViewDidEndDecelerating   %d",selectTag);
    HeaderLabel.text=[NSString stringWithFormat:@"%d/%d",selectTag+1,(int)self.dataArr.count];
}

-(UIStatusBarStyle )preferredStatusBarStyle{
    
    return UIStatusBarStyleLightContent;
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
