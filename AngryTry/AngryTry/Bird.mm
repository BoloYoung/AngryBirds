//
//  Bird.m
//  AngryTry
//
//  Created by apple on 13-7-25.
//  Copyright (c) 2013年 apple. All rights reserved.
//

#import "Bird.h"

@implementation Bird
@synthesize isFly = _isFly, isReady = _isReady;

- (id)initWithX:(float)x andY:(float)y andWorld:(b2World *)world andLayer:(CCLayer<SpriteDelegate> *)layer
{
    myLayer = layer;
    imageUrl = @"bird";
    myWorld = world;
    self = [super initWithFile:[NSString stringWithFormat:@"%@1.png",imageUrl]];
    // 调用cocos2d里面的创建精灵方法
    self.tag = BIRD_ID;
    self.position = ccp(x, y);
    HP = 10000;
    self.scale = 0.3f;
    return self;
}

- (void) setSpeedX:(float)x andY:(float)y andWorld:(b2World *)world
{
    myWorld = world;
    // 给精灵创建一个2bBody
    b2BodyDef bodyAttr;
    bodyAttr.type = b2_dynamicBody;
    bodyAttr.position.Set(self.position.x/PTM_RATIO,
                          self.position.y/PTM_RATIO);
    bodyAttr.userData = self;
    b2Body *birdbody = world->CreateBody(&bodyAttr);
    
    // 创建圆形属性
    b2CircleShape shape;
    shape.m_radius = 5.0f/PTM_RATIO;
    
    // 创建形状属性
    b2FixtureDef fixtureAttr;
    fixtureAttr.shape = &shape;
    fixtureAttr.density = 50.0f;
    fixtureAttr.friction = 0.50f;             //
    fixtureAttr.restitution = 0.5f;          // 反弹系数
    birdbody->CreateFixture(&fixtureAttr);
    
    b2Vec2 force = b2Vec2(x, y);
//    birdbody->ApplyLinearImpulse(force, b2Vec2(85, 125));
    //    NSLog(@"x = %f, y = %f", x, y);
//    NSLog(@"x = %f, y = %f",bodyAttr.position.x ,bodyAttr.position.y);
    birdbody->ApplyLinearImpulse(force, bodyAttr.position);
//    NSLog(@"起飞");
    // 给球中心点一个力
}

- (void) hitAnimationX:(float)x andY:(float)y
{
    // 碰撞时小鸟掉毛
    for (int i = 0; i < 6; i++) {
        // 掉毛范围值
        int range = 2;
        
        // 创建羽毛Sprite，并设置相应变量
        CCSprite *temp = [CCSprite spriteWithFile:@"yumao1.png"];
        temp.scale = (float)(arc4random()%3/10.0f);
        temp.position = CGPointMake((x+arc4random()%10*range-10), (y+arc4random()%10*range-10));
        
        // 设置羽毛动作，移动，淡出，旋转，调用runEnd:方法
        CCMoveTo *actionMove = [CCMoveTo actionWithDuration:0.5 position:CGPointMake(x+arc4random()%10*range-10, y+arc4random()%10*range-10)];
        CCAction *actionAlpha = [CCFadeOut actionWithDuration:0.5];
        CCAction *actionRotate = [CCRotateBy actionWithDuration:0.5 angle:arc4random()%180];
        CCAction *actionMoveEnd = [CCCallFuncN actionWithTarget:self selector:@selector(runEnd:)];
        
        // 加入动作，Spawn为动作同时发生
        CCSpawn *mut = [CCSpawn actions:actionMove, actionAlpha, actionRotate, nil];
        [temp runAction:[CCSequence actions:mut, actionMoveEnd, nil]];

        [myLayer addChild:temp];
    }
}

@end
