/* 
 * Copyright (c) 2009 Keith Lazuka
 * License: http://www.opensource.org/licenses/mit-license.html
 */

#import <QuartzCore/QuartzCore.h>
#import "KalTileView.h"
#import "KalDate.h"
#import "KalPrivate.h"
#import "Kal_Prefix.pch"


@implementation KalTileView{
    CGSize kTileSize;
}

@synthesize date;

- (id)initWithFrame:(CGRect)frame
{
  if ((self = [super initWithFrame:frame])) {
      NSDictionary *titleSize = [KalCustom shareInstance].titleSize;
      kTileSize = CGSizeMake([titleSize[@"w"] floatValue], [titleSize[@"h"] floatValue]);

      self.opaque = NO;
    self.backgroundColor = [UIColor clearColor];
    self.clipsToBounds = NO;
    origin = frame.origin;
    [self setIsAccessibilityElement:YES];
    [self setAccessibilityTraits:UIAccessibilityTraitButton];
    [self resetState];
    self.backgroundColor = UIColorFromRGB(0xffffff);
      self.layer.masksToBounds = YES;
      self.layer.cornerRadius = 4.0f;


  }
  return self;
}

- (void)drawRect:(CGRect)rect
{
  CGContextRef ctx = UIGraphicsGetCurrentContext();
  CGFloat fontSize = 24.f;
  UIFont *font = [UIFont boldSystemFontOfSize:fontSize];
  UIColor *shadowColor = nil;
  UIColor *textColor = nil;
  UIImage *markerImage = nil;
  CGContextSelectFont(ctx, [font.fontName cStringUsingEncoding:NSUTF8StringEncoding], fontSize, kCGEncodingMacRoman);
      
  CGContextTranslateCTM(ctx, 0, kTileSize.height);
  CGContextScaleCTM(ctx, 1, -1);

  textColor = [UIColor whiteColor];
  CGFloat drawStartY =  -1.0f;
  CGFloat drawGapSize = 1.0f;
    UIColor *bgColorWhenSelected = UIColorFromRGB(0x565654); //gray
    UIColor *bgColorWhenNotSelected = UIColorFromRGB(0xffffff); //white
    UIColor *bgColorWhenNotEmpty = UIColorFromRGB(0x75B2BF); //green
     bgColorWhenNotEmpty = UIColorFromRGB(0x659596); //green
     bgColorWhenNotEmpty = UIColorFromRGB(0x659596); //green
     bgColorWhenNotEmpty = UIColorFromRGB(0x76A6A6); //green


    if ([self isToday] && self.selected) {
//    [[[UIImage imageNamed:@"Kal.bundle/kal_tile_today_selected.png"] stretchableImageWithLeftCapWidth:6 topCapHeight:0] drawInRect:CGRectMake(0, -1, kTileSize.width+1, kTileSize.height+1)];
    shadowColor = [UIColor blackColor];
    markerImage = [UIImage imageNamed:@"Kal.bundle/kal_marker_today.png"];
    [bgColorWhenSelected setFill]; //gray color
    CGContextFillRect(ctx, CGRectMake(0.f, drawStartY, kTileSize.width + drawGapSize, kTileSize.height + drawGapSize));

  } else if ([self isToday] && !self.selected) {
     [bgColorWhenNotSelected setFill]; //white color
      CGContextFillRect(ctx, CGRectMake(0.f, drawStartY, kTileSize.width + drawGapSize, kTileSize.height + drawGapSize));
    shadowColor = [UIColor blackColor];
    markerImage = [UIImage imageNamed:@"Kal.bundle/kal_marker_today.png"];
      textColor = UIColorFromRGB(0x535353);
  } else if (self.selected) {
//    [[[UIImage imageNamed:@"Kal.bundle/kal_tile_selected.png"] stretchableImageWithLeftCapWidth:1 topCapHeight:0] drawInRect:CGRectMake(0, -1, kTileSize.width+1, kTileSize.height+1)];
    shadowColor = [UIColor blackColor];
    markerImage = [UIImage imageNamed:@"Kal.bundle/kal_marker_selected.png"];
      [bgColorWhenSelected setFill]; //gray color
      CGContextFillRect(ctx, CGRectMake(0.f, drawStartY, kTileSize.width + drawGapSize, kTileSize.height + drawGapSize));

  } else if (self.belongsToAdjacentMonth) {
    textColor = UIColorFromRGB(0xD1D1D1);
    shadowColor = nil;
    markerImage = [UIImage imageNamed:@"Kal.bundle/kal_marker_dim.png"];
  } else {
    textColor = UIColorFromRGB(0x535353); //when younot selected
    shadowColor = [UIColor whiteColor];
    markerImage = [UIImage imageNamed:@"Kal.bundle/kal_marker.png"];
  }

  if (flags.marked && !self.belongsToAdjacentMonth){
      [bgColorWhenNotEmpty setFill]; //green color
      CGContextFillRect(ctx, CGRectMake(0.f, drawStartY, kTileSize.width + drawGapSize, kTileSize.height + drawGapSize));
      textColor = [UIColor whiteColor];
      textColor = UIColorFromRGB(0xFAF9F9);
  }

    if (self.selected ) {
//    [[[UIImage imageNamed:@"Kal.bundle/kal_tile_selected.png"] stretchableImageWithLeftCapWidth:1 topCapHeight:0] drawInRect:CGRectMake(0, -1, kTileSize.width+1, kTileSize.height+1)];
        shadowColor = [UIColor blackColor];
        markerImage = [UIImage imageNamed:@"Kal.bundle/kal_marker_selected.png"];
        [bgColorWhenSelected setFill]; //gray color
        CGContextFillRect(ctx, CGRectMake(0.f, drawStartY, kTileSize.width + drawGapSize, kTileSize.height + drawGapSize));
    }

  
  NSUInteger n = [self.date day];
  NSString *dayText = [NSString stringWithFormat:@"%lu", (unsigned long)n];
  const char *day = [dayText cStringUsingEncoding:NSUTF8StringEncoding];
  CGSize textSize = [dayText sizeWithFont:font];
  CGFloat textX, textY;
  textX = roundf(0.5f * (kTileSize.width - textSize.width));
  textY = 6.f + roundf(0.5f * (kTileSize.height - textSize.height));
//  if (shadowColor) {
//    [shadowColor setFill];
//    CGContextShowTextAtPoint(ctx, textX, textY, day, n >= 10 ? 2 : 1);
//    textY += 1.f;
//  }
  [textColor setFill];
  CGContextShowTextAtPoint(ctx, textX, textY, day, n >= 10 ? 2 : 1);
  
  if (self.highlighted) {
    [[UIColor colorWithWhite:0.25f alpha:0.3f] setFill];
    CGContextFillRect(ctx, CGRectMake(0.f, 0.f, kTileSize.width, kTileSize.height));
  }
}

