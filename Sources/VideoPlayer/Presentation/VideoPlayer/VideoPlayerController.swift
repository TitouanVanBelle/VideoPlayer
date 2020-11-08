
import AVFoundation
import Combine
import PureLayout
import UIKit


public final class VideoPlayerController: UIViewController {

    // MARK: Public Properties

    @Published public var currentTime: CMTime = .zero

    public var videoGravity: AVLayerVideoGravity {
        get { playerView.playerLayer.videoGravity }
        set { playerView.playerLayer.videoGravity = newValue }
    }

    @Published public var isPlaying: Bool = false

    public lazy var itemDidPlayToEnd: AnyPublisher<Void, Never> = {
        store.itemDidPlayToEnd
    }()

    public var player: AVPlayer {
        store.player
    }

    // MARK: Private Properties

    private lazy var playerView: PlayerView = makePlayerView()
    private lazy var blurredView: UIView = makeBlurredBiew()
    private lazy var backgroundView: PlayerView = makeBackgroundView()
    private lazy var controlsViewController: ControlsViewController = makeControlsViewController()

    private var cancellables = Set<AnyCancellable>()

    private let store: VideoPlayerStore
    private let viewFactory: VideoPlayerViewFactoryProtocol

    private let theme: Theme
    private let capabilities: Capabilities

    // MARK: Init

    public init(capabilities: Capabilities = .all, theme: Theme = Theme()) {
        self.capabilities = capabilities
        self.theme = theme
        self.store = VideoPlayerStore()
        self.viewFactory = VideoPlayerViewFactory()

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Life Cycle

    public override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        setupBindings()
    }
}

// MARK: Public

public extension VideoPlayerController {
    func load(item: AVPlayerItem, autoPlay: Bool = false) {
        store.load(item)

        if autoPlay {
            play()
        }
    }

    func play() {
        store.play()
    }

    func pause() {
        store.pause()
    }

    func seek(toFraction fraction: Double) {
        let time = store.startTime(forFraction: fraction)
        store.seek(to: time)
    }

    func enterFullscreen() {
        let originalFrame = playerView.superview?.convert(playerView.frame, to: nil)
        let controller = viewFactory.makeFullscreenVideoPlayerController(
            store: store,
            capabilities: capabilities,
            theme: theme,
            originalFrame: originalFrame
        )
        present(controller, animated: false)
    }
}

// MARK: Binding

fileprivate extension VideoPlayerController {
    func setupBindings() {
        store.$isPlaying
            .assign(to: \.isPlaying, weakly: self)
            .store(in: &cancellables)

        store.$playheadProgress
            .assign(to: \.currentTime, weakly: self)
            .store(in: &cancellables)
    }
}

// MARK: UI

fileprivate extension VideoPlayerController {
    func setupUI() {
        setupView()
        setupConstraints()
    }

    func setupView() {
        view.backgroundColor = .black

        switch theme.backgroundStyle {
        case .plain(let color):
            view.backgroundColor = color
        case .blurred:
            view.addSubview(backgroundView)
            view.addSubview(blurredView)
        }

        view.addSubview(playerView)

        add(controlsViewController)
    }

    func setupConstraints() {
        if case .blurred = theme.backgroundStyle {
            backgroundView.autoPinEdgesToSuperviewEdges()
            blurredView.autoPinEdgesToSuperviewEdges()
        }

        playerView.autoPinEdgesToSuperviewSafeArea()

        controlsViewController.view.autoPinEdgesToSuperviewEdges()
    }

    func makePlayerView() -> PlayerView {
        let view = PlayerView()
        view.player = store.player
        return view
    }

    func makeBlurredBiew() -> UIVisualEffectView {
        let effect = UIBlurEffect(style: .regular)
        let visualEffectView = UIVisualEffectView(effect: effect)
        return visualEffectView
    }

    func makeBackgroundView() -> PlayerView {
        let view = PlayerView()
        view.playerLayer.videoGravity = .resizeAspectFill
        view.player = store.player
        return view
    }

    func makeControlsViewController() -> ControlsViewController {
        let controller = viewFactory.makeControlsViewController(
            store: store,
            capabilities: capabilities,
            theme: theme,
            isFullscreen: false)
        controller.delegate = self
        return controller
    }
}

// MARK: Controls View Controller Delegate

extension VideoPlayerController: ControlsViewControllerDelegate {
    func fullscreenButtonWasTapped() {
        enterFullscreen()
    }
}

// MARK: Inner Types

public extension VideoPlayerController {

    struct Capabilities: OptionSet {
        public let rawValue: Int

        public init(rawValue: Int) {
            self.rawValue = rawValue
        }

        public static let fullscreen = Capabilities(rawValue: 1 << 0)
        public static let playPause = Capabilities(rawValue: 1 << 1)
        public static let seek = Capabilities(rawValue: 1 << 2)

        public static let none: Capabilities = []
        public static let all: Capabilities = [.fullscreen, .playPause, .seek]
    }

    struct Theme {
        public enum Style {
            case plain(UIColor)
            case blurred
        }

        public init() {}

        public var backgroundStyle: Style = .plain(.black)
        public var controlsTintColor: UIColor = .white
    }

}
