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
    var spacing: CGFloat? = nil
    
    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        print("SimpleHStack Proposed Size", proposal)
        let idealViewSizes = subviews.map { $0.sizeThatFits(.unspecified) }
        
        let spaces = computeSpacing(subviews)
        let accumulatedSpaces = spaces.reduce(0) { $0 + $1 }
        let accumulatedWidths = idealViewSizes.reduce(0) { $0 + $1.width }
        let maxHeight = idealViewSizes.reduce(0) { max($0, $1.height) }
        
        return CGSize(width: accumulatedSpaces + accumulatedWidths, height: maxHeight)
    }
    
    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        var pt = CGPoint(x: bounds.minX, y: bounds.minY)
        let spaces = computeSpacing(subviews)
        
        for idx in subviews.indices {
            subviews[idx].place(at: pt, anchor: .topLeading, proposal: .unspecified)
            
            if idx < subviews.count - 1 {
                pt.x += subviews[idx].sizeThatFits(.unspecified).width + spaces[idx]
            }
        }
    }
    
    func explicitAlignment(of guide: HorizontalAlignment, in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGFloat? {
        if guide == .leading {
            return bounds.minY
        } else {
            return nil
        }
    }
    
    private func computeSpacing(_ subviews: LayoutSubviews) -> [CGFloat] {
        // if there is spacing applied then create an array of spacing
        if let spacing  {
            return Array<CGFloat>(repeating: spacing, count: subviews.count - 1)
        } else {
            return subviews.indices.map { idx in
                guard idx < subviews.count - 1 else { return CGFloat(0) }
                
                return subviews[idx].spacing.distance(to: subviews[idx + 1].spacing, along: .horizontal)
            }
        }
        // if not then we need to create an array of custom spacing by asking subviews
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
