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
    [self addBricks];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
}

-(void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    location.y = _spritePaddle.position.y;
    
    if(location.x > _spritePaddle.size.width/2 && location.x < self.size.width - _spritePaddle.size.width/2)
        _spritePaddle.position = location;
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

-(void) addBricks {
    
    for (int count = 0; count<=4; count++) {
        SKSpriteNode *brickRed = [SKSpriteNode spriteNodeWithImageNamed:@"brick-red"];
        CGPoint brickInitPoint = CGPointMake(10 + ((brickRed.size.width + 10) *count), 300);
        brickRed.position = brickInitPoint;
        [self addChild:brickRed];
    }
}

@end
