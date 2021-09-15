import SwiftUI
import Combine
import HealthKit

class ContentViewModel: ObservableObject, Identifiable {

    @Published var dataSource:[ListRowItem] = []
    
    func get( fromDate: Date, toDate: Date)  {

        let healthStore = HKHealthStore()
        let readTypes = Set([
            HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount )!
        ])
        
        healthStore.requestAuthorization(toShare: readTypes, read: readTypes, completion: { success, error in
            
            if success == false {
                print("データにアクセスできません")
                return
            }
            
            // 歩数を取得
            let query = HKSampleQuery(sampleType: HKSampleType.quantityType(forIdentifier: .stepCount)!,
                                      predicate: HKQuery.predicateForSamples(withStart: fromDate, end: toDate, options: []),
//                                           predicate: nil,
                                           limit: HKObjectQueryNoLimit,
                                           sortDescriptors: [NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: true)]){ (query, results, error) in

                guard error == nil else { print("error"); return }
                print(query,results)
                if let tmpResults = results as? [HKQuantitySample] {

                    // 取得したデータを１件ずつ ListRowItem 構造体に格納
                    // ListRowItemは、dataSource配列に追加します。ViewのListでは、この dataSource配列を参照して歩数を表示します。
                    for item in tmpResults {
                        print("aa")

                        let listItem = ListRowItem(
                            id: item.uuid.uuidString,
                            datetime: item.endDate,
                            count: String(item.quantity.doubleValue(for: .count()))
                        )

                        self.dataSource.append(listItem)
                    }
                }
            }
            healthStore.execute(query)
        })
    }
}
