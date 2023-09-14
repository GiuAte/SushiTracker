//
//  ListInsideScontrino.swift
//  SushiTracker
//
//  Created by Giulio Aterno on 13/09/23.
//

import SwiftUI

struct ListInsideScontrino: View {
    var body: some View {
        VStack {
            ScrollView {
                VStack(alignment: .leading) {
                    HStack {
                        Text("Sashimi")
                        Divider()
                        Text("A60")
                            .bold()
                        Spacer()
                        Text("Porzioni:")
                        Text("7")
                    }
                    
                    HStack {
                        Text("Gunkan con roll di sashimi e salsa rosa e patatine fritte con ketchup")
                            .truncationMode(.tail)
                            .minimumScaleFactor(0.3)
                            .lineLimit(3)
                        Divider()
                        Text("A720")
                            .bold()
                        Spacer()
                        Text("Porzioni:")
                        Text("3")
                       
                    }
                    
                }
                .padding(.horizontal)
                Spacer()
            }
        }
                .padding()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.white)
            }
}


struct ListInsideScontrino_Previews: PreviewProvider {
    static var previews: some View {
        ListInsideScontrino()
    }
}
