//
//  WJPhotoViewCollectionViewCell.h
//  HuPlus
//
//  Created by reborn on 17/3/22.
//  Copyright © 2017年 IHUJIA. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WJPhotoViewCollectionViewCell : UICollectionViewCell

@property(nonatomic, strong)WJActionBlock deleteBlock;

-(void)configDataWithImage:(UIImage *)uploadImage;

@end
