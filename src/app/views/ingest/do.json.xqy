xquery version "1.0-ml";

import module namespace vh = "http://marklogic.com/roxy/view-helper" at "/roxy/lib/view-helper.xqy";
import module namespace info = "http://marklogic.com/appservices/infostudio"  
      at "/MarkLogic/appservices/infostudio/info.xqy";
import module namespace json = "http://marklogic.com/xdmp/json" at "/MarkLogic/json/json.xqy";

declare option xdmp:mapping "false";

let $path := xdmp:get-request-field("path")
let $col := xdmp:get-request-field("collection")

let $delta := 
      <options xmlns="http://marklogic.com/appservices/infostudio">
          <collection>{$col}</collection>
          <collection>originals</collection>
          <uri>
              <literal>{fn:concat("/imports/originals/",$col)}</literal>
              <path strip-prefix="{$path}"/>
              <literal>/</literal>
              <filename/>
              <literal>.</literal>
              <ext/>
          </uri>
      </options>

let $ticket := info:load($path, (), $delta)


let $c := json:config("custom") , 
    $cx := map:put( $c, "text-value", "label" ),
    $cx := map:put( $c , "camel-case", fn:true() )
    
return
  (
    (:fn:concat("{ticketuri: '",$ticket,"'}"):)
    
    json:transform-to-json(<ticketuri>{$ticket}</ticketuri>,$c) 
  )
