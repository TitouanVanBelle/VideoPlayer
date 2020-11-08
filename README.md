# VideoPlayer

A customizable video player with controls and fullscreen mode

<br/>
<p align="center">
  <img src="https://i.postimg.cc/fL4GmHXQ/Video-Player.png" width="814" height="400">
</p>
<br/>

## How to use

### Load a player item

```swift
let controller = VideoPlayerController()
controller.videoGravity = .resizeAspectFill

let url = Bundle.main.url(forResource: "Skate", withExtension: "mp4")!
let item = AVPlayerItem(url: url)

controller.load(item: item, autoPlay: true)
```

### Control the capabilities

```swift
let capabilities: VideoPlayerController.Capabilities = [.seek, .fullscreen, .playPause]

let controller = VideoPlayerController(capabilities: capabilities)
```

### Change the theme

```swift
var theme = VideoPlayerController.Theme()
theme.backgroundStyle = .plain(.white)
theme.controlsTintColor = .white

let controller = VideoPlayerController(theme: theme)
```

## To do

- Seeking (dragging) 
- Seeking (+/- 15s double tap)
