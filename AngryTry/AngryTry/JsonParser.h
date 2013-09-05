//
//  JsonParser.h
//  MyBox2dTest
//
//  Created by apple on 13-7-29.
//  Copyright (c) 2013年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SpriteModel : NSObject
{
    int tag;
    float x;
    float y;
    float angle;
}
@property (nonatomic, assign) int tag;
@property (nonatomic, assign) float x;
@property (nonatomic, assign) float y;
@property (nonatomic, assign) float angle;

@end

@interface JsonParser : NSObject

+ (id) getAllSprite:(NSString *)file;

@end
