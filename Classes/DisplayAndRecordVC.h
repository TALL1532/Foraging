//
//  DisplayAndRecordVC.h
//  SentenceForaging
//
//  Created by Andrew Battles on 5/17/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SentenceGridVC.h"
#import "ForagingLoggingSingleton.h"
#import <AVFoundation/AVFoundation.h>
#import <CoreAudio/CoreAudioTypes.h>

@protocol ProcessDataDelegate3 <NSObject>	//---comm
- (void)logIt:(NSString *)stringToLog;		//---comm
- (void)recordingEnded;						//---comm
- (void)addWaitToCounter:(int)waitTime;		//---comm

- (int)getInputMode;						//---comm
- (int)getTlogInputMode;					//---comm
- (NSString *)getTag;						//---comm
- (int)getDelayLow;							//---comm
- (int)getDelayHigh;						//---comm
- (int)getFontSize;							//---comm
- (int)getSetNum;							//---comm
- (int)getOrder;							//---comm
- (int)getTotalWait;						//---comm

@end										//---comm

@interface DisplayAndRecordVC : UIViewController {
    IBOutlet UIButton *recordButton;
    IBOutlet UITextView *sentenceDisplay;
    IBOutlet UIButton *stopButton;
    IBOutlet UIActivityIndicatorView *spinner;
	
	BOOL recording;
	//int fontSize;
	int recordingDelayLow;
	int recordingDelayHigh;
    int delaySecs;
    
	int fontSize;
	NSString *tag;
	
	int inputMode;
	int tlogInputMode;
	BOOL tlogVersion;
	
	NSString *sentenceToDisplay;
	
	NSURL *recordedTempFileURL;
	AVAudioRecorder *recorder;
	NSError *error;
	
	int recordingNum;
	
	int sentenceNum;
    
	id <ProcessDataDelegate3> delegate;		//---comm
    NSTimer * readTimer;
    NSDate *readStart;
	
}
- (IBAction)recordPressed:(id)sender;
- (IBAction)stopPressed:(id)sender;
- (void)displaySentence:(NSString *)sentence;
- (void)setSentenceNum:(int)number;

- (void)logTextEntered;
- (void)delayFunction;
- (int)makeRandomDelay;

- (void)setupRecording;
- (void)beginRecording;
- (void)endRecording;
- (void)saveAudioToLog:(NSURL *)audioFilePath;

-(IBAction)backPressed:(id)sender;

- (NSString *)getDocumentsDirectory;

@property (retain) id delegate;				//---comm

@end
