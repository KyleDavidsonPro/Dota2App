//
//  HeroCell.h
//  Dota2App
//
//  Created by Kyle Davidson on 11/11/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HeroCell : UITableViewCell
@property (nonatomic, retain) IBOutlet UILabel *cellTitleLabel;
@property (nonatomic, retain) IBOutlet UILabel *cellDetailLabel;
@property (nonatomic, retain) IBOutlet UIImageView *cellImage;
@property (nonatomic, retain) IBOutlet UIImageView *factionImage;
@property (nonatomic, retain) IBOutlet UIImageView *attributeImage;

@end
