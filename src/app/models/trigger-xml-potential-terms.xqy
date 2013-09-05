xquery version "1.0-ml";
import module namespace trgr="http://marklogic.com/xdmp/triggers" at "/MarkLogic/triggers.xqy";
declare namespace h = "http://www.w3.org/1999/xhtml";

declare variable $trgr:uri as xs:string external;

let $log := xdmp:log(fn:concat("****** XML POTENTIAL TERMS TRIGGER FIRED FOR",$trgr:uri))

let $original := fn:doc($trgr:uri)

let $body := $original/h:html/h:body
let $log := xdmp:log($body)

(: get all contained text, in order :)
let $words := fn:tokenize(fn:normalize-space($body/fn:string(.))," ")

(: only process those whose first letter is a capital :)
let $map := map:map()

let $candidates :=
  for $word in $words
  return
    if (fn:substring($word,1,1) = ('A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z')) then
    $word
      (: candidate word, append to buffer :)
     (: map:put($map,"c",fn:concat(map:get($map,"c")," ",$word)):)
    else
      (: if we have existing words in buffer, save whole lot as a phrase and clear the buffer. This is to catch multi word phrases. :)
     (: (map:get($map,"c"),map:clear($map)):)
      ()

(: check buffer is empty, flush if not :)
(: get unique candidates :)
let $candidates := fn:distinct-values($candidates)

(: use cts:highlight for candidates in xhtml document :)
let $dp := map:put($map,"d",$original)
let $n := 
  for $term in $candidates
  return
    map:put($map,"d",cts:highlight(map:get($map,"d"), $term, <potential>{$term}</potential>))



let $rep := xdmp:node-replace($original,map:get($map,"d"))

return fn:true()
