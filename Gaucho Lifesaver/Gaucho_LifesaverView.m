//
//  Gaucho_LifesaverView.m
//  Gaucho Lifesaver
//
//  Created by Mike Piatek-Jimenez on 9/10/18.
//  Copyright © 2018 Mike Piatek-Jimenez. All rights reserved.
//

#import "Gaucho_LifesaverView.h"
#import "Gaucho_Life-Swift.h"

@implementation Gaucho_LifesaverView

- (instancetype)initWithFrame:(NSRect)frame isPreview:(BOOL)isPreview {
    self = [super initWithFrame:frame isPreview:isPreview];
    if (self) {
        [self setAnimationTimeInterval:0.75];
        
        self.model = [[LifeModel alloc] init];
    }
    return self;
}

- (void)drawRect:(NSRect)rect {
    [super drawRect:rect];

    [self.model increment];
    [self.model drawIn:self.bounds];
}

- (void)animateOneFrame {
    [self setNeedsDisplay:YES];
}

- (BOOL)hasConfigureSheet {
    return NO;
}

- (NSWindow*)configureSheet {
    return nil;
}

@end
