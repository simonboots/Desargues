//
//  CalcListController.h
//  Desargues
//
//  Created by Simon Stiefel on 11/23/08.
//  Copyright 2008 stiefels.net. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DesarguesAppDelegate;
@class CalcTableViewCell;

@interface CalcListController : UIViewController <UITextFieldDelegate> {
	IBOutlet DesarguesAppDelegate *appDelegate;
	IBOutlet UITableView *tableView;
}

@property (readonly) UITableView *tableView;

- (void)add:(id)sender;
- (void)clearAll:(id)sender;
- (void)resignFirstResponder;

@end
