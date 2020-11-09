

import UIKit
import AVFoundation
import MobileCoreServices
import AVKit
import Photos
import MediaPlayer


class MainViewController: UIViewController {
    
    //MARK: - Variable/Constant
    
    var pickedFileName : String = ""
    var selectedIndex = 0
    var selectedRow = 0
    var thumbImg: UIImage?
    var slctVideoUrl: URL?
    var slctAudioUrl: URL?
    var loadFirstName = 0
    var audioAsset: AVAsset?
    var filterSelcted = 100
    var assetArray = [AVAsset]()
    var player = AVPlayer()
    var playerVC = AVPlayerViewController()
    var activeTF: UITextField?
    
    var isMergeClicked = false
    var isSliderEnd = true
    var isMenuOpen = false
    
    var cropSliderMinValue: Double = 0.0
    var cropSliderMaxValue: Double = 0.0
    var mergeSliderMinValue: Double = 0.0
    var mergeSliderMaxValue: Double = 0.0
    var videoPlaybackPosition: CGFloat = 0.0
    
    var galleryBtnCenter: CGPoint!
    var videoBtnCenter: CGPoint!
    
    var videoTotalsec = 0.0
    var audioTotalsec = 0.0
    var strSelectedEffect = ""
    var strSelectedSpeed = ""
    var strSelectedSticker = ""
    var selectedTransitionType = -1
    var selectedStickerPosition = -1
    var selectedTextPosition = -1
    
    var timer = Timer()
    var progressValue = 0.1
    
    //Audio Crop view
    var mergeSlidervw: ViddstRangeSliderView!
    
    //MARK: - Outlets
    @IBOutlet weak var menuCV: UICollectionView!
    @IBOutlet weak var videoView: UIView!
    @IBOutlet weak var menuView: UIView!
    @IBOutlet weak var functionView: UIView!
    @IBOutlet weak var progresView: UIProgressView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var parentView: UIView!
    @IBOutlet weak var progressBckgrView: UIView!
    @IBOutlet weak var parantViewHeightConstr: NSLayoutConstraint!
    @IBOutlet weak var videoViewHeightConstr: NSLayoutConstraint!
    @IBOutlet weak var mergeMusicViewHeightConstr: NSLayoutConstraint!
    @IBOutlet weak var selectVideoBtn: UIButton!
    @IBOutlet weak var selectVideoView: UIView!
    @IBOutlet weak var menuClosedBtn: UIButton!
    @IBOutlet weak var menuGalleryBtn: UIButton!
    @IBOutlet weak var menuVideoBtn: UIButton!
    
    //Effect View
    @IBOutlet weak var effectView: UIView!
    @IBOutlet weak var effectCollectView: UICollectionView!
    
    //Speed View
    @IBOutlet weak var speedView: UIView!
    @IBOutlet weak var speedCV: UICollectionView!
    
    //Sticker View
    @IBOutlet weak var stickerView: UIView!
    @IBOutlet weak var stickerCV: UICollectionView!
    @IBOutlet weak var stickerPosCV: UICollectionView!
    
    //TransitionView
    @IBOutlet weak var transitionView: UIView!
    @IBOutlet weak var transitionCV: UICollectionView!
    
    //MergeView
    @IBOutlet weak var mergeView: UIView!
    @IBOutlet weak var mergeFirstBtn: UIButton!
    @IBOutlet weak var mergeSecondBtn: UIButton!
    
    //Merge Music View
    @IBOutlet weak var mergeMusicBackView: UIView!
    @IBOutlet weak var mergeSliderView: UIView!
    @IBOutlet weak var txtAudioLbl: UILabel!
    
    //TextView
    @IBOutlet weak var addTxtView: UIView!
    @IBOutlet weak var addTF: UITextField!
    @IBOutlet weak var textPosCV: UICollectionView!
    
    //Video Crop View
    @IBOutlet weak var cropView: UIView!
    @IBOutlet weak var startTimeLbl: UILabel!
    @IBOutlet weak var endTimeLbl: UILabel!
    @IBOutlet weak var cropVideoImgFrameView: UIView!
    @IBOutlet weak var videoFrameView: UIView!
    
    // Array Declartion
    var menuItems = ["filterW","audiomergeW","speedW","textW","stickerW", "videomergeW", "transitionW"]
    
    var filterNames = ["Luminance","Chrome","Fade","Instant","Noir","Process","Tonal","Transfer","SepiaTone","ColorClamp","ColorInvert","ColorMonochrome","SpotLight","ColorPosterize","BoxBlur","DiscBlur","GaussianBlur","MaskedVariableBlur","MedianFilter","MotionBlur","NoiseReduction"]
    
    var speedItems = ["0.25", "0.5", "0.75", "1.0", "1.25", "1.5"]
    
    var positionItems = ["BottomLeft","BottomCenter","BottomRight","CenterLeft","Center","CenterRight","TopLeft","TopCenter","TopRight"]
    
    var transitionItems = ["Right to Left","Left to Right","Top to Bottom","Bottom to Top", "Lefttop to Rightbottom","Rightbottom to Lefttop", "Fade in/out"]
    
    
    //MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setTitle("Viddster", andImage: UIImage(named: "logo")!)
        
        //Collection view Cell NIB Identifier
        menuCV.register(UINib(nibName: Constants().CMenuCell, bundle: Bundle.main), forCellWithReuseIdentifier: Constants().CMenuCell)
        effectCollectView.register(UINib(nibName: Constants().CEffectCell, bundle: Bundle.main), forCellWithReuseIdentifier: Constants().CEffectCell)
        speedCV.register(UINib(nibName: Constants().CSpeedCell, bundle: Bundle.main), forCellWithReuseIdentifier: Constants().CSpeedCell)
        stickerCV.register(UINib(nibName: Constants().CMenuCell, bundle: Bundle.main), forCellWithReuseIdentifier: Constants().CMenuCell)
        transitionCV.register(UINib(nibName: Constants().CSpeedCell, bundle: Bundle.main), forCellWithReuseIdentifier: Constants().CSpeedCell)
        stickerPosCV.register(UINib(nibName: Constants().CSpeedCell, bundle: Bundle.main), forCellWithReuseIdentifier: Constants().CSpeedCell)
        textPosCV.register(UINib(nibName: Constants().CSpeedCell, bundle: Bundle.main), forCellWithReuseIdentifier: Constants().CSpeedCell)
        
