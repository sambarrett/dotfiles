#!/bin/sh

if [ $USER != "root" ]; then
  echo "Needs to be run as root, try: sudo !!"
  exit 2
fi

target_file="/usr/lib/slack/resources/app.asar.unpacked/src/static/ssb-interop.js"

# Don't want to interpret variables whilst reading from the HEREDOC - thus the single quotes... potto
cat << 'EOT' >> $target_file

// BEGIN PATCH by SAM BARRETT
// First make sure the wrapper app is loaded
document.addEventListener("DOMContentLoaded", function() {

   // Then get its webviews
   let webviews = document.querySelectorAll(".TeamView webview");

  var fs = require('fs'),
  filePath = '/home/sam/dotfiles/slack-night-mode-black.css';

  fs.readFile(filePath, {encoding: 'utf-8'}, function(err, css) {
    if (!err) {
      let s = document.createElement('style');
      s.type = 'text/css';
      s.innerHTML = css;
      document.head.appendChild(s);
    }
  })

   // Wait for each webview to load
   webviews.forEach(webview => {
      webview.addEventListener('ipc-message', message => {
         if (message.channel == 'didFinishLoading')
            // Finally add the CSS into the webview
            cssPromise.then(css => {
               let script = `
                     let s = document.createElement('style');
                     s.type = 'text/css';
                     s.id = 'slack-custom-css';
                     s.innerHTML = \`${css}\`;
                     document.head.appendChild(s);
                     `
               webview.executeJavaScript(script);
            })
      });
   });
});
// END PATCH by SAM BARRETT
EOT
