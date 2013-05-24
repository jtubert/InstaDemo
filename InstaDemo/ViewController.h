//
//  ViewController.h
//  InstaDemo
//
//  Created by John Tubert on 5/24/13.
//  Copyright (c) 2013 John Tubert. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Camera.h"

@interface ViewController : UIViewController <UIDocumentInteractionControllerDelegate>{
    Camera* camera;
    UIDocumentInteractionController *documentInteractionController;
}

-(IBAction) getPhoto:(id) sender;

@end
