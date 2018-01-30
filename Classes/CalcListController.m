//
//  CalcListController.m
//  Desargues
//
//  Created by Simon Stiefel on 11/23/08.
//  Copyright 2008 stiefels.net. All rights reserved.
//

#import "CalcListController.h"
#import "DesarguesAppDelegate.h"
#import "CalcTableViewCell.h"
#import "DESTerm.h"

#define kOFFSET_KEYBOARD_HEIGHT 216
#define kOFFSET_NAVBAR_HEIGHT 44

@implementation CalcListController

@synthesize tableView;

- (void)add:(id)sender {
	[appDelegate addNewTerm];
}

- (void)clearAll:(id)sender {
	[tableView becomeFirstResponder];
	[appDelegate clearAllTerms];
}

- (void)resignFirstResponder {
	// ? better idea here?
	NSArray *cells = [tableView visibleCells];
	for (int i = 0; i < [cells count]; i++) {
		CalcTableViewCell *cell = [cells objectAtIndex:i];
		[cell.term resignFirstResponder];
	}
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tv {
	return 1;
}

- (NSInteger)tableView:(UITableView *)tv numberOfRowsInSection:(NSInteger)section {
	return [appDelegate.terms count];
}

- (UITableViewCell *)tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	CalcTableViewCell *cell = (CalcTableViewCell *)[tv dequeueReusableCellWithIdentifier:@"calcCell"];
	NSError *error = nil;
	
	if (nil == cell) {
		UIViewController *tempController = [[UIViewController alloc] initWithNibName:@"CalcTableViewCell" bundle:[NSBundle mainBundle]];
		cell = (CalcTableViewCell *)[tempController.view retain];
		[cell.term setDelegate:self];
		cell.errorLabel.text = @"";
		[tempController release];
	}

	
	DESTerm *term = [appDelegate.terms objectAtIndex:indexPath.row];
		
	cell.identifier.text = [NSString stringWithFormat:@"%d:", indexPath.row + 1];
	cell.term.text = [term term];
	cell.term.tag = indexPath.row;
	NSNumber *result = nil;
	if ([term getResult:&result error:&error]) {
		cell.result.text = [result stringValue];
		cell.errorLabel.text = @"";
	} else {
		cell.result.text = @"0";
		cell.errorLabel.text = [error localizedFailureReason];
	}
	
	return cell;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	return nil;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
	[appDelegate setTerm:textField.text forTermAtIndex:textField.tag];
	CGRect tvRect = self.tableView.frame;
	tvRect.size.height += kOFFSET_KEYBOARD_HEIGHT;
	tvRect.origin.y = kOFFSET_NAVBAR_HEIGHT;
	self.tableView.frame = tvRect;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
	CGRect tvRect = self.tableView.frame;
	tvRect.size.height -= kOFFSET_KEYBOARD_HEIGHT;
	tvRect.origin.y = kOFFSET_NAVBAR_HEIGHT;
	self.tableView.frame = tvRect;
	
	return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	[textField resignFirstResponder];
	
	return YES;
}



/*
// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}


- (void)dealloc {
    [super dealloc];
}


@end
