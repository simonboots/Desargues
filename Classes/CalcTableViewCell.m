//
//  CalcTableViewCell.m
//  Desargues
//
//  Created by Simon Stiefel on 11/23/08.
//  Copyright 2008 stiefels.net. All rights reserved.
//

#import "CalcTableViewCell.h"


@implementation CalcTableViewCell

@synthesize identifier, term, result, errorLabel;

- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithFrame:frame reuseIdentifier:reuseIdentifier]) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {

    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
    [super dealloc];
}


@end
