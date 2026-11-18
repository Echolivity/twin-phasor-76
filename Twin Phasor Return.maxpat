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
      0.106,
      0.11,
      0.122,
      1.0
     ],
     "border": 0,
     "rounded": 0,
     "background": 1,
     "bgfillcolor": {
      "type": "color",
      "color": [
       0.106,
       0.11,
       0.122,
       1.0
      ]
     }
    }
   },
   {
    "box": {
     "id": "obj-2",
     "maxclass": "live.comment",
     "numinlets": 1,
     "numoutlets": 0,
     "fontname": "Ableton Sans Bold",
     "fontsize": 11,
     "textcolor": [
      0.922,
      0.922,
      0.91,
      1.0
     ],
     "text": "TWIN PHASOR RETURN",
     "textjustification": 0,
     "patching_rect": [
      700,
      400,
      180,
      13
     ],
     "presentation": 1,
     "presentation_rect": [
      10,
      4,
      180,
      13
     ],
     "background": 1
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
      141
     ],
     "presentation": 1,
     "presentation_rect": [
      8,
      24,
      184,
      141
     ],
     "mode": 0,
     "bgcolor": [
      0.137,
      0.145,
      0.161,
      1.0
     ],
     "border": 1,
     "rounded": 6,
     "background": 1,
     "bordercolor": [
      0.18,
      0.192,
      0.212,
      1.0
     ],
     "bgfillcolor": {
      "type": "color",
      "color": [
       0.137,
       0.145,
       0.161,
       1.0
      ]
     }
    }
   },
   {
    "box": {
     "id": "obj-4",
     "maxclass": "panel",
     "numinlets": 1,
     "numoutlets": 0,
     "patching_rect": [
      700,
      0,
      3,
      11
     ],
     "presentation": 1,
     "presentation_rect": [
      16,
      31,
      3,
      11
     ],
     "mode": 0,
     "bgcolor": [
      0.78,
      0.796,
      0.82,
      1.0
     ],
     "border": 0,
     "rounded": 1,
     "background": 1,
     "bgfillcolor": {
      "type": "color",
      "color": [
       0.78,
       0.796,
       0.82,
       1.0
      ]
     }
    }
   },
   {
    "box": {
     "id": "obj-5",
     "maxclass": "live.comment",
     "numinlets": 1,
     "numoutlets": 0,
     "fontname": "Ableton Sans Bold",
     "fontsize": 10,
     "textcolor": [
      0.922,
      0.922,
      0.91,
      1.0
     ],
     "text": "LEGACY BUS",
     "textjustification": 0,
     "patching_rect": [
      700,
      400,
      164,
      13
     ],
     "presentation": 1,
     "presentation_rect": [
      23,
      29,
      164,
      13
     ],
     "background": 1
    }
   },
   {
    "box": {
     "id": "obj-6",
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
     "id": "obj-7",
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
     "id": "obj-8",
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
     "id": "obj-9",
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
     "id": "obj-10",
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
     "id": "obj-11",
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
     "id": "obj-12",
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
     "id": "obj-13",
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
     "id": "obj-14",
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
     "id": "obj-15",
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
     "id": "obj-19",
     "maxclass": "live.comment",
     "numinlets": 1,
     "numoutlets": 0,
     "fontname": "Ableton Sans Medium",
     "fontsize": 8.5,
     "textcolor": [
      0.557,
      0.576,
      0.608,
      1.0
     ],
     "text": "BUS",
     "textjustification": 0,
     "patching_rect": [
      700,
      400,
      40,
      13
     ],
     "presentation": 1,
     "presentation_rect": [
      16,
      47,
      40,
      13
     ],
     "background": 1
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
      45,
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
      0.169,
      0.18,
      0.2,
      1.0
     ],
     "activebgcolor": [
      0.169,
      0.18,
      0.2,
      1.0
     ],
     "textcolor": [
      0.922,
      0.922,
      0.91,
      1.0
     ],
     "activetextcolor": [
      0.922,
      0.922,
      0.91,
      1.0
     ],
     "tricolor": [
      0.78,
      0.796,
      0.82,
      1.0
     ],
     "fontname": "Ableton Sans Medium",
     "fontsize": 9.0
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
      52,
      54
     ],
     "presentation": 1,
     "presentation_rect": [
      14,
      64,
      52,
      54
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
      0.78,
      0.796,
      0.82,
      1.0
     ],
     "activeneedlecolor": [
      0.922,
      0.922,
      0.91,
      1.0
     ],
     "focusbordercolor": [
      0.78,
      0.796,
      0.82,
      1.0
     ],
     "dialcolor": [
      0.227,
      0.239,
      0.263,
      1.0
     ],
     "needlecolor": [
      0.922,
      0.922,
      0.91,
      1.0
     ],
     "textcolor": [
      0.922,
      0.922,
      0.91,
      1.0
     ],
     "fontname": "Ableton Sans Medium",
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
      108,
      18
     ],
     "presentation": 1,
     "presentation_rect": [
      76,
      82,
      108,
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
      0.169,
      0.18,
      0.2,
      1.0
     ],
     "bgoncolor": [
      0.78,
      0.796,
      0.82,
      1.0
     ],
     "textcolor": [
      0.922,
      0.922,
      0.91,
      1.0
     ],
     "textoncolor": [
      0.169,
      0.18,
      0.2,
      1.0
     ],
     "rounded": 3.0,
     "activebgcolor": [
      0.169,
      0.18,
      0.2,
      1.0
     ],
     "activebgoncolor": [
      0.78,
      0.796,
      0.82,
      1.0
     ],
     "activetextcolor": [
      0.922,
      0.922,
      0.91,
      1.0
     ],
     "activetextoncolor": [
      0.169,
      0.18,
      0.2,
      1.0
     ]
    }
   },
   {
    "box": {
     "id": "obj-20",
     "maxclass": "live.comment",
     "numinlets": 1,
     "numoutlets": 0,
     "fontname": "Ableton Sans Medium",
     "fontsize": 8,
     "textcolor": [
      0.557,
      0.576,
      0.608,
      1.0
     ],
     "text": "send~ between devices is unsupported;",
     "textjustification": 0,
     "patching_rect": [
      700,
      400,
      172,
      13
     ],
     "presentation": 1,
     "presentation_rect": [
      16,
      122,
      172,
      13
     ],
     "background": 1
    }
   },
   {
    "box": {
     "id": "obj-21",
     "maxclass": "live.comment",
     "numinlets": 1,
     "numoutlets": 0,
     "fontname": "Ableton Sans Medium",
     "fontsize": 8,
     "textcolor": [
      0.557,
      0.576,
      0.608,
      1.0
     ],
     "text": "prefer Audio From > Twin Phasor 3/4.",
     "textjustification": 0,
     "patching_rect": [
      700,
      400,
      172,
      13
     ],
     "presentation": 1,
     "presentation_rect": [
      16,
      134,
      172,
      13
     ],
     "background": 1
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
      "obj-9",
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
      "obj-6",
      0
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
      "obj-6",
      1
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
      "obj-15",
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
      "obj-15",
      1
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
      "obj-7",
      0
     ]
    }
   },
   {
    "patchline": {
     "source": [
      "obj-15",
      0
     ],
     "destination": [
      "obj-7",
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
      "obj-10",
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
      "obj-18",
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
      "obj-8",
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
      "obj-9",
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