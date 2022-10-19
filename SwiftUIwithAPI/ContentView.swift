//
//  ContentView.swift
//  SwiftUIwithAPI
//
//  Created by Patiphan Manawanich on 20/10/2565 BE.
//

import SwiftUI

struct Course: Hashable,Codable {
    let province: String
    let total_case: Int
    let total_death: Int
    let year:Int
}

struct Course2: Hashable,Codable {
    
    let total_case: Int
    let total_death: Int
    let year:Int
}



class ViewModel: ObservableObject{
    @Published var allData: [Course2] = []
    @Published var provinceData: [Course] = []
    
    func fetchAll(){
        
        guard let url = URL(string: "https://covid19.ddc.moph.go.th/api/Cases/today-cases-all") else{
            return
        }
        let task = URLSession.shared.dataTask(with: url){[weak self]
            data,_,error in
            guard let data = data,error == nil else{
                return
            }
            
            // convert to JSON
            do{
                let course = try JSONDecoder().decode([Course2].self, from: data)
                DispatchQueue.main.async {
                    self?.allData = course
                }
            }
            catch{
                
            }
        }
        
        task.resume()
    }
    
    func fetchProvince(){
        guard let url = URL(string: "https://covid19.ddc.moph.go.th/api/Cases/today-cases-by-provinces") else{
            return
        }
        let task = URLSession.shared.dataTask(with: url){[weak self]
            data,_,error in
            guard let data = data,error == nil else{
                return
            }
            
            // convert to JSON
            do{
                let course = try JSONDecoder().decode([Course].self, from: data)
                DispatchQueue.main.async {
                    self?.provinceData = course
                }
            }
            catch{
                
            }
        }
        
        task.resume()
    }
    
    func clear(){
        self.allData = []
        self.provinceData = []
    }
}

struct ContentView: View {
    @StateObject var viewModel = ViewModel()
    
    func firstCharacterUppercaseString(string: String) -> String {
        let str = string as NSString
        let firstUppercaseCharacter = str.substring(to: 1).uppercased()
        let firstUppercaseCharacterString = str.replacingCharacters(in: NSMakeRange(0, 1), with: firstUppercaseCharacter)
        return firstUppercaseCharacterString.replacingOccurrences(of:"_",with:" ")
    }
    
    var body: some View {
        VStack {
            NavigationView{
                List{
                    if(!viewModel.provinceData.isEmpty){
                        ForEach(viewModel.provinceData,id:\.self){
                            course in VStack {
                                
                                HStack{
                                    Text(self.firstCharacterUppercaseString(string:"province : "))
                                        .bold()
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                    Text(course.province)
                                }
                                .padding()
                                
                                HStack{
                                    Text(self.firstCharacterUppercaseString(string:"total_case : "))
                                        .bold()
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                    Text(String(course.total_case))
                                }
                                .padding()
                                
                                HStack{
                                    Text(self.firstCharacterUppercaseString(string:"total_death : "))
                                        .bold()
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                    Text(String(course.total_death))
                                }
                                .padding()
                            }
                        }
                        
                    }else if(!viewModel.allData.isEmpty){
                        ForEach(viewModel.allData,id:\.self){
                            course in VStack {
                                                            
                                HStack{
                                    Text(self.firstCharacterUppercaseString(string:"total_case : "))
                                        .bold()
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                    Text(String(course.total_case))
                                }
                                .padding()
                                
                                HStack{
                                    Text(self.firstCharacterUppercaseString(string:"total_death : "))
                                        .bold()
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                    Text(String(course.total_death))
                                }
                                .padding()
                            }
                        }
                    }
                    else{
                        VStack{
                            Button("Fetch All Data") {
                                viewModel.fetchAll()
                            }
                            .padding()
                        }
                        VStack{
                            Button("Fetch Province Data") {
                                viewModel.fetchProvince()
                            }
                            .padding()
                        }
                    }
                }
                .navigationTitle("Covid 19 Data")
                //            .onAppear{
                //                viewModel.fetch()
                //            }
            }
            
            
            
            
            HStack{
                Button("Back") {
                    viewModel.clear()
                }
                .padding()
            }
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
