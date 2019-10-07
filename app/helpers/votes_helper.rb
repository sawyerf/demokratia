module VotesHelper
  def convert_time(datetime)
    return datetime.strftime("%-d/%-m %H:%M")
  end
end