        menuClosedBtn.setImage(#imageLiteral(resourceName: "menuClosed"), for: .normal)
        menuClosedBtn.tintColor = .white
        
        menuVideoBtn.setImage(#imageLiteral(resourceName: "videoCamera"), for: .normal)
        menuVideoBtn.tintColor = .white
        menuVideoBtn.addTarget(self, action: #selector(cameraViewAction), for: .touchUpInside)
        
        menuGalleryBtn.setImage(#imageLiteral(resourceName: "videoGallery"), for: .normal)
        menuGalleryBtn.tintColor = .white
        menuGalleryBtn.addTarget(self, action: #selector(galleryViewAction), for: .touchUpInside)
        
        videoBtnCenter = menuVideoBtn.center
        galleryBtnCenter = menuGalleryBtn.center
        
        menuVideoBtn.center = menuClosedBtn.center
        menuGalleryBtn.center = menuClosedBtn.center
        
        menuVideoBtn.alpha = 0
        menuGalleryBtn.alpha = 0
        
        self.mergeView.isHidden = true
        self.effectView.isHidden = true
        self.speedView.isHidden = true
        self.stickerView.isHidden = true
        self.transitionView.isHidden = true
        self.addTxtView.isHidden = true
        self.mergeMusicBackView.isHidden = true
        self.progressBckgrView.isHidden = true
        self.progresView.progress = 0.0
        if self.slctVideoUrl == nil {
            self.selectVideoBtn.isHidden = false
            self.selectVideoView.isHidden = true
        }
        self.setupAudioCropSliderView()
        
        NotificationCenter.default.addObserver(self, selector: #selector(MainViewController.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(MainViewController.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        showSmallAlertStart(txt: "To somehow change your video, first select a video from the gallery or shoot a video yourself!")
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        DispatchQueue.main.async {
            if UIDevice.current.orientation.isLandscape {
                self.videoViewHeightConstr = self.videoViewHeightConstr.setMultiplier(multiplier: 0.6)
                self.parantViewHeightConstr = self.parantViewHeightConstr.setMultiplier(multiplier: 1.4)
                self.mergeMusicViewHeightConstr = self.mergeMusicViewHeightConstr.setMultiplier(multiplier: 0.72)
                self.scrollView.contentSize = CGSize(width: self.view.frame.size.width, height:(self.menuView.frame.origin.y + self.menuView.bounds.height) + 20)
                
            } else {
                self.videoViewHeightConstr = self.videoViewHeightConstr.setMultiplier(multiplier: 0.65)
                self.parantViewHeightConstr = self.parantViewHeightConstr.setMultiplier(multiplier: 1.0)
                self.mergeMusicViewHeightConstr = self.mergeMusicViewHeightConstr.setMultiplier(multiplier: 0.65)
                self.scrollView.contentSize = CGSize(width: self.view.frame.size.width, height:self.parentView.frame.size.height)
                
            }
            self.menuCV.reloadData()
            self.effectCollectView.reloadData()
            self.speedCV.reloadData()
            self.stickerCV.reloadData()
            self.transitionCV.reloadData()
            self.stickerPosCV.reloadData()
            self.textPosCV.reloadData()
        }
    }
    
    //MARK: - Functions
    
    private func showSmallAlertStart(txt: String) {
        let alert = UIAlertController(title: "Hello!", message: txt, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Let's start!", style: .default, handler: nil)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    //Timer
    func setTimer()  {
        self.progressValue = 0.1
        timer.fire()
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector:#selector(updateProgressValue), userInfo: nil, repeats: true)
    }
    
    
    func setupAudioCropSliderView()  {
        if self.mergeSlidervw == nil {
            self.mergeSlidervw = ViddstRangeSliderView(frame: CGRect(x: 20, y: -15 ,width: self.mergeSliderView.frame.size.width - 40,height: self.mergeSliderView.frame.size.height))
            self.mergeSlidervw.delegate = self
            self.mergeSlidervw.tag = 2
            self.mergeSlidervw.thumbTintColor = UIColor.lightGray
            self.mergeSlidervw.trackHighlightTintColor = UIColor.darkGray
            self.mergeSlidervw.lowerLabel?.textColor = UIColor.lightGray
            self.mergeSlidervw.upperLabel?.textColor = UIColor.lightGray
            self.mergeSlidervw.trackTintColor = UIColor.lightGray
            self.mergeSlidervw.thumbBorderColor = UIColor.clear
            self.mergeSlidervw.lowerValue = 0.0
            self.mergeSlidervw.upperValue = audioTotalsec
            self.mergeSlidervw.stepValue = 5
            self.mergeSlidervw.gapBetweenThumbs = 5
            self.mergeSlidervw.thumbLabelStyle = .FOLLOW
            self.mergeSlidervw.lowerDisplayStringFormat = "%.0f"
            self.mergeSlidervw.upperDisplayStringFormat = "%.0f"
            self.mergeSlidervw.sizeToFit()
            self.mergeSliderView.addSubview(self.mergeSlidervw)
        }
    }
    
    //Video Play Action
    func addVideoPlayer(videoUrl: URL, to view: UIView) {
        self.player = AVPlayer(url: videoUrl)
        playerVC.player = self.player
        self.addChild(playerVC)
        view.addSubview(playerVC.view)
        playerVC.view.frame = view.bounds
        playerVC.showsPlaybackControls = true
        self.player.play()
    }
    
    //Seek video when slide
    func seekVideo(toPos pos: CGFloat) {
        self.videoPlaybackPosition = pos
        let time: CMTime = CMTimeMakeWithSeconds(Float64(self.videoPlaybackPosition), preferredTimescale: self.player.currentTime().timescale)
        self.player.seek(to: time, toleranceBefore: CMTime.zero, toleranceAfter: CMTime.zero)
        if(pos == CGFloat(videoTotalsec))
        {
            self.player.pause()
        }
    }
    
    @objc func galleryViewAction() {
        self.player.pause()
        let videoPickerController = UIImagePickerController()
        videoPickerController.delegate = self
        videoPickerController.transitioningDelegate = self
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) == false { return }
        videoPickerController.allowsEditing = true
        videoPickerController.sourceType = .photoLibrary
        videoPickerController.videoMaximumDuration = TimeInterval(240.0)
        videoPickerController.mediaTypes = [kUTTypeMovie as String]
        videoPickerController.modalPresentationStyle = .custom
        self.present(videoPickerController, animated: true, completion: nil)
    }
    @objc func cameraViewAction() {
        self.player.pause()
        let videoPickerController = UIImagePickerController()
        videoPickerController.delegate = self
        if UIImagePickerController.isSourceTypeAvailable(.camera) == false {
            DispatchQueue.main.async {
                ViddstExt.showNegativeMessage(view: self.view, message: Constants().cameraNotAvailable)
            }
            return
        }
        videoPickerController.allowsEditing = true
        videoPickerController.sourceType = .camera
        videoPickerController.mediaTypes = [kUTTypeMovie as String]
        videoPickerController.videoMaximumDuration = TimeInterval(240.0)
        videoPickerController.cameraCaptureMode = .video
        videoPickerController.modalPresentationStyle = .fullScreen
        self.present(videoPickerController, animated: true, completion: nil)
    }
    
    //MARK: - Objc method Actions
    
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        // handling code
        if isMergeClicked == true {
            self.assetArray.removeAll()
            self.isMergeClicked = false
        }
        UIView.animate(withDuration: 0.5, delay: 0, options: [.curveLinear],animations: {
            self.functionView.frame = CGRect(x: self.menuView.frame.origin.x, y: (self.menuView.frame.origin.y + self.menuView.bounds.height) + 360 , width: self.menuView.bounds.width, height: self.menuView.bounds.height)
            self.functionView.layoutIfNeeded()
        }, completion: nil)
    }
    
    @objc func updateProgressValue() {
        DispatchQueue.main.async {
            self.progressValue += 0.05
            if self.progressValue < 0.9 {
                self.progresView.progress = Float(self.progressValue)
            }else{
                self.timer.invalidate()
            }
        }
    }
    
    // RangeSlider Delegate
    @objc func rangeSliderValueChanged(_ rangeSlider: ViddstRangeSlider) {
        self.player.pause()
        if(isSliderEnd == true)
        {
            if  self.slctVideoUrl != nil {
                rangeSlider.minimumValue = 0.0
                rangeSlider.maximumValue = videoTotalsec
                rangeSlider.upperValue = videoTotalsec
            }
            isSliderEnd = !isSliderEnd
        }
        
        if rangeSlider.upperValue < 60 {
            self.startTimeLbl.text = String(format: "%.2fs",(rangeSlider.lowerValue))
            self.endTimeLbl.text   = String(format: "%.2fs",(rangeSlider.upperValue))
        } else {
            self.startTimeLbl.text = String(format: "%.2fm",(rangeSlider.lowerValue/60))
            self.endTimeLbl.text   = String(format: "%.2fm",(rangeSlider.upperValue/60))
        }
        self.cropSliderMinValue = rangeSlider.lowerValue
        self.cropSliderMaxValue = rangeSlider.upperValue
        if(rangeSlider.lowerLayerSelected)
        {
            self.seekVideo(toPos: CGFloat(rangeSlider.lowerValue))
        }else{
            self.seekVideo(toPos: CGFloat(rangeSlider.upperValue))
        }
    }
    
    @objc func saveActionforEditedVideo() {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Viddster: Video Editor", message: Constants().saveVideo, preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Continue", style: UIAlertAction.Style.default, handler: { action in
                if let videourl = self.slctVideoUrl {
                    let getalbum = UserDefaults.standard.bool(forKey: "AlbumCreated")
                    if getalbum {
                        VideoEditor().saveInAlbum(videoUrl: videourl, toAlbum: "Viddster: Video Editor", completionHandler: { (saved, error) in
                            DispatchQueue.main.async {
                                if saved {
                                    let saveBarBtnItm = UIBarButtonItem(title: "", style: .done, target: self, action: nil)
                                    self.navigationItem.rightBarButtonItem  = saveBarBtnItm
                                    ViddstExt.showPositiveMessage(view: self.view, message: Constants().videoSaved)
                                } else {
                                    ViddstExt.showNegativeMessage(view: self.view, message: error?.localizedDescription ?? "")
                                }
                            }
                        })
                    } else {
                        VideoEditor().createAlbum(withTitle: "Viddster: Video Editor", completionHandler: { (album) in
                            VideoEditor().saveInAlbum(videoUrl: videourl, toAlbum: "Viddster: Video Editor", completionHandler: { (saved, error) in
                                DispatchQueue.main.async {
                                    if saved {
                                        let saveBarBtnItm = UIBarButtonItem(title: "", style: .done, target: self, action: nil)
                                        self.navigationItem.rightBarButtonItem  = saveBarBtnItm
                                        ViddstExt.showPositiveMessage(view: self.view, message: Constants().videoSaved)
                                    } else {
                                        ViddstExt.showNegativeMessage(view: self.view, message: error?.localizedDescription ?? "")
                                    }
                                }
                            })
                        })
                    }
                }
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func toggleButton(btn: UIButton, onImg: UIImage, offImg: UIImage) {
        if btn.currentImage == offImg {
            btn.setImage(onImg, for: .normal)
        } else {
            btn.setImage(offImg, for: .normal)
        }
    }
    
    //MARK: - Actions
    
    @IBAction func addVideoforMerge(_ sender: UIButton) {
        loadFirstName = sender.tag
        VideoEditor().startMediaBrowser(delegate: self, sourceType: .savedPhotosAlbum)
        if sender.tag == 1 {
            
        } else {
            
        }
    }
    
    @IBAction func menuOpenTapped(_ sender: UIButton) {
        if isMenuOpen == false {
            isMenuOpen = true
            UIView.animate(withDuration: 0.3) {
                self.menuVideoBtn.alpha = 1
                self.menuGalleryBtn.alpha = 1
                
                self.menuVideoBtn.center = self.videoBtnCenter
                self.menuGalleryBtn.center = self.galleryBtnCenter
            }
        } else {
            isMenuOpen = false
            UIView.animate(withDuration: 0.3) {
                self.menuVideoBtn.alpha = 0
                self.menuGalleryBtn.alpha = 0
                
                self.menuVideoBtn.center = self.menuClosedBtn.center
                self.menuGalleryBtn.center = self.menuClosedBtn.center
            }
        }
        toggleButton(btn: menuClosedBtn, onImg: #imageLiteral(resourceName: "menuOpen"), offImg: #imageLiteral(resourceName: "menuClosed"))
    }
    
    @IBAction func functionclosebtn_Action(_ sender: UIButton) {
        let saveBarBtnItm = UIBarButtonItem(title: "", style: .done, target: self, action: nil)
        self.navigationItem.rightBarButtonItem  = saveBarBtnItm
        if isMergeClicked == true {
            self.assetArray.removeAll()
            self.isMergeClicked = false
        }
        addTF.resignFirstResponder()
        UIView.animate(withDuration: 0.5, delay: 0, options: [.curveLinear],
                       animations: {
                        self.functionView.frame = CGRect(x: self.menuView.frame.origin.x, y: (self.menuView.frame.origin.y + self.menuView.bounds.height) + 360 , width: self.menuView.bounds.width, height: self.menuView.bounds.height)
                        self.functionView.layoutIfNeeded()
                       }, completion: nil)
        
    }
    @IBAction func selectVideoAction(_ sender: UIButton) {
        self.selectVideoView.isHidden = false
    }
    @IBAction func closeAction(_ sender: UIButton) {
        self.selectVideoView.isHidden = true
    }
    @IBAction func selectVideoFromGalleryAction(_ sender: UIButton) {
        self.galleryViewAction()
    }
    @IBAction func recordVideoAction(_ sender: UIButton) {
        self.cameraViewAction()
    }
    
    @IBAction func selectBtnPressed(_ sender: UIButton) {
        self.addTF.resignFirstResponder()
        if isMergeClicked == true {
            self.player.pause()
            if assetArray.count > 0 {
                UIView.animate(withDuration: 0.5, delay: 0, options: [.curveLinear],animations: {
                    self.functionView.frame = CGRect(x: self.menuView.frame.origin.x, y: (self.menuView.frame.origin.y + self.menuView.bounds.height) + 360 , width: self.menuView.bounds.width, height: self.menuView.bounds.height)
                    self.functionView.layoutIfNeeded()
                }, completion: nil)
                self.progressBckgrView.isHidden = false
                self.progresView.progress = 0.1
                self.setTimer()
                self.isMergeClicked = false
                VideoEditor().mergeTwoVideosArr(arrayVideos: assetArray, success: { (url) in
                    DispatchQueue.main.async {
                        let saveBarBtnItm = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(self.saveActionforEditedVideo))
                        self.navigationItem.rightBarButtonItem  = saveBarBtnItm
                        self.progresView.progress = 1.0
                        self.slctVideoUrl = url
                        self.addVideoPlayer(videoUrl: url, to: self.videoView)
                        self.assetArray.removeAll()
                        self.audioAsset = nil
                        self.progressBckgrView.isHidden = true
                    }
                }) { (error) in
                    DispatchQueue.main.async {
                        ViddstExt.showNegativeMessage(view: self.view, message: error ?? "")
                        self.progressBckgrView.isHidden = true
                    }
                }
            } else {
                DispatchQueue.main.async {
                    ViddstExt.showNegativeMessage(view: self.view, message: Constants().select2video)
                }
            }
        } else {
            if effectView.isHidden ==  false {
                self.player.pause()
                if let videourl = slctVideoUrl {
                    UIView.animate(withDuration: 0.5, delay: 0, options: [.curveLinear],animations: {
                        self.functionView.frame = CGRect(x: self.menuView.frame.origin.x, y: (self.menuView.frame.origin.y + self.menuView.bounds.height) + 360 , width: self.menuView.bounds.width, height: self.menuView.bounds.height)
                        self.functionView.layoutIfNeeded()
                    }, completion: nil)
                    if strSelectedEffect.count > 0 {
                        self.progressBckgrView.isHidden = false
                        self.progresView.progress = 0.1
                        self.setTimer()
                        VideoEditor().addfiltertoVideo(strfiltername: strSelectedEffect, strUrl: videourl, success: { (url) in
                            DispatchQueue.main.async {
                                let saveBarBtnItm = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(self.saveActionforEditedVideo))
                                self.navigationItem.rightBarButtonItem  = saveBarBtnItm
                                self.progresView.progress = 1.0
                                self.slctVideoUrl = url
                                self.addVideoPlayer(videoUrl: url, to: self.videoView)
                                self.progressBckgrView.isHidden = true
                            }
                        }) { (error) in
                            DispatchQueue.main.async {
                                ViddstExt.showNegativeMessage(view: self.view, message: error ?? "")
                                self.progressBckgrView.isHidden = true
                            }
                        }
                    }
                }
                
            } else if speedView.isHidden ==  false {
                self.player.pause()
                if let videourl = slctVideoUrl {
                    UIView.animate(withDuration: 0.5, delay: 0, options: [.curveLinear],animations: {
                        self.functionView.frame = CGRect(x: self.menuView.frame.origin.x, y: (self.menuView.frame.origin.y + self.menuView.bounds.height) + 360 , width: self.menuView.bounds.width, height: self.menuView.bounds.height)
                        self.functionView.layoutIfNeeded()
                    }, completion: nil)
                    if strSelectedSpeed.count > 0 {
                        self.progressBckgrView.isHidden = false
                        self.progresView.progress = 0.1
                        self.setTimer()
                        let num = strSelectedSpeed.toDouble()
                        VideoEditor().videoScaleAssetSpeed(fromURL: videourl, by: num ?? 1.0, success: { (url) in
                            DispatchQueue.main.async {
                                let saveBarBtnItm = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(self.saveActionforEditedVideo))
                                self.navigationItem.rightBarButtonItem  = saveBarBtnItm
                                self.progresView.progress = 1.0
                                self.addVideoPlayer(videoUrl: url, to: self.videoView)
                                self.progressBckgrView.isHidden = true
                            }
                        }) { (error) in
                            DispatchQueue.main.async {
                                ViddstExt.showNegativeMessage(view: self.view, message: error ?? "")
                                self.progressBckgrView.isHidden = true
                            }
                        }
                    }
                }
            }else if addTxtView.isHidden == false {
                self.player.pause()
                if let videourl = self.slctVideoUrl {
                    if selectedTextPosition != -1 && addTF.text != "" {
                        UIView.animate(withDuration: 0.5, delay: 0, options: [.curveLinear],animations: {
                            self.functionView.frame = CGRect(x: self.menuView.frame.origin.x, y: (self.menuView.frame.origin.y + self.menuView.bounds.height) + 360 , width: self.menuView.bounds.width, height: self.menuView.bounds.height)
                            self.functionView.layoutIfNeeded()
                        }, completion: nil)
                        self.progressBckgrView.isHidden = false
                        self.progresView.progress = 0.1
                        self.setTimer()
                        VideoEditor().addStickerOrTxtToVideo(videoUrl: videourl, watermarkText: addTF.text ?? "", imageName: "", position: selectedTextPosition, success: { (url) in
                            DispatchQueue.main.async {
                                let saveBarBtnItm = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(self.saveActionforEditedVideo))
                                self.navigationItem.rightBarButtonItem  = saveBarBtnItm
                                self.progresView.progress = 1.0
                                self.slctVideoUrl = url
                                self.addVideoPlayer(videoUrl: url, to: self.videoView)
                                self.progressBckgrView.isHidden = true
                            }
                        }){ (error) in
                            DispatchQueue.main.async {
                                ViddstExt.showNegativeMessage(view: self.view, message: error ?? "")
                                self.progressBckgrView.isHidden = true
                            }
                        }
                    }else if addTF.text == "" {
                        DispatchQueue.main.async {
                            ViddstExt.showNegativeMessage(view: self.view, message: Constants().addText)
                        }
                    } else if selectedTextPosition == -1 {
                        DispatchQueue.main.async {
                            ViddstExt.showNegativeMessage(view: self.view, message: Constants().selectPosition)
                        }
                    }
                    
                }
                
            } else if stickerView.isHidden == false {
                self.player.pause()
                if let videourl = self.slctVideoUrl {
                    if selectedStickerPosition != -1 && strSelectedSticker != "" {
                        UIView.animate(withDuration: 0.5, delay: 0, options: [.curveLinear],animations: {
                            self.functionView.frame = CGRect(x: self.menuView.frame.origin.x, y: (self.menuView.frame.origin.y + self.menuView.bounds.height) + 360 , width: self.menuView.bounds.width, height: self.menuView.bounds.height)
                            self.functionView.layoutIfNeeded()
                        }, completion: nil)
                        self.progressBckgrView.isHidden = false
                        self.progresView.progress = 0.1
                        self.setTimer()
                        VideoEditor().addStickerOrTxtToVideo(videoUrl: videourl, watermarkText: "", imageName: strSelectedSticker, position: selectedStickerPosition, success: { (url) in
                            DispatchQueue.main.async {
                                let saveBarBtnItm = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(self.saveActionforEditedVideo))
                                self.navigationItem.rightBarButtonItem  = saveBarBtnItm
                                self.progresView.progress = 1.0
                                self.slctVideoUrl = url
                                //  self.cropView.isHidden = true
                                self.addVideoPlayer(videoUrl: url, to: self.videoView)
                                self.progressBckgrView.isHidden = true
                            }
                        }){ (error) in
                            DispatchQueue.main.async {
                                ViddstExt.showNegativeMessage(view: self.view, message: error ?? "")
                                self.progressBckgrView.isHidden = true
                            }
                        }
                    }else if strSelectedSticker == "" {
                        DispatchQueue.main.async {
                            ViddstExt.showNegativeMessage(view: self.view, message: Constants().selectSticker)
                        }
                        
                    } else if selectedStickerPosition == -1  {
                        DispatchQueue.main.async {
                            ViddstExt.showNegativeMessage(view: self.view, message: Constants().slctPositonSticker)
                        }
                    }
                    
                }
                
            } else if self.cropView.isHidden == false {
                self.player.pause()
                if let videourl = self.slctVideoUrl {
                    UIView.animate(withDuration: 0.5, delay: 0, options: [.curveLinear],animations: {
                        self.functionView.frame = CGRect(x: self.menuView.frame.origin.x, y: (self.menuView.frame.origin.y + self.menuView.bounds.height) + 360 , width: self.menuView.bounds.width, height: self.menuView.bounds.height)
                        self.functionView.layoutIfNeeded()
                    }, completion: nil)
                    self.progressBckgrView.isHidden = false
                    self.progresView.progress = 0.1
                    self.setTimer()
                    VideoEditor().trimVideo(sourceURL: videourl, startTime:cropSliderMinValue, endTime: cropSliderMaxValue, success: { (url) in
                        DispatchQueue.main.async {
                            let saveBarBtnItm = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(self.saveActionforEditedVideo))
                            self.navigationItem.rightBarButtonItem  = saveBarBtnItm
                            self.progresView.progress = 1.0
                            self.slctVideoUrl = url
                            let asset = AVAsset(url: url)
                            let duration = asset.duration
                            let durationTime = CMTimeGetSeconds(duration)
                            self.videoTotalsec = durationTime
                            self.addVideoPlayer(videoUrl: url, to: self.videoView)
                            self.progressBckgrView.isHidden = true
                        }
                    }){ (error) in
                        DispatchQueue.main.async {
                            ViddstExt.showNegativeMessage(view: self.view, message: error ?? "")
                            self.progressBckgrView.isHidden = true
                        }
                    }
                }
            } else if self.transitionView.isHidden == false {
                self.player.pause()
                if let videourl = slctVideoUrl {
                    UIView.animate(withDuration: 0.5, delay: 0, options: [.curveLinear],animations: {
                        self.functionView.frame = CGRect(x: self.menuView.frame.origin.x, y: (self.menuView.frame.origin.y + self.menuView.bounds.height) + 360 , width: self.menuView.bounds.width, height: self.menuView.bounds.height)
                        self.functionView.layoutIfNeeded()
                        
                    }, completion: nil)
                    self.progressBckgrView.isHidden = false
                    self.progresView.progress = 0.1
                    self.setTimer()
                    VideoEditor().transitionAnimation(videoUrl: videourl, animation: true, type: selectedTransitionType, playerSize: self.videoView.frame, success: { (url) in
                        DispatchQueue.main.async {
                            let saveBarBtnItm = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(self.saveActionforEditedVideo))
                            self.navigationItem.rightBarButtonItem  = saveBarBtnItm
                            self.progresView.progress = 1.0
                            self.slctVideoUrl = url
                            self.addVideoPlayer(videoUrl: url, to: self.videoView)
                            self.progressBckgrView.isHidden = true
                        }
                    }) { (error) in
                        DispatchQueue.main.async {
                            ViddstExt.showNegativeMessage(view: self.view, message: error ?? "")
                            self.progressBckgrView.isHidden = true
                            
                        }
                    }
                }
                
            }
        }
    }
    @IBAction func selectAudioClicked(_ sender: Any) {
        let documentPicker: UIDocumentPickerViewController = UIDocumentPickerViewController(documentTypes: ["public.audio","public.mp3","public.mpeg-4-audio","public.aifc-audio","public.aiff-audio"], in: UIDocumentPickerMode.import)
        documentPicker.delegate = self
        documentPicker.modalPresentationStyle = UIModalPresentationStyle.fullScreen
        self.present(documentPicker, animated: true, completion: nil)
    }
    
    @IBAction func audioVideoMergeCloseAction(_ sender: UIButton) {
        let saveBarBtnItm = UIBarButtonItem(title: "", style: .done, target: self, action: nil)
        self.navigationItem.rightBarButtonItem  = saveBarBtnItm
        self.mergeMusicBackView.isHidden = true
        UIView.animate(withDuration: 0.5, delay: 0, options: [.curveLinear],
                       animations: {
                        self.functionView.frame = CGRect(x: self.menuView.frame.origin.x, y: (self.menuView.frame.origin.y + self.menuView.bounds.height) + 360 , width: self.menuView.bounds.width, height: self.menuView.bounds.height)
                        self.functionView.layoutIfNeeded()
                       }, completion: nil)
    }
    @IBAction func audioVideoMergeSaveAction(_ sender: UIButton) {
        if let audiourl = self.slctAudioUrl {
            UIView.animate(withDuration: 0.5, delay: 0, options: [.curveLinear],animations: {
                self.functionView.frame = CGRect(x: self.menuView.frame.origin.x, y: (self.menuView.frame.origin.y + self.menuView.bounds.height) + 360 , width: self.menuView.bounds.width, height: self.menuView.bounds.height)
                self.functionView.layoutIfNeeded()
            }, completion: nil)
            VideoEditor().trimAudio(sourceURL: audiourl, startTime: mergeSliderMinValue, stopTime: mergeSliderMaxValue, success: { (audioUrl) in
                let asset = AVAsset(url: audioUrl)
                let audiosec = CMTimeGetSeconds(asset.duration)
                if self.videoTotalsec >= audiosec {
                    DispatchQueue.main.async {
                        self.progressBckgrView.isHidden = false
                        self.progresView.progress = 0.1
                        self.setTimer()
                        self.mergeMusicBackView.isHidden = true
                        self.mergeView.isHidden = true
                        if  let videourl = self.slctVideoUrl  {
                            VideoEditor().mergeVideoWithAudio(videoUrl: videourl, audioUrl: audioUrl, success: { (url) in
                                DispatchQueue.main.async {
                                    let saveBarBtnItm = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(self.saveActionforEditedVideo))
                                    self.navigationItem.rightBarButtonItem  = saveBarBtnItm
                                    self.progresView.progress = 1.0
                                    self.slctVideoUrl = url
                                    self.addVideoPlayer(videoUrl: url, to: self.videoView)
                                    self.progressBckgrView.isHidden = true
                                }
                            }) { (error) in
                                DispatchQueue.main.async {
                                    ViddstExt.showNegativeMessage(view: self.view, message: error ?? "")
                                    self.progressBckgrView.isHidden = true
                                }
                            }
                        }
                    }
                }else{
                    DispatchQueue.main.async {
                        ViddstExt.showNegativeMessage(view: self.view, message: Constants().cropAudioDuration)
                        self.progressBckgrView.isHidden = true
                    }
                }
                
            }) { (error) in
                DispatchQueue.main.async {
                    ViddstExt.showNegativeMessage(view: self.view, message: error ?? "")
                    self.progressBckgrView.isHidden = true
                }
            }
        }
    }
}

