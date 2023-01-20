/*
See LICENSE folder for this sample’s licensing information.
*/

import SwiftUI
import CoreData

struct CardView: View {
//    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.managedObjectContext) private var viewContext
    
    let item: Overviews
    @State var selected: Overview?
    @State var trend: String?
    
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
                        Group{
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
                            Text("\(doubleFormat(value:overview.value))")
                            Text("\(overview.unit.rawValue)")
                                .padding(.trailing)
                        }
                        .foregroundColor(.black)
                        .onTapGesture {
                            print("click \(overview.name)")
                            self.selected = overview
                        }
                        Spacer()
                        TrendChart(data: trendByName(name: overview.name))
                            .onTapGesture {
                                trend = overview.name
                            }.frame(maxWidth: 150)
                    }
                    .sheet(item: $selected) {
                        overview in
                        EditItem(overview: overview, currency: Model.shared.unit) {
                            selected = nil
                        }
                    }
                    .sheet(item: $trend){
                        name in
                        TrendView(name: name, viewContext: viewContext, viewModel: TrendViewModel())
                    }
                    .padding(.top)
                }
                
                
            }
            .padding()
            
            
        }
    }
    
    func trendByName(name: String) -> [Double] {
//        print(viewContext)
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Item")
        request.predicate = NSPredicate(format: "name == %@", name)
        let items = try! viewContext.fetch(request) as! Array<Item>
        return items.map{$0.value}
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
