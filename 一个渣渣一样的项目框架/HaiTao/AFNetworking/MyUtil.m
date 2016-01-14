//
//  MyUtil.m
//  gatako
//
//  Created by 光速达 on 15-2-3.
//  Copyright (c) 2015年 光速达. All rights reserved.
//

#import "MyUtil.h"

@implementation MyUtil

+ (MyUtil *)shareUtil
{
    static dispatch_once_t onceToken;
    static MyUtil *singleton;
    dispatch_once(&onceToken, ^{
      singleton = [[MyUtil alloc] init];
    });
    NSLog(@"-------singletonAlipay---------%@", singleton);
    return singleton;
}

+ (BOOL)isEmptyString:(NSString *)string
{
    if (string == nil || string == NULL) {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length] == 0) {
        return YES;
    }
    return NO;
}
+ (NSString *)toJsonUTF8String:(id)obj
{
    NSError *error = nil;
    NSData *data = [NSJSONSerialization dataWithJSONObject:obj options:NSJSONWritingPrettyPrinted error:&error];

    if (error) {
        NSLog(@"%@", error);
    }
    NSString *json = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return json;
}

+ (void)saveImage:(UIImage *)currentImage withName:(NSString *)imageName andCompressionQuality:(CGFloat)quality
{
    NSData *imageDate = UIImageJPEGRepresentation(currentImage, quality);
    NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:imageName];

    NSLog(@"%@", fullPath);
    [imageDate writeToFile:fullPath atomically:NO];
}

//颜色值转化 ＃ffffff 转化成10进制
+ (int)colorStringToInt:(NSString *)colorStrig colorNo:(int)colorNo
{
    const char *cstr;
    int iPosition = 0;
    int nColor = 0;
    cstr = [colorStrig UTF8String];

    //判断是否有#号
    if (cstr[0] == '#')
        iPosition = 1; //有#号，则从第1位开始是颜色值，否则认为第一位就是颜色值
    else
        iPosition = 0;

    //第1位颜色值
    iPosition = iPosition + colorNo * 2;
    if (cstr[iPosition] >= '0' && cstr[iPosition] < '9')
        nColor = (cstr[iPosition] - '0') * 16;
    else
        nColor = (cstr[iPosition] - 'A' + 10) * 16;

    //第2位颜色值
    iPosition++;
    if (cstr[iPosition] >= '0' && cstr[iPosition] < '9')
        nColor = nColor + (cstr[iPosition] - '0');
    else
        nColor = nColor + (cstr[iPosition] - 'A' + 10);

    return nColor;
}

//验证手机号码格式
+ (BOOL)isValidateTelephone:(NSString *)str
{

    if ([str length] == 0) {

        return NO;
    }

    NSString *regex = @"^1[3|4|5|8|7]\\d{9}$";
    //    NSString *regex = @"^((13[0-9])|(147)|(15[^4,\\D])|(18[0,5-9]))\\d{8}$";

    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];

    BOOL isMatch = [pred evaluateWithObject:str];

    if (!isMatch) {

        return NO;
    }

    return YES;
}

//利用正则表达式验证邮箱
+ (BOOL)isValidateEmail:(NSString *)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

+ (BOOL)validateZipcode:(NSString *)zipcode
{
    NSString *zipcodeRegex = @"\\d{6}";
    NSPredicate *zipcodeTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", zipcodeRegex];
    return [zipcodeTest evaluateWithObject:zipcode];
}

+ (NSString *)getFormatDate:(NSDate *)date
{
    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    //用[NSDate date]可以获取系统当前时间
    NSString *currentDateStr = [dateFormatter stringFromDate:date];

    return currentDateStr;
}
+ (NSString *)trim:(NSString *)string
{
    NSString *result = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    return result;
}

+ (NSString *)md5HexDigest:(NSString *)input
{
    const char *cStr = [input UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStr, strlen(cStr), result);

    return [[NSString stringWithFormat:@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
                                       result[0], result[1], result[2], result[3],
                                       result[4], result[5], result[6], result[7],
                                       result[8], result[9], result[10], result[11],
                                       result[12], result[13], result[14], result[15]] lowercaseString];
}

//身份证号
+ (BOOL)validateIdentityCard:(NSString *)identityCard
{
    BOOL flag;
    if (identityCard.length <= 0) {
        flag = NO;
        return flag;
    }
    NSString *regex2 = @"^(\\d{14}|\\d{17})(\\d|[xX])$";
    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex2];
    return [identityCardPredicate evaluateWithObject:identityCard];
}

