class EventsController < ApplicationController
  def index
    @events = Event.search_by(fb_graph: @graph, params: params)
  end

  def show
    @event = Event.find(fb_graph: @graph, params: params)
  end
end
