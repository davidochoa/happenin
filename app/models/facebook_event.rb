class FacebookEvent
  SOURCE = 1

  attr_reader :id, :name, :description, :location, :start_time, :end_time,
              :timezone, :privacy, :venue_name, :owner_name, :owner_url,
              :ticket_url

  class << self
    def search_by(params, fb_graph)
      return [] if params[:q].blank?
      results = fb_graph.search(params[:q], type: 'event')
      results = filter_raw_results(results)
      results.map { |attrs| new(attrs) }
    end

    def find(params, fb_graph)
      new(params, fb_graph)
    end

    private

    def filter_raw_results(results)
      results.select! do |x|
        !x['start_time'].blank? && x['start_time'] > Time.now
      end
      results.sort! { |a, b| a['start_time'] <=> b['start_time'] }
    end
  end

  def initialize(params, fb_graph = nil)
    @raw_object =
      fb_graph.blank? ? params :
      src_object(params['id'], fb_graph)
  end

  def source_id
    SOURCE
  end

  def id
    object_param(:id)
  end

  def name
    object_param(:name)
  end

  def description
    object_param(:description)
  end

  def location
    object_param(:location)
  end

  def start_time
    object_param(:start_time)
  end

  def end_time
    object_param(:end_time)
  end

  def timezone
    object_param(:timezone)
  end

  def privacy
    object_param(:privacy)
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
    object_param(:ticket_uri)
  end

  private

  def src_object(id, fb_graph)
    fb_graph.get_object(id)
  end

  def object_param(param)
    return if @raw_object.blank? || param.blank? ||
      @raw_object[param.to_s].blank?
    @raw_object[param.to_s]
  end
end
