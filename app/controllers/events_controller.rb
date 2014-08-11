class EventsController < ApplicationController
  def index
    @events = Event.search_by(params, @graph)
  end

  def show
    @event = Event.find(params, @graph)
  end
end
