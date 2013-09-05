//
//  ParticleManager.h
//  AngryTry
//
//  Created by apple on 13-7-25.
//  Copyright (c) 2013年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h" 

// 定义两种例子效果
typedef enum{
    ParticleTypeSnow,
    ParticleTypeBirdExplosion,
    ParticleTypeMax
} ParticleTypes;

@interface ParticleManager : NSObject

+ (id) sharedParticleManager;
// 取得单例对象
- (CCParticleSystem *) particleWithType:(ParticleTypes)type;
// 取得指定TYPE的粒子对象

@end
