

import UIKit
import AVFoundation

extension UIColor {
    convenience init(hex: Int, alpha: Double = 1.0) {
        self.init(red: CGFloat((hex>>16)&0xFF)/255.0, green:CGFloat((hex>>8)&0xFF)/255.0, blue: CGFloat((hex)&0xFF)/255.0, alpha:  CGFloat(255 * alpha) / 255)
    }
}

/// enum for label positions
public enum NHSliderLabelStyle: Int {
    /// lower and upper labels stick to the left and right of slider
    case STICKY
    
    /// lower and upper labels follow position of lower and upper thumbs
    case FOLLOW
}

/// delegate for changed value
public protocol VidRangeSliderViewDelegate: class {
    /// slider value changed
    func sliderValueChanged(slider: ViddstRangeSlider?,slidervw : ViddstRangeSliderView)
}

/// optional implementation
public extension VidRangeSliderViewDelegate{
     func sliderValueChanged(slider: ViddstRangeSlider?,slidervw : ViddstRangeSliderView){}
}

/// Range slider with labels for upper and lower thumbs, title label and configurable step value (optional)
open class ViddstRangeSliderView: UIView {
    
    //MARK: properties
    
    open var delegate: VidRangeSliderViewDelegate? = nil
    
    /// Range slider
    open var rangeSlider : ViddstRangeSlider? = nil
    
    /// Display title
    open var titleLabel : UILabel? = nil
    
    // lower value label for displaying selected lower value
    open var lowerLabel : UILabel? = nil
    
    /// upper value label for displaying selected upper value
    open var upperLabel : UILabel? = nil
    
    /// display format for lower value. Default to %.0f to display value as Int
    open var lowerDisplayStringFormat: String = "%.0f" {
        didSet {
            updateLabelDisplay()
        }
    }
    
    /// display format for upper value. Default to %.0f to display value as Int
    open var upperDisplayStringFormat: String = "%.0f" {
        didSet {
            updateLabelDisplay()
        }
    }
    
    /// vertical spacing
    open var spacing: CGFloat = 4.0
    
    /// position of thumb labels. Set to STICKY to stick to left and right positions. Set to FOLLOW to follow left and right thumbs
    open var thumbLabelStyle: NHSliderLabelStyle = .STICKY
    
    /// minimum value
    @IBInspectable open var minValue: Double = 0.0 {
        didSet {
            self.rangeSlider?.minimumValue = minValue
        }
    }
    
    /// max value
    @IBInspectable open var maxValue: Double = totalSEC {
        didSet {
            self.rangeSlider?.maximumValue = maxValue
        }
    }
    
    /// value for lower thumb
    @IBInspectable open var lowerValue: Double = 0.0 {
        didSet {
            self.rangeSlider?.lowerValue = lowerValue
            self.updateLabelDisplay()
        }
    }
    
    /// value for upper thumb
    @IBInspectable open var upperValue: Double = totalSEC {
        didSet {
            self.rangeSlider?.upperValue = upperValue
            self.updateLabelDisplay()
        }
    }
    
    /// stepValue. If set, will snap to discrete step points along the slider . Default to nil
    @IBInspectable open var stepValue: Double = 0.0 {
        didSet {
            self.rangeSlider?.stepValue = stepValue
        }
    }
    
    /// minimum distance between the upper and lower thumbs.
    open var gapBetweenThumbs: Double = 2.0 {
        didSet {
            self.rangeSlider?.gapBetweenThumbs = gapBetweenThumbs
        }
    }
    
