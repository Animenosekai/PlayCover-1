//
//  StoreGenshinAccountView.swift
//  PlayCover
//
//  Created by José Elias Moreno villegas on 21/07/22.
//
import SwiftUI
import AlertToast

struct StoreGenshinAccountView: View {
    @Environment(\.presentationMode) var presentationMode
    @State var folderName: String = ""
    @State var selectedRegion: String = ""
    @State var regionIsNotValid: Bool = false
    var body: some View {
        VStack(alignment: .center, spacing: 16) {
            Spacer()
            Text("storeAccount.storeAcc").font(.largeTitle).lineLimit(1).fixedSize()
            Spacer()
            HStack(spacing: 0) {
                Picker(selection: $selectedRegion,
                       label: Text("storeAccount.selectAccRegion")
                    .font(.headline).lineLimit(1).fixedSize(),
                       content: {
                            Text("storeAccount.selectAccRegion.usa").tag("America")
                            Text("storeAccount.selectAccRegion.euro").tag("Europe")
                }).pickerStyle(.radioGroup)
                Spacer()
            }
            HStack {
                Text("storeAccount.nameOfAcc")
                    .font(.headline).lineLimit(1).fixedSize()
                TextField(NSLocalizedString(
                    "storeAccount.nameOfAcc.textfieldPlaceholder", comment: ""
                ), text: $folderName)
            }
            Spacer()
            Button(action: {
                if !folderName.isEmpty && !selectedRegion.isEmpty {
                    do {
                        if try checkCurrentRegion(selectedRegion: selectedRegion) {
                            regionIsNotValid = false
                            if selectedRegion == "America" {
                                storeUserData(folderName: $folderName.wrappedValue.lowercased(),
                                              accountRegion: "os_usa")
                            } else {
                                storeUserData(folderName: $folderName.wrappedValue.lowercased(),
                                              accountRegion: "os_euro")
                            }
                            presentationMode.wrappedValue.dismiss()
                        } else {
                            regionIsNotValid = true
                        }
                    } catch {
                        Log.shared.error("An error occoured while trying to store your account: "
                                         + error.localizedDescription)
                    }
                } else { presentationMode.wrappedValue.dismiss() }
            }, label: {
                Text("storeAccount.store").frame(minWidth: 300, alignment: .center)
            }).controlSize(.large).buttonStyle(.automatic).font(.title3)
                .keyboardShortcut(.defaultAction)
                .disabled(selectedRegion == "" || folderName == "")

            Button(action: {
                presentationMode.wrappedValue.dismiss()
            }, label: {
                Text("Exit").frame(alignment: .center)
            })
            .keyboardShortcut(.cancelAction)
        }.padding()
                .alert(NSLocalizedString("alert.storeAccount.regionIsNotValid",
                                         comment: ""), isPresented: $regionIsNotValid) {
                    Button("button.Close",
                           role: .cancel) {
                        regionIsNotValid.toggle()
                        presentationMode.wrappedValue.dismiss()
                    }
                }
        }
    }

struct GenshinView_preview: PreviewProvider {
    static var previews: some View {
        StoreGenshinAccountView()
    }
}
