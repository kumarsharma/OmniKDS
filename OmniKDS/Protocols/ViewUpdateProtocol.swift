//
//  ViewUpdateProtocol.swift
//  OmniKDS
//
//  Created by Kumar Sharma on 11/10/20.
//  Copyright © 2020 Omni Systems. All rights reserved.
//

import UIKit

protocol ViewUpdateProtocol {
    
    func didCompleteDataSync(from presenter:KDSPresenter)
    func didUpdateModel()
    func playKitchenSound(withSoundName soundName:String)
    func didSelectItem(atIndexPath indexPath:IndexPath, inCollectionView:UICollectionView)
}
