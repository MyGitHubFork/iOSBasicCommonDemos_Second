//
//  PDTSimpleCalendarViewCell.m
//  PDTSimpleCalendar
//
//  Created by Jerome Miglino on 10/7/13.
//  Copyright (c) 2013 Producteev. All rights reserved.
//

#import "PDTSimpleCalendarViewCell.h"

const CGFloat PDTSimpleCalendarCircleSize = 38.0f;

@interface PDTSimpleCalendarViewCell ()

@property (nonatomic, strong) UIView *textView;
@property (nonatomic, strong) UILabel *dayLabel;
@property (nonatomic, strong) UILabel *localDayLabel;
@property (nonatomic, strong) CALayer *localDayBorder;

@property (nonatomic, strong) NSDate *date;
@property (strong, nonatomic) UIView *separatorView;
@property (nonatomic, assign) BOOL isHoliday;
@property (nonatomic, strong) UILabel *holidayLabel;

@end

@implementation PDTSimpleCalendarViewCell

@synthesize enabled = _enabled;

#pragma mark - Class Methods

+ (NSString *)formatDate:(NSDate *)date withCalendar:(NSCalendar *)calendar
{
    NSDateFormatter *dateFormatter = [self dateFormatter];
    return [PDTSimpleCalendarViewCell stringFromDate:date withDateFormatter:dateFormatter withCalendar:calendar];
}

+ (NSString *)formatAccessibilityDate:(NSDate *)date withCalendar:(NSCalendar *)calendar
{
    NSDateFormatter *dateFormatter = [self accessibilityDateFormatter];
    return [PDTSimpleCalendarViewCell stringFromDate:date withDateFormatter:dateFormatter withCalendar:calendar];
}


+ (NSDateFormatter *)dateFormatter {
    static NSDateFormatter *dateFormatter;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"d";
    });
    return dateFormatter;
}

+ (NSCalendar *)chineseCalendar {
    static NSCalendar *chineseCalendar;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        chineseCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierChinese];
        chineseCalendar.locale = [NSLocale currentLocale];
    });
    return chineseCalendar;
}

+ (NSDateFormatter *)accessibilityDateFormatter {
    static NSDateFormatter *dateFormatter;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateStyle:NSDateFormatterLongStyle];
        [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    });
    return dateFormatter;
}

+ (NSString *)stringFromDate:(NSDate *)date withDateFormatter:(NSDateFormatter *)dateFormatter withCalendar:(NSCalendar *)calendar {
        //Test if the calendar is different than the current dateFormatter calendar property
    if (![dateFormatter.calendar isEqual:calendar]) {
        dateFormatter.calendar = calendar;
    }
    return [dateFormatter stringFromDate:date];
}

+ (NSArray *)cacheMonthSymbolsForCalendar:(NSCalendar *)calendar {
    static NSMutableDictionary *monthSymbols;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        monthSymbols = [[NSMutableDictionary alloc] init];
    });
    if (!monthSymbols[calendar.calendarIdentifier]) {
        monthSymbols[calendar.calendarIdentifier] = calendar.shortStandaloneMonthSymbols;
    }
    return monthSymbols[calendar.calendarIdentifier];
}

+ (NSArray *)lunarDaySymbols {
    static NSArray *lunarDaySymbols;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        lunarDaySymbols = [NSArray arrayWithObjects:@"初一", @"初二", @"初三", @"初四", @"初五", @"初六", @"初七", @"初八", @"初九", @"初十", @"十一", @"十二", @"十三", @"十四", @"十五", @"十六", @"十七", @"十八", @"十九", @"二十", @"廿一", @"廿二", @"廿三", @"廿四", @"廿五", @"廿六", @"廿七", @"廿八", @"廿九", @"三十", @"三一", nil];
    });
    return lunarDaySymbols;
}

+ (NSArray *)cacheWeekdaySymbolsForCalendar:(NSCalendar *)calendar {
    static NSMutableDictionary *weekdaySymbols;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        weekdaySymbols = [[NSMutableDictionary alloc] init];
    });
    if (!weekdaySymbols[calendar.calendarIdentifier]) {
        weekdaySymbols[calendar.calendarIdentifier] = calendar.weekdaySymbols;
    }
    return weekdaySymbols[calendar.calendarIdentifier];
}

+ (void)addHolidays:(NSDictionary *)holidays{
    [[self holidays] addEntriesFromDictionary:holidays];
}

