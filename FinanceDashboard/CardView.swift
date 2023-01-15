/*
See LICENSE folder for this sample’s licensing information.
*/

import SwiftUI

struct CardView: View {
    let item: Overviews
    
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
                    HStack {
                        Image(systemName: "dollarsign.circle")
                        Text(overview.name)
                        Spacer()
                        Text(overview.categroy.rawValue)
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
