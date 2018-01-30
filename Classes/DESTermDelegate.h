//
//  DESTermDelegate.h
//  Desargues
//
//  Created by Simon Stiefel on 8/10/08.
//  Copyright 2008 stiefels.net. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DESTerm;

@protocol DESTermDelegate

- (DESTerm *)termAtIndex:(NSInteger)index;
- (NSInteger)indexForTerm:(DESTerm *)term;

@end
