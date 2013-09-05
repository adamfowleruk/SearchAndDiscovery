xquery version "1.0-ml";

import module namespace vh = "http://marklogic.com/roxy/view-helper" at "/roxy/lib/view-helper.xqy";


import module namespace info = "http://marklogic.com/appservices/infostudio"  
      at "/MarkLogic/appservices/infostudio/info.xqy";
import module namespace json = "http://marklogic.com/xdmp/json" at "/MarkLogic/json/json.xqy";

declare option xdmp:mapping "false";


let $ticketuri := xdmp:get-request-field("ticketuri")


let $c := json:config("custom") , 
    $cx := map:put( $c, "text-value", "label" ),
    $cx := map:put( $c , "camel-case", fn:true() )

let $ticket := info:ticket-errors($ticketuri)

return
  (
    json:transform-to-json($ticket,$c) 
  )
