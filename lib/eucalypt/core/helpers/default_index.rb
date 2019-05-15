class MainController < ApplicationController
  unless self.routes["GET"].map {|r| r.first.to_s}.include?('/')
    self.get '/' do
      <<-HEREDOC
  <html>
      <head>
          <style>
              @import url('https://fonts.googleapis.com/css?family=Signika|Inconsolata:400,700');
              body {
                  margin: 0;
                  height: 100vh;
                  width: 100vw;
                  display: flex;
                  align-items: center;
                  justify-content: center;
              }
              #container {
                  display: flex;
                  align-items: center;
              }
              #container img {
                  display: inline-block;
                  height: 200px;
                  padding: 30px;
              }
              #text {
                  display: inline-block;
              }
              #text h1 {
                  font-family: 'Signika', sans-serif;
                  font-size: 2.5em;
              }
              #text p {
                  font-family: 'Inconsolata', monospace;
                  font-size: 1.5em;
              }
              #text p b {
                  color: rgb(120,120,120);
                  font-family: 'Inconsolata', monospace;
                  font-weight: 700;
              }
              #text p span {
                  color: #4ab37b;
              }
          </style>
          <meta name="viewport" content="width=device-width">
      </head>
      <body>
          <div id="container">
              <img src="https://i.ibb.co/BKb7SxT/eucalypt.png">
              <div id="text">
                  <h1>It's running!</h1>
                  <p><b>Eucalypt version</b> : <span>#{Eucalypt::VERSION}</span></p>
                  <p><b>Ruby version</b>     : <span>#{RUBY_VERSION}</span></p>
              </div>
          </div>
      </body>
  </html>
      HEREDOC
    end
  end
end