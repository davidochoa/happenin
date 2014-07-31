class EventsController < ApplicationController
  def index
    @events = Event.search_by(fb_graph: @graph, params: permitted_params)
  end

  def show
  end

  private

  def permitted_params
    params.permit(:q)
  end
end
