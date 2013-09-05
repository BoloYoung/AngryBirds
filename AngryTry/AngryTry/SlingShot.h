//
//  SlingShot.h
//  MyBox2dTest
//
//  Created by apple on 13-7-29.
//  Copyright (c) 2013年 apple. All rights reserved.
//

#import "CCSprite.h"

@interface SlingShot : CCSprite
{
    CGPoint _startPoint;
    
    CGPoint _endPoint;
}

@property (nonatomic, assign) CGPoint startPoint;
@property (nonatomic, assign) CGPoint endPoint;

@end
