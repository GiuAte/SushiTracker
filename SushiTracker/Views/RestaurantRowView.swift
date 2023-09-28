//
//  RestaurantRowView.swift
//  SushiTracker
//
//  Created by Giulio Aterno on 07/09/23.
//

import SwiftUI

struct RestaurantRowView: View {
    
    var restaurant: RestaurantItem
    
    var body: some View {
        
        HStack {
            Image(systemName: "mappin.circle.fill")
                .foregroundColor(.red)
                .font(.system(size: 32))
            
            
            VStack(alignment: .leading) {
                Text(restaurant.name!)
                    .font(.headline)
                
                Text(restaurant.address!)
                    .font(.subheadline)
                    .italic()
                    .foregroundColor(.gray)
                    .minimumScaleFactor(0.3)
                    .lineLimit(1)
            }
            
            Spacer()
            
            Text("\(restaurant.rating)/5")
                .font(.subheadline)
                .bold()
                .foregroundColor(.black)
            
            Image(systemName: "star.fill")
                .foregroundColor(.yellow)
                .font(.system(size: 20))
        }
    }
}
