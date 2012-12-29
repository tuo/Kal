//
//  KalCustom.h
//  Kal
//
//  Created by Test on 12/29/12.
//
//

#import <Foundation/Foundation.h>

@protocol KalCustomDelegate <NSObject>
-(void)userSelectTileOfUpdateDate:(NSDate *)date;
@end

@interface KalCustom : NSObject
+ (KalCustom *)shareInstance;
@property (nonatomic, assign) BOOL isCustom;
@property(nonatomic, retain) id<KalCustomDelegate> delegate;

- (NSDictionary *)titleSize;

@end