+ (NSMutableDictionary *)holidays{
    static NSMutableDictionary *holidays;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        holidays = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                    @"春节", @"l1-1",
                    @"元宵", @"l1-15",
                    @"端午", @"l5-5",
                    @"七夕", @"l7-7",
                    @"中元", @"l7-15",
                    @"中秋", @"l8-15",
                    @"重阳", @"l9-9",
                    @"腊八", @"l12-8",
                    @"小年", @"l12-24",
                    @"除夕", @"l12-30",
                    @"元旦", @"1-1",
                    @"情人节", @"2-14",
                    @"雷锋日", @"3-5",
                    @"妇女节", @"3-8",
                    @"植树节", @"3-12",
                    @"消费日", @"3-15",
                    @"愚人节", @"4-1",
                    @"劳动节", @"5-1",
                    @"青年节", @"5-4",
                    @"儿童节", @"6-1",
                    @"建党节", @"7-1",
                    @"建军节", @"8-1",
                    @"教师节", @"9-10",
                    @"国庆", @"10-1",
                    @"平安夜", @"12-24",
                    @"圣诞", @"12-25",
                    nil];
    });
    return holidays;
}

#pragma mark - Instance Methods

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        CGFloat width = CGRectGetWidth(frame);
        _date = nil;
        _enabled = YES;
        _textView = [[UIView alloc] init];
        CGFloat top = 5;
        _dayLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, top, PDTSimpleCalendarCircleSize, 17)];
        _dayLabel.backgroundColor = [UIColor clearColor];
        [self.dayLabel setFont:[self textDefaultFont]];
        [self.dayLabel setTextAlignment:NSTextAlignmentCenter];
        [_textView addSubview:_dayLabel];
        
        _localDayLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, top + 18, PDTSimpleCalendarCircleSize, 10)];
        _localDayLabel.backgroundColor = [UIColor clearColor];
        [self.localDayLabel setFont:[UIFont systemFontOfSize:10.0]];
        [self.localDayLabel setTextAlignment:NSTextAlignmentCenter];
        _localDayBorder = [CALayer layer];
        _localDayBorder.frame = CGRectMake(10.f, 12.f, 18.f, 1.f);
        _localDayBorder.backgroundColor = [self circleSelectedColor].CGColor;
        [_localDayLabel.layer addSublayer:_localDayBorder];
        [_textView addSubview:_localDayLabel];
        
        [self.contentView addSubview:self.textView];
        //Add the Constraints
        [self.textView setBackgroundColor:[UIColor clearColor]];
//        self.textView.layer.cornerRadius = PDTSimpleCalendarCircleSize/2;
//        self.textView.layer.masksToBounds = YES;
        
        self.textView.frame = CGRectMake((width - PDTSimpleCalendarCircleSize)/2, 6.f, PDTSimpleCalendarCircleSize, PDTSimpleCalendarCircleSize);
        self.textView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin |UIViewAutoresizingFlexibleRightMargin;

//        [self.textView setTranslatesAutoresizingMaskIntoConstraints:NO];
//        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.textView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0]];
//        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.textView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTop multiplier:1.0 constant:6.f]];
//        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.textView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:PDTSimpleCalendarCircleSize]];
//        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.textView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:PDTSimpleCalendarCircleSize]];
        
        _separatorView = [[UIView alloc] init];
        [_separatorView setBackgroundColor:[self separatorColor]];
        [self.contentView addSubview:_separatorView];
        
        _separatorView.frame = CGRectMake(-.5f, 0, width + 1, 1.0f / [UIScreen mainScreen].scale);
        _separatorView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleLeftMargin |UIViewAutoresizingFlexibleRightMargin;
        
//        [_separatorView setTranslatesAutoresizingMaskIntoConstraints:NO];
//        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_separatorView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0]];
//        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_separatorView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTop multiplier:1.0 constant:0]];
//        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_separatorView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeWidth multiplier:1.0 constant:1.f]];
//        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_separatorView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:1.0f / [UIScreen mainScreen].scale]];
        
        [self setCircleColor:NO selected:NO];
        
       
    }

    return self;
}

- (UILabel *)holidayLabel{
    if (!_holidayLabel) {
        _holidayLabel = [[UILabel alloc] init];
        _holidayLabel.backgroundColor = [UIColor clearColor];
        [_holidayLabel setFont:[UIFont systemFontOfSize:10.0]];
        [_holidayLabel setTextAlignment:NSTextAlignmentCenter];
        [self.contentView addSubview:_holidayLabel];
        
        _holidayLabel.frame = CGRectMake((CGRectGetWidth(self.contentView.frame) - PDTSimpleCalendarCircleSize)/2, PDTSimpleCalendarCircleSize, PDTSimpleCalendarCircleSize, 24.f);
        _holidayLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        [_holidayLabel setTextColor:[UIColor redColor]];
        
        //        [_holidayLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
        //        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.holidayLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0]];
        //        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.holidayLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTop multiplier:1.0 constant:PDTSimpleCalendarCircleSize]];
        //
        //        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.holidayLabel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:24.f]];
        //        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.holidayLabel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:PDTSimpleCalendarCircleSize]];
    }
    return _holidayLabel;
}

