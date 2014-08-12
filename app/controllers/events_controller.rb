class EventsController < ApplicationController
  def index
    @events = Event.search_by(params, @fb_graph, @ebrite)
  end

  def show
    @event = Event.find(params, @fb_graph, @ebrite)
  end
end
