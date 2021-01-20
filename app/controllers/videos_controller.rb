class VideosController < ApplicationController
  require 'httparty'

  before_action :require_video, only: [:show]

  def index
    if params[:query]
      data = VideoWrapper.search(params[:query])
    else
      data = Video.all
    end

    render status: :ok, json: data
  end

  def show
    render(
      status: :ok,
      json: @video.as_json(
        only: [:title, :overview, :release_date, :inventory],
        methods: [:available_inventory]
        )
      )
  end

  # ANSEL ADVICE
  # Make use of video wrapper code to make call to TMDB
  # Get it from rails application.
  # In React user enters title and inventory.
  # This talks to Rails via the axios
  # Rails code then queries tmdb to get details for that movie
  # Then add it into your database
  # Router is just to selectively show or hide bits of the React app
  # It amkes it look like there are different routes to visit, but there really aren't bc single page app
  # web server that react runs is special bc requests sent into it get sent to react app running, regardless of path in address bar, anything coming in gets sent to index.js
  #
  #
  # Is it get or post? Get from tmdb


  # look up the title to get data
  # add to db
  # doesnt sound like enough to make a helperclass
  # put it in an action in controller
  # just make use of wrapper

  def add_new_video.get(url, params)
    SEE VIDEO WRAPPER
    URL = "the url of tmdb --search the video"
    response = HTTParty.get(url, query: params)

    we format the response to have the info we want to add to the video table
    then we .save to the video table
  end

  private

  def require_video
    @video = Video.find_by(title: params[:title])
    unless @video
      render status: :not_found, json: { errors: { title: ["No video with title #{params["title"]}"] } }
    end
  end
end
