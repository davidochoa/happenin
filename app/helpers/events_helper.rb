module EventsHelper
  def event_path(event, options={})
    url_for(options.merge(controller: :events, action: :show, only_path: true,
                          id: event.id, source_id: event.source_id))
  end
end
