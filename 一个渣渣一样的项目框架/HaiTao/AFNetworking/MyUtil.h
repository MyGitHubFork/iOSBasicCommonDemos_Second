//
//  MyUtil.h
//  gatako
//
//  Created by 光速达 on 15-2-3.
//  Copyright (c) 2015年 光速达. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CommonCrypto/CommonDigest.h>
@interface MyUtil : NSObject

+(MyUtil  *)shareUtil;

//判断字符串是否为空
+ (BOOL) isEmptyString:(NSString *)string;
//对象转换成utf8json
+ (NSString *) toJsonUTF8String:(id)obj;

//将图片压缩 保存至本地沙盒
+ (void) saveImage:(UIImage *)currentImage withName:(NSString *)imageName andCompressionQuality:(CGFloat) quality ;

//颜色值转化 ＃ffffff 转化成10进制
+(int)colorStringToInt:(NSString *)colorStrig colorNo:(int)colorNo;

//验证手机号码格式
+ (BOOL)isValidateTelephone:(NSString *)str;

//利用正则表达式验证邮箱
+(BOOL)isValidateEmail:(NSString *)email;

/**
 *  利用正则表达式验证邮编
 */
+ (BOOL)validateZipcode:(NSString *)zipcode;

+(NSString *)getFormatDate:(NSDate *)date;

+(NSString *)trim:(NSString *)string;

+ (NSString *)md5HexDigest:(NSString*)input;

+ (BOOL) validateIdentityCard: (NSString *)identityCard;

/**
 *  将站内信中的『&nbsp;』字符转为空格字符
 */
+ (NSString *)specialCharactersToSpaceCharacters:(NSString *)specialCharacters;

/**
 *  将手机号或身份证号的中间数字转为*字符
 */
+ (NSString *)encryptTelephoneOrIDCard:(NSString *)number;

// 判断是否要在『选择商品属性和数量』界面 显示尺码说明的提示文字
+ (BOOL)isNeedSizeAdvice:(NSString *)categoryID;

// 创建Label的方法
+ (UILabel *)createLabelWithFrame:(CGRect)frame title:(NSString *)title textColor:(UIColor *)color font:(UIFont *)font textAlignment:(NSTextAlignment)textAlignment numberOfLines:(NSInteger)numberOfLines;

// 创建Label的另外一个方法
+ (UILabel *)createLabelWithFrame:(CGRect)frame title:(NSString *)title font:(UIFont *)font;

// 创建按钮的方法
+ (UIButton *)createButtonWithFrame:(CGRect)frame title:(NSString *)title backgroundImageName:(NSString *)bgImageName selectImageName:(NSString *)selectImageName target:(id)target action:(SEL)action;

// 创建图片视图的方法
+ (UIImageView *)createImageViewWithFrame:(CGRect)frame imageName:(NSString *)imageName;

// 创建文字输入框的方法
+ (UITextField *)createTextField:(CGRect)frame placeHolder:(NSString *)placeHolder;

// 创建 TableView 的方法
+ (UITableView *)createTableViewWithFrame:(CGRect)frame style:(UITableViewStyle)style delegate:(id<UITableViewDelegate> _Nullable)delegate dataSource:(id<UITableViewDataSource> _Nullable)dataSource;

@end
