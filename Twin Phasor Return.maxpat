{
 "patcher": {
  "fileversion": 1,
  "appversion": {
   "major": 8,
   "minor": 6,
   "revision": 5,
   "architecture": "x64",
   "modernui": 1
  },
  "classnamespace": "box",
  "rect": [
   100.0,
   100.0,
   900.0,
   700.0
  ],
  "openrect": [
   0.0,
   0.0,
   200,
   169
  ],
  "bglocked": 0,
  "openinpresentation": 1,
  "default_fontface": 0,
  "default_fontname": "Ableton Sans Medium",
  "default_fontsize": 10.0,
  "gridonopen": 1,
  "gridsize": [
   8.0,
   8.0
  ],
  "gridsnaponopen": 1,
  "objectsnaponopen": 1,
  "statusbarvisible": 2,
  "toolbarvisible": 1,
  "lefttoolbarpinned": 0,
  "toptoolbarpinned": 0,
  "righttoolbarpinned": 0,
  "bottomtoolbarpinned": 0,
  "toolbars_unpinned_last_save": 0,
  "tallnewobj": 0,
  "boxanimatetime": 200,
  "enablehscroll": 1,
  "enablevscroll": 1,
  "devicewidth": 200,
  "description": "",
  "digest": "",
  "tags": "",
  "style": "",
  "subpatcher_template": "",
  "autosave": 0,
  "boxes": [
   {
    "box": {
     "id": "obj-1",
     "maxclass": "panel",
     "numinlets": 1,
     "numoutlets": 0,
     "patching_rect": [
      700,
      0,
      200,
      169
     ],
     "presentation": 1,
     "presentation_rect": [
      0,
      0,
      200,
      169
     ],
     "mode": 0,
     "bgcolor": [
      0.788,
      0.792,
      0.8,
      1.0
     ],
     "border": 0,
     "rounded": 0,
     "background": 1,
     "bgfillcolor": {
      "type": "color",
      "color": [
       0.788,
       0.792,
       0.8,
       1.0
      ]
     }
    }
   },
   {
    "box": {
     "id": "obj-2",
     "maxclass": "panel",
     "numinlets": 1,
     "numoutlets": 0,
     "patching_rect": [
      700,
      0,
      194,
      163
     ],
     "presentation": 1,
     "presentation_rect": [
      3,
      3,
      194,
      163
     ],
     "mode": 0,
     "bgcolor": [
      0.216,
      0.314,
      0.663,
      1.0
     ],
     "border": 0,
     "rounded": 4,
     "background": 1,
     "bgfillcolor": {
      "type": "gradient",
      "color1": [
       0.216,
       0.314,
       0.663,
       1.0
      ],
      "color2": [
       0.239,
       0.345,
       0.698,
       1.0
      ],
      "color": [
       0.216,
       0.314,
       0.663,
       1.0
      ],
      "angle": 0.0,
      "proportion": 0.5,
      "autogradient": 0
     }
    }
   },
   {
    "box": {
     "id": "obj-3",
     "maxclass": "panel",
     "numinlets": 1,
     "numoutlets": 0,
     "patching_rect": [
      700,
      0,
      184,
      155
     ],
     "presentation": 1,
     "presentation_rect": [
      8,
      7,
      184,
      155
     ],
     "mode": 0,
     "bgcolor": [
      0,
      0,
      0,
      0
     ],
     "border": 1.5,
     "rounded": 8,
     "background": 1,
     "bordercolor": [
      0.957,
      0.957,
      0.945,
      1.0
     ],
     "bgfillcolor": {
      "type": "color",
      "color": [
       0,
       0,
       0,
       0
      ]
     }
    }
   },
   {
    "box": {
     "id": "obj-4",
     "maxclass": "live.comment",
     "numinlets": 1,
     "numoutlets": 0,
     "fontname": "Ableton Sans Bold",
     "fontsize": 9.5,
     "textcolor": [
      0.957,
      0.957,
      0.945,
      1.0
     ],
     "text": "PHASOR RETURN",
     "textjustification": 1,
     "patching_rect": [
      700,
      400,
      176,
      14
     ],
     "presentation": 1,
     "presentation_rect": [
      12,
      9,
      176,
      14
     ]
    }
   },
   {
    "box": {
     "id": "obj-5",
     "maxclass": "newobj",
     "fontname": "Arial Bold",
     "fontsize": 10.0,
     "numinlets": 1,
     "numoutlets": 2,
     "patching_rect": [
      30,
      250,
      60,
      22
     ],
     "text": "plugin~",
     "outlettype": [
      "signal",
      "signal"
     ]
    }
   },
   {
    "box": {
     "id": "obj-6",
     "maxclass": "newobj",
     "fontname": "Arial Bold",
     "fontsize": 10.0,
     "numinlets": 2,
     "numoutlets": 0,
     "patching_rect": [
      30,
      450,
      60,
      22
     ],
     "text": "plugout~"
    }
   },
   {
    "box": {
     "id": "obj-7",
     "maxclass": "newobj",
     "fontname": "Arial Bold",
     "fontsize": 10.0,
     "numinlets": 1,
     "numoutlets": 1,
     "patching_rect": [
      150,
      250,
      120,
      22
     ],
     "text": "receive~ tpx_bus1_L",
     "outlettype": [
      "signal"
     ]
    }
   },
   {
    "box": {
     "id": "obj-8",
     "maxclass": "newobj",
     "fontname": "Arial Bold",
     "fontsize": 10.0,
     "numinlets": 1,
     "numoutlets": 1,
     "patching_rect": [
      290,
      250,
      120,
      22
     ],
     "text": "receive~ tpx_bus1_R",
     "outlettype": [
      "signal"
     ]
    }
   },
   {
    "box": {
     "id": "obj-9",
     "maxclass": "newobj",
     "fontname": "Arial Bold",
     "fontsize": 10.0,
     "numinlets": 2,
     "numoutlets": 1,
     "patching_rect": [
      150,
      300,
      40,
      22
     ],
     "text": "*~ 1.",
     "outlettype": [
      "signal"
     ]
    }
   },
   {
    "box": {
     "id": "obj-10",
     "maxclass": "newobj",
     "fontname": "Arial Bold",
     "fontsize": 10.0,
     "numinlets": 2,
     "numoutlets": 1,
     "patching_rect": [
      290,
      300,
      40,
      22
     ],
     "text": "*~ 1.",
     "outlettype": [
      "signal"
     ]
    }
   },
   {
    "box": {
     "id": "obj-11",
     "maxclass": "newobj",
     "fontname": "Arial Bold",
     "fontsize": 10.0,
     "numinlets": 2,
     "numoutlets": 1,
     "patching_rect": [
      30,
      300,
      40,
      22
     ],
     "text": "*~ 0.",
     "outlettype": [
      "signal"
     ]
    }
   },
   {
    "box": {
     "id": "obj-12",
     "maxclass": "newobj",
     "fontname": "Arial Bold",
     "fontsize": 10.0,
     "numinlets": 2,
     "numoutlets": 1,
     "patching_rect": [
      90,
      300,
      40,
      22
     ],
     "text": "*~ 0.",
     "outlettype": [
      "signal"
     ]
    }
   },
   {
    "box": {
     "id": "obj-13",
     "maxclass": "newobj",
     "fontname": "Arial Bold",
     "fontsize": 10.0,
     "numinlets": 2,
     "numoutlets": 1,
     "patching_rect": [
      30,
      400,
      40,
      22
     ],
     "text": "+~",
     "outlettype": [
      "signal"
     ]
    }
   },
   {
    "box": {
     "id": "obj-14",
     "maxclass": "newobj",
     "fontname": "Arial Bold",
     "fontsize": 10.0,
     "numinlets": 2,
     "numoutlets": 1,
     "patching_rect": [
      150,
      400,
      40,
      22
     ],
     "text": "+~",
     "outlettype": [
      "signal"
     ]
    }
   },
   {
    "box": {
     "id": "obj-15",
     "maxclass": "live.comment",
     "numinlets": 1,
     "numoutlets": 0,
     "fontname": "Ableton Sans Bold",
     "fontsize": 8.0,
     "textcolor": [
      0.957,
      0.957,
      0.945,
      1.0
     ],
     "text": "BUS",
     "textjustification": 0,
     "patching_rect": [
      700,
      400,
      60,
      12
     ],
     "presentation": 1,
     "presentation_rect": [
      14,
      26,
      60,
      12
     ]
    }
   },
   {
    "box": {
     "id": "obj-16",
     "maxclass": "live.menu",
     "varname": "Return Bus",
     "numinlets": 1,
     "numoutlets": 3,
     "outlettype": [
      "",
      "",
      "float"
     ],
     "parameter_enable": 1,
     "patching_rect": [
      700,
      700,
      70,
      15
     ],
     "presentation": 1,
     "presentation_rect": [
      50,
      24,
      70,
      15
     ],
     "saved_attribute_attributes": {
      "valueof": {
       "parameter_longname": "Return Bus",
       "parameter_shortname": "Bus",
       "parameter_type": 2,
       "parameter_enum": [
        "Bus 1",
        "Bus 2",
        "Bus 3",
        "Bus 4",
        "Bus 5",
        "Bus 6",
        "Bus 7",
        "Bus 8"
       ],
       "parameter_initial_enable": 1,
       "parameter_initial": [
        0
       ],
       "parameter_mmax": 7,
       "parameter_modmode": 0
      }
     },
     "bgcolor": [
      0.184,
      0.192,
      0.204,
      1.0
     ],
     "activebgcolor": [
      0.184,
      0.192,
      0.204,
      1.0
     ],
     "textcolor": [
      0.957,
      0.957,
      0.945,
      1.0
     ],
     "activetextcolor": [
      0.957,
      0.957,
      0.945,
      1.0
     ],
     "tricolor": [
      0.91,
      0.914,
      0.918,
      1.0
     ],
     "fontname": "Ableton Sans Bold",
     "fontsize": 8.5
    }
   },
   {
    "box": {
     "id": "obj-17",
     "maxclass": "live.dial",
     "varname": "Return Level",
     "numinlets": 1,
     "numoutlets": 2,
     "outlettype": [
      "",
      "float"
     ],
     "parameter_enable": 1,
     "patching_rect": [
      700,
      100,
      50,
      52
     ],
     "presentation": 1,
     "presentation_rect": [
      14,
      48,
      50,
      52
     ],
     "appearance": 0,
     "showname": 1,
     "shownumber": 1,
     "triangle": 1,
     "saved_attribute_attributes": {
      "valueof": {
       "parameter_longname": "Return Level",
       "parameter_shortname": "Level",
       "parameter_type": 0,
       "parameter_mmin": -70,
       "parameter_mmax": 12,
       "parameter_initial_enable": 1,
       "parameter_initial": [
        0
       ],
       "parameter_unitstyle": 4,
       "parameter_exponent": 1.0,
       "parameter_modmode": 0
      }
     },
     "activedialcolor": [
      0.957,
      0.957,
      0.945,
      1.0
     ],
     "activeneedlecolor": [
      0.957,
      0.957,
      0.945,
      1.0
     ],
     "focusbordercolor": [
      0.91,
      0.914,
      0.918,
      1.0
     ],
     "dialcolor": [
      0.082,
      0.086,
      0.094,
      1.0
     ],
     "needlecolor": [
      0.957,
      0.957,
      0.945,
      1.0
     ],
     "textcolor": [
      0.957,
      0.957,
      0.945,
      1.0
     ],
     "fontname": "Ableton Sans Bold",
     "fontsize": 9.0
    }
   },
   {
    "box": {
     "id": "obj-18",
     "maxclass": "live.text",
     "varname": "Track Thru",
     "numinlets": 1,
     "numoutlets": 2,
     "outlettype": [
      "",
      ""
     ],
     "parameter_enable": 1,
     "text": "TRACK INPUT OFF",
     "texton": "TRACK INPUT ON",
     "fontname": "Ableton Sans Bold",
     "fontsize": 8.0,
     "patching_rect": [
      700,
      1100,
      100,
      18
     ],
     "presentation": 1,
     "presentation_rect": [
      80,
      62,
      100,
      18
     ],
     "saved_attribute_attributes": {
      "valueof": {
       "parameter_longname": "Track Thru",
       "parameter_shortname": "Thru",
       "parameter_type": 2,
       "parameter_enum": [
        "TRACK INPUT OFF",
        "TRACK INPUT ON"
       ],
       "parameter_initial_enable": 1,
       "parameter_initial": [
        0
       ],
       "parameter_mmax": 1,
       "parameter_modmode": 0
      }
     },
     "bgcolor": [
      0.184,
      0.192,
      0.204,
      1.0
     ],
     "bgoncolor": [
      0.91,
      0.914,
      0.918,
      1.0
     ],
     "textcolor": [
      0.957,
      0.957,
      0.945,
      1.0
     ],
     "textoncolor": [
      0.184,
      0.192,
      0.204,
      1.0
     ],
     "rounded": 3.0,
     "activebgcolor": [
      0.184,
      0.192,
      0.204,
      1.0
     ],
     "activebgoncolor": [
      0.91,
      0.914,
      0.918,
      1.0
     ],
     "activetextcolor": [
      0.957,
      0.957,
      0.945,
      1.0
     ],
     "activetextoncolor": [
      0.184,
      0.192,
      0.204,
      1.0
     ]
    }
   },
   {
    "box": {
     "id": "obj-19",
     "maxclass": "live.comment",
     "numinlets": 1,
     "numoutlets": 0,
     "fontname": "Ableton Sans Bold",
     "fontsize": 7.5,
     "textcolor": [
      0.957,
      0.957,
      0.945,
      1.0
     ],
     "text": "LEGACY: send~ between devices is",
     "textjustification": 0,
     "patching_rect": [
      700,
      400,
      172,
      12
     ],
     "presentation": 1,
     "presentation_rect": [
      14,
      104,
      172,
      12
     ]
    }
   },
   {
    "box": {
     "id": "obj-20",
     "maxclass": "live.comment",
     "numinlets": 1,
     "numoutlets": 0,
     "fontname": "Ableton Sans Bold",
     "fontsize": 7.5,
     "textcolor": [
      0.957,
      0.957,
      0.945,
      1.0
     ],
     "text": "unsupported, latency varies.",
     "textjustification": 0,
     "patching_rect": [
      700,
      400,
      172,
      12
     ],
     "presentation": 1,
     "presentation_rect": [
      14,
      116,
      172,
      12
     ]
    }
   },
   {
    "box": {
     "id": "obj-21",
     "maxclass": "live.comment",
     "numinlets": 1,
     "numoutlets": 0,
     "fontname": "Ableton Sans Bold",
     "fontsize": 7.5,
     "textcolor": [
      0.957,
      0.957,
      0.945,
      1.0
     ],
     "text": "Prefer Audio From: Twin Phasor 3/4.",
     "textjustification": 0,
     "patching_rect": [
      700,
      400,
      172,
      12
     ],
     "presentation": 1,
     "presentation_rect": [
      14,
      128,
      172,
      12
     ]
    }
   },
   {
    "box": {
     "id": "obj-22",
     "maxclass": "newobj",
     "fontname": "Arial Bold",
     "fontsize": 10.0,
     "numinlets": 1,
     "numoutlets": 1,
     "patching_rect": [
      200,
      350,
      50,
      22
     ],
     "text": "dbtoa",
     "outlettype": [
      ""
     ]
    }
   },
   {
    "box": {
     "id": "obj-23",
     "maxclass": "newobj",
     "fontname": "Arial Bold",
     "fontsize": 10.0,
     "numinlets": 2,
     "numoutlets": 1,
     "patching_rect": [
      400,
      200,
      40,
      22
     ],
     "text": "+ 1",
     "outlettype": [
      "int"
     ]
    }
   },
   {
    "box": {
     "id": "obj-24",
     "maxclass": "newobj",
     "fontname": "Arial Bold",
     "fontsize": 10.0,
     "numinlets": 1,
     "numoutlets": 2,
     "patching_rect": [
      400,
      226,
      40,
      22
     ],
     "text": "t i i",
     "outlettype": [
      "int",
      "int"
     ]
    }
   },
   {
    "box": {
     "id": "obj-25",
     "maxclass": "newobj",
     "fontname": "Arial Bold",
     "fontsize": 10.0,
     "numinlets": 1,
     "numoutlets": 1,
     "patching_rect": [
      400,
      252,
      130,
      22
     ],
     "text": "sprintf tpx_bus%ld_L",
     "outlettype": [
      ""
     ]
    }
   },
   {
    "box": {
     "id": "obj-26",
     "maxclass": "newobj",
     "fontname": "Arial Bold",
     "fontsize": 10.0,
     "numinlets": 1,
     "numoutlets": 1,
     "patching_rect": [
      540,
      252,
      130,
      22
     ],
     "text": "sprintf tpx_bus%ld_R",
     "outlettype": [
      ""
     ]
    }
   },
   {
    "box": {
     "id": "obj-27",
     "maxclass": "newobj",
     "fontname": "Arial Bold",
     "fontsize": 10.0,
     "numinlets": 1,
     "numoutlets": 1,
     "patching_rect": [
      400,
      278,
      80,
      22
     ],
     "text": "prepend set",
     "outlettype": [
      ""
     ]
    }
   },
   {
    "box": {
     "id": "obj-28",
     "maxclass": "newobj",
     "fontname": "Arial Bold",
     "fontsize": 10.0,
     "numinlets": 1,
     "numoutlets": 1,
     "patching_rect": [
      540,
      278,
      80,
      22
     ],
     "text": "prepend set",
     "outlettype": [
      ""
     ]
    }
   }
  ],
  "lines": [
   {
    "patchline": {
     "source": [
      "obj-7",
      0
     ],
     "destination": [
      "obj-9",
      0
     ]
    }
   },
   {
    "patchline": {
     "source": [
      "obj-8",
      0
     ],
     "destination": [
      "obj-10",
      0
     ]
    }
   },
   {
    "patchline": {
     "source": [
      "obj-5",
      0
     ],
     "destination": [
      "obj-11",
      0
     ]
    }
   },
   {
    "patchline": {
     "source": [
      "obj-5",
      1
     ],
     "destination": [
      "obj-12",
      0
     ]
    }
   },
   {
    "patchline": {
     "source": [
      "obj-11",
      0
     ],
     "destination": [
      "obj-13",
      0
     ]
    }
   },
   {
    "patchline": {
     "source": [
      "obj-9",
      0
     ],
     "destination": [
      "obj-13",
      1
     ]
    }
   },
   {
    "patchline": {
     "source": [
      "obj-12",
      0
     ],
     "destination": [
      "obj-14",
      0
     ]
    }
   },
   {
    "patchline": {
     "source": [
      "obj-10",
      0
     ],
     "destination": [
      "obj-14",
      1
     ]
    }
   },
   {
    "patchline": {
     "source": [
      "obj-13",
      0
     ],
     "destination": [
      "obj-6",
      0
     ]
    }
   },
   {
    "patchline": {
     "source": [
      "obj-14",
      0
     ],
     "destination": [
      "obj-6",
      1
     ]
    }
   },
   {
    "patchline": {
     "source": [
      "obj-17",
      0
     ],
     "destination": [
      "obj-22",
      0
     ]
    }
   },
   {
    "patchline": {
     "source": [
      "obj-22",
      0
     ],
     "destination": [
      "obj-9",
      1
     ]
    }
   },
   {
    "patchline": {
     "source": [
      "obj-22",
      0
     ],
     "destination": [
      "obj-10",
      1
     ]
    }
   },
   {
    "patchline": {
     "source": [
      "obj-18",
      0
     ],
     "destination": [
      "obj-11",
      1
     ]
    }
   },
   {
    "patchline": {
     "source": [
      "obj-18",
      0
     ],
     "destination": [
      "obj-12",
      1
     ]
    }
   },
   {
    "patchline": {
     "source": [
      "obj-16",
      0
     ],
     "destination": [
      "obj-23",
      0
     ]
    }
   },
   {
    "patchline": {
     "source": [
      "obj-23",
      0
     ],
     "destination": [
      "obj-24",
      0
     ]
    }
   },
   {
    "patchline": {
     "source": [
      "obj-24",
      0
     ],
     "destination": [
      "obj-25",
      0
     ]
    }
   },
   {
    "patchline": {
     "source": [
      "obj-24",
      1
     ],
     "destination": [
      "obj-26",
      0
     ]
    }
   },
   {
    "patchline": {
     "source": [
      "obj-25",
      0
     ],
     "destination": [
      "obj-27",
      0
     ]
    }
   },
   {
    "patchline": {
     "source": [
      "obj-26",
      0
     ],
     "destination": [
      "obj-28",
      0
     ]
    }
   },
   {
    "patchline": {
     "source": [
      "obj-27",
      0
     ],
     "destination": [
      "obj-7",
      0
     ]
    }
   },
   {
    "patchline": {
     "source": [
      "obj-28",
      0
     ],
     "destination": [
      "obj-8",
      0
     ]
    }
   }
  ],
  "dependency_cache": [],
  "latency": 0,
  "project": {
   "version": 1,
   "creationdate": 1763078400,
   "modificationdate": 1763078400,
   "viewrect": [
    0.0,
    0.0,
    300.0,
    500.0
   ],
   "autoorganize": 1,
   "hideprojectwindow": 1,
   "showdependencies": 1,
   "autolocalize": 0,
   "contents": {
    "patchers": {}
   },
   "layout": {},
   "searchpath": {},
   "detailsvisible": 0,
   "amxdtype": 1633771873,
   "readonly": 0,
   "devpathtype": 0,
   "devpath": ".",
   "sortmode": 0,
   "viewmode": 0,
   "includepackages": 0
  },
  "parameters": {
   "obj-16": [
    "Return Bus",
    "Bus",
    0
   ],
   "obj-17": [
    "Return Level",
    "Level",
    0
   ],
   "obj-18": [
    "Track Thru",
    "Thru",
    0
   ],
   "parameterbanks": {
    "0": {
     "index": 0,
     "name": "Return",
     "parameters": [
      "Return Bus",
      "Return Level",
      "Track Thru",
      "-",
      "-",
      "-",
      "-",
      "-"
     ]
    }
   },
   "inherited_shortname": 1
  },
  "assistshowspatchername": 0,
  "is_mpe": 0,
  "external_mpe_tuning_enabled": 0,
  "minimum_live_version": "",
  "minimum_max_version": "",
  "platform_compatibility": 0,
  "openrectmode": 0
 }
}