//
//  WJHomeBannerModel.m
//  HuPlus
//
//  Created by reborn on 17/2/15.
//  Copyright © 2017年 IHUJIA. All rights reserved.
//

#import "WJHomeBannerModel.h"

@implementation WJHomeBannerModel
- (instancetype)initWithDictionary:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        self.linkType     = ToString(dic[@"link_type"]);
        self.linkUrl      = ToString(dic[@"link_url"]);
        self.picUrl       = ToString(dic[@"pic_url"]);
        self.title        = ToString(dic[@"descriptions"]);

    }
    return self;
}
#pragma mark - NSCoding协议
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.linkType forKey:@"link_type"];
    [aCoder encodeObject:self.linkUrl forKey:@"link_url"];
    [aCoder encodeObject:self.picUrl forKey:@"pic_url"];
    [aCoder encodeObject:self.title forKey:@"descriptions"];
    
}
- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        self.linkType = [aDecoder decodeObjectForKey:@"link_type"];
        self.linkUrl = [aDecoder decodeObjectForKey:@"link_url"];
        self.picUrl = [aDecoder decodeObjectForKey:@"pic_url"];
        self.title = [aDecoder decodeObjectForKey:@"descriptions"];
    }
    
    return self;
}
@end
