//
//  ViewController.m
//  Metroidvania
//
//  Created by Jake Gundersen on 12/27/13.
//  Modified by Nick VanCise

#import "ViewController.h"
#import "MenuScene.h"

@implementation ViewController

- (void)viewDidAppear:(BOOL)animated
{
  //NSLog(@"in view");
  [super viewDidAppear:animated];
  
  // Configure the view.
  SKView * skView = (SKView *)self.view;
  skView.showsFPS = YES;
  skView.showsNodeCount = YES;
  skView.showsDrawCount =YES;
  skView.ignoresSiblingOrder=YES;
  skView.multipleTouchEnabled=NO;
  __block SKScene *menuscenep;
  // Create and configure the scene.
  // Present the scene.
  __weak SKView*weakview=skView;
  NSArray *texturesformenuscene=@[@"menusceneitems"];
  [SKTextureAtlas preloadTextureAtlasesNamed:texturesformenuscene withCompletionHandler:^(NSError*error,NSArray*foundatlases){
    dispatch_async(dispatch_get_main_queue(), ^{
    NSLog(@"preloaded menuscene");
    menuscenep=[[MenuScene alloc] initWithSize:weakview.bounds.size];
    [weakview presentScene:menuscenep];
    });
  }];
  
}

- (BOOL)shouldAutorotate
{
  return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
  return UIInterfaceOrientationMaskLandscape;
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Release any cached data, images, etc that aren't in use.
}




@end
