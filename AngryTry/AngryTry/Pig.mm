//
//  Pig.m
//  AngryTry
//
//  Created by apple on 13-7-25.
//  Copyright (c) 2013年 apple. All rights reserved.
//

#import "Pig.h"

@implementation Pig
- (id)initWithX:(float)x andY:(float)y andWorld:(b2World *)world andLayer:(CCLayer<SpriteDelegate> *)layer
{
    myWorld = world;
    imageUrl = @"pig";
    myLayer = layer;
    // mylayer表示gamelayer
    self = [super initWithFile:[NSString stringWithFormat:@"%@1.png", imageUrl]];
    self.position = ccp(x, y);
    self.tag = PIG_ID;
    HP = 1;
    float scale = 2;
    self.scale = scale/10;
    
    
    // 定义小猪body的基本数据b2BodyDef
    b2BodyDef ballBodyDef;
    ballBodyDef.type = b2_dynamicBody;                      // 动态刚体
    ballBodyDef.position.Set(x/PTM_RATIO, y/PTM_RATIO);     // 位置
    ballBodyDef.userData = self;                            // 数据
    // 通过world使用特征def创建小猪body
    b2Body * ballBody = world->CreateBody(&ballBodyDef);
    
    myBody = ballBody;
    
    // 设置多边形参数
    float size = 0.12f;
    // 形状类定义
    b2PolygonShape blockShape;
    b2Vec2 vertices[] = {
        b2Vec2(size ,-2*size),
        b2Vec2(2*size,-size),
        b2Vec2(2*size,size),
        
        b2Vec2(size,2*size),
        b2Vec2(-size,2*size),
        b2Vec2(-2*size,size),
        b2Vec2(-2*size,-size),
        b2Vec2(-size,-2*size)
    };
    // 定义点阵
    blockShape.Set(vertices, 8);
    
    // 设置物理特性
    b2FixtureDef ballShapeDef;
    ballShapeDef.shape = &blockShape;
    ballShapeDef.density = 80.0f;                 // 密度
    ballShapeDef.friction = 80.0f;                // 摩擦力
    ballShapeDef.restitution = 0.15f;             // 反弹系数
    // 创建物理特性
    ballBody->CreateFixture(&ballShapeDef);
    return self;
}

@end
