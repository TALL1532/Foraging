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


#define SUBJECT_NAME       @"k_subjectName"
#define INPUT_MODE         @"k_inputMode"
#define PRACTICE_DELAY_LOW @"k_practice_delay_text"
#define PRACTICE_DELAY_HIGH @"k_practice_delay_upper_text"
#define CN_DELAY_LOW       @"k_connecticuit_delay_text"
#define CN_DELAY_HIGH      @"k_connecticuit_delay_upper_text"
#define RI_DELAY_LOW       @"k_ri_delay_text"
#define RI_DELAY_HIGH      @"k_ri_delay_upper_text"
#define SET_TIME_LIMIT     @"k_setTimeLimit"
#define PUZZLE_BREAK_TIME  @"k_puzzleTimeLimit"
#define FONT_SIZE          @"k_font_size_int"

/*[SettingsManager setObject:tag.text withKey:@"k_subjectName"];
[SettingsManager setInteger:inputMode withKey:@"k_inputMode"];

[SettingsManager setInteger:[delay.text integerValue] withKey:@"k_practice_delay_text"];
[SettingsManager setInteger:[delayUpperLimit.text integerValue] withKey:@"k_practice_delay_upper_text"];

[SettingsManager setInteger:[delay2.text integerValue] withKey:@"k_connecticuit_delay_text"];
[SettingsManager setInteger:[delayUpperLimit2.text integerValue] withKey:@"k_connecticuit_delay_upper_text"];

[SettingsManager setInteger:[delay3.text integerValue] withKey:@"k_ri_delay_text"];
[SettingsManager setInteger:[delayUpperLimit3.text integerValue] withKey:@"k_ri_delay_upper_text"];


[SettingsManager setInteger:[setTimeLimit.text integerValue] withKey:@"k_setTimeLimit"];
[SettingsManager setInteger:[puzzleWaitTime.text integerValue] withKey:@"k_puzzleTimeLimit"];

[SettingsManager setInteger:fontSize withKey:@"k_font_size_int"];*/
@class ViewLog;
@class StartMenuVC;


@interface ExpInterfaceVC : UIViewController <UITextViewDelegate, ProcessDataDelegate1> {
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
