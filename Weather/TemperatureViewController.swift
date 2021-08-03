//
//  TemperatureViewController.swift
//  Weather
//
//  Created by YOONJONG on 2021/08/03.
//

import UIKit

class TemperatureViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
}

extension TemperatureViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TemperatureCell", for: indexPath) as? TemperatureCell else { return UICollectionViewCell() }
        // let info = viewmodel.info(At:indexpath.item)
        // cell.update(info:info)
        return cell;
    }
    
    
}

extension TemperatureViewController: UICollectionViewDelegate {
    // 필요없을듯. 클릭했을때의 동작
}


class TemperatureCell: UICollectionViewCell {
    @IBOutlet weak var weatherImage: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    
    
}
