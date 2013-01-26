//
//  KalCustom.m
//  Kal
//
//  Created by Test on 12/29/12.
//
//

#import "KalCustom.h"

@implementation KalCustom
@synthesize delegate = _delegate;


+ (KalCustom *)shareInstance {
    static KalCustom *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[KalCustom alloc] init];
    });
    return sharedInstance;

}


-(NSDictionary *)titleSize{
    //7 * width + 6 * gap = 294 or 320 ;
    //gap = 2 width = 44
    if (self.isCustom){
        return @{@"w" : @40.0f, @"h":@40.0f,@"g" : @2.3f};
    }
    return @{@"w" : @44.0f, @"h":@42.0f, @"g" : @2.0f};
}

- (void)dealloc {
    [_delegate release];
    [super dealloc];
}


@end
