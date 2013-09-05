//
//  GameUtils.m
//  AngryTry
//
//  Created by apple on 13-7-25.
//  Copyright (c) 2013年 apple. All rights reserved.
//

#import "GameUtils.h"

@implementation GameUtils
+ (NSString *) getLevelFilePath
{
    // 得到成功通过关卡的文件
    return [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"SuccessLevel"];
    // 存在沙盒 Documents/SuccessLevel;
}

+ (int) readLevelFromFile
{
    NSString *file = [[self class] getLevelFilePath];
    // 获取文件路径
    NSString *s = [NSString stringWithContentsOfFile:file encoding:NSUTF8StringEncoding error:nil];
    if (s)
    {
        return [s intValue];
    }
    return 2;
}

+ (void) writeLevelToFile:(int)level
{
    NSString *s = [NSString stringWithFormat:@"%d", level];
    // 把level转换成字符串
    NSString *file = [[self class] getLevelFilePath];
    // 取得要存放的文件
    [s writeToFile:file atomically:YES encoding:NSUTF8StringEncoding error:nil];
}

@end
