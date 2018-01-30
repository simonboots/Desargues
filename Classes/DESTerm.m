//
//  DESTerm.m
//  Desargues
//
//  Created by Simon Stiefel on 8/10/08.
//  Copyright 2008 stiefels.net. All rights reserved.
//

#import "DESTerm.h"

NSString *const DESErrorDomain = @"net.stiefels.Desargues.ErrorDomain";

@implementation DESTerm

@synthesize term, delegate;

+ (DESTerm *)termWithString:(NSString *)string
{
	return [[[DESTerm alloc] initWithString:string] autorelease];
}

- (id)initWithString:(NSString *)string
{
	self = [super init];
	if (self != nil) {
		self.term = string;
		self.delegate = nil;
	}
	return self;
}

- (id)init
{
	self = [self initWithString:@""];
	return self;
}

- (NSString *)interpolatedTermWithTermSet:(NSMutableSet *)termset error:(NSError **)error
{
	*error = nil;
	
	// check if delegate is available
	if (delegate == nil) {
		NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithCapacity:3];
		[userInfo setObject:@"Could not interpolate term: No delegate set" forKey:NSLocalizedDescriptionKey];
		[userInfo setObject:@"No delegate set" forKey:NSLocalizedFailureReasonErrorKey];
		*error = [NSError errorWithDomain:DESErrorDomain code:kDESENoDelegateError userInfo:userInfo];
		return nil;
	}
	
	// check if self is stored in delegate
	NSInteger selfID = [delegate indexForTerm:self];
	if (selfID == NSNotFound) {
		NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithCapacity:3];
		[userInfo setObject:@"Could not interpolate term: Cannot find selfID in delegate" forKey:NSLocalizedDescriptionKey];
		[userInfo setObject:@"Cannot find selfID in delegate" forKey:NSLocalizedFailureReasonErrorKey];
		*error = [NSError errorWithDomain:DESErrorDomain code:kDESETermNotFound userInfo:userInfo];
		return nil;
	}
	
	// check if self is in term set
	if ([termset member:[NSNumber numberWithInt:selfID]] != nil) {
		NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithCapacity:3];
		[userInfo setObject:@"Could not interpolate term: Circular dependency" forKey:NSLocalizedDescriptionKey];
		[userInfo setObject:@"Circular dependency" forKey:NSLocalizedFailureReasonErrorKey];
		*error = [NSError errorWithDomain:DESErrorDomain code:kDESECircularDependency userInfo:userInfo];
		return nil;
	}
	
	[termset addObject:[NSNumber numberWithInt:selfID]];
	
	NSMutableString *workString = [self.term mutableCopy];
	
	while (YES) {
		NSRange referencedTermRange = [workString rangeOfString:@"@"];
		
		// no more references found
		if (referencedTermRange.location == NSNotFound) {
			break;
		}
		
		NSString *substring = [workString substringFromIndex:(referencedTermRange.location + referencedTermRange.length)];
		NSScanner *intScanner = [NSScanner scannerWithString:substring];
		NSInteger index;
		if (! [intScanner scanInteger:&index]) {
			// SYNTAX ERROR
			NSLog(@"error while parsing index");
			break;
		}
		
		NSLog(@"Looking for Term at index %d", index-1);
		
		DESTerm *referencedTerm = [delegate termAtIndex:index-1];
		if (referencedTerm == nil) {
			NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithCapacity:3];
			[userInfo setObject:@"Could not interpolate term: Referenced term index does not exist" forKey:NSLocalizedDescriptionKey];
			[userInfo setObject:@"Referenced term index does not exist" forKey:NSLocalizedFailureReasonErrorKey];
			*error = [NSError errorWithDomain:DESErrorDomain code:kDESERefTermNotFound userInfo:userInfo];
			return nil;
		}
		
		NSString *interpolatedSubTerm = [referencedTerm interpolatedTermWithTermSet:termset error:error];
		if (interpolatedSubTerm == nil) {
			return nil;
		}
		
		// replace term reference with interpolated subterm
		NSString *indexString = [NSString stringWithFormat:@"%d", index];
		NSRange referenceRangeAt = [workString rangeOfString:@"@"];
		NSRange indexSearchRange = NSMakeRange(referenceRangeAt.location, [workString length] - referenceRangeAt.location);
		NSRange referenceRangeIndex = [workString rangeOfString:indexString options:NSLiteralSearch range:indexSearchRange];
		NSRange referenceRange = NSMakeRange(referenceRangeAt.location, referenceRangeIndex.location - referenceRangeAt.location + referenceRangeIndex.length);

		[workString replaceCharactersInRange:referenceRange withString:interpolatedSubTerm];
	}
		
	// remove self from termset
	[termset removeObject:[termset member:[NSNumber numberWithInt:selfID]]];
		
	return workString;
}

- (BOOL)getResult:(NSNumber **)result error:(NSError **)error
{
	extern int yy_scan_string(char const*);
	extern int yyparse(double *);
	
	int status;
	double dresult = 0.0;
	
	*error = nil;
	NSString *interpolatedTerm = [self interpolatedTermWithTermSet:[NSMutableSet setWithCapacity:5] error:error];
	
	if (interpolatedTerm == nil) {
		NSLog([*error localizedDescription]);
		return NO;
	}

	yy_scan_string([interpolatedTerm cStringUsingEncoding:NSASCIIStringEncoding]);
	status = yyparse(&dresult);
	
	if (status == 0) {
		*result = [NSNumber numberWithDouble:dresult];
		return YES;
	} else {
		*result = nil;
		NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithCapacity:3];
		[userInfo setObject:@"Unable to calculate result: Parser error" forKey:NSLocalizedDescriptionKey];
		[userInfo setObject:@"Parser error" forKey:NSLocalizedFailureReasonErrorKey];
		*error = [NSError errorWithDomain:DESErrorDomain code:kDESEUnknownError userInfo:userInfo];
		return NO;
	}
}

@end
