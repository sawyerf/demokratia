class OutboxController < ApplicationController
  
  def filter_uploaded(votes, votelogs, choices, filter)
    filup = Time.at(filter["updated"].to_i).to_datetime
    if @votes; @votes = @votes.where(updated: filup..Time.current) end
    if @votelogs; @votelogs = @votelogs.where(updated: filup..Time.current) end
    if @choices; @choices = @choices.where(updated: filup..Time.current) end
  end
  
  def filter_type(filter)
    case filter["type"]
    when "vote"
      @votelogs = @choices = nil
    when "votelog"
      @vote = @choices = nil
    when "choice"
      @vote = @votelogs = nil
    else
      @vote = @votelogs = @choices = nil
    end
  end

  def convert_json(tables, json)
    if !tables
      return
    end
    tables.each do |table|
      json[:items].push(table.outbox_json)
    end
  end

  def filter(filter, site_id)
    json = {:items => []}
    @votes = Vote.where(site_id: 1)
    @votelogs = VoteLog.where(site_id: site_id)
    @choices = Choice.where(site_id: 1)
    if filter["type"]
      filter_type(filter)
    end
    if filter["updated"]
      filter_uploaded(@votes, @votelogs, @choices, filter)
    end
    convert_json(@votes, json)
    convert_json(@votelogs, json)
    convert_json(@choices, json)
    return json.to_json
  end

  def outbox
    site_key = request.headers["Authorization"]
    site = Site.where(itskey: site_key).first
    if site
      @json = filter(params, site.id)
    end
  end
end
