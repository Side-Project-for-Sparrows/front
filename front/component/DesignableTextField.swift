import UIKit

@IBDesignable
class DesignableTextField: UITextField {

    @IBInspectable var borderColor: UIColor = .gray {
        didSet { updateLayer() }
    }

    @IBInspectable var borderWidth: CGFloat = 1 {
        didSet { updateLayer() }
    }

    @IBInspectable var cornerRadius: CGFloat = 8 {
        didSet { updateLayer() }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        sharedInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        sharedInit()
    }

    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        sharedInit()
    }

    private func sharedInit() {
        updateLayer()
    }

    private func updateLayer() {
        layer.borderColor = borderColor.cgColor
        layer.borderWidth = borderWidth
        layer.cornerRadius = cornerRadius
        layer.masksToBounds = true
    }
}
