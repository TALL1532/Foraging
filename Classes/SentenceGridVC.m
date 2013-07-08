    //
//  SentenceGridVC.m
//  SentenceForaging
//
//  Created by Andrew Battles on 5/14/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "SentenceGridVC.h"


@implementation SentenceGridVC


@synthesize delegate;												//---comm


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	//NSLog(@"ViewDidLoad SGVC");
	
	sentenceSet = [[self delegate] getSetNum];
	CTfirstOrder = [[self delegate] getOrder];
	
	[self setupSentences:sentenceSet];
	NSLog(@"sentences set up");
	
	[self setupButtons:sentenceSet];
	NSLog(@"buttons set up");
		
	[self loadSentencesIntoButtons:sentenceSet];
	NSLog(@"sentences loaded");
	
	[self randomizeButtonLocation:sentenceSet];
	
	NSLog(@"randomized");
	
	self.navigationItem.hidesBackButton = YES;
	
	self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc]
											   initWithTitle:@"QUIT" 
											   style:UIBarButtonItemStylePlain
											   target:self
											   action:@selector(puzzleQuit)] autorelease];
	
	/////////////create travelogue, for demonstration only //////////////////////////////////
	self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc]
											  initWithTitle:@"Skip to Travelogue" 
											  style:UIBarButtonItemStylePlain
											  target:self
											  action:@selector(createTlogSpare)] autorelease];
	/////////////////////////////////////////////////////////////////////////////////////////

	[createTlogButton setHidden:YES];
	[createTlogButton setEnabled:NO];
	
	//NSLog(@"tlog button created");
	
	buttonsPressed = 0;
	
	//initialize view for sentence display and recording
	drvc = [[DisplayAndRecordVC alloc] initWithNibName:@"DisplayAndRecordVC" bundle:nil];
	[drvc setDelegate:self];
	[self.navigationController pushViewController:drvc animated:NO];
	
	//clear counter
	cumulativeDelay = 0;
	
	//NSLog(@"drvc initialized");
	
	[self logIt:@"----- Button grid visible"];
	
    [super viewDidLoad];
}

