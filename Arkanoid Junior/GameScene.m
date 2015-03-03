//
//  GameScene.m
//  Arkanoid Junior
//
//  Created by Jeremy Bec on 03/03/2015.
//  Copyright (c) 2015 JeremyBec. All rights reserved.
//

#import "GameScene.h"


@interface GameScene()

@property SKSpriteNode *spritePaddle;

@end

@implementation GameScene

-(void)didMoveToView:(SKView *)view {
    /* Setup your scene here */
    [self addPaddle];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    
    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInNode:self];
        
        SKSpriteNode *sprite = [SKSpriteNode spriteNodeWithImageNamed:@"paddle"];
        NSLog(@"Position : %@", NSStringFromCGPoint(location));
        sprite.position = location;
        
        SKAction *action = [SKAction rotateByAngle:M_PI duration:1];
        
        [sprite runAction:[SKAction repeatActionForever:action]];
        
        [self addChild:sprite];
    }
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}

-(void) addPaddle {
    _spritePaddle = [SKSpriteNode spriteNodeWithImageNamed:@"paddle"];
    
    CGPoint initialPosition = CGPointMake(74, 62);
    _spritePaddle.position = initialPosition;
    
    [self addChild:_spritePaddle];
}

@end
