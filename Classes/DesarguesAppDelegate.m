//
//  DesarguesAppDelegate.m
//  Desargues
//
//  Created by Simon Stiefel on 8/9/08.
//  Copyright stiefels.net 2008. All rights reserved.
//

#import "DesarguesAppDelegate.h"
#import "CalcListController.h"
#import "DESTerm.h"

@implementation DesarguesAppDelegate

@synthesize window, calcListController, terms;

- (void)addNewTerm {
	DESTerm *newTerm = [[[DESTerm alloc] init] autorelease];
	[newTerm setDelegate:self];
	[self.terms addObject:newTerm];
	[calcListController.tableView reloadData];
}

- (void)createNewTermWithTerm:(NSString *)term {
	DESTerm *newTerm = [[[DESTerm alloc] init] autorelease];
	[newTerm setTerm:term];
	[newTerm setDelegate:self];
	[self.terms addObject:newTerm];
}

- (void)clearAllTerms {
	[calcListController resignFirstResponder];
	[self.terms release];
	self.terms = [[NSMutableArray array] retain];
	[calcListController.tableView reloadData];
	[self addNewTerm];
}

- (void)setTerm:(NSString *)term forTermAtIndex:(NSInteger)index {
	[[self.terms objectAtIndex:index] setTerm:term];
	[calcListController.tableView reloadData];
}

- (void)applicationDidFinishLaunching:(UIApplication *)application {	
	// Override point for customization after app launch	
	self.terms = [[NSMutableArray array] retain];
	
	// load terms from user defaults
	if (! [self loadTermsFromUserDefaults]) {
		[self addNewTerm];
	}
	
	[window addSubview:calcListController.view];
	[window makeKeyAndVisible];
}

- (void)applicationWillTerminate:(UIApplication *)application {
	// save terms to user defaults
	[self saveTermsToUserDefaults];
}

- (DESTerm *)termAtIndex:(NSInteger)index {
	if (index >= [self.terms count]) {
		return nil;
	}
	
	return [self.terms objectAtIndex:index];
}

- (NSInteger)indexForTerm:(DESTerm *)term {
	return [self.terms indexOfObject:term];
}

- (void)saveTermsToUserDefaults {
	NSMutableArray *rawterms = [NSMutableArray arrayWithCapacity:[self.terms count]];
	
	// converting terms to strings
	for (DESTerm *t in self.terms) {
		[rawterms addObject:[t term]];
	}
	
	[[NSUserDefaults standardUserDefaults] setObject:rawterms forKey:@"terms"];	
}

- (BOOL)loadTermsFromUserDefaults {
	NSArray *rawterms = [[NSUserDefaults standardUserDefaults] arrayForKey:@"terms"];
	if (rawterms == nil) return NO;
	
	for (NSString *t in rawterms) {
		[self createNewTermWithTerm:t];
	}
	
	[calcListController.tableView reloadData];
	
	return YES;
}

- (void)dealloc {
	[window release];
	[super dealloc];
}

@end