- (void)setupSentences:(int)setNum {
	
	sentenceSet = setNum;
	
	NSString *sentencesPath = @"invalid path!";
	
	if(setNum == 1) {
		sentencesPath = [[NSBundle mainBundle] pathForResource:@"PRACsentences" ofType:@"txt"];
	}
	if(setNum == 2) {
		if (CTfirstOrder) {
			sentencesPath = [[NSBundle mainBundle] pathForResource:@"CTsentences" ofType:@"txt"];
		}
		else {
			sentencesPath = [[NSBundle mainBundle] pathForResource:@"RIsentences" ofType:@"txt"];
		}
	}
	if(setNum == 3) {
		if (CTfirstOrder) {
			sentencesPath = [[NSBundle mainBundle] pathForResource:@"RIsentences" ofType:@"txt"];	
		}
		else {
			sentencesPath = [[NSBundle mainBundle] pathForResource:@"CTsentences" ofType:@"txt"];
		}

	}

	NSString *sentencesContent = [NSString stringWithContentsOfFile:sentencesPath
														   encoding:NSUTF8StringEncoding
															  error:nil];
	
	sentencesArray = [sentencesContent componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
	[sentencesArray retain];
	
	sentencesDone = [[NSMutableArray alloc] init];
	[sentencesDone retain];
	
}

- (void)setupButtons:(int)setNum {
	
	if(setNum == 1) {
		buttonArray = [[NSArray alloc] initWithObjects:button1, button2, button3, nil];
		
		[self hide21Buttons];
		
	}
	else {
	
		//initialze array of button names
		buttonArray = [[NSArray alloc] initWithObjects:button1, button2, button3, button4,button5 ,button6 ,button7 ,button8 ,button9 ,button10 
				   ,button11 ,button12 ,button13 ,button14 ,button15 ,button16 ,button17 ,button18 ,button19 ,button20
				   ,button21 ,button22 ,button23 ,button24 ,nil];
	}
	
	[buttonArray retain];
	
}

- (void)hide21Buttons {
	
	//build an array of the buttons we're hiding
	NSArray *hiddenButtons = [[NSArray alloc] initWithObjects:button4,button5 ,button6 ,button7 ,button8 ,button9 ,button10 
							  ,button11 ,button12 ,button13 ,button14 ,button15 ,button16 ,button17 ,button18 ,button19 ,button20
							  ,button21 ,button22 ,button23 ,button24 ,nil];
	
	//int arraySize = (sizeof hiddenButtons)/(sizeof hiddenButtons[0]); //get length of array by dividing (sizeof array) by size of one element
	
	//hide buttons 4-24
	UIButton *button;
	int i;
	for (i = 0; i<18; i++) {
		button = [hiddenButtons objectAtIndex:i];
		[button setHidden:YES];
	}
	[hiddenButtons release];
}

- (IBAction)createTlogPressed:(id)sender {
	
	//NSLog(@"Travelogue Button Pressed");
	[[self delegate] logIt:@"----- TRAVELOGUE Button Pressed"];
	
	//set up memory puzzle
	int delayTime = [self getMemoryPuzzleTime];
	NSLog(@"Clearing WM for %d seconds...",delayTime);
	[self startMemoryPuzzle:delayTime];
	//[self performSelector:@selector(endMemoryPuzzle) withObject:nil afterDelay:delayTime+1];
	buttonsPressed++;
}

////////////////////////////////////////////////////////////////////////////////////
- (void)createTlogSpare {
	
	[[self delegate] logIt:@"----- (Spare) TRAVELOGUE Button Pressed"];
	
	//set up memory puzzle
	int delayTime = [self getMemoryPuzzleTime];
	[self startMemoryPuzzle:delayTime];
	//[self performSelector:@selector(endMemoryPuzzle) withObject:nil afterDelay:delayTime+1];
	buttonsPressed = (sentencesArray.count+1);
	
	// push view to DisplayAndRecordVC
	//[self.navigationController pushViewController:drvc animated:NO];
	//[drvc displaySentence:@"(press record to begin)"];
}
/////////////////////////////////////////////////////////////////////////////////////

- (void)startMemoryPuzzle:(int)startTime {
	
	// intialize the memory puzzle
	mvc = [[MemoryVC alloc] initWithNibName:@"MemoryVC" bundle:nil];
	[mvc setDelegate:self];
	[self.navigationController pushViewController:mvc animated:YES];
	
	[mvc startGame:startTime];
}

- (void)endMemoryPuzzle {

	[mvc release];	
}


- (void)recordingEnded { //called by drvc
	
	if(buttonsPressed == (sentencesArray.count+1)) {
		
		UIAlertView *doneAlert = [[UIAlertView alloc] initWithTitle:nil message:@"Done with this set!" 
														   delegate:self 
												  cancelButtonTitle:@"OK" 
												  otherButtonTitles:nil]; 
		[doneAlert show]; 
		[doneAlert release]; 
		
		
		[self puzzleInterrupted];
		[self closePuzzle];
		
		[self logIt:@"----- Set Complete!"];
	}
	
	
}

- (void)logIt:(NSString *)stringToLog {
	//send the log up the chain to WordSearchPuzzleVC, dont log here
	[[self delegate] logIt:stringToLog];
}



- (void)loadSentencesIntoButtons:(int)setNum {
	
	//[button1 setTitle:[sentencesArray objectAtIndex:0] forState:UIControlStateNormal];
	
	UIButton *button;
	//this for-loop sets the title of each button to the number of words in its corresponding sentence
	int n;
	for (n=0; n < (sentencesArray.count); n++) {			//for each button
		
		//NSLog(@"Length of sentence %d: %d",n+1,thisLength);		
		
		button = [buttonArray objectAtIndex:n];	//get button #
		
		//turn button text into a circle
		UniChar specialChar = 0x25CF;	//--Circle
		NSString *specialString = [NSString stringWithCharacters:&specialChar length:1];
		[button setTitle:specialString forState:UIControlStateNormal];	//set title to a circle
		
		
		int titleSize;
		
		if(setNum == 1) {
			titleSize = (2*n+2)*12;
		}
		else {
			titleSize= (n/8+1)*35;
		}
		
		[button.titleLabel setFont:[UIFont boldSystemFontOfSize:titleSize]];
		[button setTitleColor:[UIColor colorWithRed:0.1 green:0.1 blue:0.7 alpha:0.9f]
					 forState:UIControlStateNormal];
		
		//int thisLength = [self getSentenceLength:n];		//get length
		//[button setTitle:[NSString stringWithFormat:@"%d",thisLength] forState:UIControlStateNormal];	//assign length to button title
	}
	
}

- (void)randomizeButtonLocation:(int)setNum {
	
	//first, create a randomized array of the button numbers
	int buttonNumSize;

	if(setNum == 1) {
		buttonNumSize = 3;
	}
	else {
		buttonNumSize = 24;
	}
	
	int buttonNums[buttonNumSize];
	
	int j;
	if(setNum == 1) {
		for(j=0;j<3;j++) {
			buttonNums[j] = (j+1);
		}
	}
	else {
		for(j=0;j<24;j++) {
			buttonNums[j] = (j+1);
		}
	}
	
	
	int i;
	int arraySize = (sizeof buttonNums)/(sizeof buttonNums[0]); //get length of array by dividing (sizeof array) by size of one element
	NSLog(@"size: %d",arraySize);
	
	int a;		
	int b;
	int rando;
	
	for (i = 0; i< arraySize; i++) {
		
		rando = (random()%arraySize);		//get a random position to move this number to
		a = buttonNums[i];		//store the current value in that position
		b = buttonNums[rando];
		
		
		buttonNums[i] = b;	//move the random number to the position of the current number
		buttonNums[rando] = a;		//move the old number into the position it was swapped with
		
	}
	
	
	//Log the button locations
	[self logIt:@"----- Sentence -> ButtonGridLocation"];
	
	for (i = 0; i< arraySize; i++) {
		//NSLog(@"%d - %d",i+1,buttonNums[i]);	
		[self logIt:[NSString stringWithFormat:@"----- %d -> %d",i+1,buttonNums[i]]];
	}
	
	
	
	
	// now that we have a randomized order, put the buttons in the locations corresponding to their randomized order
	int xPos;
	int yPos;
	int n;
	
	UIButton *button;
	CGRect buttonRect;
	
	for (i = 0; i< arraySize; i++) {
		
		n = buttonNums[i];	//this is the number of the button location we're moving to
		
		xPos = 103+(n-1)%4*187;
		yPos = 90+(n-1)/4*155;
		//xPos = 85+(n-1)%5*150;
		//yPos = 65+(n-1)/5*98;
		
 
		button = [buttonArray objectAtIndex:i];	//get button 'i'
		
		buttonRect = CGRectMake(xPos-83.5, yPos-67.5, 167, 135);
		button.frame = buttonRect;
		//******* [[self delegate] logIt:[NSString stringWithFormat:@"----- Button %d at position %d",i+1,buttonNums[i]]]; //*********
	}
	
	
}


- (void)buttonPressed:(NSInteger)number {
	
	//NSLog(@"Button %d Pressed",number);
	//NSLog(@"%@",[sentencesArray objectAtIndex:(number-1)]);
	[[self delegate] logIt:[NSString stringWithFormat:@"----- SENTENCE %d pressed",number]];
	
	
	UIButton *button = [buttonArray objectAtIndex:(number-1)];
	button.enabled = NO;														//diable used buttons
	[button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];	//white-out used buttons
	

	
	// push view to DisplayAndRecordVC
	[self.navigationController pushViewController:drvc animated:NO];

	//display the sentence number in the text field of the new window
	NSString *theSentence = [sentencesArray objectAtIndex:(number-1)];
	[drvc displaySentence:theSentence];
	[drvc setSentenceNum:number];

	buttonsPressed++;
	
	if(buttonsPressed == sentencesArray.count) { //if user has pressed all buttons, unhide createTlogButton
		
	//if(buttonsPressed == 2) {	
		[createTlogButton setHidden:NO];
		[createTlogButton setEnabled:YES];
		
	}
	
}

//////////// DELEGATE FUNCTIONS /////////////////////////////////////////////

- (int)getInputMode {
	int mode = [[self delegate] getInputMode];
	return mode;
}

- (int)getTlogInputMode {
	int mode = [[self delegate] getTlogInputMode];
	return mode;
}

- (NSString *)getTag {
	NSString *tag = [[self delegate] getTag];
	return tag;
}

- (int)getDelayLow {
	int delay = [[self delegate] getDelayLow];
	return delay;
}

- (int)getDelayHigh {
	int delay = [[self delegate] getDelayHigh];
	return delay;
}

- (int)getFontSize {
	int fontSize = [[self delegate] getFontSize];
	return fontSize;
}

- (int)getMemoryPuzzleTime { //returns the amount of time to run the memory puzzle
	int totalWait = [[self delegate] getTotalWait];
	int waitLeft = totalWait-cumulativeDelay;
	
	if (sentenceSet == 1) {
		return 30;
	}
	else {
		if (waitLeft < 1) {
			return 0;
		}
		else {
		    return waitLeft;
		}
	}
}

- (int)getSentenceLength:(int)index {
	
	NSArray *words = [[sentencesArray objectAtIndex:(index)] componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
	int wordCount = words.count;
	return wordCount;
}

- (int)getSetNum {
	return sentenceSet;
}

- (int)getOrder {
	return CTfirstOrder;
}

- (void)addWaitToCounter:(int)waitTime {
	cumulativeDelay = cumulativeDelay+waitTime;
	NSLog(@"cumulativeDelay: %d",cumulativeDelay);
}


- (void)puzzleQuit {
	//NSLog(@"puzzleQuit SGVC");
	
	[[self delegate] logIt:@"----- QUIT button pressed"];
	[self showBackButton];
	
	[self.navigationController popViewControllerAnimated:NO];
	
	UIAlertView *doneAlert = [[UIAlertView alloc] initWithTitle:nil message:@"Foraging Aborted" 
													   delegate:self 
											  cancelButtonTitle:@"OK" 
											  otherButtonTitles:nil]; 
	[doneAlert show]; 
	[doneAlert release]; 
		
}

- (void)puzzleInterrupted {
	//NSLog(@"puzzleInterrupted SGVC");
	
	[self showBackButton];
	[self.navigationController popViewControllerAnimated:NO];
	 
}

- (void)showBackButton {
	
	self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc]
											  initWithTitle:@"Back To Menu" 
											  style:UIBarButtonItemStylePlain
											  target:self
											  action:@selector(closePuzzle)] autorelease];
	
	self.navigationItem.rightBarButtonItem = nil;	
}

