//
//  GameResultScene.m
//  Arkanoid Junior
//
//  Created by Jeremy Bec on 17/03/2015.
//  Copyright (c) 2015 JeremyBec. All rights reserved.
//

#import "GameResultScene.h"
#import "GameScene.h"

@implementation GameResultScene

-(id)initWithSize:(CGSize)size playerWon:(BOOL)isWon {
    self = [super initWithSize:size];
    if (self) {
        SKLabelNode* gameResultLabel = [SKLabelNode labelNodeWithFontNamed:@"Arial"];
        gameResultLabel.fontSize = 42;
        gameResultLabel.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
        if (isWon) {
            gameResultLabel.text = @"Game Won";
        } else {
            gameResultLabel.text = @"Game Over";
        }
        [self addChild:gameResultLabel];
    }
    return self;
}
@end
