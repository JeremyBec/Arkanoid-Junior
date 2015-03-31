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

- (void)addBtn: (NSString*) name coordX:(CGFloat)X coordY:(CGFloat)Y {

    SKSpriteNode * playBtn = [[SKSpriteNode alloc]initWithImageNamed:name];
    CGPoint btnPos = CGPointMake(X, Y);
    playBtn.position = btnPos;
    playBtn.name = name;
    playBtn.zPosition = 1.0;
    
    [self addChild:playBtn];
}
-(void)displayScore {
    
    SKLabelNode* scoreLabel = [SKLabelNode labelNodeWithFontNamed:@"Arial"];
    scoreLabel.fontSize = 35;
    scoreLabel.position = CGPointMake(CGRectGetMidX(self.frame), _gameResultLabel.frame.origin.y + 150);
    scoreLabel.text = [NSString stringWithFormat:@"Votre score est de %@", [self.userData valueForKey:@"score"]];
    [self addChild:scoreLabel];
}

-(id)initWithSize:(CGSize)size playerWon:(BOOL)isWon {
    self = [super initWithSize:size];
    if (self) {
        _gameResultLabel = [SKLabelNode labelNodeWithFontNamed:@"Arial"];
        _gameResultLabel.fontSize = 42;
        _gameResultLabel.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
        
        
        if (isWon) {
            _gameResultLabel.text = @"Game Won";
            
        } else {
            _gameResultLabel.text = @"Game Over";
            
        }
        [self addChild:_gameResultLabel];
        [self performSelector:@selector(displayScore) withObject:nil afterDelay:0.1];
        [self addBtn:@"replay-button" coordX:self.size.width/2 coordY:_gameResultLabel.frame.origin.y-_gameResultLabel.frame.size.height*2];
        [self addBtn:@"quit-button" coordX:self.size.width/2 coordY:_gameResultLabel.frame.origin.y-_gameResultLabel.frame.size.height*4];
    }
    return self;
}

-(id) initWithSize:(CGSize)size {
    self = [super initWithSize:size];
    if (self) {
        [self addBtn:@"play-button" coordX:self.size.width/2 coordY:self.size.height/2];
        [self addBtn:@"quit-button" coordX:self.size.width/2 coordY:self.size.height/2-40];
    }
    return self;
}

-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    SKNode *node = [self nodeAtPoint:location];
    NSLog(@"%@", node.name);
    
    
    if ([node.name isEqualToString:@"play-button"] || [node.name isEqualToString:@"replay-button"]) {
        SKView * skView = (SKView *)self.view;
        GameScene *scene = [GameScene sceneWithSize:skView.bounds.size];
        scene.backgroundColor = [SKColor darkGrayColor];
        
        scene.scaleMode = SKSceneScaleModeAspectFill;
        SKTransition *transition = [SKTransition fadeWithDuration:1];
        [skView presentScene:scene transition: transition];
    } else if ([node.name isEqualToString:@"quit-button"]) {
        exit(0);
    }
    
    
}



@end
