//
//  CalcTableViewCell.h
//  Desargues
//
//  Created by Simon Stiefel on 11/23/08.
//  Copyright 2008 stiefels.net. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CalcTableViewCell : UITableViewCell {
	IBOutlet UILabel *identifier;
	IBOutlet UITextField *term;
	IBOutlet UILabel *result;
	IBOutlet UILabel *errorLabel;
}

@property (nonatomic, retain) UILabel *identifier;
@property (nonatomic, retain) UITextField *term;
@property (nonatomic, retain) UILabel *result;
@property (nonatomic, retain) UILabel *errorLabel;

@end
