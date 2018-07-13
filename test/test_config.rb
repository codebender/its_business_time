require File.expand_path('../helper.rb', __FILE__)

describe "config" do
  before do
    ItsBusinessTime.configuration = ItsBusinessTime::Config.new
  end

  it "keeps track of holidays" do
    assert ItsBusinessTime.configuration.holidays.empty?
    daves_birthday = Date.parse("August 4th, 1969")
    ItsBusinessTime.configure do |c|
      c.holidays << daves_birthday
    end
    assert ItsBusinessTime.configuration.holidays.include?(daves_birthday)
  end

  it "uses defaults to UTC as the configured time zone" do
    assert_equal "UTC", ItsBusinessTime.configuration.time_zone.name
  end

  it "keeps track of the configured time zone" do
    ItsBusinessTime.configure do |c|
      c.time_zone = "Ljubljana"
    end

    assert_equal "Ljubljana", ItsBusinessTime.configuration.time_zone.name
  end

  it "keeps track of the start of the day using work_hours" do
    assert_equal({
      mon: [ItsBusinessTime::ParsedTime.new(9),ItsBusinessTime::ParsedTime.new(17)],
      tue: [ItsBusinessTime::ParsedTime.new(9),ItsBusinessTime::ParsedTime.new(17)],
      wed: [ItsBusinessTime::ParsedTime.new(9),ItsBusinessTime::ParsedTime.new(17)],
      thu: [ItsBusinessTime::ParsedTime.new(9),ItsBusinessTime::ParsedTime.new(17)],
      fri: [ItsBusinessTime::ParsedTime.new(9),ItsBusinessTime::ParsedTime.new(17)]
    }, ItsBusinessTime.configuration.work_hours)

    ItsBusinessTime.configure do |c|
      c.work_hours = {
        mon: ['6:00 am', '5:00 pm'],
        tue: ['7:00 am', '6:00 pm'],
        thu: ['8:00 am', '7:00 pm'],
        fri: ['9:00 am', '8:00 pm']
      }
    end

    assert_equal({
      mon: [ItsBusinessTime::ParsedTime.new(6),ItsBusinessTime::ParsedTime.new(17)],
      tue: [ItsBusinessTime::ParsedTime.new(7),ItsBusinessTime::ParsedTime.new(18)],
      thu: [ItsBusinessTime::ParsedTime.new(8),ItsBusinessTime::ParsedTime.new(19)],
      fri: [ItsBusinessTime::ParsedTime.new(9),ItsBusinessTime::ParsedTime.new(20)]
    }, ItsBusinessTime.configuration.work_hours)
  end

  it 'calculates the beginning of the workday' do
    ItsBusinessTime.configure do |c|
      c.work_hours = {
        mon: ['6:00 am', '5:00 pm']
      }
      c.time_zone = 'Mountain Time (US & Canada)'
    end

    now = Time.parse("January 23rd, 2017, 11:50 am Mountain Time (US & Canada)")
    expecting = ItsBusinessTime::ParsedTime.new(6)
    assert_equal expecting, ItsBusinessTime.configuration.beginning_of_workday(now)
  end

  it 'calculates the end of the workday' do
    ItsBusinessTime.configure do |c|
      c.work_hours = {
        mon: ['6:00 am', '5:00 pm']
      }
      c.time_zone = 'Mountain Time (US & Canada)'
    end

    now = Time.parse("January 23rd, 2017, 11:50 am Mountain Time (US & Canada)")
    expecting = ItsBusinessTime::ParsedTime.new(17)
    assert_equal expecting, ItsBusinessTime.configuration.end_of_workday(now)
  end

  it 'keeps work_week up to date with work_hours' do
    assert_equal [1,2,3,4,5], ItsBusinessTime.configuration.work_week.to_a.sort

    ItsBusinessTime.configure do |c|
      c.work_hours = {
        mon: ['6:00 am', '5:00 pm']
      }
      c.time_zone = 'Mountain Time (US & Canada)'
    end

    assert_equal [1], ItsBusinessTime.configuration.work_week.to_a.sort
  end
end
