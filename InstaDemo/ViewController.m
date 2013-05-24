//
//  ViewController.m
//  InstaDemo
//
//  Created by John Tubert on 5/24/13.
//  Copyright (c) 2013 John Tubert. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onImageAdded:) name:@"addImage" object:nil];
    camera = [Camera new];
    [camera setViewController:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction) getPhoto:(id) sender {
	[camera photoCaptureButtonAction:sender];
}

- (void) onImageAdded:(NSNotification*)notification{   
    UIImage *img = (UIImage*)[notification object];
    NSLog(@"img: %@",img);    
    
    
    UIImageView* iview = [[UIImageView alloc] initWithImage:img];
    [self.view addSubview:iview];
    [self saveToInstagram:img];
    
}



-(void) saveToInstagram:(UIImage*) i {
    NSString *savePath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Screenshot.igo"];
    
    // Write image to PNG
    [UIImageJPEGRepresentation(i, 1.0) writeToFile:savePath atomically:YES];
    
    NSURL *instagramURL = [NSURL URLWithString:@"instagram://app"];
    
    if ([[UIApplication sharedApplication] canOpenURL:instagramURL]) {
        //imageToUpload is a file path with .ig file extension
        documentInteractionController = [UIDocumentInteractionController interactionControllerWithURL:[NSURL fileURLWithPath:savePath]];
        documentInteractionController.UTI = @"com.instagram.exclusivegram";
        documentInteractionController.delegate = self;
        
        documentInteractionController.annotation = [NSDictionary dictionaryWithObject:@"Insert Caption here" forKey:@"InstagramCaption"];
        [documentInteractionController presentOpenInMenuFromRect:CGRectZero inView:self.view animated:YES];
        
    }
}

- (UIImage *) scaleToSize: (CGSize)size  withImage:(UIImage*)img
{
    // Scalling selected image to targeted size
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(NULL, size.width, size.height, 8, 0, colorSpace, kCGImageAlphaPremultipliedLast);
    CGContextClearRect(context, CGRectMake(0, 0, size.width, size.height));
    
    if(img.imageOrientation == UIImageOrientationRight)
    {
        CGContextRotateCTM(context, -M_PI_2);
        CGContextTranslateCTM(context, -size.height, 0.0f);
        CGContextDrawImage(context, CGRectMake(0, 0, size.height, size.width), img.CGImage);
    }
    else
        CGContextDrawImage(context, CGRectMake(0, 0, size.width, size.height), img.CGImage);
    
    CGImageRef scaledImage=CGBitmapContextCreateImage(context);
    
    CGColorSpaceRelease(colorSpace);
    CGContextRelease(context);
    
    UIImage *image = [UIImage imageWithCGImage: scaledImage];
    
    CGImageRelease(scaledImage);
    
    return image;
}

- (UIImage *) scaleProportionalToSize: (CGSize)size1 withImage:(UIImage*)img
{
    if(img.size.width>img.size.height)
    {
        NSLog(@"LandScape");
        size1=CGSizeMake((img.size.width/img.size.height)*size1.height,size1.height);
    }
    else
    {
        NSLog(@"Potrait");
        size1=CGSizeMake(size1.width,(img.size.height/img.size.width)*size1.width);
    }
    
    return [self scaleToSize:size1 withImage:img];
}

- (UIDocumentInteractionController *) setupControllerWithURL: (NSURL*) fileURL usingDelegate: (id <UIDocumentInteractionControllerDelegate>) interactionDelegate {
    
    NSLog(@"setupControllerWithURL");
    UIDocumentInteractionController *interactionController = [UIDocumentInteractionController interactionControllerWithURL: fileURL];
    interactionController.delegate = interactionDelegate;
    
    return interactionController;
}

- (void)documentInteractionControllerWillPresentOpenInMenu:(UIDocumentInteractionController *)controller {
    NSLog(@"documentInteractionControllerWillPresentOpenInMenu %@", controller);
}





@end