    /// tint color for track between 2 thumbs
    @IBInspectable open var trackTintColor: UIColor = UIColor(white: 0.9, alpha: 1.0) {
        didSet {
            self.rangeSlider?.trackTintColor = trackTintColor
        }
    }
    
    
    /// track highlight tint color
    @IBInspectable open var trackHighlightTintColor: UIColor = UIColor(red: 0.0, green: 0.45, blue: 0.94, alpha: 1.0) {
        didSet {
            self.rangeSlider?.trackHighlightTintColor = trackHighlightTintColor
        }
    }
    
    
    /// thumb tint color
    @IBInspectable open var thumbTintColor: UIColor = UIColor.white {
        didSet {
            self.rangeSlider?.thumbTintColor = thumbTintColor
        }
    }
    
    /// thumb border color
    @IBInspectable open var thumbBorderColor: UIColor = UIColor.gray {
        didSet {
            self.rangeSlider?.thumbBorderColor = thumbBorderColor
        }
    }
    
    
    /// thumb border width
    @IBInspectable open var thumbBorderWidth: CGFloat = 0.5 {
        didSet {
            self.rangeSlider?.thumbBorderWidth = thumbBorderWidth
            
        }
    }
    
    /// set 0.0 for square thumbs to 1.0 for circle thumbs
    @IBInspectable open var curvaceousness: CGFloat = 1.0 {
        didSet {
            self.rangeSlider?.curvaceousness = curvaceousness
        }
    }
    
    /// thumb width and height
    @IBInspectable open var thumbSize: CGFloat = 32.0 {
        didSet {
            if let slider = self.rangeSlider {
                var oldFrame = slider.frame
                oldFrame.size.height = thumbSize
                slider.frame = oldFrame
            }
        }
    }
    
