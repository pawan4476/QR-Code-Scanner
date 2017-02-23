//
//  ViewController.h
//  QRCodeViewer
//
//  Created by Nagam Pawan on 12/15/16.
//  Copyright © 2016 Nagam Pawan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface ViewController : UIViewController<AVCaptureMetadataOutputObjectsDelegate>

@property (strong, nonatomic)AVCaptureSession *capture;
@property (strong, nonatomic)AVCaptureVideoPreviewLayer *previewLayer;
@property (strong, nonatomic)AVAudioPlayer *audioPlayer;
@property (nonatomic) BOOL isReading;

@property (strong, nonatomic) IBOutlet UIView *scanView;
@property (strong, nonatomic) IBOutlet UILabel *statusLabel;
@property (strong, nonatomic) IBOutlet UIButton *buttonForBcgrnd;

- (IBAction)startstopScan:(id)sender;

-(BOOL)startReading;
-(void)stopReading;
-(void)loadBeepSound;

@end

