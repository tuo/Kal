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




@end