- (void)resetState
{
  // realign to the grid
  CGRect frame = self.frame;
  frame.origin = origin;
  frame.size = kTileSize;
  self.frame = frame;
  
  [date release];
  date = nil;
  flags.type = KalTileTypeRegular;
  flags.highlighted = NO;
  flags.selected = NO;
  flags.marked = NO;
}

- (void)setDate:(KalDate *)aDate
{
  if (date == aDate)
    return;

  [date release];
  date = [aDate retain];

  [self setNeedsDisplay];
}

- (BOOL)isSelected { return flags.selected; }

- (void)setSelected:(BOOL)selected
{
  if (flags.selected == selected)
    return;

  // workaround since I cannot draw outside of the frame in drawRect:
  if (![self isToday]) {
    CGRect rect = self.frame;
    if (selected) {
      rect.origin.x--;
      rect.size.width++;
      rect.size.height++;
    } else {
      rect.origin.x++;
      rect.size.width--;
      rect.size.height--;
    }
    self.frame = rect;
  }
  
  flags.selected = selected;
  [self setNeedsDisplay];
}

- (BOOL)isHighlighted { return flags.highlighted; }

- (void)setHighlighted:(BOOL)highlighted
{
  if (flags.highlighted == highlighted)
    return;
  
  flags.highlighted = highlighted;
  [self setNeedsDisplay];
}

- (BOOL)isMarked { return flags.marked; }

- (void)setMarked:(BOOL)marked
{
  if (flags.marked == marked)
    return;
  
  flags.marked = marked;
  [self setNeedsDisplay];
}

- (KalTileType)type { return flags.type; }

- (void)setType:(KalTileType)tileType
{
  if (flags.type == tileType)
    return;
  
  // workaround since I cannot draw outside of the frame in drawRect:
  CGRect rect = self.frame;
  if (tileType == KalTileTypeToday) {
    rect.origin.x--;
    rect.size.width++;
    rect.size.height++;
  } else if (flags.type == KalTileTypeToday) {
    rect.origin.x++;
    rect.size.width--;
    rect.size.height--;
  }
  self.frame = rect;
  
  flags.type = tileType;
  [self setNeedsDisplay];
}

- (BOOL)isToday { return flags.type == KalTileTypeToday; }

- (BOOL)belongsToAdjacentMonth { return flags.type == KalTileTypeAdjacent; }

- (void)dealloc
{
  [date release];
  [super dealloc];
}

@end
