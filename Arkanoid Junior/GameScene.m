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
@property SKSpriteNode *spriteBall;
@property SKNode *bottomEdge;
@property (nonatomic) BOOL isFingerOnPaddle;

@end

// categoryBitMasks. Permet de définir à quelle categorie un body appartiens.
static const uint32_t ballCategory  = 0x1 << 0;  // 00000000000000000000000000000001
static const uint32_t bottomCategory = 0x1 << 1; // 00000000000000000000000000000010
static const uint32_t blockCategory = 0x1 << 2;  // 00000000000000000000000000000100
static const uint32_t paddleCategory = 0x1 << 3; // 00000000000000000000000000001000

@implementation GameScene

-(void)didMoveToView:(SKView *)view {
    /* Appels de nos méthodes */
    [self addPaddle];
    [self addBricks];
    [self addBall];
    [self addBottom];
    
    self.physicsWorld.contactDelegate = self;
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

-(void)touchesEnded:(NSSet*)touches withEvent:(UIEvent*)event {
    self.isFingerOnPaddle = NO;
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
    
    // Definition des bitmasks
    _spritePaddle.physicsBody.categoryBitMask = paddleCategory;
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
    _spriteBall = [SKSpriteNode spriteNodeWithImageNamed:@"ball"];
    CGPoint ballStartingPoint = CGPointMake(self.size.width/2, 200);
    _spriteBall.position = ballStartingPoint;
    
    // Ajout d'un corsp physique à notre balle
    _spriteBall.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:_spriteBall.frame.size.width/2];
    // Desactiver la friction sur notre balle
    _spriteBall.physicsBody.friction = 0.0f;
    // Définir la restitution. La balle rebondira avec autant de force que l'impact
    _spriteBall.physicsBody.restitution = 1.0f;
    // Simule une friction de l'air, notre balle ne veut pas être ralentie lorsqu'elle bouge.
    _spriteBall.physicsBody.linearDamping = 0.0f;
    _spriteBall.physicsBody.allowsRotation = NO;
    
    //Définition des bitmasks
    _spriteBall.physicsBody.categoryBitMask = ballCategory;
    _spriteBall.physicsBody.contactTestBitMask = bottomCategory;
    
    [self addChild:_spriteBall];
    
    
}

-(void) addBottom {
    // Ajout du rectangle pour detection de l'écran gameover
    CGRect bottomRect = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, 1);
    _bottomEdge = [SKNode node];
    // Ajout d'un corps physique pour pouvoir détecter le contact avec la balle
    _bottomEdge.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:bottomRect];
    
    //Définition des bitmasks
    _bottomEdge.physicsBody.categoryBitMask = bottomCategory;
    
    [self addChild:_bottomEdge];
}


// Delegates

-(void) didBeginContact:(SKPhysicsContact *)contact {
    // Body pour pouvoir stocker les informations passées au delegate
    SKPhysicsBody *firstBody;
    SKPhysicsBody *secondBody;
    
    // Faire en sorte que l'objet qui possède la catégorie la plus faible soit toujours le premier Body
    if (contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask) {
        firstBody = contact.bodyA;
        secondBody = contact.bodyB;
    } else {
        firstBody = contact.bodyB;
        secondBody = contact.bodyA;
    }
    
    // Permet de gérer l'écran du Game Over
    if (firstBody.categoryBitMask == ballCategory && secondBody.categoryBitMask == bottomCategory) {
        NSLog(@"La balle à touché le sol");
    }
}

@end
