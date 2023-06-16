# ObjectCaptureApp-WWDC23

Trying out the new ObjectCaptureView &amp; ObjectCaptureSession from [WWDC23](https://developer.apple.com/wwdc23/10191)



https://github.com/KKodiac/ObjectCaptureApp-WWDC23/assets/35219323/c8663a4b-cf2a-4e99-9f9a-eea4ad84ffb4



## Prerequisites 

Running this project requires installing [beta sdks](https://developer.apple.com/download/)
- Xcode 15.0
- iOS 17.0

## Known Bugs

Since this is a beta version of frameworks and sdks, it has serveral problems.
- Session fails after `session.state.initializing` during debugging.
  - Work around: [forum thread](https://developer.apple.com/forums/thread/731324) -> detaching process and relaunching app.
  - You can also -> disable Metal API validation on you build scheme.
- App crashes after selecting `session.beginNewScanPassAfterFlip()` when deciding to start new scan pass session.

