//
//  LineChartWrapper.swift
//  FinanceDashboard
//
//  Created by 顾艳华 on 2023/1/22.
//

import SwiftUI
import SwiftUICharts

struct LineChartWrapper: View {
    let lineData: [Double]
    var line: some View {
        var line = LineChartView(data: lineData, title: "Mouth Trend", form: ChartForm.extraLarge, rateValue: 0)
        line.darkModeStyle = ChartStyle(backgroundColor: Color.gray, accentColor: Colors.OrangeStart, secondGradientColor: Colors.OrangeEnd, textColor: Color.white, legendTextColor: Color.white, dropShadowColor: .gray)
        return line
    }
    var body: some View {
        line
    }
}

//struct LineChartWrapper_Previews: PreviewProvider {
//    static var previews: some View {
//        LineChartWrapper()
//    }
//}
