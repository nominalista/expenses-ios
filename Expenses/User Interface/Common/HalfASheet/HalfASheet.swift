

//
//  HalfASheet.swift
//
//  Created by Franklyn Weber on 28/01/2021.
//
import SwiftUI

struct HalfASheet<Content: View>: View {
    
    @Binding var isPresented: Bool
    
    @ViewBuilder let content: () -> Content
    
    @State private var hasAppeared = false
    @State private var dragOffset: CGFloat = 0
    
    var backgroundColor: UIColor = .tertiarySystemGroupedBackground
    
    private var background: Color {
        Color.black.opacity(0.5)
    }
    
    public var body: some View {
        GeometryReader { geometry in
            ZStack {
                if isPresented {
                    background
                        .onTapGesture {
                            dismiss()
                        }
                        .transition(.opacity)
                        .onAppear { // we don't want the content to slide up until the background has appeared
                            withAnimation {
                                hasAppeared = true
                            }
                        }
                        .onDisappear() {
                            withAnimation {
                                hasAppeared = false
                            }
                        }
                       // .ignoresSafeArea()
                }
                
                if hasAppeared {
                    VStack {
                        Spacer()
                        ZStack {
                            RoundedRectangle(cornerRadius: 16)
                                .foregroundColor(Color(backgroundColor))
                            
                            content()
                                .padding(.top, 16)
                                // .padding(actualContentInsets)
                        }
                        .frame(height: height(with: geometry))
                        // .roundedCorners(16, corners: [.topLeft, .topRight])
                        .offset(y: dragOffset)
                    }
                    .transition(.verticalSlide(height(with: geometry)))
//                    .highPriorityGesture(
//                        dragGesture(geometry)
//                    )
                    .onDisappear {
                        dragOffset = 0
                    }
                }
            }
        }
    }
    
    private func height(with geometry: GeometryProxy) -> CGFloat {
        geometry.size.height * 0.5
    }
}

extension HalfASheet {
    
    private func dragGesture(_ geometry: GeometryProxy) -> _EndedGesture<_ChangedGesture<DragGesture>> {
        
        let gesture = DragGesture()
            .onChanged {
                let offset = $0.translation.height
                dragOffset = offset > 0 ? offset : sqrt(-offset) * -3
            }
            .onEnded {
                if dragOffset > 0, $0.predictedEndTranslation.height / $0.translation.height > 2 {
                    dismiss()
                    return
                }
                
                let validDragDistance = height(with: geometry) / 2
                if dragOffset < validDragDistance {
                    withAnimation {
                        dragOffset = 0
                    }
                } else {
                    dismiss()
                }
            }
        
        return gesture
    }
    
    private func dismiss() {
        withAnimation {
            hasAppeared = false
            isPresented = false
        }
    }
}
