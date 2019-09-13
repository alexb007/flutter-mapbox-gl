// This file is generated.

// Copyright 2018 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

package com.mapbox.mapboxgl;

import com.mapbox.geojson.Point;
import com.mapbox.mapboxsdk.geometry.LatLng;
import com.mapbox.mapboxsdk.plugins.annotation.Symbol;
import com.mapbox.mapboxsdk.plugins.annotation.SymbolManager;
import com.mapbox.mapboxsdk.plugins.annotation.SymbolOptions;

import java.util.ArrayList;
import java.util.List;


class MultiSymbolBuilder {
    private final SymbolManager symbolManager;
    private final List<SymbolOptions> symbolsOptions;

    MultiSymbolBuilder(SymbolManager symbolManager) {
        this.symbolManager = symbolManager;
        this.symbolsOptions = new ArrayList<SymbolOptions>();
    }

    List<Symbol> build() {
        return symbolManager.create(symbolsOptions);
    }

    public void setSymbols(List<Object> symbols) {
        for (Object o : symbols) {
            SymbolOptionsConverter soc = new SymbolOptionsConverter();
            Convert.interpretSymbolOptions(o, soc);
            symbolsOptions.add(soc.getSymbolOptions());
        }
    }
}

