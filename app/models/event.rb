class Event
  SOURCE = 01

  attr_reader :id, :name, :description, :location, :start_time, :end_time,
              :timezone, :privacy, :venue, :owner, :ticket_uri

  class << self
    def search_by(fb_graph:, params:)
      return [] if params[:q].blank?
      results = fb_graph.search(params[:q], type: 'event')
      results = filter_raw_results(results: results)
      results.map { |x| new(params: x) }
    end

    def find(fb_graph:, params:)
      new(fb_graph: fb_graph, params: params)
    end

    private

    def filter_raw_results(results:)
      results.select! do |x|
        !x['start_time'].blank? && x['start_time'] > Time.now
      end
      results.sort! { |a,b| a['start_time'] <=> b['start_time'] }
    end
  end

  def initialize(fb_graph: nil, params:)
    params = event_information(fb_graph: fb_graph, id: params[:id]) if fb_graph
    event_parameterize(params: params)
  end

  def source_id
    SOURCE
  end

  private

  def event_information(fb_graph:, id:)
    return unless fb_graph
    fb_graph.get_object(id)
  end

  def event_parameterize(params: params)
    params.each do |key, value|
      instance_variable_set("@#{key}", value)
    end
  end
end
