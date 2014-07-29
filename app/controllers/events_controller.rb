class EventsController < ApplicationController
  def index
    @events = Event.search_by(@graph, permitted_params)
  end

  def show
  end

  private

  def permitted_params
    params.permit(:q)
  end
end
