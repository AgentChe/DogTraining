//
//  ClickerViewController.swift
//  DogTraining
//
//  Created by Андрей Чернышев on 23.08.2023.
//

import UIKit
import RxSwift
import AVFoundation

final class ClickerViewController: UIViewController {
    lazy var mainView = ClickerView()
    
    private lazy var disposeBag = DisposeBag()
    
    private lazy var whistleLongPressGesture = UILongPressGestureRecognizer()
    
    private var player: AVAudioPlayer?
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainView.clickerView.clickButton.rx.tap
            .bind(to: Binder(self) { base, void in
                base.play(soundName: "Sound.Clicker")
            })
            .disposed(by: disposeBag)
        
        mainView.whistleView.clickButton.rx.tap
            .bind(to: Binder(self) { base, void in
                guard let soundName = base.mainView.whistleView.selectedElement?.shortSoundName else {
                    return
                }
                
                base.play(soundName: soundName)
            })
            .disposed(by: disposeBag)
        
        whistleLongPressGesture.rx.event
            .bind(to: Binder(self) { base, event in
                if event.state == .began {
                    if let soundName = base.mainView.whistleView.selectedElement?.longSoundName {
                        base.play(soundName: soundName)
                        base.mainView.whistleView.clickButton.setImage(UIImage(named: "Clicker.Whistle.Tapped"), for: .normal)
                    }
                } else if event.state == .ended {
                    base.stop()
                    base.mainView.whistleView.clickButton.setImage(UIImage(named: "Clicker.Whistle.Normal"), for: .normal)
                }
            })
            .disposed(by: disposeBag)
        
        mainView.whistleView.clickButton.addGestureRecognizer(whistleLongPressGesture)
        
        addUnitActions()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .darkContent
    }
}

// MARK: Public
extension ClickerViewController {
    static func make() -> ClickerViewController {
        let vc = ClickerViewController()
        vc.navigationItem.backButtonTitle = " "
        return vc
    }
}

// MARK: Private
private extension ClickerViewController {
    func addUnitActions() {
        Observable
            .merge(
                mainView.unitView.whistleButton.rx.tap
                    .map { ClickerUnitView.Unit.whistle },
                mainView.unitView.clickerButton.rx.tap
                    .map { ClickerUnitView.Unit.clicker }
            )
            .bind(to: Binder(mainView) { base, unit in
                base.unitView.unit = unit
                base.move(to: unit)
            })
            .disposed(by: disposeBag)
    }
    
    func play(soundName: String) {
        stop()
        
        guard let assetData = NSDataAsset(name: soundName) else {
            return
        }
        
        player = try? AVAudioPlayer(data: assetData.data, fileTypeHint: "caf")
        
        player?.play()
    }
    
    func stop() {
        player?.stop()
        player = nil
    }
}
