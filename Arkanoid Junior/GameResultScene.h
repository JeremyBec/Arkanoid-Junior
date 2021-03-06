//
//  GameResultScene.h
//  Arkanoid Junior
//
//  Created by Jeremy Bec on 17/03/2015.
//  Copyright (c) 2015 JeremyBec. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface GameResultScene : SKScene<SKPhysicsContactDelegate>

@property SKLabelNode* gameResultLabel;

-(id)initWithSize:(CGSize)size playerWon:(BOOL)isWon;
-(id)initWithSize:(CGSize)size;

@end
