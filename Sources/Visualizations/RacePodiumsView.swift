//
//  RacePodiumsView.swift
//  
//
//  Created by Eneko Alonso on 4/21/22.
//

import SwiftUI
import GPSModels

public struct RacePodiumsView: View {
    var circuitName: String
    var racePodiums: [RacePodium]

    public init(circuitName: String, racePodiums: [RacePodium]) {
        self.circuitName = circuitName
        self.racePodiums = racePodiums
    }

    public var body: some View {
        VStack(spacing: 30) {
            VStack {
                HStack(alignment: .lastTextBaseline) {
                    Text("Circuit")
                        .font(.system(size: 16, weight: .medium))
                    ZStack {
                        //                        Text(circuitName)
                        //                            .font(.system(size: 36, weight: .bold, design: .monospaced))
                        //                            .foregroundColor(Color.green)
                        Text(circuitName)
                            .font(.system(size: 34, weight: .bold, design: .monospaced))
                            .foregroundColor(Color.red)
                        Text(circuitName)
                            .font(.system(size: 32, weight: .bold, design: .monospaced))
                    }
                }
                Text("Last \(racePodiums.count) Podiums")
            }
            VStack(spacing: 20) {
                ForEach(racePodiums, id: \.year) { racePodium in
                    HStack {
                        Text(String(racePodium.year))
                            .font(.system(size: 50, weight: .heavy))
                            .frame(width: 180)

                        VStack {
                            HStack {
                                Text("1st 🏆".uppercased())
                                    .font(.system(size: 16, weight: .bold))
                                    .frame(width: 50)
                                    .foregroundColor(Color.yellow)
                                    .multilineTextAlignment(.leading)
                                ZStack {
                                    Color(cssColor: racePodium.p1ConstructorColor)
                                    HStack {
                                        Text(racePodium.p1)
                                        //                                        .font(.system(size: 32, weight: .bold, design: .monospaced))
                                            .font(Font.custom("MTV2C", size: 42))
                                        Text(racePodium.p1Time)
                                    }
                                }
                            }
                            HStack {
                                Text("2nd 🥈".uppercased())
                                    .font(.system(size: 16, weight: .bold))
                                    .frame(width: 50)
                                    .foregroundColor(Color.gray)
                                    .multilineTextAlignment(.leading)
                                ZStack {
                                    Color(cssColor: racePodium.p2ConstructorColor)
                                    HStack {
                                        Text(racePodium.p2)
                                        //                                        .font(.system(size: 32, weight: .bold, design: .monospaced))
                                            .font(Font.custom("MTV2C", size: 42))
                                        Text(racePodium.p2Time)
                                    }
                                }
                            }
                            HStack {
                                Text("3rd 🥉".uppercased())
                                    .font(.system(size: 16, weight: .bold))
                                    .frame(width: 50)
                                    .foregroundColor(Color.orange)
                                    .multilineTextAlignment(.leading)
                                ZStack {
                                    Color(cssColor: racePodium.p3ConstructorColor)
                                    HStack {
                                        Text(racePodium.p3)
                                        //                                          .font(.system(size: 32, weight: .bold, design: .monospaced))
                                            .font(Font.custom("MTV2C", size: 42))
                                        Text(racePodium.p3Time)
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}

struct RacePodiumsView_Previews: PreviewProvider {
    static var previews: some View {
        RacePodiumsView(circuitName: "Imola", racePodiums: imola)
            .frame(width: 1024, height: 768)
    }

    static var imola: [RacePodium] {
        [
            RacePodium(
                year: 2021,
                raceName: "Emilia Romagna Grand Prix",
                laps: 68,
                p1: "VERSTAPPEN",
                p2: "HAMILTON",
                p3: "NORRIS",
                p1Time: "1h2m3s",
                p2Time: "+20s",
                p3Time: "+25s",
                p1Milliseconds: 100,
                p2Milliseconds: 120,
                p3Milliseconds: 125,
                p1ConstructorColor: "#ff8800",
                p2ConstructorColor: "#123456",
                p3ConstructorColor: "#554477"
            ),
            RacePodium(
                year: 2020,
                raceName: "Emilia Romagna Grand Prix",
                laps: 68,
                p1: "HAM 🇬🇧",
                p2: "BOT 🇫🇮",
                p3: "RIC 🇦🇺",
                p1Time: "1h2m3s",
                p2Time: "+20s",
                p3Time: "+25s",
                p1Milliseconds: 100,
                p2Milliseconds: 120,
                p3Milliseconds: 125,
                p1ConstructorColor: "#558800",
                p2ConstructorColor: "#345678",
                p3ConstructorColor: "#443377"
            )
        ]
    }
}

//struct StrokeTextLabel: UIViewRepresentable {
//    var text: String
//    func makeUIView(context: Context) -> UILabel {
//        let attributedStringParagraphStyle = NSMutableParagraphStyle()
//        attributedStringParagraphStyle.alignment = NSTextAlignment.center
//        let attributedString = NSAttributedString(
//            string: text,
//            attributes:[
//                NSAttributedString.Key.paragraphStyle: attributedStringParagraphStyle,
//                NSAttributedString.Key.strokeWidth: 3.0,
//                NSAttributedString.Key.foregroundColor: UIColor.black,
//                NSAttributedString.Key.strokeColor: UIColor.black,
//                NSAttributedString.Key.font: UIFont(name:"Helvetica", size:30.0)!
//            ]
//        )
//
//        let strokeLabel = UILabel(frame: CGRect.zero)
//        strokeLabel.attributedText = attributedString
//        strokeLabel.backgroundColor = UIColor.clear
//        strokeLabel.sizeToFit()
//        strokeLabel.center = CGPoint.init(x: 0.0, y: 0.0)
//        return strokeLabel
//    }
//
//    func updateUIView(_ uiView: UILabel, context: Context) {}
//}
