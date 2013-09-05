xquery version "1.0-ml";

import module namespace vh = "http://marklogic.com/roxy/view-helper" at "/roxy/lib/view-helper.xqy";

declare option xdmp:mapping "false";

(: use the vh:required method to force a variable to be passed. it will throw an error
 : if the variable is not provided by the controller :)
(:
  declare variable $title as xs:string := vh:required("title");
    or
  let $title as xs:string := vh:required("title");
:)

(: grab optional data :)
(:
  declare variable $stuff := vh:get("stuff");
    or
  let $stuff := vh:get("stuff")
:)

<div xmlns="http://www.w3.org/1999/xhtml" class="ingest main">
 <p>Enter the information below and submit to perform an ingest of a new collection.</p>
 
 <form name="ingest" id="ingest" action="">
 <table border="0">
 <tr>
 <td>
 <label for="collection">Collection(s): </label>
 </td><td>
 <input type="text" size="40" name="collection" id="collection" value="doc-disco-data"/>
 </td></tr>
 <tr><td>
 <label for="path">Server Path: </label>
 </td><td>
 <input type="text" name="path" size="40" id="path" value="/Users/adamfowler/Documents/marklogic/strategy/demos/doc-disco-data" />
 </td></tr>
 <tr><td colspan="2" align="center"><input type="submit" value="submit" name="submit"/></td></tr>
 </table>
 </form>
 
 <div id="monitor"></div>
 
 <script type="text/javascript">
$(document).ready(function(){{
 var monitor = new com.marklogic.widgets.IngestPanel('monitor');
 $('#ingest').submit(function(e) {{
   e.preventDefault();
   console.log("jQuery submit handler");
   monitor.begin($('#collection').val(),$('#path').val());
   return false;
 }});
 }});
 </script>
</div>