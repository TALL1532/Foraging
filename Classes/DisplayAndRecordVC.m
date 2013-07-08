    //
//  DisplayAndRecordVC.m
//  SentenceForaging
//
//  Created by Andrew Battles on 5/17/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "DisplayAndRecordVC.h"
#import "SettingsManager.h"
#import "ExpInterfaceVC.h"

//////  delayTime set in StartMenuVC //////////


@implementation DisplayAndRecordVC

-(IBAction)backPressed:(id)sender{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Are you sure you want to quit?"
                                                    message:@"Your session will be reset"
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:@"cancel",nil];
    alert.tag = 22;
    
    [alert show];
    [alert release];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
	//NSLog(@"alertView called");
    if(alertView.tag == 22){//22 is called from the quit button
        if(buttonIndex == 0){
            [self puzzleQuit];
        }
    }
	
}

- (IBAction)recordPressed:(id)sender {
	
	[LoggingSingleton logIt:@"----- RECORD pressed"];
	
	recording = YES;	//change state to recording
	sentenceDisplay.text = @"";	//clear text field for user notes entry
	
	
	if (tlogVersion) {
		NSLog(@"tlogInputMode: %d",tlogInputMode);
		if (tlogInputMode == 1) {
			//make the sentenceDisplay enabled and active
			[sentenceDisplay setBackgroundColor:[UIColor whiteColor]];
			[sentenceDisplay setEditable:YES];
			[sentenceDisplay becomeFirstResponder];
		}
		else {
			//make the background gray to indicate recording ready	
			[sentenceDisplay setBackgroundColor:[UIColor lightGrayColor]];
			
			//--start recorder
			[self beginRecording];
			
			// indicate to the user that recording is ready
			UniChar specialChar = 0x003F;  //question mark   //2713 //2714 //Checkmark
			NSString *specialString = [NSString stringWithCharacters:&specialChar length:1];
			NSString *specialString2 = [NSString stringWithFormat:@"%@",specialString];
			sentenceDisplay.text =  specialString2;
			sentenceDisplay.textColor = [UIColor blackColor];
			sentenceDisplay.font = [UIFont boldSystemFontOfSize:250];
			sentenceDisplay.textAlignment = UITextAlignmentCenter;
			
			
		}
	}
	else {
		if (inputMode == 1) {
			//make the sentenceDisplay enabled and active
			[sentenceDisplay setBackgroundColor:[UIColor whiteColor]];
			[sentenceDisplay setEditable:YES];
			[sentenceDisplay becomeFirstResponder];
		}
		else {
			//make the background gray to indicate recording ready	
			[sentenceDisplay setBackgroundColor:[UIColor lightGrayColor]];
			
			//--start recorder
			[self beginRecording];
			
			// indicate to the user that recording is ready
			UniChar specialChar = 0x003F; //Checkmark
			NSString *specialString = [NSString stringWithCharacters:&specialChar length:1];
			NSString *specialString2 = [NSString stringWithFormat:@"%@",specialString];
			sentenceDisplay.text =  specialString2;
			sentenceDisplay.textColor = [UIColor blackColor];
			sentenceDisplay.font = [UIFont boldSystemFontOfSize:300];
			sentenceDisplay.textAlignment = UITextAlignmentCenter;
			
		}
	}
	//make the stop button black and enabled, record gray and disabled
	[stopButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
	[stopButton setEnabled:YES];
	[recordButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
	[recordButton setEnabled:NO];
	
}

- (IBAction)stopPressed:(id)sender {
	
	[LoggingSingleton logIt:@"----- END RECORDING pressed"];
	
	if (tlogVersion) {
		if(tlogInputMode == 1) {
			[self logTextEntered];
		}
		else {	
			[self endRecording]; //stop the audio recorder
		}
	}
	else {
		if(inputMode == 1) {
			[self logTextEntered];
		}
		else {	
			[self endRecording]; //stop the audio recorder
		}
	}
	
	recording = NO; //change state to not-recording
	
	//gray out stop button and make record button red again for next sentence
    [stopButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
	[recordButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
	[recordButton setEnabled:YES];
	[stopButton setEnabled:NO];
	
	[sentenceDisplay setBackgroundColor:[UIColor whiteColor]];
	[sentenceDisplay setEditable:NO];
	sentenceDisplay.font = [UIFont systemFontOfSize:fontSize];	//return text size to normal
	sentenceDisplay.textAlignment =  UITextAlignmentLeft;
	
    [self dismissViewControllerAnimated:NO completion:nil];
	//[self.navigationController popViewControllerAnimated:NO];
	
	[[self delegate] recordingEnded];
	
}

- (void)displaySentence:(NSString *)sentence {
	
	//store the sentence to the variable.  we will access it in the delayFunction method
	sentenceToDisplay = sentence;
	
	//gray out background
	[sentenceDisplay setBackgroundColor:[UIColor lightGrayColor]];
	sentenceDisplay.text = @"";	//clear text field for user notes entry
	
	//gray out record button and stop button until after delay
	[stopButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
	[recordButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
	[recordButton setEnabled:NO];
	[stopButton setEnabled:NO];	
	
	//get delay
	int delayTime;
	if(sentence.length <= 23) {
		delayTime = 0;
		self.navigationItem.title = @"Record a Travelogue";
		tlogVersion = YES;
		NSLog(@"tlogVersion");
	}
	else {
		delayTime = [self makeRandomDelay]; 
		//NSLog(@"delay time %d",delayTime);
		[[self delegate] addWaitToCounter:delayTime];
		self.navigationItem.title = @"";
		tlogVersion = NO;
		NSLog(@"regular sentence");
	}
	//NSLog(@"before delay");
	//put in a time delay before people can edit the text field
	[self performSelector:@selector(delayFunction) withObject:nil afterDelay:delayTime];
	//NSLog(@"after delay");
	
}

- (void)setSentenceNum:(int)number {
	sentenceNum = number;
}

- (void)delayFunction {
	NSLog(@"delay function called");
	spinner.hidden = YES;
	[sentenceDisplay setBackgroundColor:[UIColor whiteColor]]; //make background white
	
	//gray out stop button and make record button red again so user can recall
    [stopButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
	[recordButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
	[recordButton setEnabled:YES];
	[stopButton setEnabled:NO];
	
	sentenceDisplay.text = sentenceToDisplay;
	[LoggingSingleton logIt:@"----- Sentence Visible"];
    readStart = [[NSDate date] retain];
}

- (int)makeRandomDelay {
	
	int rando;
	if (recordingDelayLow == recordingDelayHigh) {
		rando = 0; //if they are the same, strict delay so no randomization
	}
	else {	
		int span = recordingDelayHigh - recordingDelayLow +1;	//get range for number (+1 to include high end)
		rando = arc4random()%span;	//get a random number in that range
	}
	
    delaySecs = rando + recordingDelayLow;
	
	[LoggingSingleton logIt:[NSString stringWithFormat:@"----- Delayed %d seconds",delaySecs]];
	return delaySecs;
}

- (void)setupRecording {
	
	//--generate temp file for recording into 
	recordedTempFileURL = [NSURL fileURLWithPath:
						[NSTemporaryDirectory() stringByAppendingPathComponent: 
						 //[NSString stringWithFormat: @"%.0f.%@", [NSDate timeIntervalSinceReferenceDate]*1000.0, @"caf"]]];
						 [NSString stringWithFormat: @"tempAudio.caf"]]];
	
	NSLog(@"Audio file called: %@",recordedTempFileURL);
	
	//set up recording session
	NSMutableDictionary *recordSetting = [[NSMutableDictionary alloc] init];
	
	//--audio format
	[recordSetting setValue:[NSNumber numberWithInt:kAudioFormatMPEG4AAC] 
					 forKey:AVFormatIDKey];
	
	//--sampling rate
	[recordSetting setValue:[NSNumber numberWithFloat:16000.0]
					 forKey:AVSampleRateKey];
	
	//--stereo sound (2 channel)
	[recordSetting setValue:[NSNumber numberWithInt:2]
					 forKey:AVNumberOfChannelsKey];
	
	//--set recorder to use temp file above
	recorder = [[AVAudioRecorder alloc] initWithURL:recordedTempFileURL settings:recordSetting error:&error];
	[recordSetting release];
}

- (void)beginRecording {
	NSLog(@"begin recording");
	recordingNum++;

	//--start the actual recording process
	[recorder record];	
}

- (void)endRecording {
	//[LoggingSingleton sharedSingleton].lastDelayTime = delaySecs;
    //[LoggingSingleton sharedSingleton].readTime = delaySecs;
    [[LoggingSingleton sharedSingleton] storeTrialDataWithsentenceNumber:sentenceNum readingTime:[recorder currentTime] delay:delaySecs];
    [[LoggingSingleton sharedSingleton] writeBufferToFile];
    
	[recorder stop];
    
	NSLog(@"endRecording");
	
	[self saveAudioToLog:recordedTempFileURL];
}


- (void)saveAudioToLog:(NSURL *)audioFilePath {
	
	NSString *directory = [self getDocumentsDirectory];
	int setNum = [[self delegate] getSetNum];
	NSString *setName = @"";
	switch (setNum) {
		case 0:
			setName = @"PR";
			break;
		case 1:
			setName = @"CT";
			break;
		case 2:
			setName = @"RI";
            break;
			
	}
    
	//audio saved as "[tag]-[setName]-audio[recordingNum].caf"
	NSString *audioFileName = [NSString stringWithFormat:@"/%@-%@-audio%d.caf",tag,setName,sentenceNum+1];
    NSLog(@"got here");
	//overwrite audioFileName if this is the 25th recording or 4th in practice (indicating it's the travelogue)
	
	
	
	NSString *filePath = [directory stringByAppendingString:audioFileName];
	NSLog(@"full path: %@",filePath);
	
	NSFileManager *fileManager = [[NSFileManager alloc] init];
	if(![fileManager fileExistsAtPath:filePath]) {
		NSLog(@"Sound file does not exist. Creating...");
	}
	else {
		[LoggingSingleton logIt:@"----- Sound file already exists, overwriting"];
	}
	
	//create/overwrite file
	[fileManager createFileAtPath:filePath contents:nil attributes:nil];
	
	NSFileHandle *fileHandle = [NSFileHandle fileHandleForWritingAtPath:filePath];  //telling fileHandle what file write to
	
	NSData *soundData = [[NSData alloc] initWithContentsOfURL:audioFilePath];
	
	//save audio file to audio.caf
	[fileHandle writeData:soundData];
	
	//erase recording
	[recorder deleteRecording];
	
	[fileManager release];
	[soundData release];
}

- (NSString *)getDocumentsDirectory {  
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);  
	return [paths objectAtIndex:0];  
} 

/*
UniChar specialChar = 0x25A0;	--Square
UniChar specialChar = 0x25CF;	--Circle
NSString *specialString = [NSString stringWithCharacters:&specialChar length:1];
[startButton setTitle:specialString forState:UIControlStateNormal];
*/

@synthesize delegate;												//---comm


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    CGFloat inc = 30.0f;
    
    UIActivityIndicatorView *activityIndicator;
    activityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activityIndicator.color = [UIColor blueColor];
    activityIndicator.frame = CGRectMake(0.0, 0.0, 100.0, 100.0);
        activityIndicator.center = self.view.center;
    [self.view addSubview: activityIndicator];
    [activityIndicator release];
    // [activityIndicator startAnimating];
    
	spinner.frame = CGRectMake(spinner.frame.origin.x-inc, spinner.frame.origin.y-inc, spinner.frame.size.width+2*inc, spinner.frame.size.height+2*inc);
    CGAffineTransform transform = CGAffineTransformMakeScale(2.5f, 2.5f);
    spinner.transform = transform;

    spinner.color = [UIColor blueColor];
	
	//change button to a red "record" circle
	UniChar specialChar = 0x25CF; //Circle
	NSString *specialString = [NSString stringWithCharacters:&specialChar length:1];
	[recordButton setTitle:specialString forState:UIControlStateNormal];
	[recordButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
	[recordButton.titleLabel setFont:[UIFont boldSystemFontOfSize:100]];
	
	//change button to a black "stop" square (but grayed out)
	specialChar = 0x25A0; //Square
	specialString = [NSString stringWithCharacters:&specialChar length:1];
	[stopButton setTitle:specialString forState:UIControlStateNormal];
	[stopButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
	[stopButton.titleLabel setFont:[UIFont boldSystemFontOfSize:60]];
	
	[sentenceDisplay setEditable:NO];
	recording = NO;
	
	fontSize = [SettingsManager getIntegerWithKey:FONT_SIZE];
	[sentenceDisplay setFont:[UIFont systemFontOfSize: fontSize]]; 
	
	recordingDelayLow = [[self delegate] getDelayLow];
	recordingDelayHigh = [[self delegate] getDelayHigh];
	
	tag = (NSString*)[SettingsManager getObjectWithKey:SUBJECT_NAME];
	inputMode = [SettingsManager getIntegerWithKey:INPUT_MODE];
    
	if ((inputMode == 2) || (tlogInputMode == 2)) { //if recording audio
		[self setupRecording];
	}
	
	tlogVersion = NO;
	recordingNum = 0;
	
	self.navigationItem.hidesBackButton = YES;
	
	self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc]
											   initWithTitle:@"QUIT" 
											   style:UIBarButtonItemStylePlain
											   target:self
											   action:@selector(puzzleQuit)] autorelease];
	
    [super viewDidLoad];
		
	//[self.navigationController popViewControllerAnimated:NO];
	//this quick push-pop makes sure the window is working on the first try
}

- (void)puzzleQuit {
	//NSLog(@"PuzzleQuit DRVC");
	
	[LoggingSingleton logIt:@"----- QUIT button pressed"];
	
    [self dismissViewControllerAnimated:NO completion:nil];
	//[self.navigationController popViewControllerAnimated:NO];
	
	[[self delegate] puzzleQuit];
	
	
}

- (void)logTextEntered {
	
	NSString *textEntered = sentenceDisplay.text;
	//NSLog(@"%@",textEntered);
	[LoggingSingleton logIt:[NSString stringWithFormat:@"----- Notes: '%@'",textEntered]];
	
}





//////////// DELEGATE FUNCTIONS /////////////////////////////////////////////


- (int)getDelay {
	int delay = [[self delegate] getDelay];
	return delay;
}

- (int)getFontSize {
	int theSize = [[self delegate] getDelay];
	return theSize;
}




////////////////////////////////////////////////////////////////////////////////////////////////////////

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Overriden to allow portrait only
    return ((interfaceOrientation != UIDeviceOrientationLandscapeLeft) &&
			(interfaceOrientation != UIDeviceOrientationLandscapeRight));
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	NSLog(@"MEMORY WARN DISPLAYANDRECORDVC");
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {

    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}
-(void)viewDidAppear:(BOOL)animated{
    spinner.hidden = NO;
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)dealloc {
	
	[recorder autorelease];
	NSLog(@"DisplayAndRecordVC: dealloc");
    [super dealloc];
}


@end
