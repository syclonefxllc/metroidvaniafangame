//
//  choot.m
//  Metroidvania
//
//  Created by nick vancise on 5/20/19.
//

#import "choot.h"


@implementation choot{
    SKTextureAtlas*_chootTex;
    SKSpriteNode*_projsprite;
    SKAction*_explode;
}

-(instancetype)initWithPos:(CGPoint)pos andDist:(int)dist andCount:(int)count andTime:(float)time Del:(float)del{
    _chootTex=[SKTextureAtlas atlasNamed:@"choot"];
    self=[super initWithTexture:[_chootTex textureNamed:@"choot1.png"]];
    if(self!=nil){
        self.position=pos;
        self.orig_y=pos.y;
        self.health=15;
        self.dead=NO;
        self.dx=5;
        self.dy=0;
        self.projectilesInAction=[[NSMutableArray alloc] init];
        NSArray *jumptex=@[[_chootTex textureNamed:@"choot1.png"],[_chootTex textureNamed:@"choot2.png"],[_chootTex textureNamed:@"choot3.png"]];
        NSArray *fallstart=@[[_chootTex textureNamed:@"choot4.png"],[_chootTex textureNamed:@"choot5.png"],[_chootTex textureNamed:@"choot5.png"],[_chootTex textureNamed:@"choot6.png"]];
        NSArray *falltex=@[[_chootTex textureNamed:@"choot7.png"],[_chootTex textureNamed:@"choot8.png"],[_chootTex textureNamed:@"choot9.png"]];
        NSArray *explodetex=@[[_chootTex textureNamed:@"choothit1.png"],[_chootTex textureNamed:@"choothit2.png"],[_chootTex textureNamed:@"choothit3.png"],[_chootTex textureNamed:@"choothit4.png"]];
        
        
        _projsprite=[SKSpriteNode spriteNodeWithTexture:[_chootTex textureNamed:@"chootp1.png"]];
        _projsprite.zPosition=-101;
        _projsprite.position=CGPointZero;
        __weak SKSpriteNode*weakprojsprite=_projsprite;
        __weak choot*weakself=self;
        SKAction*fallblock=[SKAction runBlock:^{
            SKSpriteNode*weakprojspritecpy=weakprojsprite.copy;
            [weakself addChild:weakprojspritecpy];
            [weakself.projectilesInAction addObject:weakprojspritecpy];
            int pps=155;
            float dur=(weakself.position.y-weakself.orig_y)/pps;
            __weak SKSpriteNode*doubleweak=weakprojspritecpy;
            [weakprojspritecpy runAction:[SKAction moveByX:0 y:-(weakself.frame.origin.y-weakself.orig_y) duration:dur] completion:^{[weakself.projectilesInAction removeObject:doubleweak];[doubleweak removeFromParent];}];
        }];
        
        SKAction*jump=[SKAction group:@[[SKAction moveByX:0 y:dist duration:time],[SKAction animateWithTextures:jumptex timePerFrame:0.08 resize:YES restore:NO]]];
        SKAction*fall=[SKAction group:@[[SKAction moveByX:0 y:-dist duration:(2.5*time)],[SKAction sequence:@[[SKAction animateWithTextures:fallstart timePerFrame:0.08 resize:YES restore:NO],[SKAction repeatAction:[SKAction sequence:@[fallblock,[SKAction animateWithTextures:falltex timePerFrame:0.1 resize:YES restore:YES]]] count:count],[SKAction setTexture:[_chootTex textureNamed:@"choot1.png"] resize:YES]]]]];
        _explode=[SKAction animateWithTextures:explodetex timePerFrame:0.1];
        
        
        
        [self runAction:[SKAction sequence:@[[SKAction waitForDuration:del],[SKAction repeatActionForever:[SKAction sequence:@[jump,fall,[SKAction  waitForDuration:4]]]]]]];
        
    }
    return self;
}


-(void)hitByBulletWithArrayToRemoveFrom:(NSMutableArray*)arr withHit:(int)hit{//default implementation
    self.health=self.health-hit;
    if(self.health<=0){
        //NSLog(@"healthisbelowzero");
        [self removeAllActions];
        [self removeAllChildren];
        for(SKSpriteNode*tmp in self.projectilesInAction.reverseObjectEnumerator){
            [self.projectilesInAction removeObject:tmp];
        }
        __weak enemyBase*weakself=self;
        [self runAction:[SKAction sequence:@[[SKAction fadeOutWithDuration:0.2],[SKAction runBlock:^{[weakself removeFromParent];}]]]];
        [arr removeObject:self];
        //NSLog(@"%d",(int)arr.count);
    }
    
}

-(void)hitByMeleeWithArrayToRemoveFrom:(NSMutableArray*)arr{
    self.health=self.health-10;
    if(self.health<=0){
        [self removeAllActions];
        [self removeAllChildren];
        for(SKSpriteNode*tmp in self.projectilesInAction.reverseObjectEnumerator){
            [self.projectilesInAction removeObject:tmp];
        }
        __weak enemyBase*weakself=self;
        [self runAction:[SKAction sequence:@[[SKAction fadeOutWithDuration:0.1],[SKAction runBlock:^{[weakself removeFromParent];}]]]];
        [arr removeObject:self];
    }
}

-(void)explode:(SKSpriteNode *)proj{
    __weak choot*weakself=self;
    __weak SKSpriteNode*weakproj=proj;
    [proj removeAllActions];
    [proj runAction:_explode completion:^{[weakself.projectilesInAction removeObject:weakproj];[weakproj removeAllActions];[weakproj removeFromParent];}];
}

-(void)enemytoplayerandmelee:(GameLevelScene *)scene{
    if(CGRectIntersectsRect(scene.player.frame,CGRectInset(self.frame,2,0))){
        [scene enemyhitplayerdmgmsg:20];
    }
    if(scene.player.meleeinaction && !scene.player.meleedelay && CGRectIntersectsRect([scene.player meleeBoundingBoxNormalized],self.frame)){
        //NSLog(@"meleehit");
        [scene.player runAction:scene.player.meleedelayac];
        [self hitByMeleeWithArrayToRemoveFrom:scene.enemies];
    }
    for(SKSpriteNode*tmp in self.projectilesInAction.reverseObjectEnumerator){
        if(CGRectContainsPoint(scene.player.frame, [scene convertPoint:tmp.position fromNode:self])){
            [scene enemyhitplayerdmgmsg:15];
            [self explode:tmp];
        }
    }
}

/*-(void)dealloc{
    NSLog(@"choot deallocated");
}*/

@end
