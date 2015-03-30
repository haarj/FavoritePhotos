//
//  PictureViewController.m
//  FavoritePhotos
//
//  Created by Justin Haar on 3/28/15.
//  Copyright (c) 2015 Justin Haar. All rights reserved.
//

#import "PictureViewController.h"
#import "Image.h"

@interface PictureViewController () <UIScrollViewDelegate, UIGestureRecognizerDelegate>

@property NSString *searchString;
@property NSMutableArray *array;

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *label;




@end

@implementation PictureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.array = [NSMutableArray new];
    self.pictureArray = [NSMutableArray new];
    self.favoritesArray = [NSMutableArray new];

    self.label.hidden = YES;

    [self loadData];
}


#pragma Mark GET INSTAGRAM API DATA

-(void)loadData
{
    //created a string with format to incorporate a search string inside the api string to specify which tag the user search. The %@ is located in the middle of the link
    NSString *tagsUrlString =[NSString stringWithFormat:@"https://api.instagram.com/v1/tags/%@/media/recent?access_token=19550704.1fb234f.928531158b3840b3831d8e60cf79f5da", self.searchText];
//    NSString *usersUrlString = NSString stringWithFormat:<#(NSString *), ...#>
    NSURL *url = [NSURL URLWithString:tagsUrlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        [self downloadComplete:data];
    }];
}


-(void)downloadComplete:(NSData *)data
{
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    self.array = dict[@"data"];

    //This for loop takes care of our image and coordinate
//    for (NSDictionary *newDict in self.array) {
//        [self unpackData:newDict];
//    }
    for (int i =0; i < 10; i++)
    {
        [self unpackData:[self.array objectAtIndex:i]];
        NSLog(@"%@", [self.array objectAtIndex:i]);
    }
}

-(void)unpackData:(NSDictionary *)dict
{
    //IMAGE DATA
    NSString *imageString = [[[dict objectForKey:@"images"] objectForKey:@"standard_resolution"] objectForKey:@"url"];
    NSURL *imageURL = [NSURL URLWithString:imageString];
    NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
    UIImage *image = [UIImage imageWithData:imageData];
    Image *anImage = [Image new];

    anImage.instagramImage = image;
    //do the first couple and the rest in the background
    //COORDINATE DATA
    //If location != Null retun object and coordinate else return object
    if (!([dict objectForKey:@"location"] == [NSNull null]))
    {
        NSString *latitude = [[dict objectForKey:@"location"] objectForKey:@"latitude"];
        double latAsDouble = latitude.doubleValue;
        NSString *longitude = [[dict objectForKey:@"location"] objectForKey:@"longitude"];
        double longAsDouble = longitude.doubleValue;
        CLLocationCoordinate2D theCoordinate = CLLocationCoordinate2DMake(latAsDouble, longAsDouble);
        anImage.coordinate = theCoordinate;
        
    } else
    {
        CLLocationCoordinate2D badCoordinate = CLLocationCoordinate2DMake(-999, -999);
        anImage.coordinate = badCoordinate;
    }
    
    [self.pictureArray addObject:anImage];
    [self scrollWithImages];
}

#pragma MARK SCROLLVIEW METHODS
//Allows to scroll multiple images in scroll view by interating through multiple indexes and multiplying at ends of scroll view
-(void)scrollWithImages
{
    [self.scrollView setContentSize:CGSizeMake(10 * self.scrollView.bounds.size.width, self.scrollView.bounds.size.height)];
    [self.scrollView setPagingEnabled:YES];

    NSInteger index = 0;
    for (Image *image in self.pictureArray)
    {
        CGRect frame = CGRectMake(self.scrollView.bounds.size.width * index, 0, self.scrollView.bounds.size.width, self.scrollView.bounds.size.height);
        UIImageView *anImageView = [[UIImageView alloc]initWithFrame:frame];
        [self.scrollView addSubview:anImageView];
        self.imageView = anImageView;
        self.imageView.image = image.instagramImage;
        index ++;
//        NSLog(@"%@", image);
    }
}

//Tells the label to be hidden or not based on if the picture was favorited or not
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSInteger index = self.scrollView.contentOffset.x / self.scrollView.frame.size.width;

    if ([self.favoritesArray containsObject:[self.pictureArray objectAtIndex:index]])
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
    if (!([self.favoritesArray containsObject:[self.pictureArray objectAtIndex:index]]))
        {
            [self.favoritesArray addObject:[self.pictureArray objectAtIndex:index]];
            self.label.hidden = NO;
            self.label.textColor = [UIColor redColor];
            self.label.text = @"Liked";
        } else
        {
            [self.favoritesArray removeObject:[self.pictureArray objectAtIndex:index]];
            self.label.hidden = YES;
        }
    NSLog(@"%@", self.favoritesArray);
}

@end
