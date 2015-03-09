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
    [self addBall];
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
    for (int count2 = 0; count2 < 3; count2++)
    {
        for (int count = 0; count<=3; count++) {
            SKSpriteNode *brickRed = [SKSpriteNode spriteNodeWithImageNamed:@"brick-red"];
            CGPoint brickInitPoint = CGPointMake((brickRed.size.width/2)+ 30 + ((brickRed.size.width + 10) *count), 400 + ((brickRed.size.height + 30) * count2));
            brickRed.position = brickInitPoint;
            [self addChild:brickRed];
        }
    }
}

-(void) addBall {
    SKSpriteNode *ball = [SKSpriteNode spriteNodeWithImageNamed:@"ball"];
    CGPoint ballStartingPoint = CGPointMake(self.size.width/2, 200);
    ball.position = ballStartingPoint;
    [self addChild:ball];
}

@end
