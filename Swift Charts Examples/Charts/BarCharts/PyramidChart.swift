//
// Copyright © 2022 Swift Charts Examples.
// Open Source - MIT License

import SwiftUI
import Charts

struct PyramidChartOverview: View {
    var body: some View {
        Chart {
            ForEach(PopulationByAgeData.example) { series in
                ForEach(series.population, id: \.percentage) { element in
                    BarMark(
                        xStart: .value("Percentage", 0),
                        xEnd: .value("Percentage", series.sex == "Male" ? element.percentage : element.percentage * -1),
                        y: .value("AgeRange", element.ageRange)
                    )
                }
                .foregroundStyle(by: .value("Sex", series.sex))
            }
        }
        .chartXAxis(.hidden)
        .chartYAxis(.hidden)
        .chartLegend(.hidden)
        .frame(height: 200)
    }
}

struct PyramidChart: View {
    @State private var data = PopulationByAgeData.example
    
    @State var leftColor: Color = .green
    @State var rightColor: Color = .blue
    
    @State var barHeight: CGFloat = 10.0
    
    var body: some View {
        List {
            Section {
                Chart(data) { series in
                    ForEach(series.population, id: \.percentage) { element in
                        BarMark(
                            xStart: .value("Percentage", 0),
                            xEnd: .value("Percentage", series.sex == "Male" ? element.percentage : element.percentage * -1),
                            y: .value("AgeRange", element.ageRange),
                            height: .fixed(barHeight)
                        )
                        .accessibilityLabel("\(element.ageRange)")
                        .accessibilityValue("\(element.percentage)")
                    }
                    .foregroundStyle(series.sex == "Male" ? rightColor.gradient : leftColor.gradient)
                    .interpolationMethod(.catmullRom)
                }
                .chartYAxis {
                    AxisMarks(preset: .aligned, position: .automatic) { _ in
                        AxisValueLabel(centered: true)
                    }
                }
                .chartXAxis {
                    AxisMarks(preset: .aligned, position: .automatic) { value in
                        let rawValue = value.as(Int.self)!
                        let percentage = abs(Double(rawValue) / 100)
                        
                        AxisGridLine()
                        AxisValueLabel(percentage.formatted(.percent))
                    }
                }
                .chartLegend(position: .top, alignment: .center)
                .frame(height: 340)
            }
            
            customization
        }
        .navigationBarTitle(ChartType.pyramid.title, displayMode: .inline)
    }
    
    var customization: some View {
        Group {
            Section {
                Button("Generate random data") {
                    withAnimation {
                        generateRandomData()
                    }
                }
            }
            
            Section {
                VStack(alignment: .leading) {
                    Text("Bar Height: \(barHeight, specifier: "%.1f")")
                    Slider(value: $barHeight, in: 0...25) {
                        Text("Bar Height")
                    } minimumValueLabel: {
                        Text("0")
                    } maximumValueLabel: {
                        Text("25")
                    }
                }
                
                ColorPicker("Left Color", selection: $leftColor)
                ColorPicker("Right Color", selection: $rightColor)
            }
        }
    }
    
    func generateRandomData() {
        data = [
            .init(sex: "Male", population: [
                (ageRange: "0-10", percentage: Int.random(in: 0..<100)),
                (ageRange: "11-20", percentage: Int.random(in: 0..<100)),
                (ageRange: "21-30", percentage: Int.random(in: 0..<100)),
                (ageRange: "31-40", percentage: Int.random(in: 0..<100)),
                (ageRange: "41-50", percentage: Int.random(in: 0..<100)),
                (ageRange: "51-60", percentage: Int.random(in: 0..<100)),
                (ageRange: "61-70", percentage: Int.random(in: 0..<100)),
                (ageRange: "71-80", percentage: Int.random(in: 0..<100)),
                (ageRange: "81-90", percentage: Int.random(in: 0..<100)),
                (ageRange: "91+", percentage: Int.random(in: 0..<100))
            ]),
            .init(sex: "Female", population: [
                (ageRange: "0-10", percentage: Int.random(in: 0..<100)),
                (ageRange: "11-20", percentage: Int.random(in: 0..<100)),
                (ageRange: "21-30", percentage: Int.random(in: 0..<100)),
                (ageRange: "31-40", percentage: Int.random(in: 0..<100)),
                (ageRange: "41-50", percentage: Int.random(in: 0..<100)),
                (ageRange: "51-60", percentage: Int.random(in: 0..<100)),
                (ageRange: "61-70", percentage: Int.random(in: 0..<100)),
                (ageRange: "71-80", percentage: Int.random(in: 0..<100)),
                (ageRange: "81-90", percentage: Int.random(in: 0..<100)),
                (ageRange: "91+", percentage: Int.random(in: 0..<100))
            ]),
        ]
    }
}

struct PyramidChart_Previews: PreviewProvider {
    static var previews: some View {
        PyramidChartOverview()
        PyramidChart()
    }
}
