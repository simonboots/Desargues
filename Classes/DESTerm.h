//
//  DESTerm.h
//  Desargues
//
//  Created by Simon Stiefel on 8/10/08.
//  Copyright 2008 stiefels.net. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DESTermDelegate.h"

#define kDESENoDelegateError 1
#define kDESETermNotFound 2
#define kDESECircularDependency 3
#define kDESERefTermNotFound 4
#define kDESEUnknownError 100

extern NSString *const DESErrorDomain;

@interface DESTerm : NSObject {
	NSString *term;
	NSObject<DESTermDelegate> *delegate;
}

@property (nonatomic, copy) NSString *term;
@property (nonatomic, assign) id delegate;

+ (DESTerm *)termWithString:(NSString *)string;
- (id)initWithString:(NSString *)string;
- (NSString *)interpolatedTermWithTermSet:(NSMutableSet *)set error:(NSError **)error;
- (BOOL)getResult:(NSNumber **)result error:(NSError **)error;

@end
