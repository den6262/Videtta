

import UIKit

var totalSEC  = 0.0
var defaultSize = CGSize(width: 1920, height: 1080)
var CIFilterNames = [
    "CISharpenLuminance",
    "CIPhotoEffectChrome",
    "CIPhotoEffectFade",
    "CIPhotoEffectInstant",
    "CIPhotoEffectNoir",
    "CIPhotoEffectProcess",
    "CIPhotoEffectTonal",
    "CIPhotoEffectTransfer",
    "CISepiaTone",
    "CIColorClamp",
    "CIColorInvert",
    "CIColorMonochrome",
    "CISpotLight",
    "CIColorPosterize",
    "CIBoxBlur",
    "CIDiscBlur",
    "CIGaussianBlur",
    "CIMaskedVariableBlur",
    "CIMedianFilter",
    "CIMotionBlur",
    "CINoiseReduction"
]

class Constants: NSObject {
    
    //MARK: - Cell Identifier
    public let CMenuCell: String = "CollectionViewMenuCell"
    public let CEffectCell: String = "EffectCollectionCell"
    public let CSpeedCell: String = "SpeedCollectionCell"

    //MARK: - Image Names
    public let Ifilter: String = "filterW"
    public let Itrim: String = "cropW"
    public let Imerge: String = "mergeW"
    public let Ispeed: String = "speedW"
    public let Itext: String = "textW"
    public let Isticker: String = "stickerW"
    
    //MARK: - Alert messages
    public let cameraNotAvailable: String = "Camera not available for this device"
    public let select2video: String = "Select 2 videos which you want to merge"
    public let addText: String = "Add the text which you want to show inside the video"
    public let selectPosition: String = "Select the position where you want to show the text"
    public let selectSticker: String = "Select the sticker which you want to show inside the video"
    public let slctPositonSticker: String = "Select the position where you want to show the sticker"
    public let cropAudioDuration: String = "Please crop audio duration with in your selected video duration"
    public let slctVideoFilter: String = "Select the video which you want to add filter animation"
    public let slctVideoCrop: String = "Select the video which you want to add crop"
    public let slctVideoMergeAudio: String = "Select the video which you want to merge the audio"
    public let slctVideoSpeed: String = "Select the video which you want to add speed animation"
    public let slctVideoAddTxt: String = "Select the video which you want to add text inside video"
    public let slctVideoSticker: String = "Select the video which you want to add sticker inside video"
    public let slctVideoMerge: String = "Select the video which you want to merge"
    public let slctVideoTransition: String = "Select the video which you want to add transition animation"
    public let videoSaved: String = "Your video was successfully saved"
    public let saveVideo: String = "Would you like to save your edited video?"
    public let anotherAction: String = "Another video editor action is processing so it can't be process new action, please wait"
    public let noLongVideoSelect: String = "Please select video duration within 4 minits"


}
