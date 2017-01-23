ItsBusinessTime.configure do |c|
  c.time_zone = Time.find_zone!('Mountain Time (US & Canada)')
  c.work_hours = {
    tue: [ItsBusinessTime::ParsedTime.new(9),ItsBusinessTime::ParsedTime.new(17)],
    wed: [ItsBusinessTime::ParsedTime.new(5),ItsBusinessTime::ParsedTime.new(19)],
    thu: [ItsBusinessTime::ParsedTime.new(9),ItsBusinessTime::ParsedTime.new(17)]
  }
  c.holidays = [
    Date.parse("January 18, 2017"), 
    Date.parse("July 4, 2017"),
    Date.parse("December 25, 2017")
  ]
end
