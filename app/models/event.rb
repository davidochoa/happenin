class Event
  SOURCE = 01

  attr_reader :id, :name, :location, :start_time, :end_time, :timezone

  class << self
    def search_by(fb_graph:, params:)
      results = fb_graph.search(params[:q], type: 'event')
      results = filter_raw_results(results: results)
      results.map { |x| new(params: x) }
    end

    private

    def filter_raw_results(results:)
      results.select! do |x|
        !x['start_time'].blank? && x['start_time'] > Time.now
      end
      results.sort! { |a,b| a['start_time'] <=> b['start_time'] }
    end
  end

  def initialize(params:, fb_graph: nil)
    @id = params['id']
    @name = params['name']
    @location = params['location']
    @start_time = params['start_time']
    @end_time = params['end_time']
    @timezone = params['timezone']
    event_information(fb_graph: fb_graph) if fb_graph
  end

  def source_id
    SOURCE
  end

  private

  def event_information(fb_graph:)
    return unless fb_graph
  end
end
