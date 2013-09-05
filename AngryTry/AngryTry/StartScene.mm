//
//  StartScene.m
//  AngryTry
//
//  Created by apple on 13-7-24.
//  Copyright (c) 2013年 apple. All rights reserved.
//

#import "StartScene.h"
#import "StartBGScene.h"
#import "StartButtonScene.h"

@implementation StartScene

+ (id) scene
{
    CCScene *sc = [CCScene node];
    StartScene *startscene = [StartScene node];
    [sc addChild:startscene];
    return sc;
}

- (id)init
{
    self = [super init];
    if (self)
    {
        StartBGScene *bgscene = [StartBGScene scene];
        StartButtonScene *buttonscene = [StartButtonScene scene];
        [self addChild:bgscene];
        [self addChild:buttonscene];
    }
    return self;
}

@end
