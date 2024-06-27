//
//  ContentView.swift
//  SwiftUILayoutProtocol
//
//  Created by Karthik K Manoj on 27/06/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            HStack(spacing: 5) {
                contents()
            }
            .border(.blue)
            
            SimpleHStack(spacing: 5) {
                Circle()
                    .fill(.yellow)
                    .frame(width: 30, height: 30)
                    .preferredPosition(1)
                
                Circle()
                    .fill(.green)
                    .frame(width: 30, height: 30)
                    .preferredPosition(2)
                
                Circle()
                    .fill(.blue)
                    .frame(width: 30, height: 30)
                    .preferredPosition(1)
                
            }
            .border(.red)
            
            HStack(spacing: 5) {
                contents()
            }
            .border(.black)
        }
        //.frame(width: 100, height: 100)
        .border(Color.green)
        .padding()
    }
    
    @ViewBuilder func contents() -> some View {
        Image(systemName: "globe.americas.fill")
        Text("Hello World")
        Image(systemName: "globe.europe.africa.fill")
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct SimpleHStack: Layout {
    let spacing: CGFloat
    
    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        print("SimpleHStack Proposed Size", proposal)
        let idealViewSizes = subviews.map { $0.sizeThatFits(.unspecified) }
        
        let spacing = spacing * CGFloat(subviews.count - 1)
        let width = spacing + idealViewSizes.reduce(0) { $0 + $1.width }
        let height = idealViewSizes.reduce(0) { max($0, $1.height) }
        
        return CGSize(width: width, height: height)
        
    }
    
    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        var pt = CGPoint(x: bounds.minX, y: bounds.minY)
        
        for v in subviews.sorted(by: { $0.preferredPosition > $1.preferredPosition }) {
            v.place(at: pt, anchor: .topLeading, proposal: .unspecified)
            pt.x += v.sizeThatFits(.unspecified).width + spacing
        }
    }
    
    func explicitAlignment(of guide: HorizontalAlignment, in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGFloat? {
        if guide == .leading {
            return subviews[0].sizeThatFits(proposal).width + spacing
        } else {
            return nil
        }
    }
}

extension View {
    func preferredPosition(_ order: CGFloat) -> some View {
        self.layoutValue(key: PreferredPosition.self, value: order)
    }
}

extension LayoutSubview {
    var preferredPosition: CGFloat {
        self[PreferredPosition.self]
    }
}

struct PreferredPosition: LayoutValueKey {
    static var defaultValue: CGFloat = 0.0
}
