/*
See LICENSE folder for this sample’s licensing information.
*/

import SwiftUI

struct CardView: View {
//    @Environment(\.colorScheme) private var colorScheme
    
    let item: Overviews
    @State var selected: Overview?
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 25, style: .continuous)
                .fill(.white)
                .shadow(radius: 10)
            VStack(alignment: .leading) {
                Text(item.key)
                    .font(.caption)
                    .foregroundColor(.gray)
                Spacer()
                ForEach(item.overviews) {
                    overview in
                    ZStack {
                        Rectangle().fill(.white)
                        HStack {
                            Image(systemName: "dollarsign.circle")
                                .foregroundColor(.black)
                            Text(overview.name)
                                .foregroundColor(.black)
                            Spacer()
                            Text(overview.categroy.rawValue)
                                .foregroundColor(.black)
                        }
                    }
                    .sheet(item: $selected) {
                        overview in
                        EditItem(overview: overview) {
                            selected = nil
                        }
                    }
                    .onTapGesture {
                        print("click \(overview.name)")
                        self.selected = overview
                    }
                    .padding(.top)
                }
                
                
            }
            .padding()
            
            
        }
    }
}

//struct CardView_Previews: PreviewProvider {
////    static var scrum = DailyScrum.sampleData[0]
//    static var previews: some View {
//        CardView(scrum: scrum)
////            .background(scrum.theme.mainColor)
//            .previewLayout(.fixed(width: 400, height: 60))
//    }
//}
