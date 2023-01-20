//
//  TrendChart.swift
//  FinanceDashboard
//
//  Created by 顾艳华 on 2023/1/20.
//


import SwiftUI

struct TrendPath: Shape {
    let data: [Double]
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.minX, y: rect.maxY))
        let dataMax = data.max()!
        let dataMin = data.min()!
        var range = dataMax - dataMin
        range = range == 0 ? 1 : range
        let per = rect.maxY / range
        for (index, entry) in data.enumerated() {
            path.addLine(to: CGPoint(x: rect.maxX / CGFloat(data.count) * CGFloat(index), y: CGFloat(rect.maxY - (entry - dataMin) * per) ))
        }
        
        return path
    }
    
    
}

struct TrendChart: View {
  var data: [Double]
  let gridColor: Color
  let dataColor: Color
  
  init(data: [Double], gridColor: Color = .gray, dataColor: Color = .blue) {
    self.data = data
    self.gridColor = gridColor
    self.dataColor = dataColor
  }
  
  var body: some View {
      TrendPath(data: data)
          .stroke(.blue, lineWidth: 2)
          .padding()
//    ZStack {
//      TrendChartGrid(categories: data.count, divisions: 10)
//        .stroke(gridColor, lineWidth: 0.5)
      
//      TrendChartPath(data: data)
//        .fill(dataColor.opacity(0.3))
      
//      TrendChartPath(data: data)
//        .stroke(dataColor, lineWidth: 2.0)
//    }
  }
}

