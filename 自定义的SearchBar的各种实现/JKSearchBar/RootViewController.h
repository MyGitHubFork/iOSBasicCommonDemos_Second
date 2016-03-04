//
//  RootViewController.h
//  JKSearchBar
//
//  Created by Jakey on 15/5/3.
//  Copyright (c) 2015年 www.skyfox.org. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JKSearchBar.h"
@interface RootViewController : UIViewController<JKSearchBarDelegate>

@property (weak, nonatomic) IBOutlet JKSearchBar *searchBar;

@end
