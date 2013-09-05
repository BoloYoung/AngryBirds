//
//  GameUtils.h
//  AngryTry
//
//  Created by apple on 13-7-25.
//  Copyright (c) 2013年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GameUtils : NSObject

+ (int) readLevelFromFile;
+ (void) writeLevelToFile:(int)level;

@end
