//
//  GameScene.m
//  Arkanoid Junior
//
//  Created by Jeremy Bec on 03/03/2015.
//  Copyright (c) 2015 JeremyBec. All rights reserved.
//

#import "GameScene.h"
#import "GameResultScene.h"

@interface GameScene()

@property SKSpriteNode *spritePaddle;
@property SKSpriteNode *spriteBall;
@property SKNode *bottomEdge;
@property int heartNumber;
@property int brickRemaining;
@property BOOL contactFinished;
@property NSMutableArray* heartArray;

@end

// categoryBitMasks. Permet de définir à quelle categorie un body appartiens.
static const uint32_t ballCategory  = 0x1 << 0;  // 00000000000000000000000000000001
static const uint32_t bottomCategory = 0x1 << 1; // 00000000000000000000000000000010
static const uint32_t brickCategory = 0x1 << 2;  // 00000000000000000000000000000100
static const uint32_t paddleCategory = 0x1 << 3; // 00000000000000000000000000001000

@implementation GameScene

-(void)didMoveToView:(SKView *)view {
    /* Appels de nos méthodes */
    [self addPaddle];
    [self addBricks];
    [self addHearts];
    [self addBall];
    [self addBottom];
    [self addBorders];
    
    self.physicsWorld.contactDelegate = self;
    self.physicsWorld.gravity = CGVectorMake(0.0f, -0.5f);
    _contactFinished = NO;
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
    _spritePaddle.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:_spritePaddle.frame.size];
    _spritePaddle.physicsBody.restitution = 0.1f;
    _spritePaddle.physicsBody.friction = 0.4f;
    // Rendre le physicsBody static
    _spritePaddle.physicsBody.dynamic = NO;
    
    // Definition des bitmasks
    _spritePaddle.physicsBody.categoryBitMask = paddleCategory;
    
    [self addChild:_spritePaddle];
}

-(void) addBricks {
    // Création des briques
    for (int count2 = 0; count2 < 3; count2++)
    {
        for (int count = 0; count<=3; count++) {
            SKSpriteNode *brickRed = [SKSpriteNode spriteNodeWithImageNamed:@"brick-red"];
            CGPoint brickInitPoint = CGPointMake((brickRed.size.width/2)+ 30 + ((brickRed.size.width + 10) *count), 400 + ((brickRed.size.height + 30) * count2));
            brickRed.position = brickInitPoint;
            
            brickRed.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:brickRed.frame.size];
            brickRed.physicsBody.allowsRotation = NO;
            brickRed.physicsBody.friction = 0.0f;
            brickRed.physicsBody.dynamic = NO;
            
            //Définitiondes bitmasks
            brickRed.physicsBody.categoryBitMask = brickCategory;
            
            _brickRemaining ++;
            [self addChild:brickRed];
        }
    }
}

-(void) addHearts {
    _heartNumber = 5;
    _heartArray = [[NSMutableArray alloc]init];
    for(int heartCount = 0; heartCount <=_heartNumber; heartCount ++) {
        SKSpriteNode *spriteHeart = [SKSpriteNode spriteNodeWithImageNamed:@"heart"];
        CGPoint heartPosition = CGPointMake(((self.frame.size.width-30)-(spriteHeart.size.width + 30)*heartCount), self.frame.size.height-30);
        spriteHeart.position = heartPosition;
        [_heartArray addObject:spriteHeart];
        [self addChild:spriteHeart];
    }
    
}

-(void) addBall {
    // Création de la balle
    _spriteBall = [SKSpriteNode spriteNodeWithImageNamed:@"ball"];
    CGPoint ballStartingPoint = CGPointMake(self.size.width/2, 130);
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
    _spriteBall.physicsBody.contactTestBitMask = bottomCategory | brickCategory;
    
    [self addChild:_spriteBall];
    
    [_spriteBall.physicsBody applyImpulse:CGVectorMake(1.0f, -5.0f)];
    
    
}

-(void) addBottom {
    // Ajout du rectangle pour detection de l'écran gameover
    CGRect bottomRect = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, 1);
    _bottomEdge = [SKNode node];
    // Ajout d'un corps physique pour pouvoir détecter le contact avec la balle
    _bottomEdge.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:bottomRect];
    
    //Définition des bitmasks
    _bottomEdge.physicsBody.categoryBitMask = bottomCategory;
    
    [self addChild:_bottomEdge];
}

-(void) addBorders {
    SKPhysicsBody *borderBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:self.frame];
    self.physicsBody = borderBody;
    self.physicsBody.friction = 0.0f;
}

-(BOOL) isGameWon {
    if(_brickRemaining == 0) {
        return YES;
    } else {
        return NO;
    }
}

-(void) presentResultScene:(BOOL) playerWon {
    
    GameResultScene *gameResultScene = [[GameResultScene alloc] initWithSize:self.frame.size playerWon:playerWon];
    gameResultScene.userData = [NSMutableDictionary dictionary];
    NSNumber *scoreResult = [NSNumber numberWithInt:_score];
    [gameResultScene.userData setObject:scoreResult forKey:@"score"];
    SKTransition *crossFade = [SKTransition crossFadeWithDuration:1.0f];
    [self.view presentScene:gameResultScene transition:crossFade];
}

- (void)ResetBallAndHeart:(SKPhysicsBody *)firstBody {
    if (_contactFinished == YES) {
        // Supprimer la balle
        [firstBody.node removeFromParent];
        
        // Supprimer le coeur
        _heartNumber -= 1;
        SKSpriteNode *heartToDelete = [_heartArray lastObject];
        [_heartArray removeLastObject];
        [heartToDelete removeFromParent];
        
        // Afficher la balle et reset le bool de collision
        [self performSelector:@selector(addBall) withObject:nil afterDelay:0.5];
        NSLog(@"Il vous reste %d coeur", _heartNumber);
        [self performSelector:@selector(setContactBoolStatus) withObject:nil afterDelay:0.05];
    }
    
}

-(void) setContactBoolStatus {
    _contactFinished = NO;
}

// Delegates

-(void) didBeginContact:(SKPhysicsContact *)contact {
    if(_contactFinished == NO) {
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
            _contactFinished = YES;
            //NSLog(@"La balle à touché le sol");
            if (_heartNumber > 0) {
                [self ResetBallAndHeart:firstBody];
            } else {
                [self presentResultScene:NO];
            }
        }
        
        // Permet de vérifier le contact entre la balle et les bricks
        if (firstBody.categoryBitMask == ballCategory && secondBody.categoryBitMask == brickCategory) {
            _contactFinished = YES;
            [secondBody.node removeFromParent];
            _brickRemaining --;
            _score += 10;
            NSLog(@"Votre score est de %d", _score);
            if([self isGameWon]) {
                [self presentResultScene:YES];
            }
            _contactFinished = NO;
        }  
    }
    
}


@end
