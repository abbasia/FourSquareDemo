//
//  FSDCollectionViewCell.h
//  FourSquareDemo
//
//  Created by abbasi on 2/16/14.
//  Copyright (c) 2014 abbasi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FSDCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *urlLabel;

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIView *labelContainerView;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

-(void)updateContentWithDictionary:(NSDictionary*)dictionary;
@end
