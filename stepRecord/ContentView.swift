import SwiftUI

struct ContentView: View {
    
    @ObservedObject var contentVM: ContentViewModel
    let dateformatter = DateFormatter()
    init(){
        
        contentVM = ContentViewModel()

        dateformatter.timeZone = TimeZone(identifier: "Asia/Tokyo")
        dateformatter.locale = Locale(identifier: "ja_JP")
        dateformatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
        
        // 歩数データを取得する関数を呼ぶ（引数は期間）
        contentVM.get(
            fromDate: dateformatter.date(from: "2020/12/01 00:00:00")!,
            toDate: dateformatter.date(from: "2021/01/01 23:59:59")!
        )
    }
    
    var body: some View {
        NavigationView {
            List {
                if contentVM.dataSource.count == 0 {
                    Text("データがありません。")
                } else {
                    ForEach( contentVM.dataSource ){ item in
                        HStack{
                            Text(dateformatter.string(from: item.datetime))
                            Text(" \(item.count)")
                        }
                    }
                }
            }.navigationBarTitle(Text("歩数一覧"), displayMode: .inline)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