//MARK: - Image Picker Delegate

extension MainViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIViewControllerTransitioningDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let videoURL = info[UIImagePickerController.InfoKey.mediaURL] as? URL
        self.dismiss(animated: true, completion: nil)
        
        if let videourl = videoURL {
            if isMergeClicked == true {
                let thumbImg = VideoEditor().generateThumbnail(path: videourl)
                let asset = AVAsset(url: videourl)
                
                if loadFirstName == 1 {
                    self.assetArray.append(asset)
                    self.mergeFirstBtn.setTitle("", for: .normal)
                    self.mergeFirstBtn.setBackgroundImage(thumbImg, for: .normal)
                } else {
                    self.assetArray.append(asset)
                    self.mergeSecondBtn.setTitle("", for: .normal)
                    self.mergeSecondBtn.setBackgroundImage(thumbImg, for: .normal)
                }
                
            } else {
                self.selectVideoBtn.isHidden = true
                self.selectVideoView.isHidden = true
                let asset = AVAsset(url: videourl)
                let duration = asset.duration
                let durationTime = CMTimeGetSeconds(duration)
                self.videoTotalsec = durationTime
                self.slctVideoUrl = videoURL
                self.thumbImg = VideoEditor().generateThumbnail(path: videourl)
                self.addVideoPlayer(videoUrl: videourl, to: videoView)
                
            }
            
        }
    }
}
//MARK: -  UICollectionView Delegate & Datasource
extension MainViewController : UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView.tag {
        case 1:
            return menuItems.count
        case 2:
            return filterNames.count
        case 3:
            return speedItems.count
        case 4:
            return 19
        case 5:
            return transitionItems.count
        case 6:
            return positionItems.count
        case 7:
            return positionItems.count
        default:
            return 0
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView.tag {
        case 1:
            let cell: CollectionViewMenuCell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants().CMenuCell, for: indexPath) as! CollectionViewMenuCell
            cell.menuImgView.image = UIImage(named:menuItems[indexPath.row])?.withRenderingMode(.alwaysTemplate)
            cell.menuImgView.tintColor = .white
            
