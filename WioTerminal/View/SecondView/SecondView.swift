//
//  SecondView.swift
//  WioTerminal
//
//  Created by Quang Nguyen on 11/16/21.
//

import SwiftUI
import SwiftUICharts

struct SecondView: View {
    var body: some View {
        GeometryReader { geo in
            ScrollView {
                MultiLineChartView(data: [([8,32,11,23,40,28], GradientColors.green), ([90,99,78,111,70,60,77], GradientColors.purple), ([34,56,72,38,43,100,50], GradientColors.orngPink)], title: "Title", form: ChartForm.large)
                    .padding()
                BarChartView(data: ChartData(points: [8,23,54,32,12,37,7,23,43,23,54,32,12,37,7,]), title: "Title", style: Styles.barChartStyleOrangeLight)
                BarCharts()
                LineChartView(data: [8,23,54,32,12,37,7,23,43,8,23,54,32,12], title: "Title")
                LineCharts()
                PieChartView(data: [8,23,54,32,12,37,7,23,43,32,12,37,7,23,43], title: "Title")
                PieCharts()
            }
        }
    }
}

struct SecondView_Previews: PreviewProvider {
    static var previews: some View {
        SecondView()
    }
}

struct BarCharts:View {
    var body: some View {
        VStack{
            BarChartView(data: ChartData(points: [8,23,54,32,12,37,7,23,43]), title: "Title", style: Styles.barChartStyleOrangeLight)
        }
    }
}

struct LineCharts:View {
    var body: some View {
        VStack{
            LineChartView(data: [8,23,54,32,12,37,7,23,43], title: "Title")
        }
    }
}

struct PieCharts:View {
    var body: some View {
        VStack{
            PieChartView(data: [8,23,54,32,12,37,7,23,43], title: "Title")
        }
    }
}

struct LineChartsFull: View {
    var body: some View {
        VStack{
            LineView(data: [8,23,54,32,12,37,7,23,43], title: "Line chart", legend: "Legend") .padding()
            // legend is optional, use optional .padding()
        }
    }
}
