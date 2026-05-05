<!DOCTYPE html>
<html lang="de">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>X/Twitter API v2 — Uniface Web Client</title>
  <style>
    *, *::before, *::after { box-sizing: border-box; }

    body {
      font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Arial, sans-serif;
      background: #f5f8fa;
      color: #14171a;
      margin: 0;
      padding: 20px;
    }

    h1 {
      font-size: 1.4rem;
      border-bottom: 2px solid #1da1f2;
      padding-bottom: 8px;
      margin-bottom: 24px;
    }

    h2 {
      font-size: 1rem;
      color: #1da1f2;
      margin: 0 0 12px 0;
    }

    .card {
      background: #fff;
      border: 1px solid #e1e8ed;
      border-radius: 8px;
      padding: 18px 20px;
      margin-bottom: 16px;
    }

    label {
      display: block;
      font-size: 0.82rem;
      font-weight: 600;
      margin-bottom: 4px;
      color: #657786;
    }

    input[type="text"], input[type="number"], textarea {
      width: 100%;
      padding: 8px 10px;
      border: 1px solid #ccd6dd;
      border-radius: 4px;
      font-size: 0.9rem;
      margin-bottom: 10px;
    }

    input[type="text"]:focus, textarea:focus {
      outline: none;
      border-color: #1da1f2;
    }

    button {
      background: #1da1f2;
      color: #fff;
      border: none;
      border-radius: 20px;
      padding: 8px 18px;
      font-size: 0.88rem;
      font-weight: 600;
      cursor: pointer;
    }

    button:hover { background: #0c85d0; }

    .result-block {
      margin-top: 10px;
      background: #f5f8fa;
      border: 1px solid #e1e8ed;
      border-radius: 4px;
      padding: 10px;
      font-family: "Courier New", monospace;
      font-size: 0.78rem;
      white-space: pre-wrap;
      word-break: break-all;
      max-height: 280px;
      overflow-y: auto;
      display: none;
    }

    .error-block {
      margin-top: 8px;
      color: #e0245e;
      font-size: 0.85rem;
      font-weight: 600;
    }

    .status-badge {
      display: inline-block;
      font-size: 0.75rem;
      padding: 2px 8px;
      border-radius: 10px;
      margin-left: 8px;
      background: #e8f5fd;
      color: #1da1f2;
    }
  </style>
</head>
<body>

<h1>&#x1F426; X/Twitter API v2 &mdash; Uniface Web Client Demo</h1>

<!--
  Uniface DSP Notes:
  - <$component name="XAPI_CLIENT"> activates the component for this page.
  - <$VARIABLE_NAME> renders the value of a Uniface DSP variable.
  - Form submissions trigger the WEBACTIVATE event; $webaction holds the button value.
  - All result variables (RESULT_JSON, ERROR_MSG, HTTP_STATUS) are set by the
    ProcScript event handler below (on $webaction ... endon blocks).
-->

<$component name="XAPI_CLIENT">

<form method="POST" action="XAPI_DEMO.dsp">

  <!-- ================================================================
       GET TWEET BY ID
       ================================================================ -->
  <div class="card">
    <h2>Tweet abrufen</h2>
    <label for="TWEET_ID">Tweet-ID</label>
    <input type="text" id="TWEET_ID" name="TWEET_ID"
           value="<$TWEET_ID>"
           placeholder="z.B. 1346889436626259968">
    <button type="submit" name="ACTION" value="GET_TWEET">Tweet laden</button>
    <span class="status-badge"><$GET_TWEET_STATUS></span>
    <div class="error-block"><$GET_TWEET_ERROR></div>
    <pre class="result-block" id="result-get-tweet"><$GET_TWEET_JSON></pre>
  </div>

  <!-- ================================================================
       SEARCH TWEETS
       ================================================================ -->
  <div class="card">
    <h2>Tweets suchen</h2>
    <label for="SEARCH_QUERY">Suchanfrage</label>
    <input type="text" id="SEARCH_QUERY" name="SEARCH_QUERY"
           value="<$SEARCH_QUERY>"
           placeholder='z.B. "uniface lang:en -is:retweet"'>
    <label for="MAX_RESULTS">Max. Ergebnisse (10&ndash;100)</label>
    <input type="number" id="MAX_RESULTS" name="MAX_RESULTS"
           value="<$MAX_RESULTS>" min="10" max="100"
           style="width:80px">
    <label for="NEXT_TOKEN">Pagination-Token (leer lassen f&uuml;r erste Seite)</label>
    <input type="text" id="NEXT_TOKEN" name="NEXT_TOKEN"
           value="<$NEXT_TOKEN>" placeholder="next_token aus vorherigem Response">
    <button type="submit" name="ACTION" value="SEARCH">Suchen</button>
    <span class="status-badge"><$SEARCH_STATUS></span>
    <div class="error-block"><$SEARCH_ERROR></div>
    <pre class="result-block" id="result-search"><$SEARCH_JSON></pre>
  </div>

  <!-- ================================================================
       GET USER BY USERNAME
       ================================================================ -->
  <div class="card">
    <h2>User-Profil abrufen (Username)</h2>
    <label for="USERNAME">Username (ohne @)</label>
    <input type="text" id="USERNAME" name="USERNAME"
           value="<$USERNAME>"
           placeholder="z.B. XDevelopers">
    <button type="submit" name="ACTION" value="GET_USER">Profil laden</button>
    <span class="status-badge"><$GET_USER_STATUS></span>
    <div class="error-block"><$GET_USER_ERROR></div>
    <pre class="result-block" id="result-get-user"><$GET_USER_JSON></pre>
  </div>

  <!-- ================================================================
       GET USER BY ID
       ================================================================ -->
  <div class="card">
    <h2>User-Profil abrufen (User-ID)</h2>
    <label for="USER_ID">User-ID</label>
    <input type="text" id="USER_ID" name="USER_ID"
           value="<$USER_ID>"
           placeholder="z.B. 2244994945">
    <button type="submit" name="ACTION" value="GET_USER_ID">Profil laden</button>
    <span class="status-badge"><$GET_USER_ID_STATUS></span>
    <div class="error-block"><$GET_USER_ID_ERROR></div>
    <pre class="result-block" id="result-get-user-id"><$GET_USER_ID_JSON></pre>
  </div>

  <!-- ================================================================
       CREATE TWEET
       ================================================================ -->
  <div class="card">
    <h2>Tweet erstellen</h2>
    <p style="font-size:0.82rem;color:#e0245e;margin:0 0 10px 0;">
      &#9888; Erfordert OAuth 2.0 User-Context (Write-Scope) &mdash; kein reines Bearer Token.
    </p>
    <label for="TWEET_TEXT">Tweet-Text (max. 280 Zeichen)</label>
    <textarea id="TWEET_TEXT" name="TWEET_TEXT" rows="3"
              placeholder="Hier den Tweet-Text eingeben..."><$TWEET_TEXT></textarea>
    <label for="REPLY_TO">Als Antwort auf Tweet-ID (optional)</label>
    <input type="text" id="REPLY_TO" name="REPLY_TO"
           value="<$REPLY_TO>"
           placeholder="Tweet-ID oder leer lassen">
    <button type="submit" name="ACTION" value="CREATE">Tweet absenden</button>
    <span class="status-badge"><$CREATE_STATUS></span>
    <div class="error-block"><$CREATE_ERROR></div>
    <pre class="result-block" id="result-create"><$CREATE_JSON></pre>
  </div>

</form>

</$component>

<script>
  /* Show result blocks that have content */
  document.querySelectorAll('.result-block').forEach(function(el) {
    if (el.textContent.trim().length > 0) {
      el.style.display = 'block';
    }
  });
</script>

<!--
=============================================================================
Uniface DSP ProcScript Event Handler
=============================================================================
The following ProcScript block is embedded in the Uniface component definition
associated with this DSP. It handles POST submissions by routing the $webaction
value to the appropriate XAPI_CLIENT operation.

Place this code in the component's WEBACTIVATE event operation in the
Uniface IDE when importing the DSP.

; ---- DSP Event: on form submit ----

operation WEBACTIVATE
  variables
    string  v_resp_json
    string  v_error
    numeric v_status
    numeric v_max
  endvariables

  ; Initialize the client (idempotent — safe to call on every request)
  activate XAPI_CLIENT INITIALIZE ("", v_error)
  if v_error != ""
    RESULT_JSON = ""
    ERROR_MSG   = "Init failed: " + v_error
    return
  endif

  ; Route based on submitted action
  if $webaction = "GET_TWEET"
    activate XAPI_CLIENT GET_TWEET (TWEET_ID, v_resp_json, v_status, v_error)
    GET_TWEET_JSON   = v_resp_json
    GET_TWEET_ERROR  = v_error
    GET_TWEET_STATUS = string(v_status)
  endif

  if $webaction = "SEARCH"
    v_max = numeric(MAX_RESULTS)
    activate XAPI_CLIENT SEARCH_TWEETS (SEARCH_QUERY, v_max, NEXT_TOKEN, v_resp_json, v_status, v_error)
    SEARCH_JSON   = v_resp_json
    SEARCH_ERROR  = v_error
    SEARCH_STATUS = string(v_status)
  endif

  if $webaction = "GET_USER"
    activate XAPI_CLIENT GET_USER_BY_USERNAME (USERNAME, v_resp_json, v_status, v_error)
    GET_USER_JSON   = v_resp_json
    GET_USER_ERROR  = v_error
    GET_USER_STATUS = string(v_status)
  endif

  if $webaction = "GET_USER_ID"
    activate XAPI_CLIENT GET_USER_BY_ID (USER_ID, v_resp_json, v_status, v_error)
    GET_USER_ID_JSON   = v_resp_json
    GET_USER_ID_ERROR  = v_error
    GET_USER_ID_STATUS = string(v_status)
  endif

  if $webaction = "CREATE"
    activate XAPI_CLIENT CREATE_TWEET (TWEET_TEXT, REPLY_TO, v_resp_json, v_status, v_error)
    CREATE_JSON   = v_resp_json
    CREATE_ERROR  = v_error
    CREATE_STATUS = string(v_status)
  endif

end operation
=============================================================================
-->

</body>
</html>
