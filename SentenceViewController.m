//
//  SentenceViewController.m
//  Foraging
//
//  Created by Thomas Deegan on 4/9/13.
//
//

#import "SentenceViewController.h"

@interface SentenceViewController ()

@end

@implementation SentenceViewController
@synthesize delegate;

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

-(void)setUpButtons{
    if(setNumber == 0){
        numberOfButtons = 3;
        [LoggingSingleton sharedSingleton].currentLocation = @"Practice";
        navBar.topItem.title = @"Practice";

    }
	else if(setNumber == 1){
        numberOfButtons = 21;
        [LoggingSingleton sharedSingleton].currentLocation = @"Connecticut";
        navBar.topItem.title = @"Connecticut";
    }
	else if(setNumber == 2){
        numberOfButtons = 21;
        [LoggingSingleton sharedSingleton].currentLocation = @"Rhode Island";
        navBar.topItem.title = @"Rhode Island";
    }
    NSInteger margins = 15;
    NSInteger rows = 3;
    NSInteger cols = 7;
    CGSize windowSize = self.view.frame.size;
    int navBarSize = 45;
    [buttons release];
    buttons = nil;
    buttons = [[NSMutableArray alloc] init];
    for(int i = 0; i < numberOfButtons; i++){
        NSLog(@"got here");
        UIButton *temp = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [temp setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];	//white-out used buttons
        temp.tag = i;//so that we know which one was pressed in buttonPressed
        
        [temp addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        UniChar specialChar = 0x25CF;	//--Circle
		NSString *specialString = [NSString stringWithCharacters:&specialChar length:1];
		[temp setTitle:specialString forState:UIControlStateNormal];	//set title to a circle
        
        NSLog(@"%f %f %f %f", (windowSize.width)/rows * (i%3), (windowSize.height)/cols * (i/3), (windowSize.width - (rows +1)*margins)/rows, (windowSize.height - (cols + 1)*margins)/cols);
        temp.frame = CGRectMake(margins + (windowSize.width- margins)/rows * (i%3), navBarSize + margins + (windowSize.height- navBarSize - margins)/cols * (i/3), (windowSize.width - (rows +1)*margins)/rows, (windowSize.height - navBarSize - (cols + 1)*margins)/cols);
        [self.view addSubview:temp];
        [buttons addObject:temp];
    }
    [buttons retain];
    
}

- (void)setupSentences:(int)setNum {
		
	NSString *sentencesPath = @"invalid path!";
	if(setNum == 0)      sentencesPath = [[NSBundle mainBundle] pathForResource:@"PRACsentences" ofType:@"txt"];
	else if(setNum == 1) sentencesPath = [[NSBundle mainBundle] pathForResource:@"CTsentences" ofType:@"txt"];
	else if(setNum == 2) sentencesPath = [[NSBundle mainBundle] pathForResource:@"RIsentences" ofType:@"txt"];
    
	NSString *sentencesContent = [NSString stringWithContentsOfFile:sentencesPath
														   encoding:NSUTF8StringEncoding
															  error:nil];
	
	sentencesArray = [sentencesContent componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
	[sentencesArray retain];
	
	sentencesDone = [[NSMutableArray alloc] init];
	[sentencesDone retain];
	
}

- (void) hideButtonsForCategoryType:(NSInteger)type {
    if(type == 0){
        //practice
        [buttons makeObjectsPerformSelector:@selector(setHidden:) withObject: true];
    }
}

- (void)buttonPressed:(UIButton*)sender {
	int number = sender.tag;
	
	UIButton *button = [buttons objectAtIndex:(number)];
	button.enabled = NO;														//diable used buttons
	[button setTitleColor:[UIColor whiteColor]  forState:UIControlStateDisabled];
	
	// push view to DisplayAndRecordVC
    [drvc view];
    [self presentViewController:drvc animated:NO completion:nil];
    //[self presentViewController:drvc animated:NO completion:nil];
	//[self.navigationController pushViewController:drvc animated:NO];
    
	//display the sentence number in the text field of the new window
    [self logIt:[NSString stringWithFormat:@"SENTENCE %d pressed", [[sentenceToButtonIndecies objectAtIndex:number] integerValue] + 1]];
	NSString *theSentence = [sentencesArray objectAtIndex:[[sentenceToButtonIndecies objectAtIndex:number] integerValue]];
    [sentencesDone addObject:[sentenceToButtonIndecies objectAtIndex:number]];
	[drvc displaySentence:theSentence];
	[drvc setSentenceNum:[[sentenceToButtonIndecies objectAtIndex:number] integerValue]];
    
	if(sentencesDone.count == sentencesArray.count) { //if user has pressed all buttons, unhide createTlogButton
		
        doneWithAllButtons = YES;
	}
	
}

- (void)assignSentencesAndScramble{
    [sentenceToButtonIndecies release];
    sentenceToButtonIndecies = nil;
    sentenceToButtonIndecies = [[NSMutableArray alloc] init];
    for(int i = 0; i < numberOfButtons; i++){
        NSNumber *temp;
        do{
            temp = [NSNumber numberWithInt:arc4random()%[sentencesArray count]];
        }while ([sentenceToButtonIndecies indexOfObject:temp] != NSNotFound);
        [sentenceToButtonIndecies addObject:temp];//assigns a sentence number to the button
        
        if(setNumber == 1 || setNumber == 2){
            if([temp integerValue] <7){
                //easy
                [[buttons objectAtIndex:i] setFont:[UIFont boldSystemFontOfSize:20]];
            }
            else if([temp integerValue] >=14){
                //hard
                [[buttons objectAtIndex:i] setFont:[UIFont boldSystemFontOfSize:100]];
            }else{
                //med
                [[buttons objectAtIndex:i] setFont:[UIFont boldSystemFontOfSize:70]];
            }
        }else{//practice
            if([temp integerValue] ==0){
                //easy
                [[buttons objectAtIndex:i] setFont:[UIFont boldSystemFontOfSize:20]];
            }
            else if([temp integerValue] == 2){
                //hard
                [[buttons objectAtIndex:i] setFont:[UIFont boldSystemFontOfSize:100]];
            }else{
                //med
                [[buttons objectAtIndex:i] setFont:[UIFont boldSystemFontOfSize:70]];
            }
        }
        
        
    }
    
}

#pragma mark -
#pragma mark Misc Methods
- (void)logIt:(NSString *)stringToLog {
	//send the log up the chain to WordSearchPuzzleVC, dont log here
	[[self delegate] logIt:stringToLog];
}

-(void) puzzleButtonPressed:(id)sender{
    int puzzleTime;
    if(setNumber !=0){
        puzzleTime = [(NSNumber*)[[NSUserDefaults standardUserDefaults] objectForKey:@"k_puzzleTimeLimit"] integerValue] + totalTime;
    }else{
        puzzleTime = 30;
    }
    [self startMemoryPuzzle:puzzleTime];
}

- (void)startMemoryPuzzle:(int)startTime {
	
	// intialize the memory puzzle
	mvc = [[MemoryVC alloc] initWithNibName:@"MemoryVC" bundle:nil];
	[mvc setDelegate:self];
    [self presentViewController:mvc animated:YES completion:nil];
	//[self.navigationController pushViewController:mvc animated:YES];
	
	[mvc startGame:startTime];
}

- (void)endMemoryPuzzle {
    UIAlertView* takeQuizAlert = [[UIAlertView alloc] initWithTitle:@"Puzzle Done"
                                                            message:@"Please take the paper and pencil quiz now."
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
    [takeQuizAlert show];
    [takeQuizAlert release];
    
    [self dismissViewControllerAnimated:NO completion:nil];
    //[self.navigationController popViewControllerAnimated:NO];
	[mvc release];
    [self returnToMainMenu];

}

- (void)returnToMainMenu{
	//NSLog(@"close Puzzle SGVC");
	
    [self dismissViewControllerAnimated:NO completion:nil];
	//[self.navigationController popViewControllerAnimated:NO];
	int next = [[self delegate] getNextSet:setNumber];
    [[self delegate] setSetNumber:next];
	[[self delegate] puzzleEnded];
	
	
	[sentencesArray release];
	[sentencesDone release];
	
	[drvc release];
	NSLog(@"drvc released");
}


- (void)addWaitToCounter:(int)waitTime{
    
}

#pragma mark -
#pragma mark Delegate Methods

- (void)puzzleQuit {
	
	[[self delegate] logIt:@"----- QUIT button pressed"];
	
    [self dismissViewControllerAnimated:NO completion:nil];
	//[self.navigationController popViewControllerAnimated:NO];
	
	UIAlertView *doneAlert = [[UIAlertView alloc] initWithTitle:nil message:@"Foraging Aborted"
													   delegate:self
											  cancelButtonTitle:@"OK"
											  otherButtonTitles:nil];
	[doneAlert show];
	[doneAlert release];
    
}

- (void)recordingEnded{
    if(doneWithAllButtons || totalTime <= 0){
        for(int i = 0; i <  [buttons count]; i++){
            ((UIButton*)[buttons objectAtIndex:i]).enabled = false;
        }
        UIAlertView *doneAlert = [[UIAlertView alloc] initWithTitle:nil message:@"Done with this set!"
														   delegate:self
												  cancelButtonTitle:@"OK"
												  otherButtonTitles:nil];
		//[doneAlert show];
		[doneAlert release];
		
        
        UIButton *puzzleButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        puzzleButton.frame = CGRectMake(234, 300, 300, 100);
        [puzzleButton setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
        
        [puzzleButton setTitle:@"PUZZLE BREAK!!" forState:UIControlStateNormal];
                
        [puzzleButton addTarget:self action:@selector(puzzleButtonPressed:) forControlEvents:UIControlEventTouchUpInside];

        
        [self.view addSubview:puzzleButton];
        
		
		[self logIt:@"----- Set Complete!"];
    }
}

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
	int delay = [[self delegate] getDelayLow:setNumber];
	return delay;
}

- (int)getDelayHigh {
	int delay = [[self delegate] getDelayHigh:setNumber];
	return delay;
}

- (int)getFontSize {
	int fontSize = [[self delegate] getFontSize];
	return fontSize;
}
- (int)getSetNum {
	return setNumber;
}

- (int)getOrder {
	return true;
}

- (int)getTotalWait{
    return 1;
}


#pragma mark -
#pragma mark Timer methods

- (NSString *)timeFormatted:(int)totalSeconds
{
    
    int seconds = totalSeconds % 60;
    int minutes = (totalSeconds / 60) % 60;
    int hours = totalSeconds / 3600;
    
    return [NSString stringWithFormat:@"%02d:%02d:%02d",hours, minutes, seconds];
}

-(void)updateTimer:(id)sender{
    if( !doneWithAllButtons && totalTime >0){
        totalTime --;
        [self performSelector:@selector(updateTimer:) withObject:nil afterDelay:1];
    }
    if(totalTime >0){
        
        totalTimeLabel.text = [self timeFormatted:totalTime];
        
    }
    else{
        
        totalTimeLabel.text = @"0:00";
        totalTimeLabel.textColor = [UIColor redColor];
        [self recordingEnded];//called to show puzzle break
    }
}

#pragma mark -
#pragma mark Initialization

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    
    
    
    self.view.backgroundColor = [UIColor colorWithRed:0.3 green:0.5 blue:0.8 alpha:1.0];
    setNumber = [[self delegate] getSetNum];
    [self setUpButtons];
    [self setupSentences:setNumber];
    [self assignSentencesAndScramble];
    
    doneWithAllButtons = NO;
    
    drvc = [[DisplayAndRecordVC alloc] init];
	[drvc setDelegate:self];
    
    totalTime = [(NSNumber*)[[NSUserDefaults standardUserDefaults] objectForKey:@"k_setTimeLimit"] integerValue];
    if(setNumber ==0){
        totalTime =180;
    }
    
    totalTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 105, 7, 100, 30)];
    totalTimeLabel.backgroundColor = [UIColor whiteColor];
    totalTimeLabel.textAlignment = UITextAlignmentRight;
    totalTimeLabel.text = @"0:00";
    [self.view addSubview:totalTimeLabel];
    [self updateTimer:nil];
    
    UIBarButtonItem *timeItem = [[UIBarButtonItem alloc] initWithCustomView:totalTimeLabel];
    self.navigationItem.rightBarButtonItem = timeItem;
    [timeItem release];

    [totalTimeLabel release];
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

-(void)viewDidAppear:(BOOL)animated{
    
    
    [super viewDidAppear:animated];
}

- (void) viewDidUnload{
    [buttons release];
    buttons = nil;
    [sentenceToButtonIndecies release];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) dealloc{
    
    [super dealloc];
}

@end
