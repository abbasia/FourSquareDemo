//
//  FSDViewController.m
//  FourSquareDemo
//
//  Created by abbasi on 2/16/14.
//  Copyright (c) 2014 abbasi. All rights reserved.
//

#import "FSDViewController.h"
#import "FSDCollectionViewCell.h"
#import <QuartzCore/QuartzCore.h>
#import "FSDManager.h"
#import "FSDMapViewController.h"

@interface FSDViewController ()

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UILabel *searchCountLabel;
@property (weak, nonatomic) IBOutlet UIView *headerView;

@property(strong,nonatomic) NSArray* venues;
@end


static NSString *CellIdentifier = @"FSDCollectionViewCell";

static NSString *Segue_MainToMap = @"mainToMaps";

@implementation FSDViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    return [self.venues count];
}


-(UIColor*)randomColor{
    CGFloat hue = ( arc4random() % 256 / 256.0 );  //  0.0 to 1.0
    CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from white
    CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from black
    UIColor *color = [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:0.5];
    
    return color;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    FSDCollectionViewCell *cell = (FSDCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    
    //cell.layer.cornerRadius = 5;
    //cell.layer.masksToBounds = YES;
    
    
    [cell updateContentWithDictionary:[self.venues objectAtIndex:indexPath.row]];
    
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if ([segue.identifier isEqualToString:Segue_MainToMap]) {
        
        FSDMapViewController* destination = segue.destinationViewController;
        
        destination.venueDictionary = sender;
        
        
    }
    
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    [self performSegueWithIdentifier:Segue_MainToMap sender:[self.venues objectAtIndex:indexPath.row]];
    
}


-(void)clearData{
    
    [UIView animateWithDuration:0.5 animations:^{
        self.headerView.alpha = 0;
    } completion:^(BOOL finished) {
        
    }];
    
    self.venues = nil;
    
    [self.collectionView reloadData];
    
    
}

-(void)showData{
    
    [UIView animateWithDuration:0.5 animations:^{
        self.headerView.alpha = 1;
    } completion:^(BOOL finished) {
        
    }];
    
    [self.collectionView reloadData];
    
}

#pragma mark - UISearchBarDelegate

- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar
{
    [searchBar resignFirstResponder];
    
    [self clearData];
    
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    [searchBar setShowsCancelButton:YES animated:YES];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    [searchBar setShowsCancelButton:NO animated:YES];
}

- (void)startSearch:(NSString *)searchString
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    [[FSDManager instance] search:searchString success:^(id response) {
        
        [self updateSearchResults:true searchString:searchString];
        
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        
        [self updateSearchResults:false searchString:searchString];
    }];
    
}

- (void)updateSearchResults:(BOOL)success searchString:(NSString *)searchString {
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    self.venues = [[FSDManager instance] dataFromLocalCache:searchString];
    
    [self updateSearchCount:success ? NO : YES];
    
    [self showData];
    
}

- (void)updateSearchCount:(BOOL)localResults {
    NSString *text = nil;
    if(self.venues.count == 0) {
        text = [NSString stringWithFormat:@"No results found"];
    } else {
        text = [NSString stringWithFormat:@"%lu results found", (unsigned long)self.venues.count];
    }
    
    if(localResults) {
        text = [NSString stringWithFormat:@"%@ on device", text];
    } else {
        text = [NSString stringWithFormat:@"%@ online", text];
    }
    
    self.searchCountLabel.text = text;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    
    [self clearData];
    
    [self startSearch:searchBar.text];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
