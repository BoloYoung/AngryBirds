//
//  LoadingScene.h
//  AngryTry
//
//  Created by apple on 13-7-23.
//  Copyright (c) 2013年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
//CClayer是所有场景的基本类型
@interface LoadingScene : CCLayer
{
    CCLabelBMFont *loadingTitle;
    // 定义一个展示字符串的label
}

+ (id) scene;
@end
