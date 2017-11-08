//
//  WJShopCartCell.m
//  HuPlus
//
//  Created by reborn on 17/1/6.
//  Copyright © 2017年 IHUJIA. All rights reserved.
//

#import "WJShopCartCell.h"
#import "WJDigitalSelectorView.h"
#import <UIImageView+WebCache.h>
#import "WJAttributeDetailModel.h"
@interface WJShopCartCell ()
{
    UIImageView *iconIV;
    UIButton    *selectButton;
    
    UILabel     *nameL;
    UILabel     *priceL;
    UILabel     *colorL;
    UILabel     *sizeL;
    UILabel     *countL;
    
    UIButton    *editButton;
    UIButton    *finishButton;
    UIButton    *deleteButton;
    UIImageView *writeImageView;
    UIView      *rightLineView;
    
    WJDigitalSelectorView *digitalSelectorView;

}

@end

@implementation WJShopCartCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        selectButton = [UIButton buttonWithType:UIButtonTypeCustom];
        selectButton.frame = CGRectMake(ALD(5), ALD(5), ALD(30),ALD(140));
        selectButton.imageEdgeInsets = UIEdgeInsetsMake(ALD(30), 0, ALD(30), 0);
        [selectButton addTarget:self action:@selector(selectButtonAction) forControlEvents:UIControlEventTouchUpInside];

        
        iconIV = [[UIImageView alloc] initWithFrame:CGRectMake(selectButton.right + ALD(10), ALD(15), ALD(92), ALD(108))];
        iconIV.layer.borderColor = WJColorSeparatorLine.CGColor;
        iconIV.layer.borderWidth = 1;
        iconIV.backgroundColor = [UIColor orangeColor];
        
        
        nameL = [[UILabel alloc] initWithFrame:CGRectMake(iconIV.right+ ALD(15), iconIV.frame.origin.y, kScreenWidth - ALD(200), ALD(44))];
        nameL.numberOfLines = 0;
        nameL.textColor = WJColorDarkGray;
        nameL.font = WJFont15;
        nameL.lineBreakMode  = NSLineBreakByTruncatingTail;
        
        colorL =  [[UILabel alloc] initWithFrame:CGRectMake(nameL.origin.x, nameL.bottom, ALD(140), ALD(22))];
        colorL.textColor = WJColorDarkGray;
        colorL.font = WJFont12;
        
        sizeL =  [[UILabel alloc] initWithFrame:CGRectMake(nameL.origin.x, colorL.bottom, kScreenWidth - ALD(139), ALD(22))];
        sizeL.textColor = WJColorDarkGray;
        sizeL.font = WJFont12;
        
        priceL = [[UILabel alloc] initWithFrame:CGRectMake(nameL.origin.x, sizeL.bottom, ALD(100), ALD(22))];
        priceL.textColor = WJColorMainRed;
        priceL.font = WJFont12;
        
        countL = [[UILabel alloc] initWithFrame:CGRectMake(priceL.right, priceL.frame.origin.y, ALD(40), ALD(22))];
        countL.textColor = WJColorDarkGray;
        countL.font = WJFont12;
        
        editButton = [UIButton buttonWithType:UIButtonTypeCustom];
        editButton.frame = CGRectMake((kScreenWidth -ALD(12) - ALD(35)), ALD(15), ALD(35), ALD(44));
        [editButton setTitle:@"编辑" forState:UIControlStateNormal];
        [editButton setTitleColor:WJColorNavigationBar forState:UIControlStateNormal];
        editButton.titleLabel.font = WJFont14;
        [editButton addTarget:self action:@selector(editButtonAction) forControlEvents:UIControlEventTouchUpInside];
        
        finishButton = [UIButton buttonWithType:UIButtonTypeCustom];
        finishButton.frame = CGRectMake((kScreenWidth  - ALD(64)), 0, ALD(64), ALD(70));
        [finishButton setTitle:@"完成" forState:UIControlStateNormal];
        [finishButton setTitleColor:WJColorNavigationBar forState:UIControlStateNormal];
        finishButton.titleLabel.font = WJFont14;
        finishButton.hidden = YES;
        [finishButton addTarget:self action:@selector(finishButtonAction) forControlEvents:UIControlEventTouchUpInside];
        finishButton.backgroundColor = WJColorViewBg2;
        
        rightLineView = [[UIView alloc] initWithFrame:CGRectMake(kScreenWidth - finishButton.width, finishButton.bottom, finishButton.width, 0.5)];
        rightLineView.hidden = YES;
        rightLineView.backgroundColor = [WJUtilityMethod colorWithHexColorString:@"#dbdfe2"];
        
        deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        deleteButton.frame = CGRectMake((kScreenWidth - ALD(64)), rightLineView.bottom, ALD(64), ALD(70));
        [deleteButton setTitle:@"删除" forState:UIControlStateNormal];
        [deleteButton setTitleColor:WJColorNavigationBar forState:UIControlStateNormal];
        deleteButton.titleLabel.font = WJFont14;
        deleteButton.hidden = YES;
        [deleteButton addTarget:self action:@selector(deleteButtonAction) forControlEvents:UIControlEventTouchUpInside];
        deleteButton.backgroundColor = WJColorViewBg2;
        
        writeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth - deleteButton.width - ALD(50) , deleteButton.frame.origin.y + ALD(5), ALD(20), ALD(20))];
        writeImageView.image = [UIImage imageNamed:@"ShoppingCart_edit_icon"];
        writeImageView.hidden = YES;
        
        
        digitalSelectorView = [[WJDigitalSelectorView alloc] initWithFrame:CGRectMake(iconIV.right, ALD(10), [WJDigitalSelectorView width], [WJDigitalSelectorView height])];
        digitalSelectorView.hidden = YES;
        
        __weak typeof(self) weakSelf = self;
        [digitalSelectorView setCountChangeBlock:^(BOOL isIncrease) {
            
            if ([weakSelf.delegate respondsToSelector:@selector(countChanged:Section:Index:)]) {
                [weakSelf.delegate countChanged:isIncrease Section:weakSelf.section Index:weakSelf.index];
            }
            
        }];

        [self.contentView addSubview:selectButton];
        [self.contentView addSubview:iconIV];
        [self.contentView addSubview:nameL];
        [self.contentView addSubview:colorL];
        [self.contentView addSubview:sizeL];
        [self.contentView addSubview:priceL];
        [self.contentView addSubview:countL];
        [self.contentView addSubview:digitalSelectorView];
        
        [self.contentView addSubview:editButton];
        [self.contentView addSubview:finishButton];
        [self.contentView addSubview:rightLineView];
        [self.contentView addSubview:deleteButton];
        [self.contentView addSubview:writeImageView];
        
    }
    
    return self;
    
}

