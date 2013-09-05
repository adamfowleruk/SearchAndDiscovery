xquery version '1.0-ml';
import module namespace trgr='http://marklogic.com/xdmp/triggers' 
   at '/MarkLogic/triggers.xqy';

declare namespace h="http://www.w3.org/1999/xhtml";
declare variable $trgr:uri as xs:string external;
 
let $log := xdmp:log(fn:concat("****** ISYS TRIGGER FIRED FOR",$trgr:uri))

let $namepart := fn:substring-after($trgr:uri,'/imports/originals/')
let $col := fn:substring-before($namepart,"/")

let $xml := xdmp:document-filter(fn:doc($trgr:uri)/binary())
let $log := xdmp:log("XML:-")
let $log := xdmp:log($xml)

(:)
let $create := 
  if (fn:exists($xml)) then 
    xdmp:document-insert(fn:concat('/imports/xhtml/',$namepart,'.xml'),$xml,xdmp:default-permissions(),(xdmp:default-collections(),'xhtml',$col)) 
  else
    ()

return fn:true()
:)


let $create := 
  if (fn:exists($xml)) then 
    xdmp:document-insert(fn:concat('/imports/xhtml/',$namepart,'.xml'),<html xmlns="http://www.w3.org/1999/xhtml">
       <head xmlns="http://www.w3.org/1999/xhtml">
         {$xml//h:head/node()}
         <meta name="originaldoc" content="{$trgr:uri}" xmlns="http://www.w3.org/1999/xhtml" />
       </head>
       {$xml//h:body}
      </html>,xdmp:document-get-permissions($trgr:uri),(xdmp:default-collections(),'xhtml',$col)) 
      
      (: ),
      
    xdmp:document-insert(fn:concat('/renderings2/',$namepart,'.xml'),
       $xml,xdmp:document-get-permissions($trgr:uri),(xdmp:document-get-collections($trgr:uri),'xhtml')) 
      ) :)
  else
    ()

return fn:true()