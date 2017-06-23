FROM alpine
RUN apk add --no-cache ruby make gcc g++ ruby-dev libffi-dev libcurl
RUN gem install sinatra json typhoeus diplomat --no-document

ENV APP_PATH /var/opt/sinatra/src

RUN mkdir -p $APP_PATH
COPY frontend.rb $APP_PATH/app.rb
COPY app.conf /etc/app.conf 
RUN mkdir $APP_PATH/views
COPY index.erb $APP_PATH/views/index.erb

CMD ruby $APP_PATH/app.rb -o 0.0.0.0
