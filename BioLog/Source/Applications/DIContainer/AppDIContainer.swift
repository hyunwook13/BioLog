//
//  AppDIContainer.swift
//  HaloGlow
//
//  Created by 이현욱 on 1/21/25.
//

import Foundation

final class AppDIContainer {
    func makeMissionsDiContainer() -> MissionsDIContainer {
        return MissionsDIContainer()
    }
    
    func makeDailyTaskDiContainer() -> DailyTaskDIContainer {
        return DailyTaskDIContainer()
    }
    
    func makeChartDIContainer() -> ChartDIContainer {
        return ChartDIContainer()
    }
}
