//
//  ViewController.m
//  FileSuffixesTest
//
//  Created by Nick Lockwood on 08/06/2012.
//
//

#import "ViewController.h"
#import "StandardPaths.h"


@implementation ViewController

@synthesize imageView1;
@synthesize imageView2;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //NOTE: because [UIImage imageWithContentsOfFile:...] automatically applies standard suffixes
    //if available anyway, we need to load images using NSData to really test this functionality
    //unfortunately this means some additional complexity to ensure the image is loaded with
    //the correct scale factor
    
    //load image 1
    NSString *path1 = [[NSFileManager defaultManager] normalizedPathForFile:@"Image1.png"];
    NSData *data1 = [NSData dataWithContentsOfFile:path1];
    self.imageView1.image = [UIImage imageWithData:data1 scale:[path1 scaleFromSuffix]];

    //load image 2
    NSString *path2 = [[NSFileManager defaultManager] normalizedPathForFile:@"Image2.png"];
    NSData *data2 = [NSData dataWithContentsOfFile:path2];
    self.imageView2.image = [UIImage imageWithData:data2 scale:[path2 scaleFromSuffix]];
}

@end
