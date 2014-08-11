class Event

  TYPES = {
    '1' => 'FacebookEvent',
    '2' => 'EventbriteEvent'
  }

  class << self
    def search_by(params, fb_graph = nil)
      return [] if params[:q].blank?
      results = FacebookEvent.search_by(params, fb_graph)
    end

    def find(params, fb_graph = nil)
      new(params, fb_graph)
    end

    def event_class(source_id)
      TYPES[source_id.to_s].constantize if TYPES.has_key?(source_id.to_s)
    end
  end

  def initialize(params, fb_graph = nil)
    return unless params[:source_id] &&
      self.class.event_class(params[:source_id])
    @event = self.class.event_class(params[:source_id])
      .new(params, fb_graph)
  end

  def method_missing(method, *args, &block)
    return @event.send(method, *args, &block) if @event.respond_to?(method)
  end
end
