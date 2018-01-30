//
//  DesarguesAppDelegate.h
//  Desargues
//
//  Created by Simon Stiefel on 8/9/08.
//  Copyright stiefels.net. 2008. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DESTermDelegate.h"

@class CalcListController;
@class DESTerm;

@interface DesarguesAppDelegate : NSObject <UIApplicationDelegate, DESTermDelegate> {
	IBOutlet UIWindow *window;
	IBOutlet CalcListController *calcListController;
	NSMutableArray *terms;
}

@property (nonatomic, retain) UIWindow *window;
@property (nonatomic, retain) CalcListController *calcListController;
@property (nonatomic, retain) NSMutableArray *terms;

- (void)addNewTerm;
- (void)createNewTermWithTerm:(NSString *)term;
- (void)clearAllTerms;
- (void)setTerm:(NSString *)term forTermAtIndex:(NSInteger)index;
- (DESTerm *)termAtIndex:(NSInteger)index;
- (void)saveTermsToUserDefaults;
- (BOOL)loadTermsFromUserDefaults;

@end

