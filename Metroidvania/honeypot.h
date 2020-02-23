//
//  honeypot.h
//  Metroidvania
//
//  Created by nick vancise on 9/29/18.
//
#import <GameplayKit/GameplayKit.h>
#import "enemyBase.h"


@interface honeypotproj:SKSpriteNode<GKAgentDelegate>

@property (nonatomic,strong) GKAgent2D *agent;
@property (nonatomic,assign) int health;
@property (nonatomic,assign) BOOL anger;
-(instancetype)initWithPosition:(CGPoint)position andTex:(SKTexture*)tex andAnger:(BOOL)angry;

@end



@interface honeypot : enemyBase

@property (nonatomic,strong) SKAction *explode;
@property (nonatomic,strong) SKAction *explodeangry;
@property (nonatomic,strong) GKComponentSystem *agentSystem;
@property (nonatomic,strong) GKAgent2D *target;
-(instancetype)init;
-(void)updateWithDeltaTime:(NSTimeInterval)seconds;
-(void)dealChildDamage:(int)damage withChild:(honeypotproj*)child;

@end