- (void)setDate:(NSDate *)date calendar:(NSCalendar *)calendar
{

    NSString* day = @"";
    NSString* localDay = @"";
    NSString* holiday = nil;
    NSString* accessibilityDay = @"";
    NSString* accessibilitylocalDay = @"";
    if (date && calendar) {

        self.separatorView.hidden = NO;
        _date = date;

        NSDateComponents *components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitWeekday
                                                          fromDate:date];
        //        day = [PDTSimpleCalendarViewCell formatDate:date withCalendar:calendar];
//        accessibilityDay = [PDTSimpleCalendarViewCell formatAccessibilityDate:date withCalendar:calendar];
        day = [@(components.day) stringValue];
        //Cache for performance
        accessibilityDay = [NSString stringWithFormat:@"%@%ld,%@", [self.class cacheMonthSymbolsForCalendar:calendar][components.month - 1], (long)components.day, [self.class cacheWeekdaySymbolsForCalendar:calendar][components.weekday-1], nil];

        NSRange range = [calendar maximumRangeOfUnit:NSCalendarUnitWeekday];
        if (components.weekday == range.location || components.weekday == range.length) {
            self.isWeekend = YES;
        }

        NSCalendar *chineseCalendar = [self.class chineseCalendar];

        NSDateComponents *chineseComponents = [chineseCalendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay
                                                          fromDate:date];

        accessibilitylocalDay = [NSString stringWithFormat:@"%@%@%ld", chineseComponents.leapMonth ? @"闰" : @"", [self.class cacheMonthSymbolsForCalendar:chineseCalendar][chineseComponents.month - 1], (long)chineseComponents.day, nil];

        if (chineseComponents.day == 1) {
            localDay = [self.class cacheMonthSymbolsForCalendar:chineseCalendar][chineseComponents.month - 1];
            if (chineseComponents.leapMonth) {
                localDay = [NSString stringWithFormat:@"闰%@", localDay];
            }
            _localDayBorder.hidden = NO;
        } else {
            _localDayBorder.hidden = YES;
            localDay = self.class.lunarDaySymbols[chineseComponents.day-1];
        }
        NSString *key = [NSString stringWithFormat:@"l%ld-%ld", (long)chineseComponents.month, (long)chineseComponents.day, nil];
        NSDictionary *holidays = [self.class holidays];
        if (!chineseComponents.leapMonth && holidays[key]) {
            holiday = holidays[key];
            self.isHoliday = YES;
        }
        key = [NSString stringWithFormat:@"%ld-%ld", (long)components.month, (long)components.day, nil];
        if (holidays[key]) {
            holiday = holidays[key];
            self.isHoliday = YES;
        }
        key = [NSString stringWithFormat:@"l%ld-%ld-%ld", (long)chineseComponents.year, (long)chineseComponents.month, (long)chineseComponents.day, nil];
        if (!chineseComponents.leapMonth && holidays[key]) {
            holiday = holidays[key];
            self.isHoliday = YES;
        }
        key = [NSString stringWithFormat:@"%ld-%ld-%ld", (long)components.year, (long)components.month, (long)components.day, nil];
        if (holidays[key]) {
            holiday = holidays[key];
            self.isHoliday = YES;
        }
        self.isAccessibilityElement = YES;

    } else {
        self.separatorView.hidden = YES;
        _localDayBorder.hidden = YES;
        self.isAccessibilityElement = NO;
    }

    self.dayLabel.text = day;
    self.dayLabel.accessibilityLabel = accessibilityDay;
    self.localDayLabel.text = localDay;
    if (holiday) {
        self.holidayLabel.text = holiday;
    } else if (_holidayLabel){
        _holidayLabel.text = nil;
    }
    self.accessibilityLabel = [NSString stringWithFormat:@"%@,农历%@,%@", accessibilityDay, accessibilitylocalDay, holiday];

}

- (void)setIsToday:(BOOL)isToday
{
    _isToday = isToday;
}

- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    [self setCircleColor:self.isToday selected:selected];
}


