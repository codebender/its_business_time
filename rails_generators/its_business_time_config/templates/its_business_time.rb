ItsBusinessTime.configure do |c|
  c.time_zone = Time.find_zone!('Mountain Time (US & Canada)')
  c.work_hours = {
    tue: ["9:00 am","5:00 pm"],
    wed: ["5:00 am","7:00 pm"],
    thu: ["9:00 am","5:00 pm"]
  }
  c.holidays = [
    Date.parse("January 18, 2017"),
    Date.parse("July 4, 2017"),
    Date.parse("December 25, 2017")
  ]
end
