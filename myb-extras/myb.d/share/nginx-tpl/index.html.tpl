<!DOCTYPE html>
<html lang="en" xmlns="http://www.w3.org/1999/html">
<head>
    <meta charset="UTF-8">
    <title>MyBee - The most simplified API for creating and destroying K8S & cloud VMs</title>
    <link rel="stylesheet" href="/font-awesome.min.css">
    <link rel="stylesheet" href="/bootstrap.min.css" integrity="sha384-ggOyR0iXCbMQv3Xipma34MD+dH/1fQ784/j6cY/iJTQUOhcWr7x9JvoRxT2MZw1T" crossorigin="anonymous">
</head>
<style>
  body {
  background-color: black;
  background-image: radial-gradient(
    rgba(100, 120, 100, 0.75), black 120%
  );
  height: 100vh;
  margin: 0;
  overflow: hidden;
  color: white;
  font: 1.0rem Inconsolata, monospace;
  text-shadow: 0 0 5px #C8C8C8;
  &::after {
    content: "";
    position: absolute;
    top: 0;
    left: 0;
    width: 100vw;
    height: 100vh;
    background: repeating-linear-gradient(
      0deg,
      rgba(black, 0.15),
      rgba(black, 0.15) 1px,
      transparent 1px,
      transparent 2px
    );
    pointer-events: none;
  }
}

output { color: #f6ffff; }
a { color: #b6d6ff; }
::selection {
  background: #0080FF;
  text-shadow: none;
}
pre {
  margin: 0;
}

</style>

<body>
<pre>
    <output id="content">
    <span id="welcome"></span><span id="platform" style="display: none;"># <a href="https://myb.convectix.com">MyBee</a> - The most simplified API for creating and destroying K8S & cloud VMs</span>
    <span id="plans" style="display: none;"># the number of VMs is limited only by your resources. Dashboard: <a target="_blank" href="%%SCHEMA%%://%%IP%%/status">%%SCHEMA%%://%%IP%%/status</a></span>
    <span id="curlimg1" style="display: none;">[you@home ~$]</span><span id="curlimg"></span>
    <span id="othercmd" style="display: none;">
    # get clusters status:
    [you@home ~$] curl %%SCHEMA%%://%%IP%%/clusters

    # get available images:
    [you@home ~$] curl %%SCHEMA%%://%%IP%%/images

    [you@home ~$] cat debian11.json
    {
      "imgsize": "10g",
      "ram": "1g",
      "cpus": "2",
      "image": "debian11",
      "pubkey": "ssh-ed25519 AAAA..XXX your@localhost"
    }

    # create cluster by data:
    [you@home ~$] curl -X POST -H "Content-Type: application/json" -d @debian11.json %%SCHEMA%%://%%IP%%/api/v1/create/vm1

    # get your namespace status:
    [you@home ~$] curl -H "cid:&lt;cid&gt;" %%SCHEMA%%://%%IP%%/api/v1/cluster

    # get cluster status
    [you@home ~$] curl -H "cid:&lt;cid&gt;" %%SCHEMA%%://%%IP%%/api/v1/status/vm1

    # start vm
    [you@home ~$] curl -H "cid:&lt;cid&gt;" %%SCHEMA%%://%%IP%%/api/v1/start/vm1

    # stop vm
    [you@home ~$] curl -H "cid:&lt;cid&gt;" %%SCHEMA%%://%%IP%%/api/v1/stop/vm1

    # destroy vm
    [you@home ~$] curl -H "cid:&lt;cid&gt;" %%SCHEMA%%://%%IP%%/api/v1/destroy/vm1
    </span>
     <span id="contactus" style="display: none;">
     # Сheck out <a target="_blank" href="https://github.com/myb-project/guide">MyB Handbook</a> before start.

     # Get <strong>nubectl</strong>, MyBee thin client for <a href="/nubectl/freebsd/nubectl">FreeBSD</a>, <a href="/nubectl/linux/nubectl">Linux, <a href="/nubectl/darwin/nubectl">MacOS/Darwin</a>, <a href="/nubectl/windows/nubectl">Windows</a>
     # Reach us <a target="_blank" href="https://t.me/mybgroup">on Telegram</a>
     # Reach us <a target="_blank" href="https://twitter.com/">on Twitter</a>
     # Support the project: <a target="_blank" href="https://www.patreon.com/clonos">via Patreon</a>
     </span>
    </output>
</pre>
<script src="jq.js"></script>
<script>
    function findGetParameter(parameterName) {
        var result = null,
            tmp = [];
        var items = location.search.substr(1).split("&");
        for (var index = 0; index < items.length; index++) {
            tmp = items[index].split("=");
            if (tmp[0] === parameterName) result = decodeURIComponent(tmp[1]);
        }
        return result;
    }


        $(document).keyup(function(e) {
             if (e.key === "Escape") { // escape key maps to keycode `27`

                $("#imgresp").show();
                $('#welcome').hide();
                $('#platform').show();

                $("#plans").show();

                $("#contactus").show();
                $("#refermore").show();

                $("#othercmd").show();
            }
            });

    $(document).ready(function(){

        setTimeout(function (){

            $('#welcome').teletype({
              text: [' ', '# Welcome to the MyBee! [Esc to skip]'],
              delay: 50,
              pause: 100
            });
                }, 1000);


        setTimeout(function (){
            $("#curlimg1").show();
        }, 4000);

        setTimeout(function (){
            $('#curlimg').teletype({
                  text: [' ', 'curl %%SCHEMA%%://%%IP%%/clusters'],
                  delay: 60,
                  pause: 100
                });

        }, 4800);


setTimeout(function (){
        $("#imgresp").show();

        }, 8000);

setTimeout(function (){
        $('#welcome').hide();
        $('#platform').show();
        }, 9000);

setTimeout(function (){
        $("#plans").show();

        }, 11000);

setTimeout(function (){
        $("#contactus").show();
        $("#refermore").show();
        }, 14000);

setTimeout(function (){
        $("#othercmd").show();
        }, 18000);

    });



(function ($) {
  // writes the string
  //
  // @param jQuery $target
  // @param String str
  // @param Numeric cursor
  // @param Numeric delay
  // @param Function cb
  // @return void
  function typeString($target, str, cursor, delay, cb) {
    $target.html(function (_, html) {
      return html + str[cursor];
    });

    if (cursor < str.length - 1) {
      setTimeout(function () {
        typeString($target, str, cursor + 1, delay, cb);
      }, delay);
    }
    else {
      cb();
    }
  }

  // clears the string
  //
  // @param jQuery $target
  // @param Numeric delay
  // @param Function cb
  // @return void
  function deleteString($target, delay, cb) {
    var length;

    $target.html(function (_, html) {
      length = html.length;
      return html.substr(0, length - 0);
    });

    if (length > 1) {
      setTimeout(function () {
        deleteString($target, delay, cb);
      }, delay);
    }
    else {
      cb();
    }
  }

  // jQuery hook
  $.fn.extend({
    teletype: function (opts) {
      var settings = $.extend({}, $.teletype.defaults, opts);

      return $(this).each(function () {
        (function loop($tar, idx) {
          // type
          typeString($tar, settings.text[idx], 0, settings.delay, function () {
            // delete
            setTimeout(function () {
              deleteString($tar, settings.delay, function () {
                loop($tar, (idx + 1) % settings.text.length);
              });
            }, settings.pause);
          });

        }($(this), 0));
      });
    }
  });

  // plugin defaults
  $.extend({
    teletype: {
      defaults: {
        delay: 100,
        pause: 5000,
        text: []
      }
    }
  });
}(jQuery));
</script>
</body>
</html>

