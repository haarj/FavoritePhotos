//
//  RootViewController.m
//  FavoritePhotos
//
//  Created by Justin Haar on 3/28/15.
//  Copyright (c) 2015 Justin Haar. All rights reserved.
//

#import "RootViewController.h"
#import "PictureViewController.h"
#import "Image.h"
#import "MapViewController.h"
#import <Social/Social.h>

@interface RootViewController () <UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *tapGesture;
@property NSMutableArray *rootFavoritesArray;
@property NSMutableArray *rootPicturesArray;


@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.rootFavoritesArray = [NSMutableArray new];
    self.rootPicturesArray = [NSMutableArray new];
    self.tapGesture.enabled = NO;
    self.label.hidden = YES;

}


- (IBAction)postToTwitter:(UIButton *)sender
{
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]) {
        SLComposeViewController *tweetSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
        [tweetSheet setInitialText:@"First app post to Twitter"];
        [self presentViewController:tweetSheet animated:YES completion:nil];
        [tweetSheet addImage:self.imageView.image];
    }
}

//Segues to next view controller
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self performSegueWithIdentifier:@"search" sender:self.searchBar];
    [self.searchBar resignFirstResponder];
}

//Passes text to API LINK
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"search"])
    {
        PictureViewController *pictureVC = segue.destinationViewController;
        pictureVC.searchText = self.searchBar.text;
    }else
    {
        MapViewController *mapVC = segue.destinationViewController;
        mapVC.arrayOfImages = self.rootFavoritesArray;
    }
}

//Passes array from picture view controller to root view controller
- (IBAction)unwindToRoot:(UIStoryboardSegue *)sender
{
    PictureViewController *viewController = sender.sourceViewController;
    self.rootFavoritesArray = viewController.favoritesArray;
    self.rootPicturesArray = viewController.pictureArray;
    self.tapGesture.enabled = YES;
    self.label.hidden= NO;
    self.label.text = @"Liked";
    self.label.textColor = [UIColor redColor];
    [self scrollWithImages];

    NSLog(@"This array has %@ photos", self.rootFavoritesArray);
    NSLog(@"This array has %@ photos", self.rootPicturesArray);
}

#pragma mark SCROLL METHODS
//Allows to scroll multiple images in scroll view by interating through multiple indexes and multiplying at ends of scroll view
-(void)scrollWithImages
{
    //self.rootfavoritearray.count is the number of scrolls that should be available
    [self.scrollView setContentSize:CGSizeMake(self.rootFavoritesArray.count * self.scrollView.bounds.size.width, self.scrollView.bounds.size.height)];
    [self.scrollView setPagingEnabled:YES];

    NSInteger index = 0;
    for (Image *image in self.rootFavoritesArray)
    {
        CGRect frame = CGRectMake(self.scrollView.bounds.size.width * index, 0, self.scrollView.bounds.size.width, self.scrollView.bounds.size.height);
        UIImageView *anImageView = [[UIImageView alloc]initWithFrame:frame];
        [self.scrollView addSubview:anImageView];
        self.imageView = anImageView;
        self.imageView.image = image.instagramImage;
        index ++;
    }

}

//Tells the label to be hidden or not based on if the picture was favorited or not
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSInteger index = self.scrollView.contentOffset.x / self.scrollView.frame.size.width;

    if ([self.rootFavoritesArray containsObject:[self.rootPicturesArray objectAtIndex:index]])
    {
        self.label.hidden = NO;
        self.label.text = @"Liked";
        self.label.textColor = [UIColor redColor];
    } else
    {
        self.label.hidden = YES;
    }
}

//Adds and removes pictures from arrays and changes label properties
- (IBAction)tapGesture:(UITapGestureRecognizer *)sender
{
    NSInteger index = self.scrollView.contentOffset.x / self.scrollView.frame.size.width;
    if (!([self.rootFavoritesArray containsObject:[self.rootPicturesArray objectAtIndex:index]]))
    {
        [self.rootFavoritesArray addObject:[self.rootPicturesArray objectAtIndex:index]];
        self.label.hidden = NO;
        self.label.text = @"Liked";
        self.label.textColor = [UIColor redColor];
        self.tapGesture.enabled = YES;
    } else
    {
        self.tapGesture.enabled = YES;
        [self.rootFavoritesArray removeObject:[self.rootPicturesArray objectAtIndex:index]];
        self.label.hidden = YES;
    }
    NSLog(@"%@", self.rootFavoritesArray);

}

@end
