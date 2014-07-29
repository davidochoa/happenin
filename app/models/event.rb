class Event
  class << self
    def search_by(fb_graph, params)
      results = fb_graph.search(params[:q], type: 'event')
      results = filter_results(results)
    end

    private

    def filter_results(results)
      results.select! do |x|
        !x['start_time'].blank? && x['start_time'] > Time.now
      end
      results.sort! { |a,b| a['start_time'] <=> b['start_time'] }
    end
  end
end
