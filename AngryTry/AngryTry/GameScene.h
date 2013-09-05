//
//  GameScene.h
//  AngryTry
//
//  Created by apple on 13-7-25.
//  Copyright (c) 2013年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "SpriteBase.h"
#import "Bird.h"
#import "Pig.h"
#import "Ice.h"
#import "JsonParser.h"
#import "SlingShot.h"
#import "MyContactListener.h"

@interface GameScene : CCLayer<SpriteDelegate>
{
    int currentLevel;
    int GameScore;
    int PigsCount;
    int BirdsCount;
    
    CCLabelTTF *scoreStrlabel;
    CCLabelBMFont *scoreNumlabel;

    NSMutableArray *birds;
    
    Bird *currentBird;
    BOOL gameStart;
    BOOL gameFinish;
    
    SlingShot *slingShot1;
    SlingShot *slingShot2;
    int touchStatus;
    
    // 定义一个世界
    b2World *world;
    
    //
    MyContactListener *contactListrner;
}

// level 关卡的数字
+ (id) sceneWithLevel:(int)level;
- (id) initWithLevel:(int)level;

@end
