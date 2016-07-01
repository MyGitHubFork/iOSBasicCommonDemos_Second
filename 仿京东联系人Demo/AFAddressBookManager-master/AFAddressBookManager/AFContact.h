//
//  AFContact.h
//
//  Created by Anders Fogh Eriksen on 09/04/13.
//  Copyright (c) 2013-2015 Anders Eriksen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface AFContact : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSArray *numbers;
@property (nonatomic, strong) NSArray *emails;
@property (nonatomic, strong) UIImage *photo;

@end
