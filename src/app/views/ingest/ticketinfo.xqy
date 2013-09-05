xquery version "1.0-ml";

(: Send back ticket status information as json :)

import module namespace info = "http://marklogic.com/appservices/infostudio"  
      at "/MarkLogic/appservices/infostudio/info.xqy";
import module namespace json = "http://marklogic.com/xdmp/json" at "/MarkLogic/json/json.xqy";

let $ticket := xdmp:get-request-field("ticketuri")


let $c := json:config("custom") , 
    $cx := map:put( $c, "text-value", "label" ),
    $cx := map:put( $c , "camel-case", fn:true() )

let $ticket := info:ticket($ticketuri)

return
  (
    xdmp:set-response-content-type("text/javascript"),
    json:transform-to-json($ticket,$c) 
  )
