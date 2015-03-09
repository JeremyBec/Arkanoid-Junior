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
    /* Setup de notre scène */
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
    // Création du paddle
    _spritePaddle = [SKSpriteNode spriteNodeWithImageNamed:@"paddle"];
    
    CGPoint initialPosition = CGPointMake(self.size.width/2, 62);
    _spritePaddle.position = initialPosition;
    _spritePaddle.name = @"paddle";
    [self addChild:_spritePaddle];
    
    _spritePaddle.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:_spritePaddle.frame.size];
    _spritePaddle.physicsBody.restitution = 0.1f;
    _spritePaddle.physicsBody.friction = 0.4f;
    // Rendre le physicsBody static
    _spritePaddle.physicsBody.dynamic = NO;
}

-(void) addBricks {
    // Création des briques
    for (int count2 = 0; count2 < 3; count2++)
    {
        for (int count = 0; count<=3; count++) {
            SKSpriteNode *brickRed = [SKSpriteNode spriteNodeWithImageNamed:@"brick-red"];
            CGPoint brickInitPoint = CGPointMake((brickRed.size.width/2)+ 30 + ((brickRed.size.width + 10) *count), 400 + ((brickRed.size.height + 30) * count2));
            brickRed.position = brickInitPoint;
            brickRed.name = [NSString stringWithFormat:@"brick%i", count];
            [self addChild:brickRed];
        }
    }
}

-(void) addBall {
    // Création de la balle
    SKSpriteNode *ball = [SKSpriteNode spriteNodeWithImageNamed:@"ball"];
    CGPoint ballStartingPoint = CGPointMake(self.size.width/2, 200);
    ball.position = ballStartingPoint;
    [self addChild:ball];
    
    // Ajout d'un body "physique" à notre balle
    ball.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:ball.frame.size.width/2];
    // Desactiver la friction sur notre balle
    ball.physicsBody.friction = 0.0f;
    // Définir la restitution. La balle rebondira avec autant de force que l'impact
    ball.physicsBody.restitution = 1.0f;
    // Simule une friction de l'air, notre balle ne veut pas être ralentie lorsqu'elle bouge.
    ball.physicsBody.linearDamping = 0.0f;
    ball.physicsBody.allowsRotation = NO;
}

@end
