//
//  ViewLog.h
//  Span Task
//
//  Created by Andrew Battles on 7/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>

@protocol ProcessDataDelegate4 <NSObject>	//---comm
- (NSString *)getTag;						//---comm
- (void)endLog;								//---comm
@end										//---comm


@interface ViewLog : UIViewController <MFMailComposeViewControllerDelegate>{
    IBOutlet UITextView *logView;
    IBOutlet UIButton *clearLogButton;
    IBOutlet UIButton *emailLogButton;
    IBOutlet UITextView *tagView;
	
	NSString *expTag;
	
	id <ProcessDataDelegate4> delegate;		//---comm
}

- (IBAction)clearLogPressed:(id)sender;
- (IBAction)emailLogPressed:(id)sender;

- (NSString *)getDocumentsDirectory;
- (void)displayLogContents;
- (void)backToMenuPressed;

- (void)deleteAudioFiles;

@property (retain) id delegate;				//---comm

@end
