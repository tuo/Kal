/* 
 * Copyright (c) 2009 Keith Lazuka
 * License: http://www.opensource.org/licenses/mit-license.html
 */

#import <CoreGraphics/CoreGraphics.h>
#import <QuartzCore/QuartzCore.h>
#import "KalMonthView.h"
#import "KalTileView.h"
#import "KalView.h"
#import "KalDate.h"
#import "KalPrivate.h"


@implementation KalMonthView{
    CGSize kTileSize;
    CGFloat kTileGap;
}

@synthesize numWeeks;

- (id)initWithFrame:(CGRect)frame
{
  if ((self = [super initWithFrame:frame])) {

      NSDictionary *titleSize = [KalCustom shareInstance].titleSize;
     kTileSize = CGSizeMake([titleSize[@"w"] floatValue], [titleSize[@"h"] floatValue]);
      kTileGap = [titleSize[@"g"] floatValue];

    tileAccessibilityFormatter = [[NSDateFormatter alloc] init];
    [tileAccessibilityFormatter setDateFormat:@"EEEE, MMMM d"];
    self.opaque = NO;
    self.clipsToBounds = YES;
    CGFloat xStart = 0.0f;
    CGFloat yStart = kTileGap;
    for (int i=0; i<6; i++) {
      for (int j=0; j<7; j++) {

          if (j % 7 == 0){
               xStart = 0;
          }
          CGRect r = CGRectMake(xStart, yStart, kTileSize.width, kTileSize.height);
          KalTileView *tileView = [[KalTileView alloc] initWithFrame:r];
          [self addSubview:[tileView autorelease]];
          xStart += (kTileSize.width + kTileGap);
      }
      yStart += (kTileSize.height + kTileGap);
    }
  }
  return self;
}

- (void)showDates:(NSArray *)mainDates leadingAdjacentDates:(NSArray *)leadingAdjacentDates trailingAdjacentDates:(NSArray *)trailingAdjacentDates
{
  int tileNum = 0;
  NSArray *dates[] = { leadingAdjacentDates, mainDates, trailingAdjacentDates };
  
  for (int i=0; i<3; i++) {
    for (KalDate *d in dates[i]) {
      KalTileView *tile = [self.subviews objectAtIndex:tileNum];
      [tile resetState];
      tile.date = d;
      tile.type = dates[i] != mainDates
                    ? KalTileTypeAdjacent
                    : [d isToday] ? KalTileTypeToday : KalTileTypeRegular;
      tileNum++;
    }
  }
  
  numWeeks = ceilf(tileNum / 7.f);
  [self sizeToFit];
  [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
//  CGContextRef ctx = UIGraphicsGetCurrentContext();
//  CGContextDrawTiledImage(ctx, (CGRect){CGPointZero,kTileSize}, [[UIImage imageNamed:@"Kal.bundle/kal_tile.png"] CGImage]);
}

- (KalTileView *)firstTileOfMonth
{
  KalTileView *tile = nil;
  for (KalTileView *t in self.subviews) {
    if (!t.belongsToAdjacentMonth) {
      tile = t;
      break;
    }
  }
  
  return tile;
}

- (KalTileView *)tileForDate:(KalDate *)date
{
  KalTileView *tile = nil;
  for (KalTileView *t in self.subviews) {
    if ([t.date isEqual:date]) {
      tile = t;
      break;
    }
  }
  NSAssert1(tile != nil, @"Failed to find corresponding tile for date %@", date);
  
  return tile;
}

- (void)sizeToFit
{
  self.height = 2.f + (kTileSize.height + kTileGap) * numWeeks;
}

- (void)markTilesForDates:(NSArray *)dates
{
  for (KalTileView *tile in self.subviews)
  {
    tile.marked = [dates containsObject:tile.date];
    NSString *dayString = [tileAccessibilityFormatter stringFromDate:[tile.date NSDate]];
    if (dayString) {
      NSMutableString *helperText = [[[NSMutableString alloc] initWithCapacity:128] autorelease];
      if ([tile.date isToday])
        [helperText appendFormat:@"%@ ", NSLocalizedString(@"Today", @"Accessibility text for a day tile that represents today")];
      [helperText appendString:dayString];
      if (tile.marked)
        [helperText appendFormat:@". %@", NSLocalizedString(@"Marked", @"Accessibility text for a day tile which is marked with a small dot")];
      [tile setAccessibilityLabel:helperText];
    }
  }
}

#pragma mark -

- (void)dealloc
{
  [tileAccessibilityFormatter release];
  [super dealloc];
}

@end
