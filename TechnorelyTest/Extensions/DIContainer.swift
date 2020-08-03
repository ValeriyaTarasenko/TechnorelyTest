//
//  DIContainer.swift
//  TechnorelyTest
//
//  Created by Valeriia Tarasenko on 29.07.2020.
//  Copyright © 2020 Valeriia Tarasenko. All rights reserved.
//

import Swinject

private let _container = Container()

public struct DIContainer {
    // MARK: - Public
    
    public static var defaultResolver: Container {
        return _container
    }
}
