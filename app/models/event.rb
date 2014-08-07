class Event
  SOURCE = 01

  attr_reader :id, :name, :description, :location, :start_time, :end_time,
              :timezone, :privacy, :venue_name, :owner_name, :owner_url,
              :ticket_url

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
      results.sort! { |a, b| a['start_time'] <=> b['start_time'] }
    end
  end

  def initialize(fb_graph: nil, params:)
    @raw_object =
      fb_graph.blank? ? params : src_object(fb_graph: fb_graph, id: params['id'])
  end

  def source_id
    SOURCE
  end

  def id
    object_param(param: :id)
  end

  def name
    object_param(param: :name)
  end

  def description
    object_param(param: :description)
  end

  def location
    object_param(param: :location)
  end

  def start_time
    object_param(param: :start_time)
  end

  def end_time
    object_param(param: :end_time)
  end

  def timezone
    object_param(param: :timezone)
  end

  def privacy
    object_param(param: :privacy)
  end

  def venue
    return if @raw_object.blank? || @raw_object['venue'].blank? ||
      @raw_object['venue']['latitude'].blank? ||
      @raw_object['venue']['longitude'].blank?
    {
      latitude: @raw_object['venue']['latitude'],
      longitude: @raw_object['venue']['longitude']
    }
  end

  def owner_name
    return if @raw_object.blank? || @raw_object['owner'].blank? ||
      @raw_object['owner']['name'].blank?
    @raw_object['owner']['name']
  end

  def owner_url
    return if @raw_object.blank? || @raw_object['owner'].blank? ||
      @raw_object['owner']['id'].blank?
    "//www.facebook.com/#{@raw_object['owner']['id']}"
  end

  def ticket_url
    object_param(param: :ticket_uri)
  end

  private

  def src_object(fb_graph:, id:)
    fb_graph.get_object(id)
  end

  def object_param(param:)
    return if @raw_object.blank? || param.blank? ||
      @raw_object[param.to_s].blank?
    @raw_object[param.to_s]
  end
end