    //MARK: - Init
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setup()
    }
    
    /// setup
    open func setup() {
        self.autoresizingMask = [.flexibleWidth]
        
        self.titleLabel = UILabel(frame: .zero)
        self.titleLabel?.numberOfLines = 1
        self.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16.0)
        self.titleLabel?.text = ""
        self.addSubview(self.titleLabel!)
        
        self.lowerLabel = UILabel(frame: .zero)
        self.lowerLabel?.numberOfLines = 1
        self.lowerLabel?.font = UIFont.systemFont(ofSize: 14.0)
        self.lowerLabel?.text = ""
        self.lowerLabel?.textColor = UIColor.white
        self.lowerLabel?.textAlignment = .center
        self.addSubview(self.lowerLabel!)
        
        self.upperLabel = UILabel(frame: .zero)
        self.upperLabel?.numberOfLines = 1
        self.upperLabel?.font = UIFont.systemFont(ofSize: 14.0)
        self.upperLabel?.text = ""
        self.upperLabel?.textColor = UIColor.white
        self.upperLabel?.textAlignment = .center
        self.addSubview(self.upperLabel!)
        
        self.rangeSlider = ViddstRangeSlider(frame: .zero)
        self.addSubview(self.rangeSlider!)
        
        self.updateLabelDisplay()
        
        self.rangeSlider?.addTarget(self, action: #selector(self.rangeSliderValueChanged(_:)), for: .valueChanged)
    }
    func getTimeStringFromSeconds(seconds: Double) -> String {
        let dcFormatter = DateComponentsFormatter()
        dcFormatter.zeroFormattingBehavior = DateComponentsFormatter.ZeroFormattingBehavior.pad
        if seconds > 3600 {
            dcFormatter.allowedUnits = [NSCalendar.Unit.hour, NSCalendar.Unit.minute, NSCalendar.Unit.second]
        } else {
            dcFormatter.allowedUnits = [NSCalendar.Unit.minute, NSCalendar.Unit.second]
        }
        
        dcFormatter.unitsStyle = DateComponentsFormatter.UnitsStyle.positional
        
        return dcFormatter.string(from: seconds)!
    }
    
    //MARK: - Range slider delegage
    
    @objc open func rangeSliderValueChanged(_ rangeSlider: ViddstRangeSlider) {
        
        delegate?.sliderValueChanged(slider: rangeSlider, slidervw: self)
        
        self.updateLabelDisplay()
        
    }
    
    //MARK: - Update labels display
    open func updateLabelDisplay() {
        
        let lowerVal = self.getTimeStringFromSeconds(seconds: rangeSlider!.lowerValue)
        let upperVal = self.getTimeStringFromSeconds(seconds: rangeSlider!.upperValue)
        
        
        self.lowerLabel?.text = lowerVal
        self.upperLabel?.text = upperVal
        
        if self.lowerLabel != nil {
            
            // for stepped value we animate the labels
            if self.thumbLabelStyle == .FOLLOW {
                UIView.animate(withDuration: 0.1, animations: {
                    self.layoutSubviews()
                })
            }
            else {
                self.setNeedsLayout()
                self.layoutIfNeeded()
            }
        }
    }
    
    /// layout subviews
    override open func layoutSubviews() {
        super.layoutSubviews()
        
        if let titleLabel = self.titleLabel , let lowerLabel = self.lowerLabel ,
            let upperLabel = self.upperLabel , let rangeSlider = self.rangeSlider {
            
            let commonWidth = self.bounds.width
            if !titleLabel.isHidden && titleLabel.text != nil && titleLabel.text!.count > 0 {
                titleLabel.frame = CGRect(x: 0,y: 0,width: commonWidth,height: (titleLabel.font.lineHeight + self.spacing))
            }
            
            rangeSlider.frame = CGRect(x: 0,y: titleLabel.frame.origin.y + titleLabel.frame.size.height +  self.spacing,width: commonWidth ,height: thumbSize)
            
            let lowerWidth = self.estimatelabelSize(font: lowerLabel.font, string: lowerLabel.text!, constrainedToWidth: Double(commonWidth)).width
            let upperWidth = self.estimatelabelSize(font: upperLabel.font, string: upperLabel.text!, constrainedToWidth: Double(commonWidth)).width
            
            var lowerLabelX : CGFloat = 0
            var upperLabelX : CGFloat = 0
            
            
            if self.thumbLabelStyle == .FOLLOW {
                lowerLabelX = rangeSlider.lowerThumbLayer.frame.midX  - lowerWidth / 2
                upperLabelX = rangeSlider.upperThumbLayer.frame.midX  - upperWidth / 2
            }else {
                // fix lower label to left and upper label to right
                lowerLabelX = rangeSlider.frame.origin.x + self.spacing
                upperLabelX = rangeSlider.frame.origin.x + rangeSlider.frame.size.width - thumbSize + self.spacing
            }
            
            lowerLabel.frame = CGRect(x: lowerLabelX,y: rangeSlider.frame.size.height + 20,width: lowerWidth ,height: lowerLabel.font.lineHeight + self.spacing )
            
            upperLabel.frame = CGRect(x: upperLabelX,y: rangeSlider.frame.size.height + 20,width: upperWidth ,height: upperLabel.font.lineHeight + self.spacing )
            
        }
        
    }
    
    // return the best size that fit within the box
    open override func sizeThatFits(_ size: CGSize) -> CGSize {
        
        if let titleLabel = self.titleLabel , let lowerLabel = self.lowerLabel {
            
            var height : CGFloat = 0
            var titleLabelMaxY : CGFloat = 0
            if !titleLabel.isHidden && titleLabel.text != nil && titleLabel.text!.count > 0 {
                titleLabelMaxY = titleLabel.font.lineHeight + self.spacing
            }
            height = titleLabelMaxY + lowerLabel.font.lineHeight + self.spacing + thumbSize
            return CGSize(width: size.width, height: height)
        }
        return size
        
    }
    
    private func estimatelabelSize(font: UIFont,string: String, constrainedToWidth width: Double) -> CGSize{
        return string.boundingRect(with: CGSize(width: width, height: Double.greatestFiniteMagnitude),
                                   options: NSStringDrawingOptions.usesLineFragmentOrigin,
                                   attributes: [NSAttributedString.Key.font: font],
                                   context: nil).size
        
    }
    
}
