//
//  City.swift
//  WeatherTest
//
//  Created by KEEVIN MITCHELL on 9/14/24.
//

import Foundation
import CoreLocation

struct City: Decodable {
  var name: String?
  var localNames: LocalName?
  var lat: Double
  var lon: Double
  var country: String?
  var state: String?

  private enum CodingKeys: String, CodingKey {
    case name
    case localNames = "local_names"
    case lat
    case lon
    case country
    case state
  }
}

struct LocalName: Decodable {
  var bi: String?
  var kv: String?
  var li: String?
  var uk: String?
  var to: String?
  var mi: String?
  var kn: String?
  var et: String?
  var os: String?
  var lv: String?
  var ru: String?
  var nn: String?
  var lo: String?
  var om: String?
  var ja: String?
  var he: String?
  var tl: String?
  var ia: String?
  var eu: String?
  var ar: String?
  var nl: String?
  var cs: String?
  var ab: String?
  var ta: String?
  var tt: String?
  var te: String?
  var nv: String?
  var no: String?
  var ms: String?
  var mt: String?
  var ro: String?
  var gu: String?
  var ay: String?
  var ht: String?
  var gl: String?
  var wa: String?
  var mg: String?
  var ig: String?
  var wo: String?
  var am: String?
  var tr: String?
  var ee: String?
  var ug: String?
  var av: String?
  var sv: String?
  var qu: String?
  var bs: String?
  var hi: String?
  var oc: String?
  var hr: String?
  var mr: String?
  var az: String?
  var tw: String?
  var sc: String?
  var sk: String?
  var na: String?
  var fi: String?
  var ur: String?
  var km: String?
  var ka: String?
  var be: String?
  var ln: String?
  var fo: String?
  var rm: String?
  var sl: String?
  var ky: String?
  var hy: String?
  var mk: String?
  var gd: String?
  var sm: String?
  var ny: String?
  var co: String?
  var pa: String?
  var bg: String?
  var lb: String?
  var ml: String?
  var sa: String?
  var sh: String?
  var si: String?
  var my: String?
  var pl: String?
  var mn: String?
  var cy: String?
  var kl: String?
  var bm: String?
  var hu: String?
  var el: String?
  var jv: String?
  var su: String?
  var fj: String?
  var de: String?
  var ps: String?
  var sw: String?
  var vi: String?
  var tk: String?
  var vo: String?
  var zu: String?
  var bn: String?
  var ie: String?
  var yo: String?
  var tg: String?
  var sq: String?
  var es: String?
  var ne: String?
  var fy: String?
  var ba: String?
  var kk: String?
  var yi: String?
  var st: String?
  var eo: String?
  var se: String?
  var so: String?
  var ff: String?
  var ga: String?
  var th: String?
  var it: String?
  var bo: String?
  var da: String?
  var ascii: String?
  var io: String?
  var sn: String?
  var fr: String?
  var `is`: String?
  var br: String?
  var featureName: String?
  var sr: String?
  var fa: String?
  var cv: String?
  var sd: String?
  var zh: String?
  var cu: String?
  var af: String?
  var lt: String?
  var gn: String?
  var ku: String?
  var bh: String?
  var ha: String?
  var ko: String?
  var kw: String?
  var en: String?
  var ce: String?
  var pt: String?
  var id: String?
  var an: String?
  var or: String?
  var uz: String?
  var gv: String?
  var ca: String?
  var oj: String?
  var cr: String?
  var iu: String?

  private enum CodingKeys: String, CodingKey {
    case bi
    case kv
    case li
    case uk
    case to
    case mi
    case kn
    case et
    case os
    case lv
    case ru
    case nn
    case lo
    case om
    case ja
    case he
    case tl
    case ia
    case eu
    case ar
    case nl
    case cs
    case ab
    case ta
    case tt
    case te
    case nv
    case no
    case ms
    case mt
    case ro
    case gu
    case ay
    case ht
    case gl
    case wa
    case mg
    case ig
    case wo
    case am
    case tr
    case ee
    case ug
    case av
    case sv
    case qu
    case bs
    case hi
    case oc
    case hr
    case mr
    case az
    case tw
    case sc
    case sk
    case na
    case fi
    case ur
    case km
    case ka
    case be
    case ln
    case fo
    case rm
    case sl
    case ky
    case hy
    case mk
    case gd
    case sm
    case ny
    case co
    case pa
    case bg
    case lb
    case ml
    case sa
    case sh
    case si
    case my
    case pl
    case mn
    case cy
    case kl
    case bm
    case hu
    case el
    case jv
    case su
    case fj
    case de
    case ps
    case sw
    case vi
    case tk
    case vo
    case zu
    case bn
    case ie
    case yo
    case tg
    case sq
    case es
    case ne
    case fy
    case ba
    case kk
    case yi
    case st
    case eo
    case se
    case so
    case ff
    case ga
    case th
    case it
    case bo
    case da
    case ascii
    case io
    case sn
    case fr
    case `is`
    case br
    case featureName = "feature_name"
    case sr
    case fa
    case cv
    case sd
    case zh
    case cu
    case af
    case lt
    case gn
    case ku
    case bh
    case ha
    case ko
    case kw
    case en
    case ce
    case pt
    case id
    case an
    case or
    case uz
    case gv
    case ca
    case oj
    case cr
    case iu
  }
}

