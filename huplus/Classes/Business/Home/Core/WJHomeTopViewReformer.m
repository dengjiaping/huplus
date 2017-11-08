//
//  WJHomeTopViewReformer.m
//  HuPlus
//
//  Created by reborn on 17/2/15.
//  Copyright © 2017年 IHUJIA. All rights reserved.
//

#import "WJHomeTopViewReformer.h"
#import "WJHomeBannerModel.h"
#import "WJBrandModel.h"
#import "WJCategoryListModel.h"
#import "WJAdvertiseListModel.h"
@implementation WJHomeTopViewReformer

- (id)manager:(APIBaseManager *)manager reformData:(id)data
{
    NSMutableArray * bannerArray        = [NSMutableArray array];
    NSMutableArray * categoriesArray    = [NSMutableArray array];
    NSMutableArray * brandArray         = [NSMutableArray array];
    NSMutableDictionary *advertiseDic   = [NSMutableDictionary dictionary];

    NSMutableDictionary *dataDic = [NSMutableDictionary dictionaryWithDictionary:data];
    
    for (id obj in data[@"pic_list"]) {
        if ([obj isKindOfClass:[NSDictionary class]]) {
            WJHomeBannerModel *homeBannerModel = [[WJHomeBannerModel alloc] initWithDictionary:obj];
            [bannerArray addObject:homeBannerModel];
        }
    }
    
    for (id obj in data[@"category_list"]) {
        if ([obj isKindOfClass:[NSDictionary class]]) {
            WJCategoryListModel *categoryModel = [[WJCategoryListModel alloc] initWithDic:obj];
            [categoriesArray addObject:categoryModel];
        }
    }
    
    for (id obj in data[@"brand_list"]) {
        if ([obj isKindOfClass:[NSDictionary class]]) {
            WJBrandModel *brandModel = [[WJBrandModel alloc] initWithDic:obj];
            [brandArray addObject:brandModel];
        }
    }
    
    advertiseDic = dataDic[@"ad_list"];
    
    [dataDic setValue:bannerArray forKey:@"bannerArray"];
    [dataDic setValue:categoriesArray forKey:@"categoriesArray"];
    [dataDic setValue:brandArray forKey:@"brandArray"];
    [dataDic setValue:advertiseDic forKey:@"advertiseDic"];
    
//    [self saveBannerArray:bannerArray];

    return dataDic;
}

#pragma mark - writeToLocalFile
- (NSString *)rootBannerPicUrlCachePath
{
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *filePath = [path firstObject];
    filePath = [filePath stringByAppendingPathComponent:@"LocalBanner.txt"];
    return filePath;
}

- (void)saveBannerArray:(NSMutableArray *)array
{
    NSData *arc = [NSKeyedArchiver archivedDataWithRootObject:array];
    [arc writeToFile:[self rootBannerPicUrlCachePath] atomically:YES];
}

@end