- (void)setCircleColor:(BOOL)today selected:(BOOL)selected
{
    UIColor *circleColor = (today) ? [self circleTodayColor] : [self circleDefaultColor];
    UIColor *labelColor = (today) ? [self textTodayColor] : (self.enabled ? (self.isWeekend ? [self circleSelectedColor] : [self textDefaultColor]) : [self textDisabledColor]);
    UIColor *subColor = (today) ? [self textTodayColor] : (self.enabled ? (self.isWeekend ? [self circleSelectedColor] : [self subTextDefaultColor]) : [self textDisabledColor]);

//    if (self.date && self.delegate) {
//        if ([self.delegate respondsToSelector:@selector(simpleCalendarViewCell:shouldUseCustomColorsForDate:)] && [self.delegate simpleCalendarViewCell:self shouldUseCustomColorsForDate:self.date]) {
//
//            if ([self.delegate respondsToSelector:@selector(simpleCalendarViewCell:textColorForDate:)] && [self.delegate simpleCalendarViewCell:self textColorForDate:self.date]) {
//                labelColor = [self.delegate simpleCalendarViewCell:self textColorForDate:self.date];
//                subColor = [self.delegate simpleCalendarViewCell:self textColorForDate:self.date];
//            }
//
//            if ([self.delegate respondsToSelector:@selector(simpleCalendarViewCell:circleColorForDate:)] && [self.delegate simpleCalendarViewCell:self circleColorForDate:self.date]) {
//                circleColor = [self.delegate simpleCalendarViewCell:self circleColorForDate:self.date];
//            }
//        }
//    }
    
    if (selected) {
        circleColor = [self circleSelectedColor];
        labelColor = [self textSelectedColor];
        subColor = [self textSelectedColor];
    }

    [self.textView setBackgroundColor:circleColor];
    [self.dayLabel setTextColor:labelColor];
    [self.localDayLabel setTextColor:subColor];
}


- (void)refreshCellColors
{
    [self setCircleColor:self.isToday selected:self.isSelected];
}


#pragma mark - Prepare for Reuse

- (void)prepareForReuse
{
    [super prepareForReuse];
    _date = nil;
    _isToday = NO;
    _isWeekend = NO;
    _isHoliday = NO;
    _enabled = YES;
    [self.dayLabel setText:@""];
    [self.localDayLabel setText:@""];
    [self.textView setBackgroundColor:[self circleDefaultColor]];
    [self.dayLabel setTextColor:[self textDefaultColor]];
    [self.localDayLabel setTextColor:[self subTextDefaultColor]];
}

#pragma mark - Circle Color Customization Methods

+(void)initialize{
    [[self appearance] setCircleDefaultColor:[UIColor whiteColor]];
    [[self appearance] setCircleTodayColor:[UIColor grayColor]];
    [[self appearance] setCircleSelectedColor:[UIColor colorWithRed:1.f green:59.f/255.f blue:48.f/255.f alpha:1]];

    [[self appearance] setTextDefaultColor:[UIColor blackColor]];
    [[self appearance] setTextTodayColor:[UIColor whiteColor]];
    [[self appearance] setTextSelectedColor:[UIColor whiteColor]];
    [[self appearance] setTextDisabledColor:[UIColor lightGrayColor]];
    
    CGFloat val = 204.f/255.f;
    [[self appearance] setSeparatorColor:[UIColor colorWithRed:val green:val blue:val alpha:1.f]];

    [[self appearance] setSubTextDefaultColor:[UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:1]];

}

- (UIColor *)subTextDefaultColor{
    return [[[self class] appearance] subTextDefaultColor];
}

- (UIColor *)circleDefaultColor
{
    return [[[self class] appearance] circleDefaultColor];
}

- (UIColor *)circleTodayColor
{
    return [[[self class] appearance] circleTodayColor];
}

- (UIColor *)circleSelectedColor
{
    return [[[self class] appearance] circleSelectedColor];
}

#pragma mark - Text Label Customizations Color

- (UIColor *)textDefaultColor
{
    return [[[self class] appearance] textDefaultColor];
}

- (UIColor *)textTodayColor
{
    return [[[self class] appearance] textTodayColor];
}

- (UIColor *)textSelectedColor
{
    return [[[self class] appearance] textSelectedColor];
}

- (UIColor *)textDisabledColor
{
    return [[[self class] appearance] textDisabledColor];
}

- (UIColor *)separatorColor
{
    return [[[self class] appearance] separatorColor];
}

#pragma mark - Text Label Customizations Font

#pragma mark - Text Label Customizations Font

- (UIFont *)textDefaultFont
{
    UIFont *font = [[[self class] appearance] textDefaultFont];
    if (!font) {
        font = [UIFont systemFontOfSize:17.0];
        [[self.class appearance] setTextDefaultFont:font];
    }
    return font;
}

@end