- (void)closePuzzle {
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Are you sure you want to quit?"
                                                    message:@"Your session will be reset"
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:@"cancel",nil];
    alert.tag = 103;
    [alert show];
    [alert release];
}
- (void)actualClosePuzzle {
	//NSLog(@"close Puzzle SGVC");
	
	[self.navigationController popViewControllerAnimated:NO];
	
	[[self delegate] puzzleEnded];
	[[self delegate] setSetNumber:sentenceSet+1 :CTfirstOrder];
	
	[sentencesArray release];
	[sentencesDone release];
	[buttonArray release];
	
	[drvc release];
	NSLog(@"drvc released");
}


////////////////////////////////////////////////////////////////////////////////////////////////////

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Overriden to allow only vertical orientations.
    return ((interfaceOrientation != UIDeviceOrientationLandscapeLeft) &&
			(interfaceOrientation != UIDeviceOrientationLandscapeRight));
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	//[MemoryVC release];
	NSLog(@"MEMORY WARN SENTENCEGRIDVC");
    
    // Release any cached data, images, etc. that aren't in use.
}


- (void)viewDidUnload {
	
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
	
	NSLog(@"SentenceGridVC: dealloc");
    [super dealloc];
}

- (IBAction)button1Pressed:(id)sender {
	[self buttonPressed:1];
}
- (IBAction)button2Pressed:(id)sender {
    [self buttonPressed:2];
}
- (IBAction)button3Pressed:(id)sender {
    [self buttonPressed:3];
}
- (IBAction)button4Pressed:(id)sender {
    [self buttonPressed:4];
}
- (IBAction)button5Pressed:(id)sender {
    [self buttonPressed:5];
}
- (IBAction)button6Pressed:(id)sender {
    [self buttonPressed:6];
}
- (IBAction)button7Pressed:(id)sender {
    [self buttonPressed:7];
}
- (IBAction)button8Pressed:(id)sender {
    [self buttonPressed:8];
}
- (IBAction)button9Pressed:(id)sender {
    [self buttonPressed:9];
}
- (IBAction)button10Pressed:(id)sender {
    [self buttonPressed:10];
}
- (IBAction)button11Pressed:(id)sender {
    [self buttonPressed:11];
}
- (IBAction)button12Pressed:(id)sender {
    [self buttonPressed:12];
}
- (IBAction)button13Pressed:(id)sender {
    [self buttonPressed:13];
}
- (IBAction)button14Pressed:(id)sender {
    [self buttonPressed:14];
}
- (IBAction)button15Pressed:(id)sender {
    [self buttonPressed:15];
}
- (IBAction)button16Pressed:(id)sender {
    [self buttonPressed:16];
}
- (IBAction)button17Pressed:(id)sender {
    [self buttonPressed:17];
}
- (IBAction)button18Pressed:(id)sender {
    [self buttonPressed:18];
}
- (IBAction)button19Pressed:(id)sender {
    [self buttonPressed:19];
}
- (IBAction)button20Pressed:(id)sender {
    [self buttonPressed:20];
}
- (IBAction)button21Pressed:(id)sender {
    [self buttonPressed:21];
}
- (IBAction)button22Pressed:(id)sender {
    [self buttonPressed:22];
}
- (IBAction)button23Pressed:(id)sender {
    [self buttonPressed:23];
}
- (IBAction)button24Pressed:(id)sender {
    [self buttonPressed:24];
}

@end
