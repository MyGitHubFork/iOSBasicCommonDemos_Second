//
//  LLNNetworkingResult.h
//  Low-Level Networking
//
//  Copyright (c) 2012 John Szumski. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LLNNetworkingResult : NSObject

@property(nonatomic,strong) NSNumber	*temperatureRoom;
@property(nonatomic,strong) NSNumber	*temperatureOutlet;
@property(nonatomic,strong) NSNumber	*temperatureCoil;

@property(nonatomic,assign) BOOL		statusCompressorOn;
@property(nonatomic,assign) BOOL		statusAirSwitchOn;
@property(nonatomic,assign) BOOL		statusAuxilaryHeatOn;
@property(nonatomic,assign) BOOL		statusFrontDoorOpen;
@property(nonatomic,assign) BOOL		statusSystemStandby;
@property(nonatomic,assign) BOOL		statusAlarmActive;

@end