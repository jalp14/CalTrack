//
//  SearchView.swift
//  CalTrack
//
//  Created by Dev on 08/12/2019.
//  Copyright © 2019 jdc0rp. All rights reserved.
//

import SwiftUI

//**************** Displays a list with search bar ****************\\
struct SearchView: View {
    @EnvironmentObject var session: SessionStore
    var body: some View {
        ListView().environmentObject(self.session)
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
