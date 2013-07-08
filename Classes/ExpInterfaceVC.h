//
//  ExpInterfaceVC.h
//  Foraging
//
//  Created by Andrew Battles on 6/2/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "ViewLog.h"
#import "StartMenuVC.h"
#import "SettingsManager.h"

@class ViewLog;
@class StartMenuVC;


@interface ExpInterfaceVC : UIViewController <UITextViewDelegate, ProcessDataDelegate1> {
											//<UITextViewDelegate> added so text field delegate works
											//remember to link delegate outlet of text field to "File's Owner"
    IBOutlet UIButton *connButton;
	IBOutlet UIButton *pracButton;
    IBOutlet UIButton *riButton;
	
    IBOutlet UITextField *delay;
	IBOutlet UITextField *delay2;
    IBOutlet UITextField *delay3;
	IBOutlet UITextField *delayUpperLimit;
    IBOutlet UITextField *delayUpperLimit2;
    IBOutlet UITextField *delayUpperLimit3;
	IBOutlet UITextField *puzzleWaitTime;
    IBOutlet UITextField *setTimeLimit;
	IBOutlet UILabel *mathIndicator;
	IBOutlet UILabel *mathIndicator2;
    IBOutlet UILabel *mathIndicator3;
	
    IBOutlet UITextField *tag;
    IBOutlet UIButton *fontMinusButton;
    IBOutlet UIButton *fontPlusButton;
    IBOutlet UITextView *fontView;
	
    IBOutlet UIButton *textModeButton;
    IBOutlet UIButton *voiceModeButton;
	IBOutlet UIButton *tlogTextModeButton;
    IBOutlet UIButton *tlogVoiceModeButton;

    IBOutlet UIButton *crashButton;
   

	ViewLog *viewLog;
	StartMenuVC *smvc;

	
	int inputMode; 
	int tlogInputMode;
	int fontSize;
	
	int CTfirst;
	
	NSArray *crasher;
    
    BOOL hasStartedCT;

}
- (IBAction)connButtonPressed:(id)sender;
- (IBAction)pracButtonPressed:(id)sender;
- (IBAction)riButtonPressed:(id)sender;
- (IBAction)fontMinusPressed:(id)sender;
- (IBAction)fontPlusPressed:(id)sender;
- (IBAction)textModePressed:(id)sender;
- (IBAction)voiceModePressed:(id)sender;
- (IBAction)tlogTextModePressed:(id)sender;
- (IBAction)tlogVoiceModePressed:(id)sender;

- (IBAction)crashPressed:(id)sender;


- (void)showMath;
- (void)hideMathIndicators;

// crash functions
- (void)crashProgram;
- (void)saveExpSettings;
- (void)loadExpSettings;

//log functions
- (void)logIt:(NSString *)whatToLog;
- (NSString *)getDocumentsDirectory;
- (void)showLogPressed;
- (void)endLog;

//delegate functions
- (NSString *)getTag;
- (int)getDelayLow:(int)setNum;
- (int)getDelayHigh:(int)setNum;
- (int)getFontSize;
- (int)getInputMode;
- (int)getTlogInputMode;
- (int)getTotalWait;
- (int)getNextSet:(int)setNum;


@end
