//
//  ContentView.swift
//  NavigationTesting
//
//  Created by Ryan on 11/3/24.
//

import SwiftUI
import UIKit

struct ContentView: View {
    var body: some View {
        VStack {
            TabViews()
        }
    }
}


struct TabViews: View {
    @StateObject private var router = Router.shared
    var body : some View {
        TabView{
            TestViewOne()
                .tabItem{
                    Label("Test 1", systemImage: "tray.and.arrow.down.fill")
                }.environmentObject(router)
            TestViewTwo()
                .tabItem{
                    Label("Test 2", systemImage: "tray.and.arrow.up.fill")
                }.environmentObject(router)
        }
        //.environmentObject(router)
    }
}

struct TestViewOne : View {
    @EnvironmentObject var router : Router
    var body: some View {
        NavigationStack(path: $router.pathHome){
            Button("Test View One"){
                router.pathHome.append(Router.tester2.three)
            }.navigationDestination(for: Router.tester2.self){ destination in
                switch destination {
                case .three:
                    TestViewThree().environmentObject(router)
                case .four(let viemodel2):
                    //case .four(let viewModel2):
                    TestViewFour(viewModel: viemodel2).environmentObject(router)
                }
            }
        }
        .environmentObject(router)
    }
}

struct TestViewTwo : View {
    @EnvironmentObject var router : Router
    var body: some View {
        NavigationStack(path: $router.pathSearch){
            Button("Test View Two"){
                router.pathSearch.append(Router.tester.one)
            }.navigationDestination(for: Router.tester.self){ destination2 in
                switch destination2 {
                case .one:
                    TestViewFive().environmentObject(router)
                case .two(let viewModel):
                    TestViewFour(viewModel: viewModel).environmentObject(router)
                }
            }
        }
        .environmentObject(router)
    }
}

struct TestViewThree : View {
    @EnvironmentObject var router : Router
    @StateObject var viewModel = TestViewFourViewModel()
    var body: some View {
        Button("Test View Three"){
            router.pathHome.append(Router.tester2.four(viewModel))
        }.environmentObject(router)
    }
}
struct TestViewFive : View {
    @EnvironmentObject var router : Router
    @StateObject var viewModel = TestViewFourViewModel()
    var body: some View {
        Button("Test View Five"){
            router.pathSearch.append(Router.tester.two(viewModel))
        }.environmentObject(router)
    }
}

struct TestViewFour : View {
    @EnvironmentObject var router : Router
    @ObservedObject var viewModel = TestViewFourViewModel()
    var body: some View {
        Text("Testing")
        Button("Pop to root and move back one"){
            router.pathHome = NavigationPath()
            router.pathSearch.removeLast()
        }
    }
}

//struct TestViewFour : View {
//    //@State var viewModel : TestViewFourViewModel
//    @EnvironmentObject var router : Router
//    var body: some View {
//        Text("Testing")
//    }
//}

class TestViewFourViewModel : ObservableObject {
    
    func testing(){
        
    }
}

class Router: ObservableObject, Hashable {
    static func == (lhs: Router, rhs: Router) -> Bool {
        return lhs.pathHome == lhs.pathHome && lhs.pathSearch == lhs.pathSearch
    }
    func hash(into hasher2: inout Hasher) {
        hasher2.combine(self)
    }
    
    static var shared = Router()
    @Published var pathHome = NavigationPath()
    @Published var pathSearch = NavigationPath()
    
    enum tester : Hashable{
        case one
        case two(TestViewFourViewModel)
        static func == (lhs: Router.tester, rhs: Router.tester) -> Bool {
            return Router.tester.self == Router.tester.self
        }
        
        func hash(into hasher: inout Hasher) {
            hasher.combine(tester.one)
           // hasher.combine(tester.two(TestViewFourViewModel()))
        }
        
        func navigateTo(_ appRoute: Router) {
            Router.shared.pathHome.append(appRoute)
        }
        
    }
    
    enum tester2 : Hashable{
        case three
        case four(TestViewFourViewModel)
        
        static func == (lhs: Router.tester2, rhs: Router.tester2) -> Bool {
            return Router.tester2.self == Router.tester2.self
        }
        
        func hash(into hasher2: inout Hasher) {
            hasher2.combine(tester2.three)
            //hasher2.combine(tester2.four(TestViewFourViewModel()))
        }
        
        func navigateTo(_ appRoute: Router) {
            Router.shared.pathSearch.append(appRoute)
        }
    }
}

