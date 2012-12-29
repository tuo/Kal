//
//  KalCustom.m
//  Kal
//
//  Created by Test on 12/29/12.
//
//

#import "KalCustom.h"

@implementation KalCustom

+ (KalCustom *)shareInstance {
    static KalCustom *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[KalCustom alloc] init];
    });
    return sharedInstance;

}


-(NSDictionary *)titleSize{
    if (self.isCustom){
        return @{@"w" : @42.0f, @"h":@42.0f};
    }
    return @{@"w" : @46.0f, @"h":@44.0f};
}



@end
