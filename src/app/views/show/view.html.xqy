xquery version "1.0-ml";

import module namespace vh = "http://marklogic.com/roxy/view-helper" at "/roxy/lib/view-helper.xqy";
import module namespace admin = "http://marklogic.com/xdmp/admin" 
      at "/MarkLogic/admin.xqy";
declare namespace mime = "http://marklogic.com/xdmp/mimetypes";

declare option xdmp:mapping "false";

let $uri := xdmp:get-request-field("uri")
let $orig := xdmp:get-request-field("original","false")
let $fullurl := xdmp:get-request-field("fullurl","false")

let $log := xdmp:log(fn:concat("*** URI orig: ",$uri))
let $uri :=
  if ("true" = $orig and "false" = $fullurl) then
    let $main := fn:substring-after($uri,"/imports/xhtml/")
let $log := xdmp:log(fn:concat("*** main: ",$main))
    let $uri2 := fn:substring-before($main,".xml")
let $log := xdmp:log(fn:concat("*** URI 2: ",$uri2))
    return fn:concat("/imports/originals/",$uri2)
  else
    $uri
    
let $log := xdmp:log(fn:concat("*** URI converted: ",$uri))
(: now determine file type based on extension of original :)
let $mime :=
  if ("true" = $orig) then
    let $initial := fn:substring-before($uri,".")
let $log := xdmp:log(fn:concat("*** initial: ",$initial))
    let $ilen := fn:string-length($initial) + 2
let $log := xdmp:log(fn:concat("*** ilen: ",$ilen))
    let $extlen := fn:string-length($uri) - $ilen + 1
let $log := xdmp:log(fn:concat("*** extlen: ",$extlen))
    let $ext := fn:substring($uri,$ilen,$extlen)
let $log := xdmp:log(fn:concat("*** ext: ",$ext))
    let $config := admin:get-configuration()
    return admin:mimetypes-get($config)[./mime:extensions = $ext]
  else
    <mime:mimetype><mime:name>text/html</mime:name><mime:format>xml</mime:format></mime:mimetype>

let $type := $mime/mime:format/fn:string(.)
let $mimetype := $mime/mime:name/fn:string(.)
let $log := xdmp:log(fn:concat("*** type: ",$type))
let $log := xdmp:log(fn:concat("*** mimetype: ",$mimetype))
let $content :=
  if ("binary" = $type) then
    fn:doc($uri)/binary()
  else
    if ("xml" = $type) then
      fn:doc($uri)/element()
    else 
      (: text :)
      fn:doc($uri)/text()

return
  (
    xdmp:set-response-content-type($mimetype),
    $content
  )