class EventbriteEvent
  SOURCE = 2

  attr_reader :id, :name, :description, :location, :start_time, :end_time,
              :timezone, :privacy, :venue_name, :owner_name, :owner_url,
              :ticket_url, :url

  class << self
    def search_by(params, ebrite)
      return [] if params[:q].blank?
      results = ebrite.event_search(keywords: CGI.escape(params[:q]), max: 100)
      results['events'].select { |r| r['event'] }
        .map { |attrs| new(attrs['event']) }
    end

    def find(params, ebrite)
      new(params, ebrite)
    end
  end

  def initialize(params, ebrite = nil)
    @raw_object =
      ebrite.blank? ? params :
      src_object(params[:id], ebrite)
  end

  def source_id
    SOURCE
  end

  def id
    object_param(:id)
  end

  def name
    object_param(:title)
  end

  def url
    return if @raw_object.blank? || @raw_object['id'].blank?
    "//www.eventbrite.com/e/#{@raw_object['id']}"
  end

  def description
    object_param(:description)
  end

  def location
    object_param(:location)
  end

  def start_time
    object_param(:start_date)
  end

  def end_time
    object_param(:end_date)
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

  def src_object(id, ebrite)
    ebrite.event_get(id: id)['event']
  end

  def object_param(param)
    return if @raw_object.blank? || param.blank? ||
      @raw_object[param.to_s].blank?
    @raw_object[param.to_s]
  end
end
