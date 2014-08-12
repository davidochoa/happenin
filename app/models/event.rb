class Event

  SOURCES = {
    '1' => 'FacebookEvent',
    '2' => 'EventbriteEvent'
  }

  SOURCES_CLIENT = {
    '1' => 'fb_graph',
    '2' => 'ebrite'
  }

  class << self
    def search_by(params, fb_graph = nil, ebrite = nil)
      return [] if params[:q].blank?
      results = FacebookEvent.search_by(params, fb_graph) + EventbriteEvent.search_by(params, ebrite)
    end

    def find(params, fb_graph = nil, ebrite = nil)
      return unless params[:source_id] && source_class(params[:source_id])
      @event = source_class(params[:source_id])
        .new(params, source_client(params[:source_id], fb_graph, ebrite))
    end

    def source_class(source_id)
      SOURCES[source_id.to_s].constantize if SOURCES.has_key?(source_id.to_s)
    end

    def source_client(source_id, fb_graph = nil, ebrite = nil)
      case source_id.to_i
      when FacebookEvent::SOURCE
        fb_graph
      when EventbriteEvent::SOURCE
        ebrite
      else
        nil
      end
    end
  end
end
