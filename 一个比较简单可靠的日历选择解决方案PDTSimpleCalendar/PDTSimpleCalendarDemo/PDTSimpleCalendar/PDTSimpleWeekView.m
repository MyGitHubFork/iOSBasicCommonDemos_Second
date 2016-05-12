//
//  PDTSimpleWeekView.m
//  PDTSimpleCalendarDemo
//
//  Created by Arron Zhang on 14/11/25.
//  Copyright (c) 2014年 Producteev. All rights reserved.
//

#import "PDTSimpleWeekView.h"
#import "PDTSimpleCalendarViewCell.h"

@interface PDTSimpleWeekView ()

@property (strong, nonatomic) NSArray *veryShortStandaloneWeekdaySymbols;
@property (strong, nonatomic) NSArray *shortStandaloneWeekdaySymbols;
@property (strong, nonatomic) NSArray *standaloneWeekdaySymbols;

@end

@implementation PDTSimpleWeekView

-(id)initWithFrame:(CGRect)frame calendar:(NSCalendar *)calendar{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [self defaultBackgroundColor];
        _calendar = calendar;
        self.isAccessibilityElement = NO;
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
        self.veryShortStandaloneWeekdaySymbols = [self.calendar veryShortStandaloneWeekdaySymbols];
        self.shortStandaloneWeekdaySymbols = [self.calendar shortStandaloneWeekdaySymbols];
        self.standaloneWeekdaySymbols = [self.calendar standaloneWeekdaySymbols];
        NSUInteger count = [self.veryShortStandaloneWeekdaySymbols count];
        CGFloat width = CGRectGetWidth(self.frame) / count;
        CGFloat height = CGRectGetHeight(self.frame);

        NSRange range = [calendar maximumRangeOfUnit:NSCalendarUnitWeekday];
        UIColor *color = [PDTSimpleCalendarViewCell appearance].circleSelectedColor;
        UIColor *def = [UIColor blackColor];
        NSDictionary *attr = [[UINavigationBar appearance] titleTextAttributes];
        if (attr[NSForegroundColorAttributeName]) {
            def = attr[NSForegroundColorAttributeName];
        }
        if(!color)
            color = [UIColor colorWithRed:1.f green:59.f/255.f blue:48.f/255.f alpha:1];
        for (int i = 0; i < count; i++) {
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(width * i, 0, width, height)];
            label.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
            label.textAlignment = NSTextAlignmentCenter;
            label.text = self.veryShortStandaloneWeekdaySymbols[i];
            label.tag = i;
            label.textColor = def;
            if ((i+1) == range.location || (i+1) == range.length) {
                label.textColor = color;
            }
            label.font = [UIFont systemFontOfSize:10.f];
            [self addSubview:label];
        }
        UIView *sep = [[UIView alloc] initWithFrame:CGRectMake(0, height, CGRectGetWidth(self.frame), 1.f / [UIScreen mainScreen].scale)];
        sep.backgroundColor = [UIColor colorWithRed:(178/255.0) green:(178/255.0) blue:(178/255.0) alpha:1];
        sep.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
        [self addSubview:sep];
    }
    return self;
}

- (UIColor *)defaultBackgroundColor
{
    return [UIColor colorWithRed:(247/255.0) green:(247/255.0) blue:(247/255.0) alpha:1];
}


@end
