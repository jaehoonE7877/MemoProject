//
//  BaseViewController.swift
//  MemoProject
//
//  Created by Seo Jae Hoon on 2022/08/31.
//

import UIKit
import SnapKit
import Then
class BaseViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configure()
        setConstraints()
    }
    
    func configure() { }
    
    func setConstraints() {}
    
    func showAlertMessage(title: String, button: String = "확인") {
        let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        let ok = UIAlertAction(title: button, style: .default)
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        alert.addAction(ok)
        alert.addAction(cancel)
        present(alert, animated: true)
    }
    
    func getNumFormat(for number: Int) -> String {
        let numberFormat = NumberFormatter()
        numberFormat.numberStyle = .decimal
        return numberFormat.string(for: number) ?? "0"
    }
    
    func naviBackground() {
        let naviBarApperance = UINavigationBarAppearance()
        naviBarApperance.backgroundColor = .defaultBackgroundColor
        self.navigationController?.navigationBar.scrollEdgeAppearance = naviBarApperance
    }
    
}
