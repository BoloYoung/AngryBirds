//
//  Bird.h
//  AngryTry
//
//  Created by apple on 13-7-25.
//  Copyright (c) 2013年 apple. All rights reserved.
//

#import "SpriteBase.h"

@interface Bird : SpriteBase
{
    BOOL _isFly;
    BOOL _isReady;
}

@property (nonatomic, assign) BOOL isFly;
@property (nonatomic, assign) BOOL isReady;

- (void) setSpeedX:(float)x andY:(float)y andWorld:(b2World *)world;
- (void) hitAnimationX:(float)x andY:(float)y;

@end
