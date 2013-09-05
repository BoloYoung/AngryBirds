//
//  Ice.m
//  MyBox2dTest
//
//  Created by apple on 13-7-29.
//  Copyright (c) 2013年 apple. All rights reserved.
//

#import "Ice.h"

@implementation Ice

- (id)initWithX:(float)x andY:(float)y andWorld:(b2World *)world andLayer:(CCLayer<SpriteDelegate> *)layer
{
    myWorld = world;
    myLayer = layer;
    imageUrl = @"ice";
    
    HP = 27;
    fullHP = HP;
    self = [self initWithFile:[NSString stringWithFormat:@"%@1.png",imageUrl]];
    self.position = ccp(x, y);
    self.tag = ICE_ID;
    float scale = 2;
    
    self.scale = scale/10;
    
    // 创建刚体，设置基本刚体特征b2BodyDef
    b2BodyDef ballBodyDef;
    ballBodyDef.type = b2_dynamicBody;                      // 动态刚体
    ballBodyDef.position.Set(x/PTM_RATIO, y/PTM_RATIO);     // 位置
    ballBodyDef.userData = self;                            // 数据
    // 使用基本特征通过world创建刚体
    b2Body * ballBody = world->CreateBody(&ballBodyDef);
    
    // 创建多边形，冰块是4方形
    b2PolygonShape blockShape;
    blockShape.SetAsBox(self.contentSize.width/11/PTM_RATIO,self.contentSize.height/11/PTM_RATIO);
    
    // 定义物理特征 b2FixtureDef
    b2FixtureDef ballShapeDef;
    ballShapeDef.shape = &blockShape;                     // 设置形状
    ballShapeDef.density = 10.0f;                         // 密度
    ballShapeDef.friction = 1.0f;                         // 摩擦力
    ballShapeDef.restitution = 0;                         // 反弹系数
    // 添加物理特性到刚体中
    ballBody->CreateFixture(&ballShapeDef);
    
    return self;
}

@end
