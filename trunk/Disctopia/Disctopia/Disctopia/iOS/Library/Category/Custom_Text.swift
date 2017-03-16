
import UIKit
@IBDesignable class CustomTextField:  UITextField
{
    
    @IBInspectable var placeholderColor: UIColor = UIColor.lightGrayColor() {
        didSet {
            let canEditPlaceholderColor = self.respondsToSelector(Selector("setAttributedPlaceholder:"))
            
            if (canEditPlaceholderColor) {
                self.attributedPlaceholder = NSAttributedString(string: placeholder!, attributes:[NSForegroundColorAttributeName: placeholderColor]);
                
            }
        }
    }
    
}

@IBDesignable class button_round: UIButton
{
    
    @IBInspectable var cornerRadius: CGFloat = 0
        {
        didSet
        {
            layer.cornerRadius = cornerRadius
        }
    }
    
    @IBInspectable var borderColor: UIColor = UIColor.clearColor() {
        didSet {
            layer.borderColor = borderColor.CGColor
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    
}

@IBDesignable class view_round: UIView
{
    
    @IBInspectable var cornerRadius: CGFloat = 0
        {
        didSet
        {
            layer.cornerRadius = cornerRadius
        }
    }
    
    @IBInspectable var borderColor: UIColor = UIColor.clearColor() {
        didSet {
            layer.borderColor = borderColor.CGColor
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    
}
public extension UITextField
{
    @IBInspectable public var myCharacterSpacing: CGFloat
        {
        get {
            return 0
        }
        set
        {
            if (placeholder != nil)
            {
                let attributedString = NSMutableAttributedString(string: placeholder!)
                attributedString.addAttribute(NSKernAttributeName, value: newValue, range: NSMakeRange(0, placeholder!.characters.count))
                self.attributedText = attributedString
            }
        }
    }
    
    @IBInspectable public var cornerRadius: CGFloat
        {
        get
        {
            return 0
        }
        set
        {
            if (newValue > 0)
            {
                layer.cornerRadius = newValue
            }
        }
    }
    
    @IBInspectable public var myPlaceholderColor:UIColor{
        get
        {
            return UIColor.clearColor()
        }
        set
        {
            if (placeholder != nil)
            {
                self.attributedPlaceholder = NSAttributedString(string: placeholder!, attributes:[NSForegroundColorAttributeName: newValue])
            }
        }
        
    }
    
    @IBInspectable public var leftSpacer:CGFloat {
        get {
            if let l = leftView {
                return l.frame.size.width
            } else {
                return 0
            }
        }
        set
        {
            if (newValue > 0)
            {
                leftViewMode = .Always
                leftView = UIView(frame: CGRect(x: 0, y: 0, width: newValue, height: frame.size.height))
            }
        }
    }
    
    @IBInspectable public var rightImage:UIImage {
        get {
            return UIImage()
        }
        set
        {
            rightViewMode = .Always
            let backgroundView =  UIView(frame: CGRect(x: -5, y: 2, width: 35, height: frame.size.height))
            let imgView = UIImageView (image: newValue)
            backgroundView.addSubview(imgView)
            imgView.center = backgroundView.center
            rightView =  backgroundView
        }
    }
    
    
    
    @IBInspectable public var leftImage:UIImage {
        get {
            return UIImage()
        }
        set
        {
            leftViewMode = .Always
            let backgroundView =  UIView(frame: CGRect(x: 0, y: 2, width: 35, height: frame.size.height))
            let imgView = UIImageView (image: newValue)
            backgroundView.addSubview(imgView)
            imgView.center = backgroundView.center
            leftView =  backgroundView
        }
    }
    
    
    @IBInspectable public var borderColor: UIColor {
        get
        {
            return UIColor(CGColor: layer.borderColor!)
        }
        set
        {
            layer.borderColor = newValue.CGColor
        }
    }
    
    @IBInspectable public var borderWidth: CGFloat {
        get
        {
            return layer.borderWidth
        }
        set
        {
            layer.borderWidth = newValue;
        }
    }
}


public extension UITextView
{
    //    @IBInspectable public var myCharacterSpacingText: CGFloat
    //        {
    //        get {
    //            return 0
    //        }
    //        set
    //        {
    //            if (newValue > 0)
    //            {
    //                let attributedString = NSMutableAttributedString(string: placeholder!)
    //                attributedString.addAttribute(NSKernAttributeName, value: newValue, range: NSMakeRange(0, placeholder!.characters.count))
    //                self.attributedText = attributedString
    //            }
    //        }
    //    }
    
    @IBInspectable public var cornerRadius: CGFloat
        {
        get
        {
            return 0
        }
        set
        {
            if (newValue > 0)
            {
                layer.cornerRadius = newValue
            }
        }
    }
    
    @IBInspectable public var borderColor: UIColor {
        get
        {
            return UIColor(CGColor: layer.borderColor!)
        }
        set
        {
            layer.borderColor = newValue.CGColor
        }
    }
    
    @IBInspectable public var borderWidth: CGFloat {
        get
        {
            return layer.borderWidth
        }
        set
        {
            layer.borderWidth = newValue;
        }
    }
}


