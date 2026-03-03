//
//  SearchableDemoView.swift
//  swiftUILearn
//
//  【知识点】Searchable 搜索栏
//  场景：在书单中按书名/作者搜索
//

import SwiftUI

struct SearchableDemoView: View {
    // @State 存储搜索关键词
    @State private var searchText = ""
    @State private var searchScope: SearchScope = .all

    let books = LibraryBook.sampleData

    // 根据关键词和范围过滤书籍
    var filteredBooks: [LibraryBook] {
        if searchText.isEmpty { return books }
        return books.filter { book in
            switch searchScope {
            case .all:
                return book.title.localizedCaseInsensitiveContains(searchText)
                    || book.author.localizedCaseInsensitiveContains(searchText)
            case .title:
                return book.title.localizedCaseInsensitiveContains(searchText)
            case .author:
                return book.author.localizedCaseInsensitiveContains(searchText)
            }
        }
    }

    var body: some View {
        // .searchable 需要放在 NavigationStack 内才能显示搜索栏
        List {
            if filteredBooks.isEmpty {
                ContentUnavailableView.search(text: searchText)
            } else {
                ForEach(filteredBooks) { book in
                    BookListRow(book: book)
                }
            }
        }
        .listStyle(.insetGrouped)
        // .searchable：为列表添加搜索栏
        // text：绑定搜索关键词
        // placement：搜索栏位置（.navigationBarDrawer 在导航栏下方）
        // prompt：占位提示文字
        .searchable(text: $searchText,
                    placement: .navigationBarDrawer(displayMode: .always),
                    prompt: "搜索书名或作者")
        // .searchScopes：添加搜索范围选择器（Scope 选项卡）
        .searchScopes($searchScope) {
            Text("全部").tag(SearchScope.all)
            Text("书名").tag(SearchScope.title)
            Text("作者").tag(SearchScope.author)
        }
        .navigationTitle("搜索书籍")
        .navigationBarTitleDisplayMode(.inline)
        .overlay {
            if searchText.isEmpty {
                VStack(spacing: 8) {
                    Image(systemName: "magnifyingglass")
                        .font(.largeTitle)
                        .foregroundStyle(.secondary)
                    Text("在上方输入书名或作者搜索")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }
            }
        }
    }

    // 搜索范围枚举
    enum SearchScope: String, CaseIterable {
        case all = "全部"
        case title = "书名"
        case author = "作者"
    }
}

#Preview {
    NavigationStack {
        SearchableDemoView()
    }
}
