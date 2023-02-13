//
//  DiceView.swift
//  RollDice
//
//  Created by Azoz Salah on 16/01/2023.
//

import SwiftUI

struct DiceView: View {
    let number: Int
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 25, style: .continuous)
                .strokeBorder(.black, lineWidth: 3)
                .frame(width: 100, height: 100)
                .background(RoundedRectangle(cornerRadius: 25, style: .continuous).fill(.white))
            VStack {
                Text("\(number)")
                    .font(.largeTitle.bold())
            }
            .frame(width: 80, height: 80, alignment: .center)
            
        }
    }
}

struct DiceView_Previews: PreviewProvider {
    static var previews: some View {
        DiceView(number: 1)
    }
}




//switch number {
//case 1:
//    HStack {
//        Spacer()
//        Circle().frame(width: 20)
//            .offset(y: 30)
//        Spacer()
//    }
//case 2:
//    Circle().frame(width: 20)
//    Spacer()
//    Circle().frame(width: 20)
//        .offset(x: -60)
//case 3:
//    Circle().frame(width: 20)
//    Circle().frame(width: 20)
//        .offset(x: -30)
//    Circle().frame(width: 20)
//        .offset(x: -60)
//case 4:
//    HStack {
//        Circle().frame(width: 20)
//            .offset(x: 30)
//        Circle().frame(width: 20)
//            .offset(x: -60)
//    }
//    Spacer()
//    HStack {
//        Circle().frame(width: 20)
//            .offset(x: 30)
//        Circle().frame(width: 20)
//            .offset(x: -60)
//    }
//case 5:
//    HStack {
//        Circle().frame(width: 20)
//            .offset(x: 30)
//        Circle().frame(width: 20)
//            .offset(x: -60)
//    }
//    HStack {
//        Circle().frame(width: 20)
//            .offset(x: -15)
//    }
//    HStack {
//        Circle().frame(width: 20)
//            .offset(x: 30)
//        Circle().frame(width: 20)
//            .offset(x: -60)
//    }
//case 6:
//    HStack {
//        Circle().frame(width: 20)
//            .offset(x: 30)
//        Circle().frame(width: 20)
//            .offset(x: -60)
//    }
//    HStack {
//        Circle().frame(width: 20)
//            .offset(x: 30)
//        Circle().frame(width: 20)
//            .offset(x: -60)
//    }
//    HStack {
//        Circle().frame(width: 20)
//            .offset(x: 30)
//        Circle().frame(width: 20)
//            .offset(x: -60)
//    }
//default:
//    HStack {
//        Spacer()
//        Circle().frame(width: 20)
//            .offset(y: 30)
//        Spacer()
//    }
//}
