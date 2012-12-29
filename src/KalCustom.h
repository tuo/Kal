//
//  KalCustom.h
//  Kal
//
//  Created by Test on 12/29/12.
//
//

#import <Foundation/Foundation.h>

@interface KalCustom : NSObject
+ (KalCustom *)shareInstance;

@property (nonatomic, assign) BOOL isCustom;

@end
