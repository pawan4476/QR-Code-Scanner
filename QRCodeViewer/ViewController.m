//
//  ViewController.m
//  QRCodeViewer
//
//  Created by Nagam Pawan on 12/15/16.
//  Copyright © 2016 Nagam Pawan. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.capture = nil;
    self.isReading = NO;
    
    [self loadBeepSound];
    
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)startstopScan:(id)sender {
    
    if (!self.isReading) {
        
        if ([self startReading]) {
            
            [self.buttonForBcgrnd setTitle:@"Stop" forState:UIControlStateNormal];
            [self.statusLabel setText:@"Scanning for QR Code"];
            
        }
    }
    
    else{
        
        [self stopReading];
        [self.buttonForBcgrnd setTitle:@"Start" forState:UIControlStateNormal];
        self.isReading = !self.isReading;
        
    }
}

-(BOOL)startReading{
    
    NSError *error;
    AVCaptureDevice *captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:captureDevice error:&error];
    if (!input) {
        
        NSLog(@"%@", [error localizedDescription]);
        return NO;
        
    }
    
    self.capture = [[AVCaptureSession alloc]init];
    [self.capture addInput:input];
    AVCaptureMetadataOutput *captureMetadataOutput = [[AVCaptureMetadataOutput alloc]init];
    [self.capture addOutput:captureMetadataOutput];
    dispatch_queue_t dispatchQueue;
    dispatchQueue = dispatch_queue_create("myQueue", NULL);
    [captureMetadataOutput setMetadataObjectsDelegate:self queue:dispatchQueue];
    [captureMetadataOutput setMetadataObjectTypes:[NSArray arrayWithObject:AVMetadataObjectTypeQRCode]];
    self.previewLayer = [[AVCaptureVideoPreviewLayer alloc]initWithSession:self.capture];
    [self.previewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    [self.previewLayer setFrame:self.scanView.layer.bounds];
    [self.scanView.layer addSublayer:self.previewLayer];
    
    [self.capture startRunning];
    
    return YES;
    
}

-(void)stopReading{
    
    [self.capture stopRunning];
    self.capture = nil;
    [self.previewLayer removeFromSuperlayer];
    
}

-(void)loadBeepSound{
    
    NSString *beepFilePath = [[NSBundle mainBundle] pathForResource:@"beep" ofType:@".mp3"];
    NSURL *beepUrl = [NSURL URLWithString:beepFilePath];
    NSError *error;
    self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:beepUrl error:&error];
    
    if (error) {
        
        NSLog(@"Beep sound can't be played");
        NSLog(@"%@", [error localizedDescription]);
        
    }
    
    else{
        
        [self.audioPlayer prepareToPlay];
        
    }
}

-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    
    if (metadataObjects != nil && [metadataObjects count] > 0) {
        
        AVMetadataMachineReadableCodeObject *object = [metadataObjects objectAtIndex:0];
        
        if ([[object type] isEqualToString:AVMetadataObjectTypeQRCode]) {
            
            [self.statusLabel performSelectorOnMainThread:@selector(setText:) withObject:[object stringValue] waitUntilDone:NO];
            [self performSelectorOnMainThread:@selector(stopReading) withObject:nil waitUntilDone:NO];
            [self.buttonForBcgrnd performSelectorOnMainThread:@selector(setTitle:) withObject:@"Start!" waitUntilDone:NO];
            self.isReading = NO;
            if (self.audioPlayer) {
                
                [self.audioPlayer play];
                
            }
        }
    }
}
@end
