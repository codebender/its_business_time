require File.expand_path('../helper.rb', __FILE__)

describe "date extensions" do
  it "knows a weekend day is not a workday"  do
    assert(Date.parse("April 9, 2010").workday?)
    refute(Date.parse("April 10, 2010").workday?)
    refute(Date.parse("April 11, 2010").workday?)
    assert(Date.parse("April 12, 2010").workday?)
  end

  it "knows a weekend day is not a workday (with a configured work week)"  do

    ItsBusinessTime.configure do |c|
      c.work_hours = {
        sun: ['9:00 am', '5:00 pm'],
        mon: ['9:00 am', '5:00 pm'],
        tue: ['9:00 am', '5:00 pm'],
        wed: ['9:00 am', '5:00 pm'],
        thu: ['9:00 am', '5:00 pm']
      }
    end

    assert(Date.parse("April 8, 2010").weekday?)
    refute(Date.parse("April 9, 2010").weekday?)
    refute(Date.parse("April 10, 2010").weekday?)
    assert(Date.parse("April 11, 2010").weekday?)
  end

  it "includes holidays as a non-workday" do
    july_4 = Date.parse("July 4, 2010")
    july_5 = Date.parse("July 5, 2010")

    refute(july_4.workday?)
    assert(july_5.workday?)

    ItsBusinessTime.configure do |c|
      c.holidays = [july_4, july_5]
    end

    refute(july_4.workday?)
    refute(july_5.workday?)
  end

  it 'knows which holidays are configured' do
    july_4 = Date.parse("July 4, 2010")

    refute(july_4.holiday?)

    ItsBusinessTime.configure do |c|
      c.holidays << july_4
    end

    assert(july_4.holiday?)
  end
end
