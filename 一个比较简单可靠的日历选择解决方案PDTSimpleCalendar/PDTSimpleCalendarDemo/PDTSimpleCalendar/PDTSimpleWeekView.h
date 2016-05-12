//
//  PDTSimpleWeekView.h
//  PDTSimpleCalendarDemo
//
//  Created by Arron Zhang on 14/11/25.
//  Copyright (c) 2014年 Producteev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PDTSimpleWeekView : UIView

@property (nonatomic, strong, readonly) NSCalendar *calendar;

-(id)initWithFrame:(CGRect)frame calendar:(NSCalendar *)calendar;


@end
