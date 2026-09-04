//
//  Extension.swift
//  AnimationProject
//
//  Created by iPHTech 40 on 04/09/26.
//
import Foundation

extension CGFloat{
    func sigmodFunc() -> CGFloat {
        return 1/(1+exp(-self))
    }
}