            return cell
        case 2:
            let cell: EffectCollectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants().CEffectCell, for: indexPath) as! EffectCollectionCell
            cell.effectNameLbl.text = filterNames[indexPath.row]
            if let convertImage = thumbImg {
                cell.effectImgView.image = VideoEditor().convertImageToBW(filterName: CIFilterNames[indexPath.row], image: convertImage)
            }
            cell.effectImgView.layer.borderWidth = 2
            
            if self.filterSelcted == indexPath.row {
                cell.effectImgView.layer.borderColor = UIColor.white.cgColor
            } else {
                cell.effectImgView.layer.borderColor = UIColor.clear.cgColor
            }
            cell.effectImgView.layer.cornerRadius = 12
            cell.effectImgView.layer.masksToBounds = true
            
            return cell
        case 3:
            let cell: SpeedCollectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants().CSpeedCell, for: indexPath) as! SpeedCollectionCell
            cell.speedSecLbl.text = "\(speedItems[indexPath.row])s"
            if strSelectedSpeed == speedItems[indexPath.row] {
                cell.speedSecLbl.textColor = UIColor.black
                cell.bckgrndView.backgroundColor = UIColor.white
                cell.bckgrndView.cornerRadius = 5.0
            } else {
                cell.speedSecLbl.textColor = UIColor.white
                cell.bckgrndView.backgroundColor = UIColor.clear
                cell.bckgrndView.cornerRadius = 0.0
            }
            return cell
        case 4:
            let cell: CollectionViewMenuCell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants().CMenuCell, for: indexPath) as! CollectionViewMenuCell
            if strSelectedSticker == "sticker\(indexPath.row + 1)" {
                cell.backgroundColor = UIColor.white
                cell.cornerRadius = 5.0
            } else {
                cell.backgroundColor = UIColor.clear
                cell.cornerRadius = 0.0
                
            }
            cell.menuImgView.image = UIImage(named:"sticker\(indexPath.row + 1)")
            return cell
        case 5:
            let cell: SpeedCollectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants().CSpeedCell, for: indexPath) as! SpeedCollectionCell
            cell.speedSecLbl.text = "\(transitionItems[indexPath.row])"
            if selectedTransitionType == indexPath.row {
                cell.speedSecLbl.textColor = UIColor.black
                cell.bckgrndView.backgroundColor = UIColor.white
                cell.bckgrndView.cornerRadius = 5.0
            } else {
                cell.speedSecLbl.textColor = UIColor.white
                cell.bckgrndView.backgroundColor = UIColor.clear
                cell.bckgrndView.cornerRadius = 0.0
            }
            return cell
        case 6:
            let cell: SpeedCollectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants().CSpeedCell, for: indexPath) as! SpeedCollectionCell
            cell.speedSecLbl.text = "\(positionItems[indexPath.row])"
            if selectedStickerPosition == indexPath.row {
                cell.speedSecLbl.textColor = UIColor.black
                cell.bckgrndView.backgroundColor = UIColor.white
                cell.bckgrndView.cornerRadius = 5.0
            } else {
                cell.speedSecLbl.textColor = UIColor.white
                cell.bckgrndView.backgroundColor = UIColor.clear
                cell.bckgrndView.cornerRadius = 0.0
            }
            return cell
        case 7:
            let cell: SpeedCollectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants().CSpeedCell, for: indexPath) as! SpeedCollectionCell
            cell.speedSecLbl.text = "\(positionItems[indexPath.row])"
            if selectedTextPosition == indexPath.row {
                cell.speedSecLbl.textColor = UIColor.black
                cell.bckgrndView.backgroundColor = UIColor.white
                cell.bckgrndView.cornerRadius = 5.0
            } else {
                cell.speedSecLbl.textColor = UIColor.white
                cell.bckgrndView.backgroundColor = UIColor.clear
                cell.bckgrndView.cornerRadius = 0.0
            }
            return cell
            
        default:
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let orientation = UIApplication.shared.statusBarOrientation
        if(orientation == .landscapeLeft || orientation == .landscapeRight)
        {
            switch collectionView.tag {
            case 1:
                return CGSize(width: menuCV.frame.width / 7.0, height: menuCV.frame.height - 40)
            case 2:
                return CGSize(width: effectCollectView.frame.width / 4.0, height: effectCollectView.frame.height)
            case 3:
                return CGSize(width: speedCV.frame.width / 7.0, height: speedCV.frame.height - 60)
            case 4:
                return CGSize(width: stickerCV.frame.width / 6.0, height: stickerCV.frame.height )
            case 5:
                return CGSize(width: transitionCV.frame.width / 5.0, height: transitionCV.frame.height - 60)
            case 6:
                return CGSize(width: stickerPosCV.frame.width / 5.0, height: stickerPosCV.frame.height)
            case 7:
                return CGSize(width: textPosCV.frame.width / 5.0, height: textPosCV.frame.height)
            default:
                return CGSize(width: menuCV.frame.width / 7.0, height: menuCV.frame.height - 40)
            }
        } else {
            switch collectionView.tag {
            case 1:
                return CGSize(width: menuCV.frame.width / 7.0, height: menuCV.frame.height - 30)
            case 2:
                return CGSize(width: effectCollectView.frame.width / 2.8, height: effectCollectView.frame.height)
            case 3:
                return CGSize(width: speedCV.frame.width / 6.0, height: speedCV.frame.height - 70)
            case 4:
                return CGSize(width: stickerCV.frame.width / 5.0, height: stickerCV.frame.height - 10)
            case 5:
                return CGSize(width: transitionCV.frame.width / 2.5, height: transitionCV.frame.height - 70)
            case 6:
                return CGSize(width: stickerPosCV.frame.width / 2.5, height: stickerPosCV.frame.height)
            case 7:
                return CGSize(width: textPosCV.frame.width / 2.5, height: textPosCV.frame.height)
            default:
                return CGSize(width: menuCV.frame.width / 7.0, height: menuCV.frame.height - 30)
            }
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        switch collectionView.tag {
        case 1:
            return UIEdgeInsets(top: 2, left: 5, bottom: 2, right: 5)
        case 2:
            return UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        case 3:
            return UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        case 4:
            return UIEdgeInsets(top: 2, left: 5, bottom: 2, right: 5)
        case 5:
            return UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        case 6:
            return UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        case 7:
            return UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        default:
            return UIEdgeInsets(top: 1, left: 1, bottom: 1, right: 1)
        }
        
    }
}
extension MainViewController : UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if self.progressBckgrView.isHidden == true {
            switch collectionView.tag {
            case 1:
                switch indexPath.row {
                
                case 0:
                    // Filter Applied
                    if (self.slctVideoUrl != nil) {
                        self.filterSelcted = 100
                        self.player.pause()
                        self.effectView.isHidden = false
                        self.speedView.isHidden = true
                        self.stickerView.isHidden = true
                        self.mergeView.isHidden = true
                        self.transitionView.isHidden = true
                        self.cropView.isHidden = true
                        self.addTxtView.isHidden = true
                        self.mergeMusicBackView.isHidden = true
                        self.effectCollectView.reloadData()
                        
                        UIView.animate(withDuration: 0.5, delay: 0, options: [.curveEaseIn],animations: {
                            self.functionView.frame = CGRect(x: self.menuView.frame.origin.x, y: self.menuView.frame.origin.y, width: self.menuView.bounds.width, height: self.menuView.bounds.height)
                            self.functionView.layoutIfNeeded()
                        }, completion: nil)
                        
                    }else{
                        DispatchQueue.main.async {
                            ViddstExt.showNegativeMessage(view: self.view, message: Constants().slctVideoFilter)
                        }
                    }
                case 1:
                    //Audio  merge
                    //                    if isUnlock {
                    if (self.slctVideoUrl != nil) {
                        self.player.pause()
                        self.mergeView.isHidden = true
                        self.effectView.isHidden = true
                        self.speedView.isHidden = true
                        self.stickerView.isHidden = true
                        self.transitionView.isHidden = true
                        self.cropView.isHidden = true
                        self.addTxtView.isHidden = true
                        self.mergeMusicBackView.isHidden = false
                        UIView.animate(withDuration: 0.5, delay: 0, options: [.curveLinear],animations: {
                            self.functionView.frame = CGRect(x: self.menuView.frame.origin.x, y: (self.menuView.frame.origin.y + self.menuView.bounds.height) + 360 , width: self.menuView.bounds.width, height: self.menuView.bounds.height)
                            self.functionView.layoutIfNeeded()
                        }, completion: nil)
                        
                    }else{
                        DispatchQueue.main.async {
                            ViddstExt.showNegativeMessage(view: self.view, message: Constants().slctVideoMergeAudio)
                        }
                    }
                case 2:
                    // SpeedView
                    if (self.slctVideoUrl != nil) {
                        self.player.pause()
                        self.speedView.isHidden = false
                        self.effectView.isHidden = true
                        self.stickerView.isHidden = true
                        self.mergeView.isHidden = true
                        self.transitionView.isHidden = true
                        self.cropView.isHidden = true
                        self.addTxtView.isHidden = true
                        self.mergeMusicBackView.isHidden = true
                        self.speedCV.reloadData()
                        UIView.animate(withDuration: 0.5, delay: 0, options: [.curveEaseIn],animations: {
                            self.functionView.frame = CGRect(x: self.menuView.frame.origin.x, y: self.menuView.frame.origin.y, width: self.menuView.bounds.width, height: self.menuView.bounds.height)
                            self.functionView.layoutIfNeeded()
                        }, completion: nil)
                        
                    }else{
                        DispatchQueue.main.async {
                            ViddstExt.showNegativeMessage(view: self.view, message: Constants().slctVideoSpeed)
                        }
                    }
                case 3:
                    // addTextView
                    if (self.slctVideoUrl != nil) {
                        self.player.pause()
                        self.stickerView.isHidden = true
                        self.effectView.isHidden = true
                        self.speedView.isHidden = true
                        self.mergeView.isHidden = true
                        self.transitionView.isHidden = true
                        self.cropView.isHidden = true
                        self.addTxtView.isHidden = false
                        self.mergeMusicBackView.isHidden = true
                        self.textPosCV.reloadData()
                        UIView.animate(withDuration: 0.5, delay: 0, options: [.curveEaseIn],animations: {
                            self.functionView.frame = CGRect(x: self.menuView.frame.origin.x, y: self.menuView.frame.origin.y, width: self.menuView.bounds.width, height: self.menuView.bounds.height)
                            self.functionView.layoutIfNeeded()
                        }, completion: nil)
                        
                    }else{
                        DispatchQueue.main.async {
                            ViddstExt.showNegativeMessage(view: self.view, message: Constants().slctVideoAddTxt)
                        }
                    }
                case 4:
                    // addStickerView
                    if (self.slctVideoUrl != nil) {
                        self.player.pause()
                        self.stickerView.isHidden = false
                        self.effectView.isHidden = true
                        self.speedView.isHidden = true
                        self.mergeView.isHidden = true
                        self.transitionView.isHidden = true
                        self.cropView.isHidden = true
                        self.addTxtView.isHidden = true
                        self.mergeMusicBackView.isHidden = true
                        self.stickerCV.reloadData()
                        UIView.animate(withDuration: 0.5, delay: 0, options: [.curveEaseIn],animations: {
                            self.functionView.frame = CGRect(x: self.menuView.frame.origin.x, y: self.menuView.frame.origin.y, width: self.menuView.bounds.width, height: self.menuView.bounds.height)
                            self.functionView.layoutIfNeeded()
                        }, completion: nil)
                        
                    }else{
                        DispatchQueue.main.async {
                            ViddstExt.showNegativeMessage(view: self.view, message: Constants().slctVideoSticker)
                        }
                    }
                case 5:
                    // Merge two Videos
                    self.player.pause()
                    self.isMergeClicked = true
                    self.stickerView.isHidden = true
                    self.effectView.isHidden = true
                    self.speedView.isHidden = true
                    self.mergeView.isHidden = false
                    self.transitionView.isHidden = true
                    self.cropView.isHidden = true
                    self.addTxtView.isHidden = true
                    self.mergeMusicBackView.isHidden = true
                    self.mergeFirstBtn.setBackgroundImage(UIImage(named: ""), for: .normal)
                    self.mergeSecondBtn.setBackgroundImage(UIImage(named: ""), for: .normal)
                    self.mergeFirstBtn.setTitle("+", for: .normal)
                    self.mergeSecondBtn.setTitle("+", for: .normal)
                    self.mergeSecondBtn.setBackgroundImage(UIImage(named: ""), for: .normal)
                    UIView.animate(withDuration: 0.5, delay: 0, options: [.curveEaseIn],animations: {
                        self.functionView.frame = CGRect(x: self.menuView.frame.origin.x, y: self.menuView.frame.origin.y, width: self.menuView.bounds.width, height: self.menuView.bounds.height)
                        self.functionView.layoutIfNeeded()
                    }, completion: nil)
                case 6:
                    // addTransitionView
                    if (self.slctVideoUrl != nil) {
                        self.player.pause()
                        self.stickerView.isHidden = true
                        self.effectView.isHidden = true
                        self.speedView.isHidden = true
                        self.mergeView.isHidden = true
                        self.transitionView.isHidden = false
                        self.cropView.isHidden = true
                        self.addTxtView.isHidden = true
                        self.mergeMusicBackView.isHidden = true
                        self.transitionCV.reloadData()
                        UIView.animate(withDuration: 0.5, delay: 0, options: [.curveEaseIn],animations: {
                            self.functionView.frame = CGRect(x: self.menuView.frame.origin.x, y: self.menuView.frame.origin.y, width: self.menuView.bounds.width, height: self.menuView.bounds.height)
                            self.functionView.layoutIfNeeded()
                        }, completion: nil)
                        
                    } else {
                        DispatchQueue.main.async {
                            ViddstExt.showNegativeMessage(view: self.view, message: Constants().slctVideoTransition)
                        }
                    }
                default:
                    break
                }
            case 2:
                //effect view
                if effectView.isHidden == false {
                    self.filterSelcted = indexPath.row
                    self.strSelectedEffect = CIFilterNames[indexPath.row]
                    self.effectCollectView.reloadData()
                }
            case 3:
                //speed view
                if speedView.isHidden == false {
                    self.strSelectedSpeed = speedItems[indexPath.row]
                    self.speedCV.reloadData()
                }
            case 4:
                //sticker view
                if stickerView.isHidden == false {
                    self.strSelectedSticker = "sticker\(indexPath.row + 1)"
                    self.stickerCV.reloadData()
                }
            case 5:
                //transition view
                if transitionView.isHidden == false {
                    self.selectedTransitionType = indexPath.row
                    self.transitionCV.reloadData()
                }
            case 6:
                //sticker view
                if stickerView.isHidden == false {
                    self.selectedStickerPosition = indexPath.row
                    self.stickerPosCV.reloadData()
                }
            case 7:
                //text view
                if addTxtView.isHidden == false {
                    self.selectedTextPosition = indexPath.row
                    self.textPosCV.reloadData()
                }
            default:
                if effectView.isHidden == false {
                    
                }
            }
        } else {
            DispatchQueue.main.async {
                ViddstExt.showNegativeMessage(view: self.view, message: Constants().anotherAction)
            }
        }
    }
}

