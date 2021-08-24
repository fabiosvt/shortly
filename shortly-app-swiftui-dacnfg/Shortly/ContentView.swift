//
//  ContentView.swift
//  URL shortening
//
//  Created by Fabio Silvestri on 20/08/21.
//

import SwiftUI

struct ContentView: View {
    @State var text = ""
    @State private var didTap:Bool = false
    @StateObject var viewModel = ViewModel()

    var body: some View {
        ScrollView(.vertical) {
            Image(uiImage: UIImage(named: "logo")!)
                .padding()
            Image(uiImage: UIImage(named: "illustration")!)
                .padding()
            Text("Let´s get started!")
                .font(.custom("Poppins-Bold", size: 17))
            Text("Paste your first link into")
                .font(.custom("Poppins-Medium", size: 17))
            Text("the field to shorten it")
                .font(.custom("Poppins-Medium", size: 17))
            if viewModel.isLoading {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .red))
                    .scaleEffect(3)
            }
            urlContainer()
            urlHistory()
        }
        .background(StyleGuide.BackgroundColors.offWhite)
    }
    
    @ViewBuilder
    func urlContainer() -> some View {
        VStack{
            TextField("Shorten a link here ...", text: $text)
                .padding()
                .autocapitalization(.none)
                .background(Color.white)
                .cornerRadius(8)
                .padding()
            
            Button(action: {
                guard !text.isEmpty else {
                    self.text = "Please add a link here"
                    return
                }
                viewModel.submit(urlString: text)
                text = ""
            }, label: {
                Text("SHORTEN IT!")
                    .padding()
                    .font(.custom("Poppins-Bold", size: 17))
                    .foregroundColor(Color.white)
                    .frame(maxWidth: .infinity)
                    .background(StyleGuide.FontColors.Primary.cyan)
                    .cornerRadius(8)
                    .padding()
            })
            Spacer()
        }
        .background(
            HStack {
                Spacer()
                Image("shape")
            })
        .background(StyleGuide.FontColors.Primary.violet)
        .padding()
    }
    
    @ViewBuilder
    func urlHistory() -> some View {
        VStack {
            Text("Your Link History")
                .font(.custom("Poppins-Medium", size: 17))
                .foregroundColor(StyleGuide.FontColors.Neutral.veryDark)
                .padding()
            ForEach(viewModel.models, id: \.self) { post in
                VStack(alignment: .leading) {
                    HStack(spacing: 10) {
                        VStack(alignment: .leading, spacing: 3) {
                            HStack (alignment: .center, spacing: 0, content: {
                                Spacer()
                                Text(post.long)
                                    .font(.custom("Poppins-Medium", size: 17))
                                    .foregroundColor(StyleGuide.FontColors.Neutral.veryDark)
                                    .lineLimit(1)
                                Button(action: {
                                    guard !post.long.isEmpty else {
                                        return
                                    }
                                    guard let index = self.viewModel.models.firstIndex(of: post) else { return }
                                    RunLoop.main.perform {
                                        self.viewModel.models.remove(at:index)
                                        let encoder = JSONEncoder()
                                        if let encoded = try? encoder.encode(viewModel.models) {
                                            let defaults = UserDefaults.standard
                                            defaults.set(encoded, forKey: "SavedLinks")
                                            defaults.synchronize()
                                        }
                                    }
                                }, label: {
                                    Image(uiImage: UIImage(named: "del")!)
                                        .padding()
                                })
                                .padding()
                            })
                            .background(StyleGuide.BackgroundColors.white)
                            .cornerRadius(8)
                            VStack(alignment: .leading) {
                                HStack(spacing: 10) {
                                    Text(post.short)
                                        .font(.custom("Poppins-Medium", size: 17))
                                        .foregroundColor(StyleGuide.FontColors.Primary.cyan)
                                        .padding()
                                    Spacer()
                                }
                                HStack(spacing: 10) {
                                    Spacer()
                                    Button(action: {
                                        guard !post.short.isEmpty else {
                                            return
                                        }
                                        self.didTap = true
                                        UIPasteboard.general.string = post.short
                                    }, label: {
                                        Text(didTap ? "COPIED!" : "COPY")
                                            .bold()
                                            .padding()
                                            .foregroundColor(Color.white)
                                            .frame(maxWidth: .infinity)
                                            .background(didTap ? StyleGuide.FontColors.Primary.violet : StyleGuide.FontColors.Primary.cyan)
                                            .cornerRadius(8)
                                            .padding()
                                    })
                                    .padding()
                                    Spacer()
                                }
                            }
                            .background(StyleGuide.BackgroundColors.white)
                            .cornerRadius(8)
                        }
                        .padding()
                        .onTapGesture {
                            guard let url = URL(string: post.long) else {
                                return
                            }
                            UIApplication.shared.open(url, options: [:], completionHandler: nil)
                        }
                    }
                }
            }.onDelete(perform: self.deleteItem)
        }
        .background(StyleGuide.BackgroundColors.offWhite)
    }
    
    private func deleteItem(at indexSet: IndexSet) {
        self.viewModel.models.remove(atOffsets: indexSet)
     }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