// 将站内信中的『&nbsp;』字符转为空格字符
+ (NSString *)specialCharactersToSpaceCharacters:(NSString *)specialCharacters
{
    return [specialCharacters stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@"\x20\x20"];
}

// 将手机号或身份证号的中间数字 @"0"||@"1"||@"2"||@"3"||@"4"||@"5"||@"6"||@"7"||@"8"||@"9" 转为*字符
+ (NSString *)encryptTelephoneOrIDCard:(NSString *)number
{
    //    return [number stringByReplacingOccurrencesOfString:@"^[0-9]*$" withString:@"*" options:NSCaseInsensitiveSearch range:NSMakeRange(3, number.length - 6)];
    NSString *frontStr = [number substringWithRange:NSMakeRange(0, 3)];
    NSString *lastStr = [number substringWithRange:NSMakeRange(number.length - 3, 3)];
    if (number.length == 11) {
        return [[frontStr stringByAppendingString:@"*****"] stringByAppendingString:lastStr];
    }
    else if (number.length == 18) {
        return [[frontStr stringByAppendingString:@"************"] stringByAppendingString:lastStr];
    }
    else if (number.length == 15) {
        return [[frontStr stringByAppendingString:@"*********"] stringByAppendingString:lastStr];
    }
    return number;
}

// 判断是否要在『选择商品属性和数量』界面 显示尺码说明的提示文字
+ (BOOL)isNeedSizeAdvice:(NSString *)categoryID {
    NSArray *needAdviceCategoryIDs = @[@"211", @"369", @"15", @"156", @"158", @"159", @"160", @"161", @"162", @"166", @"168", @"169", @"172", @"182", @"190", @"192", @"194", @"195", @"202", @"203", @"206", @"207", @"208", @"210", @"396"];
    for (NSString *needAdviceCategoryID in needAdviceCategoryIDs) {
        if ([categoryID isEqualToString:needAdviceCategoryID]) {
            return YES;
        };
    }
    return NO;
}

+ (UILabel *)createLabelWithFrame:(CGRect)frame title:(NSString *)title textColor:(UIColor *)color font:(UIFont *)font textAlignment:(NSTextAlignment)textAlignment numberOfLines:(NSInteger)numberOfLines
{
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    if (title) {
        label.text = title;
    }
    if (color) {
        label.textColor = color;
    }
    if (font) {
        label.font = font;
    }
    if (textAlignment) {
        label.textAlignment = textAlignment;
    }
    if (numberOfLines) {
        label.numberOfLines = numberOfLines;
    }

    return label;
}

+ (UILabel *)createLabelWithFrame:(CGRect)frame title:(NSString *)title font:(UIFont *)font
{
    return [self createLabelWithFrame:frame title:title textColor:[UIColor blackColor] font:font textAlignment:NSTextAlignmentLeft numberOfLines:1];
}


+ (UIButton *)createButtonWithFrame:(CGRect)frame title:(NSString *)title backgroundImageName:(NSString *)bgImageName selectImageName:(NSString *)selectImageName target:(id)target action:(SEL)action
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = frame;
    if (title) {
        [btn setTitle:title forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    if (bgImageName) {
        [btn setBackgroundImage:[UIImage imageNamed:bgImageName] forState:UIControlStateNormal];
    }
    if (selectImageName) {
        [btn setBackgroundImage:[UIImage imageNamed:selectImageName] forState:UIControlStateSelected];
    }
    if (target && action) {
        [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    }
    
    return btn;
}

+ (UITextField *)createTextField:(CGRect)frame placeHolder:(NSString *)placeHolder
{
    UITextField *textField = [[UITextField alloc] initWithFrame:frame];
    if (placeHolder) {
        textField.placeholder = placeHolder;
    }
    textField.borderStyle = UITextBorderStyleRoundedRect;
    return textField;
}

+ (UIImageView *)createImageViewWithFrame:(CGRect)frame imageName:(NSString *)imageName
{
    UIImageView *tmpImageView = [[UIImageView alloc] initWithFrame:frame];
    tmpImageView.image = [UIImage imageNamed:imageName];
    
    return tmpImageView;
}

+ (UITableView *)createTableViewWithFrame:(CGRect)frame style:(UITableViewStyle)style delegate:(id<UITableViewDelegate> _Nullable)delegate dataSource:(id<UITableViewDataSource> _Nullable)dataSource
{
    UITableView *tableView = [[UITableView alloc] initWithFrame:frame style:style];
    tableView.delegate = delegate;
    tableView.dataSource = dataSource;
    
    return tableView;
}

@end