-(void)updateWithProductModel:(WJProductModel *)productModel
{
    [iconIV sd_setImageWithURL:[NSURL URLWithString:productModel.imageUrl] placeholderImage:[UIImage imageNamed:@"bitmap_commodity"]];
    nameL.text = productModel.name;
    
    for (WJAttributeDetailModel *attributeDetailModel in productModel.attributeArray) {
        
        if ([attributeDetailModel.attributeName isEqualToString:@"颜色"]) {
            
            colorL.text = [NSString stringWithFormat:@"颜色：%@",attributeDetailModel.valueName];
        } else {
            
            sizeL.text = [NSString stringWithFormat:@"尺寸：%@",attributeDetailModel.valueName];
            
        }
    }
    
    
    priceL.text = [NSString stringWithFormat:@"¥%.2f",[productModel.salePrice floatValue]];
    
    CGSize txtSize = [priceL.text sizeWithAttributes:@{NSFontAttributeName:WJFont12} constrainedToSize:CGSizeMake(1000000, ALD(20))];
    priceL.frame = CGRectMake(nameL.origin.x, sizeL.bottom, txtSize.width, ALD(22));
    countL.frame = CGRectMake(priceL.right + ALD(25), priceL.frame.origin.y, ALD(40), ALD(22));
    countL.text = [NSString stringWithFormat:@"x %ld",productModel.count];

    
    [digitalSelectorView refeshDigitalSelectorViewWithCount:productModel.count];
    
    if (productModel.isSelect) {
        
        [selectButton setImage:[UIImage imageNamed:@"shopCart_sel"] forState:UIControlStateNormal];
    } else {
 
        [selectButton setImage:[UIImage imageNamed:@"shopCart_nor"] forState:UIControlStateNormal];
    }
}


#pragma mark - Action
-(void)editButtonAction
{
    nameL.hidden = YES;
    finishButton.hidden = NO;
    deleteButton.hidden = NO;
    rightLineView.hidden = NO;
    digitalSelectorView.hidden = NO;
    priceL.hidden = YES;
    countL.hidden = YES;
    writeImageView.hidden = NO;
    
    self.isCanClick = YES;

    colorL.frame = CGRectMake(nameL.origin.x, digitalSelectorView.bottom + ALD(15), ALD(140), ALD(22));
    sizeL.frame = CGRectMake(nameL.origin.x, colorL.bottom, kScreenWidth - ALD(139), ALD(22));
    
    self.editBlock();
    
}

-(void)finishButtonAction
{
    finishButton.hidden = YES;
    deleteButton.hidden = YES;
    digitalSelectorView.hidden = YES;
    rightLineView.hidden = YES;

    nameL.hidden = NO;
    priceL.hidden = NO;
    countL.hidden = NO;
    writeImageView.hidden = YES;
    
    self.isCanClick = NO;

    colorL.frame = CGRectMake(nameL.origin.x, nameL.bottom, ALD(140), ALD(22));
    sizeL.frame = CGRectMake(nameL.origin.x, colorL.bottom, kScreenWidth - ALD(139), ALD(22));
    self.finishBlock();
}

-(void)deleteButtonAction
{
    finishButton.hidden = YES;
    deleteButton.hidden = YES;
    rightLineView.hidden = YES;
    digitalSelectorView.hidden = YES;
    nameL.hidden = NO;
    priceL.hidden = NO;
    writeImageView.hidden = YES;

    colorL.frame = CGRectMake(nameL.origin.x, nameL.bottom, ALD(140), ALD(22));
    sizeL.frame = CGRectMake(nameL.origin.x, colorL.bottom, kScreenWidth - ALD(139), ALD(22));
    
    self.deleteBlock();
}

- (void)selectButtonAction
{
    self.selectBlock();
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
