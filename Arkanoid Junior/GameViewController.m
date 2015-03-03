//
//  GameViewController.m
//  Arkanoid Junior
//
//  Created by Jeremy Bec on 03/03/2015.
//  Copyright (c) 2015 JeremyBec. All rights reserved.
//

#import "GameViewController.h"
#import "GameScene.h"

@implementation GameViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Configure the view.
    SKView * skView = (SKView *)self.view;
    skView.showsFPS = YES;
    skView.showsNodeCount = YES;
    /* Sprite Kit applies additional optimizations to improve rendering performance */
    skView.ignoresSiblingOrder = YES;
    
    // Create and configure the scene.
    SKScene *loadingScene = [[SKScene alloc] initWithSize:skView.bounds.size];
    loadingScene.backgroundColor = [SKColor blackColor];
    
    // Present the scene.
    [skView presentScene:loadingScene];
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    SKView * skView = (SKView *)self.view;
    GameScene *scene = [GameScene sceneWithSize:skView.bounds.size];
    
    scene.scaleMode = SKSceneScaleModeAspectFill;
    SKTransition *transition = [SKTransition fadeWithDuration:1];
    [skView presentScene:scene transition: transition];
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    } else {
        return UIInterfaceOrientationMaskAll;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

@end
