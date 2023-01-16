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
                            switch overview.categroy {
                            case .Cash:
                                Image(systemName: "dollarsign.circle")
                                  
                            case .Bond:
                                Image(systemName: "b.circle")
                                   
                            case .Debt:
                                Image(systemName: "creditcard")
                                    
                            case .Estate:
                                Image(systemName: "house")
                               
                            case .Fund:
                                Image(systemName: "dial.high")
                                  
                            case .Futures:
                                Image(systemName:  "carrot")
                                
                            case .Option:
                                Image(systemName: "envelope")
                            case .Stock:
                                Image(systemName:  "waveform.path.ecg.rectangle")
                            case .Savings:
                                Image(systemName:  "banknote")
                                
                                
                            default:
                                Image(systemName: "dollarsign.circle")
                            }
                                
                            Text(overview.name)
                                
                            Spacer()
                            Text(overview.categroy.rawValue)
                                
                        }.foregroundColor(.black)
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
