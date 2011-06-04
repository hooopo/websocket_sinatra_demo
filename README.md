##Requeirements

     gem install oa-oauth dm-core dm-sqlite-adapter dm-migrations sinatra erb
     gem install eventmachine em-websocket json

##Usage
To start it up, fire up the Sinatra app:

    cd websocket-demo
    ruby ./application.rb

Remember to also fire up the websocket server:

    ruby lib/websocket.rb

Point your browser to http://localhost:4567/ (or wherever you put it) and
that's it.