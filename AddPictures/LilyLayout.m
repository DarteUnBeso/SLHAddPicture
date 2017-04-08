//
//  LilyLayout.m
//  LilyComponent
//
//  Created by  on 15/10/15.
//  Copyright © 2015年 . All rights reserved.
//

#import "LilyLayout.h"

@implementation LilyLayout

-(CGSize)collectionViewContentSize{
    long pageCount = [self.collectionView.dataSource collectionView:self.collectionView numberOfItemsInSection:0]/6;
    return CGSizeMake(self.collectionView.bounds.size.width * pageCount, self.collectionView.bounds.size.height);
}



- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect

{
    
    NSMutableArray *layoutAttributes = [NSMutableArray array];
    
    long cellCount = [self.collectionView.dataSource collectionView:self.collectionView numberOfItemsInSection:0];
    
    NSMutableArray *visibleIndexPaths = [NSMutableArray array];
    for(int i=0;i<cellCount;i++){
        [visibleIndexPaths addObject:[NSIndexPath indexPathForRow:i inSection:0]];
    }
    
    for (NSIndexPath *indexPath in visibleIndexPaths) {
        
        UICollectionViewLayoutAttributes *attributes =
        
        [self layoutAttributesForItemAtIndexPath:indexPath];
        
        [layoutAttributes addObject:attributes]; 
        
    }
    
    return layoutAttributes;
}

-(UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath{
  
    int number=4;
    long index = indexPath.row;
    
    UICollectionViewLayoutAttributes *attributes =
    
    [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    
    CGFloat gap = self.collectionView.bounds.size.width / number * 0.8 / 6;


    attributes.frame = CGRectMake((index / 6) * self.collectionView.bounds.size.width + ((index % 6) % number) * ((self.collectionView.bounds.size.width - 2 * gap) / number) + 13 , ((index % 6) /number) * (self.collectionView.bounds.size.height / 3.5), self.itemSize.width, self.itemSize.height);
    

    return attributes;
}

@end
