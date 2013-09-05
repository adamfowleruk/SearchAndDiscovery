xquery version "1.0-ml";

(: This module is intended to be executed by an alert. The word query that matches the new document is used to 
 : highlight the term in any new xhtml document
 :)
 
declare namespace alert = "http://marklogic.com/xdmp/alert";
import module "http://marklogic.com/xdmp/alert" at "/MarkLogic/alert.xqy";

declare variable $alert:config-uri as xs:string external;
declare variable $alert:doc as node() external;
declare variable $alert:rule as element(alert:rule) external;
declare variable $alert:action as element(alert:action) external;

let $log := xdmp:log(fn:concat("ALERT FIRED for doc at uri: ",fn:base-uri($alert:doc)))
let $query := alert:rule-get-query($alert:rule)

let $term := $alert:rule/alert:options/term/text() 
let $log := xdmp:log($alert:rule)

let $newdoc := 
  if ($term) then
    (: for $r in cts:search(fn:doc(fn:base-uri($alert:doc)),$query)
    return :) 
      cts:highlight($alert:doc, $term, <term>{$cts:text}</term>)
  else
    $alert:doc
    
let $log := xdmp:log($newdoc)    
    
return
  xdmp:node-replace($alert:doc,$newdoc) (: Avoids infinite loop of document-insert :)
