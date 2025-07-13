import UIKit

extension UIViewController {
    func showToast(message: String, duration: Double = 2.0) {
        let toastLabel = UILabel()
        toastLabel.text = message
        toastLabel.textColor = .white
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.5) // 투명도 50%
        toastLabel.textAlignment = .center
        toastLabel.font = UIFont.systemFont(ofSize: 14)
        toastLabel.numberOfLines = 0
        toastLabel.alpha = 0.0
        toastLabel.layer.cornerRadius = 10
        toastLabel.clipsToBounds = true

        let maxWidth = self.view.frame.width - 40
        let textSize = toastLabel.sizeThatFits(CGSize(width: maxWidth, height: CGFloat.greatestFiniteMagnitude))
        let labelWidth = min(textSize.width + 32, maxWidth)
        let labelHeight = textSize.height + 20
        toastLabel.frame = CGRect(x: (self.view.frame.width - labelWidth) / 2,
                                  y: 80, // 상단에서 80pt 아래
                                  width: labelWidth,
                                  height: labelHeight)
        self.view.addSubview(toastLabel)

        UIView.animate(withDuration: 0.3, animations: {
            toastLabel.alpha = 1.0
        }) { _ in
            UIView.animate(withDuration: 0.3, delay: duration, options: .curveEaseOut, animations: {
                toastLabel.alpha = 0.0
            }) { _ in
                toastLabel.removeFromSuperview()
            }
        }
    }

    func showAlert(title: String = "알림", message: String, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default) { _ in
            completion?()
        })
        present(alert, animated: true)
    }
} 